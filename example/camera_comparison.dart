import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

void main() async {
  // Load refresh token from .env file
  final envFile = File('.env');
  final envContent = await envFile.readAsString();
  final refreshToken = envContent
      .split('\n')
      .firstWhere((line) => line.startsWith('refreshToken='))
      .split('=')[1]
      .trim();

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
