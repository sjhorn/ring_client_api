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

  // Example 1: Create API instance with refresh token
  final api = RingApi(
    RefreshTokenAuth(refreshToken: refreshToken),
    options: RingApiOptions(
      debug: false, // Set to true for detailed debug logging
      cameraStatusPollingSeconds: 20,
      locationModePollingSeconds: 20,
    ),
  );

  // Example 2: Listen for refresh token updates to save the new token
  api.onRefreshTokenUpdated.listen((update) async {
    print('Refresh token updated, saving to .env...');
    try {
      // Save the updated token back to .env file
      await envFile.writeAsString('refreshToken=${update.newRefreshToken}\n');
      print('✓ Refresh token saved to .env');
    } catch (e) {
      print('✗ Failed to save refresh token: $e');
    }
  });

  // Example 3: Get all locations
  print('\n=== Testing API - Getting Locations ===');
  List locations = [];
  List cameras = [];

  try {
    locations = await api.getLocations();
    print('✓ SUCCESS! Found ${locations.length} locations');
    for (final location in locations) {
      print('  - Location: ${location.name} (ID: ${location.id})');
    }

    // Example 4: Get all cameras
    print('\n=== Getting Cameras ===');
    cameras = await api.getCameras();
    print('✓ Found ${cameras.length} cameras');
    for (final camera in cameras) {
      print('  - Camera: ${camera.name}');
      print('    Type: ${camera.deviceType}');
      print('    Battery: ${camera.batteryLevel ?? "N/A"}');
      print('    Offline: ${camera.isOffline}');
    }
  } catch (e, stack) {
    print('✗ Error: $e');
    print('Stack: $stack');
  }

  // Example 5: Get a snapshot from a camera
  if (cameras.isNotEmpty) {
    final camera = cameras.first;
    print('\nGetting snapshot from ${camera.name}...');
    try {
      final snapshot = await camera.getSnapshot();
      print('Snapshot received: ${snapshot.length} bytes');

      // Save snapshot to file
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename =
          'snapshot_${camera.name.replaceAll(' ', '_')}_$timestamp.jpg';
      final file = File(filename);
      await file.writeAsBytes(snapshot);
      print('✓ Snapshot saved to: $filename');
    } catch (e) {
      print('Failed to get snapshot: $e');
    }
  }

  // Example 6: Listen for doorbell events
  for (final camera in cameras.where((c) => c.isDoorbot)) {
    camera.onDoorbellPressed.listen((notification) {
      print('\nDoorbell pressed: ${camera.name}');
      print('  Event ID: ${notification.data.event.ding.id}');
    });
  }

  // Example 7: Listen for motion events
  for (final camera in cameras) {
    camera.onMotionDetected.listen((detected) {
      if (detected) {
        print('\nMotion detected: ${camera.name}');
      }
    });
  }

  // Example 8: Get camera events
  if (cameras.isNotEmpty) {
    final camera = cameras.first;
    final events = await camera.getEvents(CameraEventOptions(limit: 10));
    print('\nRecent events for ${camera.name}:');
    for (final event in events.events) {
      print('  - ${event.kind} at ${event.createdAt}');
    }
  }

  // Example 9: Get devices from locations with hubs
  for (final location in locations) {
    print('\n=== Location: ${location.name} ===');
    print('Has Hubs: ${location.hasHubs}');
    print('Has Alarm Base Station: ${location.hasAlarmBaseStation}');

    if (location.hasHubs) {
      print('Getting devices...');
      try {
        final devices = await location.getDevices();
        print('✓ Found ${devices.length} devices');
        for (final device in devices.take(3)) {
          print('  - Device: ${device.name}');
          print('    Type: ${device.deviceType}');
          print('    Category ID: ${device.categoryId}');
        }
      } catch (e, stack) {
        print('✗ Error getting devices: $e');
        print('Stack: $stack');
      }
    }
  }

  // Clean up when done
  print('\nDisconnecting...');
  await api.disconnect();
  print('Disconnected successfully!');
}
