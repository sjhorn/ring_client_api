/// WebRTC connection manager for Ring camera streaming
///
/// This class manages the WebSocket signaling and WebRTC peer connection
/// for streaming video from Ring cameras.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../ring_camera.dart';
import '../subscribed.dart';
import '../util.dart';
import 'peer_connection.dart';

/// Options for streaming connection
class StreamingConnectionOptions {
  /// Optional factory for creating custom peer connections
  final BasicPeerConnection Function()? createPeerConnection;

  StreamingConnectionOptions({this.createPeerConnection});
}

/// WebRTC connection for streaming Ring camera video
///
/// This class:
/// 1. Creates a WebSocket connection to Ring's signaling server
/// 2. Uses WebRTC to establish peer-to-peer video connection
/// 3. Handles SDP offers/answers and ICE candidates
/// 4. Manages the streaming session lifecycle
class WebRTCConnection extends Subscribed {
  /// Emits session ID when received from server
  final onSessionId = ReplaySubject<String>(maxSize: 1);

  /// Emits when offer has been sent
  final onOfferSent = ReplaySubject<void>(maxSize: 1);

  /// Emits when camera is connected
  final onCameraConnected = ReplaySubject<void>(maxSize: 1);

  /// Emits SDP answer when received
  final onCallAnswered = ReplaySubject<String>(maxSize: 1);

  /// Emits when call ends
  final onCallEnded = ReplaySubject<void>(maxSize: 1);

  /// Emits errors
  final onError = ReplaySubject<dynamic>(maxSize: 1);

  /// Emits all WebSocket messages
  final onMessage = ReplaySubject<Map<String, dynamic>>();

  /// Emits when WebSocket is open
  late final Stream<void> onWsOpen;

  /// Audio RTP packets stream
  late final Stream<RtpPacket> onAudioRtp;

  /// Video RTP packets stream
  late final Stream<RtpPacket> onVideoRtp;

  /// Dialog ID for this connection
  final String _dialogId = generateUuid();

  /// The peer connection
  late final BasicPeerConnection _pc;

  /// The WebSocket connection
  late final WebSocket _ws;

  /// The camera being streamed
  final RingCamera _camera;

  /// Current session ID
  String? _sessionId;

  /// Whether the call has ended
  bool _hasEnded = false;

  /// Whether WebSocket is connected
  bool _wsConnected = false;

  WebRTCConnection(
    String ticket,
    RingCamera camera,
    StreamingConnectionOptions options,
  ) : _camera = camera {
    // Create peer connection
    if (options.createPeerConnection != null) {
      // Custom peer connection factory
      _pc = options.createPeerConnection!();

      // Custom peer connections don't support RTP packet forwarding
      onAudioRtp = Stream.empty();
      onVideoRtp = Stream.empty();
    } else {
      // Use WebRTCPeerConnection with RTP packet support
      final pc = WebRTCPeerConnection();
      _pc = pc;
      onAudioRtp = pc.onAudioRtp;
      onVideoRtp = pc.onVideoRtp;
    }

    // Connect WebSocket to Ring signaling server
    _connectWebSocket(ticket);

    // Handle peer connection state changes
    addSubscriptions([
      _pc.onConnectionState.listen((state) {
        if (state == ConnectionState.failed) {
          logError('Stream connection failed');
          _callEnded();
        }
        if (state == ConnectionState.closed) {
          logDebug('Stream connection closed');
          _callEnded();
        }
      }),

      // Handle errors
      onError.listen((e) {
        logError(e);
        _callEnded();
      }),

      // Send ICE candidates to remote
      _pc.onIceCandidate.listen((iceCandidate) async {
        // Wait for offer to be sent first
        await onOfferSent.first;

        _sendMessage({
          'method': 'ice',
          'dialog_id': _dialogId,
          'body': {
            'doorbot_id': _camera.id,
            'ice': iceCandidate.candidate,
            'mlineindex': iceCandidate.sdpMLineIndex,
          },
        });
      }),

      // Ping every 5 seconds to keep connection alive (ring-edge requirement)
      Stream.periodic(const Duration(seconds: 5)).listen((_) {
        _sendSessionMessage('ping');
      }),
    ]);
  }

