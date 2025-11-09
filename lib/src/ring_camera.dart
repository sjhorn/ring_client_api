/// Ring camera device implementation
///
/// This file handles Ring camera devices with video streaming, notifications,
/// events, snapshots, and more.
library;

import 'dart:async';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'rest_client.dart';
import 'util.dart';
import 'subscribed.dart';

/// Union type for camera data - either CameraData or OnvifCameraData
typedef AnyCameraData =
    Object; // Base type, actual instances are CameraData or OnvifCameraData

/// Constants
const int maxSnapshotRefreshSeconds = 15;
const int fullDayMs = 24 * 60 * 60 * 1000;

/// Set of wired camera models that cannot take snapshots during recording
final Set<String> wiredModelsWithNoSnapshotDuringRecording = {
  RingCameraKind.doorbellGrahamCracker,
};

/// Set of enabled doorbell types
final Set<int> enabledDoorbellTypes = {
  DoorbellType.mechanical,
  DoorbellType.digital,
};

/// Parse battery life from string or number
double? parseBatteryLife(dynamic batteryLife) {
  if (batteryLife == null) {
    return null;
  }

  double batteryLevel;
  if (batteryLife is num) {
    batteryLevel = batteryLife.toDouble();
  } else if (batteryLife is String) {
    final parsed = double.tryParse(batteryLife);
    if (parsed == null) {
      return null;
    }
    batteryLevel = parsed;
  } else {
    return null;
  }

  if (batteryLevel.isNaN) {
    return null;
  }

  return batteryLevel;
}

/// Get start of today in milliseconds
int getStartOfToday() {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  return startOfDay.millisecondsSinceEpoch;
}

/// Get end of today in milliseconds
int getEndOfToday() {
  return getStartOfToday() + fullDayMs - 1;
}

/// Get battery level from camera data
///
/// Returns the minimum battery level from all available battery sources,
/// or null if no battery is present.
double? getBatteryLevel(dynamic data) {
  if (data is! CameraData) {
    return null;
  }

  final levels = <double>[];

  final level1 = parseBatteryLife(data.batteryLife);
  if (level1 != null) {
    levels.add(level1);
  }

  final level2 = parseBatteryLife(data.batteryLife2);
  if (level2 != null) {
    levels.add(level2);
  }

  final health = data.health;
  if (levels.isEmpty ||
      health == null ||
      (health.batteryPercentage == null &&
          health.batteryPresent != true &&
          health.secondBatteryPercentage == null)) {
    return null;
  }

  if (levels.isEmpty) {
    return null;
  }

  return levels.reduce((a, b) => a < b ? a : b);
}

/// Build search query string from options
String getSearchQueryString(Map<String, dynamic> options) {
  final queryString = options.entries
      .where((entry) => entry.value != null)
      .map((entry) {
        var key = entry.key;
        final value = entry.value;

        if (key == 'olderThanId') {
          key = 'pagination_key';
        }

        return '$key=$value';
      })
      .join('&');

  return queryString.isNotEmpty ? '?$queryString' : '';
}

/// Clean snapshot UUID by removing everything after colon
String? cleanSnapshotUuid(String? uuid) {
  if (uuid == null || uuid.isEmpty) {
    return uuid;
  }

  return uuid.replaceAll(RegExp(r':.*$'), '');
}

// TODO: WebRTC streaming classes - to be implemented when streaming modules are ported
// These are placeholders for the streaming functionality:
// - WebrtcConnection: Handles WebRTC connection for streaming
// - StreamingSession: Manages streaming session with ffmpeg transcoding
// - SimpleWebRtcSession: Simplified WebRTC session for browser use

/// Options for streaming connection
class StreamingConnectionOptions {
  // TODO: Add streaming connection options when streaming module is ported
  const StreamingConnectionOptions();
}

/// FFmpeg options for video transcoding
class FfmpegOptions {
  final List<String> output;

  const FfmpegOptions({required this.output});
}

/// Streaming session (placeholder - TODO: implement when streaming module is ported)
class StreamingSession {
  final RingCamera camera;

  StreamingSession(this.camera, dynamic connection);

  Future<void> startTranscoding(FfmpegOptions options) async {
    throw UnimplementedError(
      'Streaming functionality not yet implemented in Dart port',
    );
  }

