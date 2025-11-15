/// Simple WebRTC session for Ring camera live view
///
/// This class provides a simple REST-based streaming session without
/// the complexity of full WebRTC peer connections. It's useful for
/// basic live view functionality.
library;

import '../ring_camera.dart';
import '../rest_client.dart';
import '../util.dart';

String _liveViewUrl(String path) {
  return 'https://api.ring.com/integrations/v1/liveview/$path';
}

/// Simple WebRTC session for streaming Ring camera video
///
/// This provides a REST-based interface to start and end live view sessions
/// with Ring cameras. It doesn't handle the full WebRTC peer connection
/// complexity - that's handled by other streaming classes.
class SimpleWebRtcSession {
  final String sessionId = generateUuid();
  final RingCamera _camera;
  final RingRestClient _restClient;

  SimpleWebRtcSession(this._camera, this._restClient);

  /// Start a live view session with the provided SDP offer
  ///
  /// Returns the SDP answer from the Ring API
  Future<String> start(String sdp) async {
    final response = await _restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: _liveViewUrl('start'),
        json: {
          'session_id': sessionId,
          'device_id': _camera.id,
          'sdp': sdp,
          'protocol': 'webrtc',
        },
      ),
    );
    return response.data['sdp'] as String;
  }

  /// End the live view session
  Future<Map<String, dynamic>> end() async {
    final response = await _restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: _liveViewUrl('end'),
        json: {'session_id': sessionId},
      ),
    );

    return response.data;
  }

  /// Activate the camera speaker by turning off stealth mode
  ///
  /// This allows two-way audio communication with the camera
  Future<void> activateCameraSpeaker() async {
    await _restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'PATCH',
        url: _liveViewUrl('options'),
        json: {
          'session_id': sessionId,
          'actions': ['turn_off_stealth_mode'],
        },
      ),
    );
  }
}