  /// Connect to Ring's WebSocket signaling server
  void _connectWebSocket(String ticket) async {
    try {
      final url = Uri.parse(
        'wss://api.prod.signalling.ring.devices.a2z.com:443/ws'
        '?api_version=4.0'
        '&auth_type=ring_solutions'
        '&client_id=ring_site-${generateUuid()}'
        '&token=$ticket',
      );

      _ws = await WebSocket.connect(
        url.toString(),
        headers: {
          // Must exist or socket closes immediately
          'User-Agent': 'android:com.ringapp',
        },
      );

      _wsConnected = true;

      // Handle WebSocket events
      _ws.listen(
        (data) {
          final message = jsonDecode(data as String) as Map<String, dynamic>;
          final method = message['method'] as String?;
          final body = message['body'] as Map<String, dynamic>?;
          logDebug('[WS] Received: $method (body keys: ${body?.keys.toList()})');
          onMessage.add(message);
          _handleMessage(message);
        },
        onError: (error) {
          logError(error);
          _callEnded();
        },
        onDone: () {
          _callEnded();
        },
      );

      // Initiate call once connected
      final connectionType = _camera.isRingEdgeEnabled ? 'Ring Edge' : 'Cloud';
      logInfo('WebSocket connected for ${_camera.name} ($connectionType)');
      await _initiateCall();
    } catch (e) {
      logError('WebSocket connection failed: $e');
      onError.add(e);
    }
  }

  /// Initiate the WebRTC call
  Future<void> _initiateCall() async {
    try {
      logInfo('Creating WebRTC offer...');
      final offer = await _pc.createOffer();
      logInfo('Offer created, SDP length: ${offer.sdp.length}');

      _sendMessage({
        'method': 'live_view',
        'dialog_id': _dialogId,
        'body': {
          'doorbot_id': _camera.id,
          'stream_options': {'audio_enabled': true, 'video_enabled': true},
          'sdp': offer.sdp,
        },
      });

      onOfferSent.add(null);
    } catch (e, stack) {
      logError('Failed to create offer: $e');
      logError('Stack: $stack');
      onError.add(e);
    }
  }

  /// Handle incoming WebSocket messages
  Future<void> _handleMessage(Map<String, dynamic> message) async {
    try {
      final body = message['body'] as Map<String, dynamic>?;
      final method = message['method'] as String?;

      if (body == null || method == null) return;

      final doorbotId = body['doorbot_id'];
      if (doorbotId != _camera.id) {
        // Ignore messages for other cameras
        return;
      }

      // Handle session_created and session_started to get session ID
      if (['session_created', 'session_started'].contains(method) &&
          body.containsKey('session_id') &&
          _sessionId == null) {
        _sessionId = body['session_id'] as String;
        onSessionId.add(_sessionId!);
      }

      // Ignore messages for other sessions
      final msgSessionId = body['session_id'];
      if (msgSessionId != null && msgSessionId != _sessionId) {
        return;
      }

      switch (method) {
        case 'session_created':
        case 'session_started':
          // Session already stored above
          break;

        case 'sdp':
          // Received SDP answer
          final sdp = body['sdp'] as String;
          logDebug('[SDP] Answer received (${sdp.length} bytes)');
          // Check if ICE candidates are bundled in SDP
          final candidateLines =
              sdp.split('\n').where((l) => l.startsWith('a=candidate:'));
          logDebug('[SDP] Contains ${candidateLines.length} bundled candidates');
          // Log audio/video directions
          final lines = sdp.split('\n');
          String? currentMedia;
          for (final line in lines) {
            if (line.startsWith('m=audio')) {
              currentMedia = 'audio';
            } else if (line.startsWith('m=video')) {
              currentMedia = 'video';
            } else if (line.startsWith('a=sendrecv') ||
                line.startsWith('a=recvonly') ||
                line.startsWith('a=sendonly') ||
                line.startsWith('a=inactive')) {
              logDebug('[SDP] $currentMedia direction: ${line.substring(2)}');
            }
          }
          await _pc.acceptAnswer(SessionDescription(type: 'answer', sdp: sdp));
          onCallAnswered.add(sdp);
          _activate();
          break;

        case 'ice':
          // Received ICE candidate
          final iceCandidate = body['ice'] as String;
          logDebug('Received remote ICE candidate: $iceCandidate');
          await _pc.addIceCandidate(
            RTCIceCandidate(
              candidate: iceCandidate,
              sdpMLineIndex: body['mlineindex'] as int?,
            ),
          );
          break;

        case 'pong':
          // Ping response, nothing to do
          break;

        case 'notification':
          final text = body['text'] as String?;
          if (text == 'camera_connected') {
            onCameraConnected.add(null);
          } else if (text == 'PeerConnectionState::kConnecting' ||
              text == 'PeerConnectionState::kConnected') {
            // Internal state notifications, ignore
          }
          break;

        case 'close':
          logError('Video stream closed');
          logError(body);
          _callEnded();
          break;

        case 'camera_started':
        case 'stream_info':
          // Ignore these messages as we don't use them
          break;

        default:
          logError('UNKNOWN MESSAGE: $method');
          logError(message);
      }
    } catch (e) {
      if (e.toString().contains('negotiate codecs failed')) {
        onError.add(
          Exception(
            'Failed to negotiate codecs. This is a known issue with Ring cameras. '
            'Please see https://github.com/dgreif/ring/wiki/Streaming-Legacy-Mode',
          ),
        );
      } else {
        onError.add(e);
      }
    }
  }

