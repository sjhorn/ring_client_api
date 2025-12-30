/// Record example - Record video from a Ring camera
///
/// This example records a 10 second video clip to output/example.mp4
///
/// Requirements:
/// - FFmpeg must be installed and in your PATH
/// - Valid Ring credentials
///
/// Usage:
///   dart run example/record_example.dart
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
    print('  dart run example/record_example.dart');
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

  // Create output directory
  final outputDir = Directory('output');
  if (outputDir.existsSync()) {
    await outputDir.delete(recursive: true);
  }
  await outputDir.create();

  print('Record Example');
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

    final camera = cameras[1];
    print('Starting Video from ${camera.name}...');

    // Record 10 seconds to output/example.mp4
    await camera.recordToFile('output/example.mp4', 10);

    print('Done recording video');
    print('Output saved to: output/example.mp4');
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
