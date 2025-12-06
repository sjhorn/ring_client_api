#!/usr/bin/env dart

/// Stream video from a Ring camera using WebRTC
///
/// This example demonstrates how to use the WebRTC streaming functionality
/// to record video from a Ring camera to a file.
///
/// Requirements:
/// - FFmpeg must be installed and in your PATH
/// - Valid Ring credentials (set RING_EMAIL and RING_PASSWORD env vars,
///   or RING_REFRESH_TOKEN)
///
/// Usage:
///   dart run bin/stream_camera.dart [duration_seconds] [output_file]
///
/// Example:
///   dart run bin/stream_camera.dart 30 recording.mp4
library;

import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

Future<void> main(List<String> args) async {
  // Parse arguments
  final duration = args.isNotEmpty ? int.tryParse(args[0]) ?? 30 : 30;
  final outputFile = args.length > 1 ? args[1] : 'ring_recording.mp4';

  // Get credentials from environment
  final email = Platform.environment['RING_EMAIL'];
  final password = Platform.environment['RING_PASSWORD'];
  final refreshToken = Platform.environment['RING_REFRESH_TOKEN'];

  if (refreshToken == null && (email == null || password == null)) {
    print('Error: Set RING_EMAIL and RING_PASSWORD, or RING_REFRESH_TOKEN');
    print('');
    print('Example:');
    print('  export RING_EMAIL="your@email.com"');
    print('  export RING_PASSWORD="your_password"');
    print('  dart run bin/stream_camera.dart');
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

  print('Ring Camera Streaming Example');
  print('==============================');
  print('Duration: ${duration}s');
  print('Output: $outputFile');
  print('');

  // Create API instance
  final dynamic authOptions;
  if (refreshToken != null) {
    authOptions = RefreshTokenAuth(refreshToken: refreshToken);
  } else {
    authOptions = EmailAuth(email: email!, password: password!);
  }

  final api = RingApi(authOptions);

  try {
    // Get locations and cameras
    print('Fetching locations...');
    final locations = await api.getLocations();

    if (locations.isEmpty) {
      print('No locations found');
      exit(1);
    }

    // Find first camera
    RingCamera? camera;
    for (final location in locations) {
      if (location.cameras.isNotEmpty) {
        camera = location.cameras.first;
        print('Found camera: ${camera.name}');
        break;
      }
    }

    if (camera == null) {
      print('No cameras found');
      exit(1);
    }

    // Start streaming
    print('');
    print('Starting live stream...');
    print('Recording for $duration seconds to $outputFile');
    print('');

    final session = await camera.startLiveCall();

    // Start transcoding to file
    await session.startTranscoding(
      FfmpegOptions(
        output: [
          '-t',
          duration.toString(),
          '-c:v',
          'libx264',
          '-preset',
          'fast',
          '-c:a',
          'aac',
          outputFile,
        ],
      ),
    );

    print('Streaming... Press Ctrl+C to stop early.');

    // Wait for call to end
    await session.onCallEnded.first;

    print('');
    print('Recording complete: $outputFile');
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
