/// Streaming session management for Ring cameras
///
/// This class manages the lifecycle of a Ring camera streaming session,
/// including forwarding RTP packets and optionally transcoding with FFmpeg.
library;

import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../ring_camera.dart';
import '../subscribed.dart';
import '../util.dart';
import 'peer_connection.dart';
import 'webrtc_connection.dart';

/// FFmpeg options for transcoding
class FfmpegOptions {
  /// Input arguments (before -i)
  final List<String>? input;

  /// Video arguments (after input, before output). Set to false to disable video.
  final dynamic video; // List<String> or false

  /// Audio arguments
  final List<String>? audio;

  /// Callback for stdout data
  final void Function(List<int> data)? stdoutCallback;

  /// Output arguments
  final List<String> output;

  FfmpegOptions({
    this.input,
    this.video,
    this.audio,
    this.stdoutCallback,
    required this.output,
  });
}


/// RTP Splitter for forwarding RTP packets to a UDP port
///
/// This is a simplified version of @homebridge/camera-utils RtpSplitter.
/// It forwards RTP packets to a local UDP socket.
class RtpSplitter {
  RawDatagramSocket? _socket;
  final void Function(List<int> message)? _onMessage;

  /// Completer for the port
  final _portCompleter = Completer<int>();

  /// Get the port when ready
  Future<int> get portPromise => _portCompleter.future;

  RtpSplitter([this._onMessage]) {
    _bind();
  }

  Future<void> _bind() async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
      _portCompleter.complete(_socket!.port);

      if (_onMessage != null) {
        _socket!.listen((event) {
          if (event == RawSocketEvent.read) {
            final datagram = _socket!.receive();
            if (datagram != null) {
              _onMessage(datagram.data);
            }
          }
        });
      }
    } catch (e) {
      _portCompleter.completeError(e);
    }
  }

  /// Send data to a specific port
  Future<void> send(List<int> data, {required int port}) async {
    final sent = _socket?.send(data, InternetAddress.loopbackIPv4, port);
    if (sent != data.length) {
      print('[RtpSplitter] Failed to send: sent=$sent expected=${data.length}');
    }
  }

  /// Close the splitter
  void close() {
    _socket?.close();
    _socket = null;
  }
}

/// Reserve a UDP port
Future<int> reservePort() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  socket.close();
  return port;
}

/// Streaming session for Ring camera video/audio
///
/// This class:
/// 1. Binds to a WebRTC connection
/// 2. Receives RTP audio/video packets
/// 3. Optionally transcodes streams using FFmpeg
/// 4. Handles return audio for two-way communication
/// 5. Manages session lifecycle
class StreamingSession extends Subscribed {
  /// Emits when the call ends
  final onCallEnded = ReplaySubject<void>(maxSize: 1);

  /// Emits when we know if Opus is being used
  final _onUsingOpus = ReplaySubject<bool>(maxSize: 1);

  /// Video RTP packets
  final onVideoRtp = PublishSubject<RtpPacket>();

  /// Audio RTP packets
  final onAudioRtp = PublishSubject<RtpPacket>();


  /// The camera being streamed
  final RingCamera camera;

  /// The WebRTC connection
  final WebRTCConnection connection;

  /// Whether the call has ended
  bool _hasEnded = false;

  /// Whether the call has ended
  bool get hasEnded => _hasEnded;

  /// Whether the camera speaker has been activated
  bool cameraSpeakerActivated = false;

  /// FFmpeg process for transcoding
  Process? _ffmpegProcess;

  StreamingSession(this.camera, this.connection) {
    _bindToConnection(connection);
  }

  /// Bind to the WebRTC connection events
  void _bindToConnection(WebRTCConnection conn) {
    addSubscriptions([
      // Forward RTP packets
      conn.onAudioRtp.listen((rtp) => onAudioRtp.add(rtp)),
      conn.onVideoRtp.listen((rtp) => onVideoRtp.add(rtp)),

      // Detect codec from SDP answer
      conn.onCallAnswered.listen((sdp) {
        _onUsingOpus.add(sdp.toLowerCase().contains(' opus/'));
      }),

      // Handle call ended
      conn.onCallEnded.listen((_) => _callEnded()),
    ]);
  }