  Stream<void> get onCallEnded => Stream.empty();
}

/// Simple WebRTC session (placeholder - TODO: implement when streaming module is ported)
class SimpleWebRtcSession {
  final RingCamera camera;
  final RingRestClient restClient;

  SimpleWebRtcSession(this.camera, this.restClient);
}

/// Ring camera device
///
/// Handles camera-specific functionality including:
/// - Video streaming and snapshots
/// - Doorbell and motion notifications
/// - Event history
/// - Device settings and health
/// - Light and siren control
class RingCamera extends Subscribed {
  // Basic properties
  final int id;
  final String deviceType;
  final String model;
  final bool isDoorbot;
  final RingRestClient restClient;
  final bool avoidSnapshotBatteryDrain;
  final bool hasLight;
  final bool hasSiren;

  // Data streams
  final BehaviorSubject<AnyCameraData> onData;
  final Subject<void> onRequestUpdate = PublishSubject<void>();
  final Subject<PushNotificationDingV2> onNewNotification =
      PublishSubject<PushNotificationDingV2>();
  final BehaviorSubject<List<PushNotificationDingV2>> onActiveNotifications =
      BehaviorSubject<List<PushNotificationDingV2>>.seeded([]);

  // Derived streams
  late final Stream<PushNotificationDingV2> onDoorbellPressed;
  late final Stream<bool> onMotionDetected;
  late final Stream<void> onMotionStarted;
  late final Stream<double?> onBatteryLevel;
  late final Stream<bool> onInHomeDoorbellStatus;

  // Snapshot state
  int _lastSnapshotTimestamp = 0;
  int _lastSnapshotTimestampLocal = 0;
  Future<Uint8List>? _lastSnapshotPromise;
  bool _fetchingSnapshot = false;

  /// Create a new Ring camera
  RingCamera({
    required AnyCameraData initialData,
    required this.isDoorbot,
    required this.restClient,
    required this.avoidSnapshotBatteryDrain,
  }) : id = _getId(initialData),
       deviceType = _getKind(initialData),
       model = _getModel(initialData),
       onData = BehaviorSubject<AnyCameraData>.seeded(initialData),
       hasLight = _hasLedStatus(initialData),
       hasSiren = _hasSirenStatus(initialData) {
    // Setup doorbell pressed stream
    onDoorbellPressed = onNewNotification
        .where(
          (notification) =>
              notification.androidConfig.category ==
              PushNotificationAction.ding,
        )
        .shareReplay(maxSize: 1);

    // Setup motion detected stream
    onMotionDetected = onActiveNotifications
        .map(
          (notifications) => notifications.any(
            (notification) =>
                notification.androidConfig.category ==
                PushNotificationAction.motion,
          ),
        )
        .distinct()
        .shareReplay(maxSize: 1);

    // Setup motion started stream
    onMotionStarted = onMotionDetected
        .where((currentlyDetected) => currentlyDetected)
        .map((_) => null)
        .share();

    // Setup battery level stream
    onBatteryLevel = onData.map((data) => getBatteryLevel(data)).distinct();

    // Setup in-home doorbell status stream
    onInHomeDoorbellStatus = onData.map((data) {
      final settings = _getSettings(data);
      return settings.chimeSettings?.enable ?? false;
    }).distinct();

    // Subscribe to ding and motion events when session is ready
    addSubscription(
      Rx.merge([
        restClient.onSession,
        Stream.value(
          restClient.onSession.valueOrNull,
        ).whereType<SessionResponse>(),
      ]).throttleTime(const Duration(seconds: 1)).listen((_) {
        subscribeToDingEvents().catchError((e) {
          logError(
            'Failed to subscribe ${_getDescription(initialData)} to ding events',
          );
          logError(e);
        });

        subscribeToMotionEvents().catchError((e) {
          logError(
            'Failed to subscribe ${_getDescription(initialData)} to motion events',
          );
          logError(e);
        });
      }),
    );
  }

  // Helper methods to extract data from union type
  static int _getId(AnyCameraData data) {
    if (data is CameraData) return data.id ?? 0;
    if (data is OnvifCameraData) return data.id ?? 0;
    throw ArgumentError('Invalid camera data type');
  }

