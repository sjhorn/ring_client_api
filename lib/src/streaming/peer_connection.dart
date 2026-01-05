/// WebRTC peer connection for Ring cameras
///
/// This module provides a WebRTC peer connection implementation using the
/// pure Dart webrtc_dart library (port of werift).
library;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:webrtc_dart/webrtc_dart.dart' as webrtc;
import 'package:webrtc_dart/nonstandard.dart' as nonstandard;

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
  late final webrtc.RTCPeerConnection _pc;

  /// Subject for requesting key frames
  final _onRequestKeyFrame = PublishSubject<void>();

  /// Audio transceiver for two-way audio
  late webrtc.RTCRtpTransceiver _audioTransceiver;

  /// Video transceiver for receiving video
  late webrtc.RTCRtpTransceiver _videoTransceiver;

  /// Audio track for sending audio back to the camera (nonstandard for RTP forwarding)
  /// This matches TypeScript werift: returnAudioTrack = new MediaStreamTrack({ kind: 'audio' })
  late final nonstandard.MediaStreamTrack returnAudioTrack;

  /// Whether peer connection is closed
  bool _closed = false;

  WebRTCPeerConnection() {
    // Create return audio track using nonstandard MediaStreamTrack (matching TypeScript werift)
    // TypeScript: this.returnAudioTrack = new MediaStreamTrack({ kind: 'audio' })
    returnAudioTrack = nonstandard.MediaStreamTrack(
      kind: nonstandard.MediaKind.audio,
      id: 'return_audio',
    );

    // Create peer connection with Ring ICE servers and codecs
    // Ring cameras require bundlePolicy: disable (no BUNDLE group in SDP)
    // This matches the TypeScript werift implementation
    _pc = webrtc.RTCPeerConnection(
      webrtc.RtcConfiguration(
        iceServers: ringIceServers
            .map((server) => webrtc.IceServer(urls: [server]))
            .toList(),
        iceTransportPolicy: webrtc.IceTransportPolicy.all,
        bundlePolicy: webrtc.BundlePolicy.disable,
        // Codecs matching TypeScript werift
        codecs: webrtc.RtcCodecs(
          // Audio codecs - Opus preferred, PCMU fallback
          audio: [
            webrtc.RtpCodecParameters(
              mimeType: 'audio/opus',
              clockRate: 48000,
              channels: 2,
            ),
            webrtc.RtpCodecParameters(
              mimeType: 'audio/PCMU',
              clockRate: 8000,
              channels: 1,
              payloadType: 0,
            ),
          ],
          // Video codecs - Ring requires H264
          video: [
            webrtc.RtpCodecParameters(
              mimeType: 'video/H264',
              clockRate: 90000,
              rtcpFeedback: [
                const webrtc.RtcpFeedback(type: 'transport-cc'),
                const webrtc.RtcpFeedback(type: 'ccm', parameter: 'fir'),
                const webrtc.RtcpFeedback(type: 'nack'),
                const webrtc.RtcpFeedback(type: 'nack', parameter: 'pli'),
                const webrtc.RtcpFeedback(type: 'goog-remb'),
              ],
              parameters:
                  'packetization-mode=1;profile-level-id=640029;level-asymmetry-allowed=1',
            ),
          ],
        ),
      ),
    );

    // Add audio transceiver with sendrecv direction for two-way audio
    // (matching TypeScript: pc.addTransceiver(this.returnAudioTrack, { direction: 'sendrecv' }))
    _audioTransceiver = _pc.addTransceiver(
      webrtc.MediaStreamTrackKind.audio,
      direction: webrtc.RtpTransceiverDirection.sendrecv,
    );
    // Register nonstandard track for RTP forwarding (matching TypeScript werift)
    // This subscribes to track.onReceiveRtp and forwards packets through sendRtp
    _audioTransceiver.sender.registerNonstandardTrack(returnAudioTrack);

    // Add video transceiver with recvonly direction
    // (matching TypeScript: pc.addTransceiver('video', { direction: 'recvonly' }))
    _videoTransceiver = _pc.addTransceiver(
      webrtc.MediaStreamTrackKind.video,
      direction: webrtc.RtpTransceiverDirection.recvonly,
    );

    // Subscribe to ICE candidates
    _pc.onIceCandidate.listen((candidate) {
      if (!_closed) {
        _onIceCandidateController.add(
          RTCIceCandidate(
            candidate: candidate.toSdp(),
            // Use sdpMLineIndex for bundlePolicy:disable - 0 for audio, 1 for video
            sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
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
    // Note: Using pc.onTrack since transceiver.onTrack doesn't fire in webrtc_dart
    // See WEBRTC_ISSUE.md for audio RTP routing issue
    _pc.onTrack.listen((transceiver) {
      final track = transceiver.receiver.track;

      if (transceiver.kind == webrtc.MediaStreamTrackKind.audio) {
        _setupTrackReceiver(track, onAudioRtp, onAudioRtcp);
      } else if (transceiver.kind == webrtc.MediaStreamTrackKind.video) {
        _setupTrackReceiver(track, onVideoRtp, onVideoRtcp);
        _setupVideoKeyFrameRequests(track);
      }
    });
  }

  /// Set up a track receiver to forward RTP/RTCP packets
  void _setupTrackReceiver(
    webrtc.MediaStreamTrack track,
    PublishSubject<RtpPacket> rtpSubject,
    PublishSubject<dynamic> rtcpSubject,
  ) {
    addSubscription(
      track.onReceiveRtp.listen((rtp) {
        if (!_closed) {
          rtpSubject.add(rtp);
        }
      }),
    );

    addSubscription(
      track.onReceiveRtcp.listen((rtcp) {
        if (!_closed) {
          rtcpSubject.add(rtcp);
        }
      }),
    );
  }

  /// Set up video keyframe requests (PLI)
  void _setupVideoKeyFrameRequests(webrtc.MediaStreamTrack track) {
    int? mediaSsrc;
    Timer? pliTimer;

    addSubscription(
      track.onReceiveRtp.listen((rtp) {
        if (!_closed && mediaSsrc == null) {
          mediaSsrc = rtp.ssrc;

          // Send PLI every 4 seconds (matching TypeScript: interval(4000))
          pliTimer = Timer.periodic(const Duration(seconds: 4), (_) {
            if (!_closed && mediaSsrc != null) {
              _videoTransceiver.receiver.rtpSession.sendPli(mediaSsrc!);
            }
          });
        }
      }),
    );

    // Set up manual keyframe request handling
    addSubscription(
      _onRequestKeyFrame.stream.listen((_) {
        if (!_closed && mediaSsrc != null) {
          _videoTransceiver.receiver.rtpSession.sendPli(mediaSsrc!);
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
      webrtc.RTCSessionDescription(type: 'answer', sdp: answer.sdp),
    );
  }

  @override
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    final parsedCandidate = webrtc.RTCIceCandidate.fromSdp(candidate.candidate);
    await _pc.addIceCandidate(parsedCandidate);
  }

  @override
  void requestKeyFrame() {
    _onRequestKeyFrame.add(null);
  }

  /// Write RTP packet to return audio track
  ///
  /// Matches TypeScript werift: this.pc.returnAudioTrack.writeRtp(rtp)
  /// The nonstandard MediaStreamTrack accepts RTP packets and forwards them
  /// through the sender's RTP session.
  void writeAudioRtp(RtpPacket rtp) {
    if (_closed) return;
    // Forward RTP to the return audio track (matching TypeScript werift)
    // writeRtp() emits to onReceiveRtp which the sender is subscribed to
    returnAudioTrack.writeRtp(rtp);
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
