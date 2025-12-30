/// WebRTC peer connection for Ring cameras
///
/// This module provides a WebRTC peer connection implementation using the
/// pure Dart webrtc_dart library (port of werift).
library;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:webrtc_dart/webrtc_dart.dart' as webrtc;

import '../subscribed.dart';

/// ICE server URLs used by Ring cameras
const ringIceServers = [
  'stun:stun.kinesisvideo.us-east-1.amazonaws.com:443',
  'stun:stun.kinesisvideo.us-east-2.amazonaws.com:443',
  'stun:stun.kinesisvideo.us-west-2.amazonaws.com:443',
  'stun:stun.l.google.com:19302',
  'stun:stun1.l.google.com:19302',
  'stun:stun2.l.google.com:19302',
  'stun:stun3.l.google.com:19302',
  'stun:stun4.l.google.com:19302',
];

/// Connection states for WebRTC peer connection
enum ConnectionState {
  new_,
  connecting,
  connected,
  disconnected,
  failed,
  closed,
}

/// ICE candidate for WebRTC connection
class RTCIceCandidate {
  final String candidate;
  final int? sdpMLineIndex;
  final String? sdpMid;

  RTCIceCandidate({required this.candidate, this.sdpMLineIndex, this.sdpMid});
}

/// SDP offer/answer
class SessionDescription {
  final String type; // 'offer' or 'answer'
  final String sdp;

  SessionDescription({required this.type, required this.sdp});
}

/// RTP packet (re-export from webrtc_dart)
typedef RtpPacket = webrtc.RtpPacket;

/// Basic peer connection interface
///
/// This interface defines the minimum requirements for a WebRTC peer
/// connection to work with Ring cameras.
abstract class BasicPeerConnection {
  /// Create an SDP offer
  Future<SessionDescription> createOffer();

  /// Accept an SDP answer
  Future<void> acceptAnswer(SessionDescription answer);

  /// Add an ICE candidate
  Future<void> addIceCandidate(RTCIceCandidate candidate);

  /// Stream of ICE candidates
  Stream<RTCIceCandidate> get onIceCandidate;

  /// Stream of connection state changes
  Stream<ConnectionState> get onConnectionState;

  /// Close the connection
  void close();

  /// Request a key frame (optional)
  void requestKeyFrame() {}
}

/// WebRTC peer connection implementation using webrtc_dart
///
/// This class wraps the webrtc_dart RtcPeerConnection to provide a Ring-compatible
/// WebRTC peer connection with audio and video transceivers.
class WebRTCPeerConnection extends Subscribed implements BasicPeerConnection {
  final _onIceCandidateController = PublishSubject<RTCIceCandidate>();
  final _onConnectionStateController = ReplaySubject<ConnectionState>(
    maxSize: 1,
  );

  @override
  Stream<RTCIceCandidate> get onIceCandidate =>
      _onIceCandidateController.stream;

  @override
  Stream<ConnectionState> get onConnectionState =>
      _onConnectionStateController.stream;

  /// Audio RTP packets stream
  final onAudioRtp = PublishSubject<RtpPacket>();

  /// Audio RTCP packets stream
  final onAudioRtcp = PublishSubject<dynamic>();

  /// Video RTP packets stream
  final onVideoRtp = PublishSubject<RtpPacket>();

  /// Video RTCP packets stream
  final onVideoRtcp = PublishSubject<dynamic>();

  /// The underlying webrtc_dart peer connection
  late final webrtc.RtcPeerConnection _pc;

  /// Subject for requesting key frames
  final _onRequestKeyFrame = PublishSubject<void>();

  // ignore: unused_field - Stored for future use (e.g., direction changes)
  webrtc.RtpTransceiver? _videoTransceiver;

  /// Audio track for sending audio back to the camera
  late final webrtc.AudioStreamTrack returnAudioTrack;

  /// Whether peer connection is closed
  bool _closed = false;

  WebRTCPeerConnection() {
    // Create return audio track
    returnAudioTrack = webrtc.AudioStreamTrack(
      id: 'return_audio',
      label: 'Return Audio Track',
    );

    // Create peer connection with Ring ICE servers and codecs
    // Ring cameras require bundlePolicy: disable (no BUNDLE group in SDP)
    // This matches the TypeScript werift implementation
    _pc = webrtc.RtcPeerConnection(
      webrtc.RtcConfiguration(
        iceServers: ringIceServers
            .map((server) => webrtc.IceServer(urls: [server]))
            .toList(),
        iceTransportPolicy: webrtc.IceTransportPolicy.all,
        bundlePolicy: webrtc.BundlePolicy.disable,
      ),
    );

    // Add audio transceiver with sendrecv direction (for two-way audio)
    _pc.addTrack(returnAudioTrack);

    // Add video transceiver with recvonly direction using H264 codec
    // Ring cameras require H264 - they reject VP8 offers
    // Use High profile (640029) like TypeScript werift for better compatibility
    _videoTransceiver = _pc.addTransceiver(
      webrtc.MediaStreamTrackKind.video,
      codec: webrtc.createH264Codec(
        payloadType: 96,
        parameters:
            'packetization-mode=1;profile-level-id=640029;level-asymmetry-allowed=1',
        rtcpFeedback: [
          const webrtc.RtcpFeedback(type: 'transport-cc'),
          const webrtc.RtcpFeedback(type: 'ccm', parameter: 'fir'),
          const webrtc.RtcpFeedback(type: 'nack'),
          const webrtc.RtcpFeedback(type: 'nack', parameter: 'pli'),
          const webrtc.RtcpFeedback(type: 'goog-remb'),
        ],
      ),
      direction: webrtc.RtpTransceiverDirection.recvonly,
    );

    // Subscribe to ICE candidates
    _pc.onIceCandidate.listen((candidate) {
      if (!_closed) {
        _onIceCandidateController.add(
          RTCIceCandidate(
            candidate: candidate.toSdp(),
            sdpMLineIndex: candidate.component,
            sdpMid: null, // webrtc_dart Candidate doesn't have sdpMid
          ),
        );
      }
    });

    // Subscribe to connection state changes
    _pc.onConnectionStateChange.listen((state) {
      if (_closed) return;

      final mappedState = _mapConnectionState(state);
      _onConnectionStateController.add(mappedState);

      if (state == webrtc.PeerConnectionState.failed) {
        // Connection failed
      }
      if (state == webrtc.PeerConnectionState.closed) {
        // Connection closed
      }
    });

    // Subscribe to track events for receiving RTP packets
    _pc.onTrack.listen((transceiver) {
      final receiver = transceiver.receiver;

      if (transceiver.kind == webrtc.MediaStreamTrackKind.audio) {
        // Audio track - forward RTP packets
        // Note: The actual RTP handling happens in the RtpSession/RtpReceiver
        // We need to set up the receiver to forward packets to our stream
        _setupAudioReceiver(receiver);
      } else if (transceiver.kind == webrtc.MediaStreamTrackKind.video) {
        // Video track - forward RTP packets and set up keyframe requests
        _setupVideoReceiver(transceiver, receiver);
      }
    });
  }