  static String _getKind(AnyCameraData data) {
    if (data is CameraData) return data.kind;
    if (data is OnvifCameraData) return data.kind;
    throw ArgumentError('Invalid camera data type');
  }

  static String _getDescription(AnyCameraData data) {
    if (data is CameraData) return data.description ?? '';
    if (data is OnvifCameraData) return data.description ?? '';
    throw ArgumentError('Invalid camera data type');
  }

  static CameraSettingsData _getSettings(AnyCameraData data) {
    if (data is CameraData) {
      final settings = data.settings;
      if (settings == null) {
        throw StateError('Camera settings is null');
      }
      return settings;
    }
    if (data is OnvifCameraData) {
      final settings = data.settings;
      if (settings == null) {
        throw StateError('Camera settings is null');
      }
      return settings;
    }
    throw ArgumentError('Invalid camera data type');
  }

  static String _getModel(AnyCameraData data) {
    final kind = _getKind(data);
    return RingCameraModel.models[kind] ?? 'Unknown Model';
  }

  static bool _hasLedStatus(AnyCameraData data) {
    if (data is CameraData) return data.ledStatus != null;
    if (data is OnvifCameraData) return data.ledStatus != null;
    return false;
  }

  static bool _hasSirenStatus(AnyCameraData data) {
    if (data is CameraData) return data.sirenStatus != null;
    if (data is OnvifCameraData) return data.sirenStatus != null;
    return false;
  }

  /// Get current camera data
  AnyCameraData get data => onData.value;

  /// Get camera name
  String get name => _getDescription(data);

  /// Get active notifications
  List<PushNotificationDingV2> get activeNotifications =>
      onActiveNotifications.value;

  /// Get latest notification
  PushNotificationDingV2? get latestNotification {
    final notifications = activeNotifications;
    return notifications.isNotEmpty ? notifications.last : null;
  }

  /// Get latest notification snapshot UUID
  String? get latestNotificationSnapshotUuid {
    final notification = latestNotification;
    return notification?.img?.snapshotUuid;
  }

  /// Get battery level
  double? get batteryLevel => getBatteryLevel(data);

  /// Check if camera has a battery
  bool get hasBattery => batteryLevel != null;

  /// Check if battery is low
  bool get hasLowBattery {
    if (data is CameraData) {
      return (data as CameraData).alerts?.battery == 'low';
    }
    if (data is OnvifCameraData) {
      return (data as OnvifCameraData).alerts?.battery == 'low';
    }
    return false;
  }

  /// Check if camera is charging
  bool get isCharging {
    if (data is CameraData) {
      return (data as CameraData).externalConnection ?? false;
    }
    return false;
  }

  /// Check if operating on battery
  bool get operatingOnBattery {
    if (!hasBattery) return false;
    final settings = _getSettings(data);
    return settings.powerMode != 'wired';
  }

  /// Check if camera can take snapshots while recording
  bool get canTakeSnapshotWhileRecording {
    return !operatingOnBattery &&
        !wiredModelsWithNoSnapshotDuringRecording.contains(deviceType);
  }

  /// Check if camera is offline
  bool get isOffline {
    if (data is CameraData) {
      return (data as CameraData).alerts?.connection == 'offline';
    }
    if (data is OnvifCameraData) {
      return (data as OnvifCameraData).alerts?.connection == 'offline';
    }
    return false;
  }

  /// Check if Ring Edge is enabled
  bool get isRingEdgeEnabled {
    final settings = _getSettings(data);
    return settings.sheilaSettings?.localStorageEnabled == true;
  }

  /// Check if camera has in-home doorbell
  bool get hasInHomeDoorbell {
    if (!isDoorbot) return false;

    final settings = _getSettings(data);
    final chimeSettings = settings.chimeSettings;

    return chimeSettings != null &&
        enabledDoorbellTypes.contains(chimeSettings.type);
  }

  /// Check if snapshots are blocked
  bool get snapshotsAreBlocked {
    final settings = _getSettings(data);
    return settings.motionDetectionEnabled == false;
  }

  /// Get snapshot lifetime in milliseconds
  int get snapshotLifeTime {
    return avoidSnapshotBatteryDrain && operatingOnBattery
        ? 600 *
              1000 // battery cams only refresh timestamp every 10 minutes
        : 10 * 1000; // snapshot updates will be forced. Limit to 10s lifetime
  }

