/// Browser example - Stream video viewable in a web browser
///
/// This example creates an HLS stream which is viewable in a browser.
/// It starts a web server at http://localhost:3000 to view the stream.
///
/// Requirements:
/// - FFmpeg must be installed and in your PATH
/// - Valid Ring credentials
///
/// Usage:
///   dart run example/browser_example.dart
///
/// Then open http://localhost:3000 in your browser to view the stream.
library;

import 'dart:async';
import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

Future<void> main() async {
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
    print('  dart run example/browser_example.dart');
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

  print('Browser Streaming Example');
  print('=========================');
  print('');

  // Create public output directory for HLS files
  final publicDir = Directory('example/public');
  final outputDir = Directory('example/public/output');

  if (!publicDir.existsSync()) {
    await publicDir.create(recursive: true);
  }
  if (!outputDir.existsSync()) {
    await outputDir.create(recursive: true);
  }

  // Create index.html if it doesn't exist
  final indexFile = File('example/public/index.html');
  if (!indexFile.existsSync()) {
    await indexFile.writeAsString(_indexHtml);
    print('Created example/public/index.html');
  }

  // Start web server
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  print('Web server listening on http://localhost:3000');
  print('Open this URL in your browser to view the stream.');
  print('');

  // Handle HTTP requests
  server.listen((request) async {
    var path = request.uri.path;
    if (path == '/') path = '/index.html';

    final file = File('example/public$path');
    if (await file.exists()) {
      // Set content type based on extension
      final contentType = _getContentType(path);
      request.response.headers.contentType = contentType;

      // Add CORS headers for HLS
      request.response.headers.add('Access-Control-Allow-Origin', '*');

      await request.response.addStream(file.openRead());
      await request.response.close();
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not found: $path');
      await request.response.close();
    }
  });

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
      await server.close();
      exit(1);
    }

    final camera = cameras.first;
    print('Starting HLS stream from ${camera.name}...');
    print('');

    // Start streaming with HLS output
    final call = await camera.streamVideo(
      FfmpegOptions(
        output: [
          '-preset',
          'veryfast',
          '-g',
          '25',
          '-sc_threshold',
          '0',
          '-f',
          'hls',
          '-hls_time',
          '2',
          '-hls_list_size',
          '6',
          '-hls_flags',
          'delete_segments',
          'example/public/output/stream.m3u8',
        ],
      ),
    );

    print('Stream started! View at http://localhost:3000');
    print('Press Ctrl+C to stop.');

    // Subscribe to call ended event
    call.onCallEnded.listen((_) {
      print('Call has ended');
    });

    // Stop after 5 minutes
    Timer(Duration(minutes: 5), () {
      print('Stopping call after 5 minutes...');
      call.stop();
    });

    // Wait for call to end
    await call.onCallEnded.first;

    print('Shutting down...');
    await server.close();
  } catch (e) {
    print('Error: $e');
    await server.close();
    exit(1);
  } finally {
    await ringApi.disconnect();
  }
}

/// Get content type for file extension
ContentType _getContentType(String path) {
  if (path.endsWith('.html')) return ContentType.html;
  if (path.endsWith('.css')) return ContentType('text', 'css');
  if (path.endsWith('.js')) return ContentType('application', 'javascript');
  if (path.endsWith('.m3u8'))
    return ContentType('application', 'vnd.apple.mpegurl');
  if (path.endsWith('.ts')) return ContentType('video', 'mp2t');
  if (path.endsWith('.mp4')) return ContentType('video', 'mp4');
  return ContentType.binary;
}

/// HTML page with HLS.js player
const _indexHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Ring Camera Stream</title>
  <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #1a1a2e;
      color: #eee;
      margin: 0;
      padding: 20px;
      min-height: 100vh;
    }
    h1 {
      color: #00d9ff;
      margin-bottom: 20px;
    }
    .container {
      max-width: 900px;
      margin: 0 auto;
    }
    video {
      width: 100%;
      max-width: 800px;
      background: #000;
      border-radius: 8px;
    }
    .status {
      margin-top: 15px;
      padding: 10px;
      background: #16213e;
      border-radius: 4px;
      font-family: monospace;
    }
    .error { color: #ff6b6b; }
    .success { color: #51cf66; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Ring Camera Stream</h1>
    <video id="video" controls autoplay muted></video>
    <div id="status" class="status">Initializing...</div>
  </div>

  <script>
    const video = document.getElementById('video');
    const status = document.getElementById('status');
    const streamUrl = '/output/stream.m3u8';

    function updateStatus(message, isError = false) {
      status.textContent = message;
      status.className = 'status ' + (isError ? 'error' : 'success');
    }

    if (Hls.isSupported()) {
      const hls = new Hls({
        liveSyncDurationCount: 3,
        liveMaxLatencyDurationCount: 6,
      });

      hls.loadSource(streamUrl);
      hls.attachMedia(video);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        updateStatus('Stream loaded - playing...');
        video.play().catch(e => console.log('Autoplay blocked:', e));
      });

      hls.on(Hls.Events.ERROR, (event, data) => {
        if (data.fatal) {
          updateStatus('Stream error: ' + data.type + ' - Retrying...', true);
          setTimeout(() => hls.loadSource(streamUrl), 3000);
        }
      });

      // Retry loading if stream not available yet
      let retryCount = 0;
      hls.on(Hls.Events.ERROR, (event, data) => {
        if (data.type === Hls.ErrorTypes.NETWORK_ERROR && retryCount < 30) {
          retryCount++;
          updateStatus('Waiting for stream... (attempt ' + retryCount + '/30)', false);
          setTimeout(() => hls.loadSource(streamUrl), 2000);
        }
      });

    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Native HLS support (Safari)
      video.src = streamUrl;
      video.addEventListener('loadedmetadata', () => {
        updateStatus('Stream loaded - playing...');
        video.play();
      });
    } else {
      updateStatus('HLS is not supported in this browser', true);
    }
  </script>
</body>
</html>
''';