  /// Set up audio receiver to forward RTP packets
  void _setupAudioReceiver(webrtc.RtpReceiver receiver) {
    // Forward raw RTP packets from the track to our stream
    // The track now emits raw RTP via onReceiveRtp (after webrtc_dart update)
    final track = receiver.track;
    addSubscription(
      track.onReceiveRtp.listen((rtp) {
        if (!_closed) {
          onAudioRtp.add(rtp);
        }
      }),
    );
    addSubscription(
      track.onReceiveRtcp.listen((rtcp) {
        if (!_closed) {
          onAudioRtcp.add(rtcp);
        }
      }),
    );
  }

  /// Set up video receiver with keyframe requests
  void _setupVideoReceiver(
    webrtc.RtpTransceiver transceiver,
    webrtc.RtpReceiver receiver,
  ) {
    final track = receiver.track;
    int? mediaSsrc;
    Timer? pliTimer;

    // Forward raw RTP packets from the track to our stream
    addSubscription(
      track.onReceiveRtp.listen((rtp) {
        if (!_closed) {
          onVideoRtp.add(rtp);

          // Start PLI requests after first RTP packet (like TypeScript werift)
          if (mediaSsrc == null) {
            mediaSsrc = rtp.ssrc;

            // Send PLI every 2 seconds (matching TypeScript werift)
            pliTimer = Timer.periodic(const Duration(seconds: 2), (_) {
              if (!_closed && mediaSsrc != null) {
                receiver.rtpSession.sendPli(mediaSsrc!);
              }
            });
          }
        }
      }),
    );
    addSubscription(
      track.onReceiveRtcp.listen((rtcp) {
        if (!_closed) {
          onVideoRtcp.add(rtcp);
        }
      }),
    );

    // Set up manual keyframe request handling
    addSubscription(
      _onRequestKeyFrame.stream.listen((_) {
        // Request keyframe via RTCP PLI
        if (!_closed && mediaSsrc != null) {
          receiver.rtpSession.sendPli(mediaSsrc!);
        }
      }),
    );

    // Clean up timer when connection closes
    addSubscription(
      _onConnectionStateController.stream
          .where((state) => state == ConnectionState.closed)
          .listen((_) {
            pliTimer?.cancel();
          }),
    );
  }

  /// Map webrtc_dart PeerConnectionState to our ConnectionState
  ConnectionState _mapConnectionState(webrtc.PeerConnectionState state) {
    switch (state) {
      case webrtc.PeerConnectionState.new_:
        return ConnectionState.new_;
      case webrtc.PeerConnectionState.connecting:
        return ConnectionState.connecting;
      case webrtc.PeerConnectionState.connected:
        return ConnectionState.connected;
      case webrtc.PeerConnectionState.disconnected:
        return ConnectionState.disconnected;
      case webrtc.PeerConnectionState.failed:
        return ConnectionState.failed;
      case webrtc.PeerConnectionState.closed:
        return ConnectionState.closed;
    }
  }

  @override
  Future<SessionDescription> createOffer() async {
    final offer = await _pc.createOffer();
    await _pc.setLocalDescription(offer);

    return SessionDescription(type: 'offer', sdp: offer.sdp);
  }

  @override
  Future<void> acceptAnswer(SessionDescription answer) async {
    await _pc.setRemoteDescription(
      webrtc.SessionDescription(type: 'answer', sdp: answer.sdp),
    );
  }

  @override
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    final parsedCandidate = webrtc.Candidate.fromSdp(candidate.candidate);
    await _pc.addIceCandidate(parsedCandidate);
  }

  @override
  void requestKeyFrame() {
    _onRequestKeyFrame.add(null);
  }

  /// Write RTP packet to return audio track
  void writeAudioRtp(RtpPacket rtp) {
    // Forward audio to the return audio track
    // The webrtc_dart AudioStreamTrack expects AudioFrame, not RTP
    // For raw RTP sending, we'd need to access the RTP session directly
    // This is a simplified implementation
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;

    _pc.close();
    _onIceCandidateController.close();
    _onConnectionStateController.close();
    onAudioRtp.close();
    onAudioRtcp.close();
    onVideoRtp.close();
    onVideoRtcp.close();
    _onRequestKeyFrame.close();
    unsubscribe();
  }
}
