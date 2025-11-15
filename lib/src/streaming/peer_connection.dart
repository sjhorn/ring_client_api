/// WebRTC peer connection for Ring cameras
///
/// **IMPORTANT: This is a stub implementation**
///
/// The TypeScript implementation uses the `werift` library, which is a pure
/// JavaScript WebRTC implementation that runs in Node.js. Dart does not have
/// an equivalent pure-Dart WebRTC implementation suitable for non-browser,
/// non-Flutter applications.
///
/// Available Dart WebRTC options:
/// - `flutter_webrtc`: Full WebRTC for Flutter apps (iOS/Android/Desktop/Web)
/// - `dart_webrtc`: Browser-only WebRTC wrapper for Dart web apps
///
/// To implement full streaming support, you would need to:
/// 1. Use flutter_webrtc if building a Flutter app
/// 2. Use dart_webrtc if building a web app
/// 3. Wait for a pure Dart WebRTC implementation
/// 4. Use FFI to bind to native WebRTC libraries
///
/// For now, this file provides the interface definitions that would be needed.
library;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
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

/// Basic peer connection interface
///
/// This interface defines the minimum requirements for a WebRTC peer
/// connection to work with Ring cameras. Implementations would need to
/// use a platform-specific WebRTC library.
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

/// Stub implementation of WeriftPeerConnection
///
/// **This is not functional** - it's a placeholder that shows what would
/// be needed if a pure Dart WebRTC implementation becomes available.
///
/// To make this work, you would need to:
/// 1. Find or create a Dart WebRTC implementation
/// 2. Implement RTP/RTCP packet handling
/// 3. Implement audio/video codec support (H.264, Opus, PCMU)
/// 4. Handle ICE candidates and STUN servers
class WeriftPeerConnection extends Subscribed implements BasicPeerConnection {
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

  // Audio/Video RTP streams (would be needed for actual implementation)
  final onAudioRtp = PublishSubject<dynamic>(); // RtpPacket
  final onVideoRtp = PublishSubject<dynamic>(); // RtpPacket

  WeriftPeerConnection() {
    throw UnimplementedError(
      'WebRTC peer connections are not yet implemented in Dart.\n'
      'To use streaming features:\n'
      '1. Use flutter_webrtc for Flutter apps\n'
      '2. Use dart_webrtc for web apps\n'
      '3. Implement native bindings for your platform',
    );
  }

  @override
  Future<SessionDescription> createOffer() async {
    throw UnimplementedError('WebRTC not implemented');
  }

  @override
  Future<void> acceptAnswer(SessionDescription answer) async {
    throw UnimplementedError('WebRTC not implemented');
  }

  @override
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    throw UnimplementedError('WebRTC not implemented');
  }

  @override
  void requestKeyFrame() {
    throw UnimplementedError('WebRTC not implemented');
  }

  @override
  void close() {
    _onIceCandidateController.close();
    _onConnectionStateController.close();
    onAudioRtp.close();
    onVideoRtp.close();
    unsubscribe();
  }
}
