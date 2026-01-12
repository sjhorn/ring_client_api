import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

void main() async {
  // Get refresh token from environment variable or .env file
  var refreshToken = Platform.environment['RING_REFRESH_TOKEN'];

  if (refreshToken == null || refreshToken.isEmpty) {
    // Fallback to .env file
    final envFile = File('.env');
    if (await envFile.exists()) {
      final envContent = await envFile.readAsString();
      final line = envContent
          .split('\n')
          .where(
            (l) =>
                l.startsWith('refreshToken=') ||
                l.startsWith('RING_REFRESH_TOKEN='),
          )
          .firstOrNull;
      if (line != null) {
        refreshToken = line.split('=').skip(1).join('=').trim();
      }
    }
  }

  if (refreshToken == null || refreshToken.isEmpty) {
    print(
      'Error: Set RING_REFRESH_TOKEN environment variable or create .env file',
    );
    exit(1);
  }

  // Create API instance
  final api = RingApi(
    RefreshTokenAuth(refreshToken: refreshToken),
    options: RingApiOptions(debug: false),
  );

  try {
    // Get all cameras
    final cameras = await api.getCameras();

    print('=== Camera Comparison (Dart) ===');
    print('Total cameras: ${cameras.length}\n');

    for (final camera in cameras) {
      print('Camera: ${camera.name}');
      print('  ID: ${camera.id}');
      print('  Type: ${camera.deviceType}');
      print('  Battery Level: ${camera.batteryLevel ?? "null"}');
      print(
        '  Battery Life: ${camera.data is CameraData ? (camera.data as CameraData).batteryLife ?? "null" : "N/A"}',
      );
      print(
        '  Battery Life 2: ${camera.data is CameraData ? (camera.data as CameraData).batteryLife2 ?? "null" : "N/A"}',
      );
      print(
        '  Battery Voltage: ${camera.data is CameraData ? (camera.data as CameraData).batteryVoltage ?? "null" : "N/A"}',
      );
      print(
        '  External Connection: ${camera.data is CameraData ? (camera.data as CameraData).externalConnection ?? "null" : "N/A"}',
      );
      print('  Offline: ${camera.isOffline}');
      print('');
    }
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
  }

  await api.disconnect();
}