  /// Get current timestamp age in milliseconds
  int get currentTimestampAge {
    return DateTime.now().millisecondsSinceEpoch - _lastSnapshotTimestampLocal;
  }

  /// Check if snapshot is within lifetime
  bool get hasSnapshotWithinLifetime {
    return currentTimestampAge < snapshotLifeTime;
  }

  /// Build doorbot API URL
  String doorbotUrl([String path = '']) {
    return clientApi('doorbots/$id/$path');
  }

  /// Build device API URL
  String deviceUrl([String path = '']) {
    return deviceApi('devices/$id/$path');
  }

  /// Update camera data
  void updateData(AnyCameraData update) {
    onData.add(update);
  }

  /// Request data update
  void requestUpdate() {
    onRequestUpdate.add(null);
  }

  /// Set light state (on/off)
  Future<bool> setLight(bool on) async {
    if (!hasLight) {
      return false;
    }

    final state = on ? 'on' : 'off';

    await restClient.request(
      RequestOptions(method: 'PUT', url: doorbotUrl('floodlight_light_$state')),
    );

    // Update local state
    // Note: We need to create a copy with updated ledStatus
    // This would require implementing copyWith or similar
    // For now, just request an update
    requestUpdate();

    return true;
  }

  /// Set siren state (on/off)
  Future<bool> setSiren(bool on) async {
    if (!hasSiren) {
      return false;
    }

    await restClient.request(
      RequestOptions(
        method: 'PUT',
        url: doorbotUrl('siren_${on ? 'on' : 'off'}'),
      ),
    );

    // Update local state
    requestUpdate();

    return true;
  }

  /// Set camera settings (partial update)
  Future<void> setSettings(Map<String, dynamic> settings) async {
    await restClient.request(
      RequestOptions(
        method: 'PUT',
        url: doorbotUrl(),
        json: {
          'doorbot': {'settings': settings},
        },
      ),
    );

    requestUpdate();
  }

