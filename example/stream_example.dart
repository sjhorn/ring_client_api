/// Stream example - Stream video to segmented files
///
/// This example streams video to files, each with 10 seconds of video.
/// The output will be in output/part0.mp4, output/part1.mp4, etc.
///
/// Requirements:
/// - FFmpeg must be installed and in your PATH
/// - Valid Ring credentials
///
/// Usage:
///   dart run example/stream_example.dart
library;

import 'dart:async';
import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

Future<void> main() async {
  // Run in guarded zone to catch async cleanup errors from WebRTC
  await runZonedGuarded(() => _main(), (error, stack) {
    // Ignore WebRTC cleanup errors
    if (error.toString().contains('Cannot add new events after calling close')) {
      return;
    }
    print('Unhandled error: $error');
  });
}

Future<void> _main() async {
  // Get credentials from environment or .env file
  var refreshToken = Platform.environment['RING_REFRESH_TOKEN'];

  if (refreshToken == null || refreshToken.isEmpty) {
    // Fallback to .env file
    final envFile = File('.env');
    if (await envFile.exists()) {
      final envContent = await envFile.readAsString();
      final line = envContent.split('\n').where(
        (l) => l.startsWith('refreshToken=') || l.startsWith('RING_REFRESH_TOKEN='),
      ).firstOrNull;
      if (line != null) {
        refreshToken = line.split('=').skip(1).join('=').trim();
      }
    }
  }

  if (refreshToken == null || refreshToken.isEmpty) {
    print('Error: Set RING_REFRESH_TOKEN environment variable or create .env file');
    print('');
    print('Example:');
    print('  export RING_REFRESH_TOKEN="your_token"');
    print('  dart run example/stream_example.dart');
    exit(1);
  }

  // Check if FFmpeg is available
  try {
    final result = await Process.run('ffmpeg', ['-version']);
    if (result.exitCode != 0) {
      print('Error: FFmpeg not found. Please install FFmpeg.');
      exit(1);
    }
  } catch (e) {
    print('Error: FFmpeg not found. Please install FFmpeg.');
    exit(1);
  }

  // Create/clean output directory
  final outputDir = Directory('output');
  if (outputDir.existsSync()) {
    await outputDir.delete(recursive: true);
  }
  await outputDir.create();

  print('Stream Example');
  print('==============');
  print('');

  // Create API instance
  final ringApi = RingApi(
    RefreshTokenAuth(refreshToken: refreshToken),
    options: RingApiOptions(debug: true),
  );

  try {
    // Get cameras
    final cameras = await ringApi.getCameras();

    if (cameras.isEmpty) {
      print('No cameras found');
      exit(1);
    }

    final camera = cameras.first;

    print('Starting Video...');

    // Stream video with 10 second segments
    // https://superuser.com/questions/999400/how-to-use-ffmpeg-to-extract-live-stream-into-a-sequence-of-mp4
    final call = await camera.streamVideo(
      FfmpegOptions(
        output: [
          '-flags',
          '+global_header',
          '-f',
          'segment',
          '-segment_time',
          '10', // 10 seconds per segment
          '-segment_format_options',
          'movflags=+faststart',
          '-reset_timestamps',
          '1',
          'output/part%d.mp4',
        ],
      ),
    );

    print('Video started, streaming to part files...');

    // Subscribe to call ended event
    call.onCallEnded.listen((_) {
      print('Call has ended');
    });

    // Stop after 1 minute
    Timer(Duration(seconds: 60), () {
      print('Stopping call...');
      call.stop();
    });

    // Wait for call to end
    await call.onCallEnded.first;

    print('Done! Check output/ directory for part files.');
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    try {
      await ringApi.disconnect();
    } catch (e) {
      // Ignore cleanup errors
    }
    exit(0);
  }
}
