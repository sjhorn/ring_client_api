/// Return audio example - Send audio to a Ring camera
///
/// This example demonstrates two-way audio functionality by playing
/// an audio file through a Ring camera's speaker.
///
/// Requirements:
/// - FFmpeg must be installed and in your PATH
/// - An audio file to play (e.g., example.mp4 or example.mp3)
/// - Valid Ring credentials
///
/// Usage:
///   dart run example/return_audio_example.dart
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
    print('  dart run example/return_audio_example.dart');
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

  // Check for audio file
  final audioFile = File('example/example.mp4');
  if (!audioFile.existsSync()) {
    print('Note: No example.mp4 found in example/ directory.');
    print('Creating a test tone using FFmpeg...');

    // Generate a 5-second test tone
    final result = await Process.run('ffmpeg', [
      '-f',
      'lavfi',
      '-i',
      'sine=frequency=440:duration=5',
      '-y',
      'example/test_tone.mp3',
    ]);

    if (result.exitCode != 0) {
      print('Failed to generate test tone');
      exit(1);
    }
    print('Created test_tone.mp3');
  }

  final inputFile =
      audioFile.existsSync() ? 'example/example.mp4' : 'example/test_tone.mp3';

  print('Return Audio Example');
  print('====================');
  print('Audio file: $inputFile');
  print('');

  // Create API instance
  final api = RingApi(RefreshTokenAuth(refreshToken: refreshToken));

  try {
    // Get cameras
    print('Fetching cameras...');
    final cameras = await api.getCameras();

    if (cameras.isEmpty) {
      print('No cameras found');
      exit(1);
    }

    final camera = cameras[1]; //cameras.first;
    print('Using camera: ${camera.name}');
    print('');

    // Start live call
    print('Starting live call...');
    final session = await camera.startLiveCall();

    print('Call started, activating return audio...');

    // Activate camera speaker and start return audio transcoding
    await Future.wait([
      session.transcodeReturnAudio(input: [inputFile]),
      Future(() => session.activateCameraSpeaker()),
    ]);

    print('Playing audio through camera speaker...');
    print('Press Ctrl+C to stop, or wait for audio to finish.');

    // Wait for call to end or timeout after 10 seconds
    await Future.any([
      session.onCallEnded.first,
      Future.delayed(const Duration(seconds: 10)),
    ]);

    print('');
    print('Stopping call...');
    session.stop();

    // Wait for async cleanup to complete
    await Future.delayed(const Duration(milliseconds: 500));

    print('Done!');
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    try {
      await api.disconnect();
    } catch (e) {
      // Ignore cleanup errors from WebRTC shutdown
    }
    // Exit explicitly to avoid hanging on pending WebRTC timers
    exit(0);
  }
}