  /// Set device settings (partial update)
  Future<DataResponse<CameraDeviceSettingsData>> setDeviceSettings(
    Map<String, dynamic> settings,
  ) async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'PATCH',
        url: deviceUrl('settings'),
        json: settings,
      ),
    );

    requestUpdate();

    return DataResponse(
      data: CameraDeviceSettingsData.fromJson(response.data),
      responseTimestamp: response.responseTimestamp,
      timeMillis: response.timeMillis,
    );
  }

  /// Get device settings
  Future<CameraDeviceSettingsData> getDeviceSettings() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(method: 'GET', url: deviceUrl('settings')),
    );

    return CameraDeviceSettingsData.fromJson(response.data);
  }

  /// Enable or disable the in-home doorbell
  Future<bool> setInHomeDoorbell(bool enable) async {
    if (!hasInHomeDoorbell) {
      return false;
    }

    await setSettings({
      'chime_settings': {'enable': enable},
    });
    return true;
  }

  /// Get camera health information
  Future<CameraHealth> getHealth() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: doorbotUrl('health')),
    );

    final deviceHealth = response.data['device_health'] as Map<String, dynamic>;
    return CameraHealth.fromJson(deviceHealth);
  }

  /// Create a streaming connection (TODO: implement when WebRTC module is ported)
  Future<dynamic> _createStreamingConnection(
    StreamingConnectionOptions options,
  ) async {
    await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi('clap/ticket/request/signalsocket'),
      ),
    );

    // TODO: Parse ticket and return WebrtcConnection when streaming module is ported
    // final ticket = SocketTicketResponse.fromJson(response.data);
    throw UnimplementedError(
      'WebRTC streaming not yet implemented in Dart port',
    );
  }

  /// Start a live call (streaming session)
  Future<StreamingSession> startLiveCall([
    StreamingConnectionOptions options = const StreamingConnectionOptions(),
  ]) async {
    final connection = await _createStreamingConnection(options);
    return StreamingSession(this, connection);
  }

  /// Remove a ding notification by ID
  void _removeDingById(String idToRemove) {
    final allActiveDings = activeNotifications;
    final otherDings = allActiveDings
        .where((notification) => notification.data.event.ding.id != idToRemove)
        .toList();

    onActiveNotifications.add(otherDings);
  }

  /// Process a push notification
  ///
  /// Handles ding and motion notifications, updating the active notifications
  /// list and emitting events.
  void processPushNotification(dynamic notification) {
    // Only process ding/motion notifications (PushNotificationDingV2)
    if (notification is! PushNotificationDingV2) {
      return;
    }

    final activeDings = activeNotifications;
    final dingId = notification.data.event.ding.id;

    // Update active notifications list
    onActiveNotifications.add(
      activeDings.where((d) => d.data.event.ding.id != dingId).followedBy([
        notification,
      ]).toList(),
    );

    onNewNotification.add(notification);

    // Remove ding after ~1 minute
    Timer(const Duration(seconds: 65), () {
      _removeDingById(dingId);
    });
  }

  /// Get camera events
  Future<CameraEventResponse> getEvents([CameraEventOptions? options]) async {
    final opts = options ?? const CameraEventOptions();
    final queryString = getSearchQueryString(opts.toJson());

    final locationId = data is CameraData
        ? (data as CameraData).locationId
        : (data as OnvifCameraData).locationId;

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url: clientApi('locations/$locationId/devices/$id/events$queryString'),
      ),
    );

    return CameraEventResponse.fromJson(response.data);
  }

  /// Search for videos
  Future<VideoSearchResponse> videoSearch({
    int? dateFrom,
    int? dateTo,
    String order = 'asc',
  }) async {
    final from = dateFrom ?? getStartOfToday();
    final to = dateTo ?? getEndOfToday();

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url: clientApi(
          'video_search/history?doorbot_id=$id&date_from=$from&date_to=$to&order=$order&api_version=11&includes%5B%5D=pva',
        ),
      ),
    );

    return VideoSearchResponse.fromJson(response.data);
  }

  /// Get periodical footage (snapshots turned into video clips)
  Future<PeriodicFootageResponse> getPeriodicalFootage({
    int? startAtMs,
    int? endAtMs,
  }) async {
    final start = startAtMs ?? getStartOfToday();
    final end = endAtMs ?? getEndOfToday();

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url:
            'https://api.ring.com/recordings/public/footages/$id?start_at_ms=$start&end_at_ms=$end&kinds=online_periodical&kinds=offline_periodical',
      ),
    );

    return PeriodicFootageResponse.fromJson(response.data);
  }

  /// Get recording URL for a specific ding
  Future<String> getRecordingUrl(
    String dingIdStr, {
    bool transcoded = false,
  }) async {
    final path = transcoded ? 'recording' : 'share/play';
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url: clientApi('dings/$dingIdStr/$path?disable_redirect=true'),
      ),
    );

    return response.data['url'] as String;
  }

  /// Check if snapshots are blocked and throw if they are
  void _checkIfSnapshotsAreBlocked() {
    if (snapshotsAreBlocked) {
      throw Exception(
        'Motion detection is disabled for $name, which prevents snapshots from this camera. '
        'This can be caused by Modes settings or by turning off the Record Motion setting.',
      );
    }

    if (isOffline) {
      throw Exception('Cannot fetch snapshot for $name because it is offline');
    }
  }

  /// Check if we should use existing snapshot promise
  bool _shouldUseExistingSnapshotPromise() {
    if (_fetchingSnapshot) {
      return true;
    }

    if (hasSnapshotWithinLifetime) {
      logDebug(
        'Snapshot for $name is still within its life time '
        '(${currentTimestampAge / 1000}s old)',
      );
      return true;
    }

    if (!avoidSnapshotBatteryDrain || !operatingOnBattery) {
      // Tell the camera to update snapshot immediately
      return false;
    }

    return false;
  }

  /// Get a snapshot from the camera
  ///
  /// Requests a new snapshot or returns cached one if still valid.
  /// Snapshots are cached based on [snapshotLifeTime].
  Future<Uint8List> getSnapshot({String? uuid}) async {
    if (_lastSnapshotPromise != null && _shouldUseExistingSnapshotPromise()) {
      return _lastSnapshotPromise!;
    }

    _checkIfSnapshotsAreBlocked();

    _fetchingSnapshot = true;
    _lastSnapshotPromise = Future.any([
      getNextSnapshot(
        uuid: uuid,
        afterMs: uuid == null ? _lastSnapshotTimestamp : null,
        force: uuid == null,
      ),
      Future.delayed(Duration(seconds: maxSnapshotRefreshSeconds)).then((_) {
        final extraMessage = !canTakeSnapshotWhileRecording
            ? '. This is normal behavior since this camera is unable to capture snapshots while streaming'
            : '';
        throw Exception(
          'Snapshot for $name ($deviceType - $model) failed to refresh after $maxSnapshotRefreshSeconds seconds$extraMessage',
        );
      }),
    ]);

    try {
      final result = await _lastSnapshotPromise!;
      _fetchingSnapshot = false;
      return result;
    } catch (e) {
      // Snapshot request failed, don't use it again
      _lastSnapshotPromise = null;
      _fetchingSnapshot = false;
      rethrow;
    }
  }

  /// Get next snapshot from camera
  Future<Uint8List> getNextSnapshot({
    int? afterMs,
    int? maxWaitMs,
    bool force = false,
    String? uuid,
  }) async {
    final searchParams = <String, dynamic>{};
    if (afterMs != null) searchParams['after-ms'] = afterMs;
    if (maxWaitMs != null) searchParams['max-wait-ms'] = maxWaitMs;
    if (force) searchParams['extras'] = 'force';
    if (uuid != null) searchParams['uuid'] = cleanSnapshotUuid(uuid);

    final response = await restClient.request<Uint8List>(
      RequestOptions(
        url:
            'https://app-snaps.ring.com/snapshots/next/$id${buildSearchString(searchParams)}',
        responseType: ResponseType.buffer,
        headers: {'accept': 'image/jpeg'},
        allowNoResponse: true,
      ),
    );

    final responseTimestamp = response.responseTimestamp ?? 0;
    final timeMillis = response.timeMillis ?? 0;
    final timestampAge = (responseTimestamp - timeMillis).abs();

    _lastSnapshotTimestamp = timeMillis;
    _lastSnapshotTimestampLocal =
        DateTime.now().millisecondsSinceEpoch - timestampAge;

    return response.data;
  }

  /// Get snapshot by UUID
  Future<Uint8List> getSnapshotByUuid(String uuid) async {
    final response = await restClient.request<Uint8List>(
      RequestOptions(
        url: clientApi('snapshots/uuid?uuid=${cleanSnapshotUuid(uuid)}'),
        responseType: ResponseType.buffer,
        headers: {'accept': 'image/jpeg'},
      ),
    );

    return response.data;
  }

  /// Record video to file
  Future<void> recordToFile(String outputPath, [int duration = 30]) async {
    final liveCall = await streamVideo(
      FfmpegOptions(output: ['-t', duration.toString(), outputPath]),
    );

    await liveCall.onCallEnded.first;
  }

  /// Stream video with ffmpeg transcoding
  Future<StreamingSession> streamVideo(FfmpegOptions ffmpegOptions) async {
    final liveCall = await startLiveCall();
    await liveCall.startTranscoding(ffmpegOptions);
    return liveCall;
  }

  /// Create a simple WebRTC session for browser use
  ///
  /// This session has no backplane for trickle ICE and is designed for
  /// browser settings. Note: cameras with Ring Edge enabled will stream
  /// with the speaker enabled as soon as the stream starts, which can
  /// drain the battery more quickly.
  SimpleWebRtcSession createSimpleWebRtcSession() {
    return SimpleWebRtcSession(this, restClient);
  }

  /// Subscribe to doorbell ding events
  Future<void> subscribeToDingEvents() {
    return restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('subscribe')),
    );
  }

  /// Unsubscribe from doorbell ding events
  Future<void> unsubscribeFromDingEvents() {
    return restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('unsubscribe')),
    );
  }

  /// Subscribe to motion events
  Future<void> subscribeToMotionEvents() {
    return restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('motions_subscribe')),
    );
  }

  /// Unsubscribe from motion events
  Future<void> unsubscribeFromMotionEvents() {
    return restClient.request(
      RequestOptions(method: 'POST', url: doorbotUrl('motions_unsubscribe')),
    );
  }

  /// Disconnect and cleanup
  void disconnect() {
    unsubscribe();
  }

  @override
  void dispose() {
    onData.close();
    onRequestUpdate.close();
    onNewNotification.close();
    onActiveNotifications.close();
    super.dispose();
  }
}
