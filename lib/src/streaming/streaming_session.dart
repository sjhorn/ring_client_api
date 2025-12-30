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

  /// Audio splitter for forwarding audio RTP to FFmpeg
  final _audioSplitter = RtpSplitter();

  /// Video splitter for forwarding video RTP to FFmpeg
  final _videoSplitter = RtpSplitter();

  /// Return audio splitter for sending audio back to camera
  final _returnAudioSplitter = RtpSplitter();

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

  /// Audio packet count for debugging
  int _audioPacketCount = 0;

  /// Video packet count for debugging
  int _videoPacketCount = 0;

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

  /// Parse Ring's SDP and extract media sections for FFmpeg
  ///
  /// Matches TypeScript's getCleanSdp() function.
  /// Splits SDP by media sections and optionally filters video.
  /// Also converts encrypted transport to plain RTP since webrtc_dart
  /// handles DTLS-SRTP decryption and forwards plain RTP to FFmpeg.
  ///
  /// See WEBRTC_ISSUE.md for known audio RTP routing issue in webrtc_dart.
  String _getCleanSdp(String sdp, bool includeVideo) {
    return sdp
        .split('\nm=')
        .skip(1) // Skip the session-level part before first m=
        .map((section) => 'm=$section')
        .where((section) => includeVideo || !section.startsWith('m=video'))
        // Convert encrypted transport to plain RTP for FFmpeg
        // (webrtc_dart decrypts SRTP to plain RTP before forwarding)
        .map((section) => section
            .replaceAll('UDP/TLS/RTP/SAVPF', 'RTP/AVP')
            .replaceAll('UDP/TLS/RTP/SAVP', 'RTP/AVP'))
        // Remove DTLS/crypto attributes that FFmpeg doesn't need
        .map((section) {
          final lines = section.split('\n');
          final filteredLines = lines.where((line) =>
              !line.startsWith('a=fingerprint:') &&
              !line.startsWith('a=setup:') &&
              !line.startsWith('a=ice-ufrag:') &&
              !line.startsWith('a=ice-pwd:') &&
              !line.startsWith('a=candidate:'));
          return filteredLines.join('\n');
        })
        .join('\n');
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

    // Reserve dynamic ports for audio and video (matching TypeScript)
    final videoPort = await reservePort(bufferPorts: 1);
    final audioPort = await reservePort(bufferPorts: 1);
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

    logDebug('Ring SDP answer:\n$ringSdp');

    // Check if using Opus codec (matching TypeScript)
    final usingOpus = await isUsingOpus;
    logDebug('Using Opus: $usingOpus');

    // Build FFmpeg input arguments (matching TypeScript)
    final ffmpegInputArgs = <String>[
      '-hide_banner',
      '-protocol_whitelist', 'pipe,udp,rtp,file,crypto',
      // Ring will answer with either opus or pcmu
      if (usingOpus) ...['-acodec', 'libopus'],
      '-f', 'sdp',
      ...?options.input,
      '-i', 'pipe:',
    ];

    // Parse Ring's SDP and replace ports (matching TypeScript getCleanSdp)
    var inputSdp = _getCleanSdp(ringSdp, transcodeVideoStream)
        .replaceFirst(RegExp(r'm=audio \d+'), 'm=audio $audioPort')
        .replaceFirst(RegExp(r'm=video \d+'), 'm=video $videoPort');

    logDebug('FFmpeg SDP (after port replacement):\n$inputSdp');

    // Build full FFmpeg arguments (matching TypeScript)
    final ffmpegArgs = <String>[
      ...ffmpegInputArgs,
      // Audio codec: default to aac if not specified
      ...(options.audio ?? ['-acodec', 'aac']),
      // Video codec: copy if not specified
      if (transcodeVideoStream)
        ...(options.video as List<String>? ?? ['-vcodec', 'copy']),
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

      // Forward audio RTP to FFmpeg (matching TypeScript)
      addSubscription(
        onAudioRtp.listen((rtp) {
          _audioPacketCount++;
          if (_audioPacketCount <= 5 || _audioPacketCount % 100 == 0) {
            logDebug('Audio RTP packet #$_audioPacketCount, size=${rtp.serialize().length}');
          }
          _audioSplitter.send(rtp.serialize().toList(), port: audioPort);
        }),
      );

      // Forward video RTP to FFmpeg (matching TypeScript)
      if (transcodeVideoStream) {
        addSubscription(
          onVideoRtp.listen((rtp) {
            _videoPacketCount++;
            if (_videoPacketCount <= 5 || _videoPacketCount % 100 == 0) {
              logDebug('Video RTP packet #$_videoPacketCount, size=${rtp.serialize().length}');
            }
            _videoSplitter.send(rtp.serialize().toList(), port: videoPort);
          }),
        );
      }

      // Stop FFmpeg and clean up when call ends
      addSubscription(
        onCallEnded.take(1).listen((_) {
          logDebug('Call ended - audio packets: $_audioPacketCount, video packets: $_videoPacketCount');
          _ffmpegProcess?.kill();
        }),
      );

      // Write SDP to FFmpeg stdin (matching TypeScript ff.writeStdin)
      _ffmpegProcess!.stdin.writeln(inputSdp);
      await _ffmpegProcess!.stdin.close();

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
    // Close splitters (matching TypeScript)
    _audioSplitter.close();
    _videoSplitter.close();
    _returnAudioSplitter.close();
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
