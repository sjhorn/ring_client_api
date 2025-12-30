/// API example - Demonstrates various Ring API calls
///
/// This example shows how to use the Location and Camera APIs
/// to retrieve events, history, and recording URLs.
///
/// Usage:
///   dart run example/api_example.dart
library;

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
    print('  dart run example/api_example.dart');
    exit(1);
  }

  print('API Example');
  print('===========');
  print('');

  // Create API instance
  final ringApi = RingApi(RefreshTokenAuth(refreshToken: refreshToken));

  try {
    final locations = await ringApi.getLocations();
    final cameras = await ringApi.getCameras();

    if (locations.isEmpty) {
      print('No locations found');
      exit(1);
    }

    final location = locations.first;

    if (cameras.isEmpty) {
      print('No cameras found');
      exit(1);
    }

    final camera = cameras.first;

    // === Locations API ===
    print('=== Location: ${location.name} ===');

    // Subscribe to connection status
    location.onConnected.listen((connected) {
      final state = connected ? 'Connected' : 'Connecting';
      print('$state to location ${location.name} - ${location.id}');
    });

    // Get camera events for location
    print('\nGetting location camera events...');
    try {
      final locationCameraEvents = await location.getCameraEvents(
        const CameraEventOptions(limit: 1),
      );
      if (locationCameraEvents.events.isNotEmpty) {
        final event = locationCameraEvents.events.first;
        print('Location Camera Event: ${event.kind} at ${event.createdAt}');
      } else {
        print('No camera events found');
      }
    } catch (e) {
      print('Failed to get camera events: $e');
    }

    // Get alarm history
    print('\nGetting alarm history...');
    try {
      final locationAlarmEvents = await location.getHistory(
        const HistoryOptions(limit: 1, category: 'alarm'),
      );
      if (locationAlarmEvents.isNotEmpty) {
        final event = locationAlarmEvents.first;
        print('Location Alarm Event: ${event.msg} (${event.datatype})');
      } else {
        print('No alarm events found');
      }
    } catch (e) {
      print('Failed to get alarm history: $e');
    }

    // Get beams history
    print('\nGetting beams history...');
    try {
      final locationBeamsEvents = await location.getHistory(
        const HistoryOptions(limit: 1, category: 'beams'),
      );
      if (locationBeamsEvents.isNotEmpty) {
        final event = locationBeamsEvents.first;
        print('Location Beams Event: ${event.msg} (${event.datatype})');
      } else {
        print('No beams events found');
      }
    } catch (e) {
      print('Failed to get beams history: $e');
    }

    // Get account monitoring status
    print('\nGetting account monitoring status...');
    try {
      final monitoringStatus = await location.getAccountMonitoringStatus();
      print('Monitoring Status: ${monitoringStatus.accountState}');
    } catch (e) {
      print('Monitoring status not available: $e');
    }

    // === Camera API ===
    print('\n=== Camera: ${camera.name} ===');

    // Get camera events with filters
    print('\nGetting camera events (ding, accepted)...');
    final eventsResponse = await camera.getEvents(
      CameraEventOptions(
        limit: 10,
        kind: DingKindConstants.ding,
        state: 'accepted',
        // olderThanId: previousEventsResponse.meta?.paginationKey,
        // favorites: true,
      ),
    );

    // Find first event with a ready recording
    final firstRecordedEvent = eventsResponse.events
        .where((event) => event.recordingStatus == 'ready')
        .firstOrNull;

    if (firstRecordedEvent == null) {
      print('No events with recordings found');
      print('Total events: ${eventsResponse.events.length}');
      await ringApi.disconnect();
      return;
    }

    print('Found event with recording: ${firstRecordedEvent.kind}');
    print('  Created at: ${firstRecordedEvent.createdAt}');
    print('  Ding ID: ${firstRecordedEvent.dingIdStr}');

    // Get recording URLs
    print('\nGetting recording URLs...');

    // Transcoded version (with Ring logo and timestamp)
    final transcodedUrl = await camera.getRecordingUrl(
      firstRecordedEvent.dingIdStr,
      transcoded: true,
    );
    print('Recording Transcoded URL: $transcodedUrl');

    // Untranscoded version (original)
    final untranscodedUrl = await camera.getRecordingUrl(
      firstRecordedEvent.dingIdStr,
    );
    print('Recording Untranscoded URL: $untranscodedUrl');
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    await ringApi.disconnect();
  }
}