  /// @deprecated Use requestKeyFrame() instead
  void activate() {
    requestKeyFrame();
  }

  /// Activate the camera speaker for two-way audio
  void activateCameraSpeaker() {
    if (cameraSpeakerActivated || _hasEnded) {
      return;
    }
    cameraSpeakerActivated = true;
    connection.activateCameraSpeaker();
  }

  /// Reserve a UDP port for RTP streaming
  Future<int> reservePort({int bufferPorts = 0}) async {
    // Reserve extra ports as buffer, return the first one
    final ports = <int>[];
    for (var i = 0; i <= bufferPorts; i++) {
      final socket = await RawDatagramSocket.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      ports.add(socket.port);
      socket.close();
    }
    return ports[0];
  }

  /// Check if the session is using Opus audio codec
  Future<bool> get isUsingOpus async {
    // Wait for either the codec info or an error
    return await _onUsingOpus.first.timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('Timed out waiting for codec'),
    );
  }

  /// Build a simplified SDP for FFmpeg from Ring's SDP answer
  ///
  /// The WebRTC library handles DTLS-SRTP decryption, so we receive plain RTP.
  /// FFmpeg needs an SDP that describes plain RTP on localhost.
  /// Note: Ring cameras typically don't send audio unless speaker is activated,
  /// so we use video-only SDP for more reliable recording.
  String _buildFfmpegSdp({required int videoPort}) {
    final buffer = StringBuffer();
    buffer.writeln('v=0');
    buffer.writeln('o=- 0 0 IN IP4 127.0.0.1');
    buffer.writeln('s=Ring Camera');
    buffer.writeln('c=IN IP4 127.0.0.1');
    buffer.writeln('t=0 0');
    buffer.writeln('m=video $videoPort RTP/AVP 98');
    buffer.writeln('a=rtpmap:98 H264/90000');
    buffer.writeln('a=fmtp:98 profile-level-id=42e01f;packetization-mode=1');
    return buffer.toString().trim();
  }

  /// Start transcoding the camera stream with FFmpeg
  ///
  /// This:
  /// 1. Waits for the WebRTC connection to be established
  /// 2. Starts FFmpeg with the appropriate codecs
  /// 3. Forwards RTP packets to FFmpeg
  /// 4. Processes the transcoded output
  Future<void> startTranscoding(FfmpegOptions options) async {
    if (_hasEnded) {
      return;
    }

    // Reserve dynamic port for video
    final videoPort = await reservePort(bufferPorts: 1);
    final transcodeVideoStream = options.video != false;

    // Wait for call to be answered
    final ringSdp = await Future.any([
      connection.onCallAnswered.first,
      onCallEnded.first.then((_) => null),
    ]);

    if (ringSdp == null) {
      logDebug('Call ended before answered');
      return;
    }

    // Build a simplified SDP for FFmpeg (video only, plain RTP on localhost)
    final inputSdp = _buildFfmpegSdp(videoPort: videoPort);
    logDebug('FFmpeg SDP:\n$inputSdp');

    // Build FFmpeg arguments - video only for reliability
    // Ring cameras don't send audio unless speaker is activated
    final ffmpegArgs = <String>[
      '-hide_banner',
      '-protocol_whitelist', 'pipe,udp,rtp,file,crypto',
      '-f', 'sdp',
      ...?options.input,
      '-i', 'pipe:',
      // Video only - no audio stream in SDP
      '-an', // Disable audio output
      if (transcodeVideoStream) ...(options.video as List<String>? ?? ['-vcodec', 'copy']),
      ...options.output,
    ];

    // Start FFmpeg process
    logDebug('Starting FFmpeg: ffmpeg ${ffmpegArgs.join(" ")}');
    try {
      _ffmpegProcess = await Process.start('ffmpeg', ffmpegArgs);

      // Handle stdout
      if (options.stdoutCallback != null) {
        _ffmpegProcess!.stdout.listen(options.stdoutCallback);
      }

      // Handle stderr (FFmpeg outputs logs to stderr)
      _ffmpegProcess!.stderr.transform(const SystemEncoding().decoder).listen((
        data,
      ) {
        logDebug('FFmpeg: $data');
      });

      // Handle exit
      unawaited(_ffmpegProcess!.exitCode.then((code) {
        logDebug('FFmpeg exited with code: $code');
        _callEnded();
      }));

      // Create UDP socket for forwarding video RTP to FFmpeg
      final videoSocket = await RawDatagramSocket.bind(
        InternetAddress.loopbackIPv4,
        0,
      );

      // Forward video RTP to FFmpeg
      if (transcodeVideoStream) {
        addSubscription(
          onVideoRtp.listen((rtp) {
            videoSocket.send(
              rtp.serialize().toList(),
              InternetAddress.loopbackIPv4,
              videoPort,
            );
          }),
        );
      }

      // Stop FFmpeg and clean up socket when call ends
      addSubscription(
        onCallEnded.take(1).listen((_) {
          _ffmpegProcess?.kill();
          videoSocket.close();
        }),
      );

      // Write SDP to FFmpeg stdin
      _ffmpegProcess!.stdin.writeln(inputSdp);
      await _ffmpegProcess!.stdin.close();

      // Give FFmpeg a moment to parse SDP and start listening on UDP ports
      await Future.delayed(const Duration(milliseconds: 100));

      // Request a key frame now that FFmpeg is ready
      requestKeyFrame();
    } catch (e) {
      logError('Failed to start FFmpeg: $e');
      rethrow;
    }
  }

  /// Transcode return audio to send back to the camera
  ///
  /// This:
  /// 1. Takes audio input (file, stream, etc.)
  /// 2. Transcodes it to Opus or PCMU
  /// 3. Sends RTP packets back to the camera
  Future<void> transcodeReturnAudio({required List<String> input}) async {
    if (_hasEnded) {
      return;
    }

    // Create splitter that forwards RTP to the connection
    final audioOutForwarder = RtpSplitter((message) {
      final rtp = RtpPacket.parse(message as dynamic);
      connection.sendAudioPacket(rtp);
    });

    final usingOpus = await isUsingOpus;
    final port = await audioOutForwarder.portPromise;

    final ffmpegArgs = <String>[
      '-hide_banner',
      '-protocol_whitelist',
      'pipe,udp,rtp,file,crypto',
      '-re',
      '-i',
      ...input,
      '-acodec',
      if (usingOpus) ...[
        'libopus',
        '-ac',
        '2',
        '-ar',
        '48k',
      ] else ...[
        'pcm_mulaw',
        '-ac',
        '1',
        '-ar',
        '8k',
      ],
      '-flags',
      '+global_header',
      '-f',
      'rtp',
      'rtp://127.0.0.1:$port',
    ];

    try {
      final ffProcess = await Process.start('ffmpeg', ffmpegArgs);

      ffProcess.stderr.transform(const SystemEncoding().decoder).listen((data) {
        logDebug('Return Audio (${camera.name}): $data');
      });

      ffProcess.exitCode.then((_) {
        _callEnded();
      });

      // Stop FFmpeg when call ends
      addSubscription(
        onCallEnded.take(1).listen((_) {
          ffProcess.kill();
          audioOutForwarder.close();
        }),
      );
    } catch (e) {
      logError('Failed to start return audio FFmpeg: $e');
      audioOutForwarder.close();
      rethrow;
    }
  }

  /// End the call
  void _callEnded() {
    if (_hasEnded) {
      return;
    }
    _hasEnded = true;

    unsubscribe();
    onCallEnded.add(null);
    connection.stop();
    _ffmpegProcess?.kill();
  }

  /// Stop the streaming session
  void stop() {
    _callEnded();
  }

  /// Send an audio packet to the camera
  void sendAudioPacket(RtpPacket rtpPacket) {
    if (_hasEnded) {
      return;
    }
    connection.sendAudioPacket(rtpPacket);
  }

  /// Request a key frame from the camera
  void requestKeyFrame() {
    connection.requestKeyFrame();
  }
}