  /// Send a message that requires session ID
  void _sendSessionMessage(String method, [Map<String, dynamic>? body]) {
    void doSend(String sessionId) {
      final message = {
        'method': method,
        'dialog_id': _dialogId,
        'body': {...?body, 'doorbot_id': _camera.id, 'session_id': sessionId},
      };
      _sendMessage(message);
    }

    if (_sessionId != null) {
      // Send immediately if we already have a session id
      // This is needed to send `close` before closing the websocket
      doSend(_sessionId!);
    } else {
      // Otherwise wait for the session id to be set
      addSubscription(onSessionId.take(1).listen(doSend));
    }
  }

  /// Send a message over WebSocket
  void _sendMessage(Map<String, dynamic> message) {
    if (_hasEnded || !_wsConnected) return;
    final method = message['method'] as String?;
    logDebug('[WS] Sending: $method');
    _ws.add(jsonEncode(message));
  }

  /// Activate the session to keep it alive longer than 70 seconds
  void _activate() {
    logInfo('Activating Session');
    _sendSessionMessage('activate_session');
    _sendSessionMessage('stream_options', {
      'audio_enabled': true,
      'video_enabled': true,
    });
  }

  /// Send an audio packet to the camera
  void sendAudioPacket(RtpPacket rtp) {
    if (_hasEnded) return;

    if (_pc case final WebRTCPeerConnection webrtcPc) {
      webrtcPc.writeAudioRtp(rtp);
    } else {
      throw UnsupportedError(
        'Cannot send audio packets to a custom peer connection implementation',
      );
    }
  }

  /// Activate the camera speaker for two-way audio
  void activateCameraSpeaker() {
    // Fire and forget - don't wait for camera_connected
    addSubscription(
      onCameraConnected.take(1).listen((_) {
        _sendSessionMessage('camera_options', {'stealth_mode': false});
      }),
    );
  }

  /// Request a key frame from the camera
  void requestKeyFrame() {
    _pc.requestKeyFrame();
  }

  /// End the call
  void _callEnded() {
    if (_hasEnded) return;

    try {
      _sendMessage({
        'reason': {'code': 0, 'text': ''},
        'method': 'close',
      });
      if (_wsConnected) {
        _ws.close();
      }
    } catch (_) {
      // Ignore errors when stopping
    }
    _hasEnded = true;

    unsubscribe();
    onCallEnded.add(null);
    _pc.close();
  }

  /// Stop the streaming connection
  void stop() {
    _callEnded();
  }
}
