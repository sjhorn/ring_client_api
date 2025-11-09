/// Ring Intercom device class
///
/// Provides functionality for managing Ring Intercom devices.
/// These are audio-only devices that allow visitors to communicate and unlock doors.
library;

import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'rest_client.dart';
import 'util.dart';
import 'ring_camera.dart' show getBatteryLevel;

/// Represents a Ring Intercom device
///
/// Ring Intercoms are audio-only devices installed in apartment buildings and other
/// multi-unit properties. They allow visitors to call residents and can unlock doors remotely.
class RingIntercom {
  /// Device ID
  final int id;

  /// Device type (kind)
  final String deviceType;

  /// Stream of intercom data updates
  final BehaviorSubject<IntercomHandsetAudioData> onData;

  /// Stream for requesting data updates
  final PublishSubject<void> onRequestUpdate = PublishSubject<void>();

  /// Stream of battery level changes
  late final Stream<double?> onBatteryLevel;

  /// Stream of doorbell ring events
  final PublishSubject<void> onDing = PublishSubject<void>();

  /// Stream of door unlock events
  final PublishSubject<void> onUnlocked = PublishSubject<void>();

  /// Initial intercom data
  final IntercomHandsetAudioData initialData;

  /// REST client for API requests
  final RingRestClient restClient;

  /// Create a new RingIntercom
  ///
  /// [initialData] - Initial intercom data from the API
  /// [restClient] - REST client for making API requests
  RingIntercom({required this.initialData, required this.restClient})
    : id = initialData.id,
      deviceType = initialData.kind,
      onData = BehaviorSubject<IntercomHandsetAudioData>.seeded(initialData) {
    // Set up battery level stream with distinct values
    onBatteryLevel = onData.map((data) => getBatteryLevel(data)).distinct();

    // Auto-subscribe to ding events if not already subscribed
    if (!initialData.subscribed) {
      subscribeToDingEvents().catchError((e) {
        logError(
          'Failed to subscribe ${initialData.description} to ding events',
        );
        logError(e);
      });
    }
  }

  /// Update intercom data
  void updateData(IntercomHandsetAudioData update) {
    onData.add(update);
  }

  /// Request a data update from the API
  void requestUpdate() {
    onRequestUpdate.add(null);
  }

  /// Get current intercom data
  IntercomHandsetAudioData get data => onData.value;

  /// Get intercom name (same as description)
  String get name => data.description;

  /// Check if the intercom is offline
  bool get isOffline => data.alerts.connection == 'offline';

  /// Get current battery level (null if not available)
  double? get batteryLevel => getBatteryLevel(data);

  /// Build a doorbot API URL
  ///
  /// [path] - Optional path to append to the base URL
  String doorbotUrl([String path = '']) {
    return clientApi('doorbots/$id/${path.isEmpty ? '' : path}');
  }

  /// Unlock the door
  ///
  /// Sends a command to unlock the door associated with this intercom
  Future<void> unlock() async {
    await restClient.request(
      RequestOptions(
        method: 'PUT',
        url: commandsApi('devices/$id/device_rpc'),
        json: {
          'command_name': 'device_rpc',
          'request': {
            'jsonrpc': '2.0',
            'method': 'unlock_door',
            'params': {'door_id': 0, 'user_id': 0},
          },
        },
      ),
    );
  }

  /// Subscribe to doorbell ring events
  ///
  /// This enables push notifications for when someone rings the intercom
  Future<void> subscribeToDingEvents() async {
    await restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('subscribe')),
    );
  }

  /// Unsubscribe from doorbell ring events
  ///
  /// This disables push notifications for doorbell rings
  Future<void> unsubscribeFromDingEvents() async {
    await restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('unsubscribe')),
    );
  }

  /// Process a push notification for DingV2 (intercom ring)
  ///
  /// This method should be called when a DingV2 push notification is received
  /// to trigger the onDing event stream
  ///
  /// [notification] - The push notification to process
  void processPushNotificationDing(PushNotificationDingV2 notification) {
    if (notification.androidConfig.category ==
        PushNotificationAction.intercomDing) {
      onDing.add(null);
    }
  }

  /// Process a push notification for IntercomUnlock
  ///
  /// This method should be called when an IntercomUnlock push notification is received
  /// to trigger the onUnlocked event stream
  ///
  /// [notification] - The push notification to process
  void processPushNotificationUnlock(
    PushNotificationIntercomUnlockV2 notification,
  ) {
    if (notification.data.gcmData.action ==
        PushNotificationAction.intercomUnlock) {
      onUnlocked.add(null);
    }
  }

  /// Dispose of resources
  void dispose() {
    onData.close();
    onRequestUpdate.close();
    onDing.close();
    onUnlocked.close();
  }
}
