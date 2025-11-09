import 'package:ring_client_api/ring_client_api.dart';

void main() async {
  // Example 1: Create API instance with refresh token
  final api = RingApi(
    RefreshTokenAuth(refreshToken: 'your-refresh-token-here'),
    options: RingApiOptions(
      debug: true,
      cameraStatusPollingSeconds: 20,
      locationModePollingSeconds: 20,
    ),
  );

  // Example 2: Listen for refresh token updates to save the new token
  api.onRefreshTokenUpdated.listen((update) {
    print('Refresh token updated: ${update.newRefreshToken}');
    // TODO: Save the new token to persistent storage
  });

  // Example 3: Get all locations
  final locations = await api.getLocations();
  print('Found ${locations.length} locations:');
  for (final location in locations) {
    print('  - ${location.name} (${location.id})');
  }

  // Example 4: Get all cameras
  final cameras = await api.getCameras();
  print('\nFound ${cameras.length} cameras:');
  for (final camera in cameras) {
    print('  - ${camera.name} (${camera.deviceType})');
    print('    Battery: ${camera.batteryLevel}%');
    print('    Offline: ${camera.isOffline}');
  }

  // Example 5: Get a snapshot from a camera
  if (cameras.isNotEmpty) {
    final camera = cameras.first;
    print('\nGetting snapshot from ${camera.name}...');
    try {
      final snapshot = await camera.getSnapshot();
      print('Snapshot received: ${snapshot.length} bytes');
      // TODO: Save snapshot to file
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
    final events = await camera.getEvents(
      CameraEventOptions(limit: 10),
    );
    print('\nRecent events for ${camera.name}:');
    for (final event in events.events) {
      print('  - ${event.kind} at ${event.createdAt}');
    }
  }

  // Example 9: Control a location's alarm mode
  if (locations.isNotEmpty) {
    final location = locations.first;
    if (location.hasAlarmBaseStation) {
      print('\nSetting alarm to away mode...');
      try {
        await location.armAway();
        print('Alarm armed in away mode');
      } catch (e) {
        print('Failed to arm alarm: $e');
      }
    }
  }

  // Clean up when done
  print('\nDisconnecting...');
  api.disconnect();
}
