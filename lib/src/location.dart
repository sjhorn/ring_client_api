/// Ring Location class - manages physical locations with devices
///
/// This file handles Ring locations (homes/buildings with Ring devices),
/// WebSocket connections for real-time updates, device management,
/// alarm control, and location history.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'rest_client.dart';
import 'subscribed.dart';
import 'ring_device.dart';
import 'ring_camera.dart';
import 'ring_chime.dart';
import 'ring_intercom.dart';
import 'util.dart';

/// Message type for device list requests
const String deviceListMessageType = 'DeviceInfoDocGetList';

/// Flatten device data from nested structure
RingDeviceData flattenDeviceData(dynamic data) {
  final Map<String, dynamic> result = {};

  // Merge general.v2 data
  if (data is Map<String, dynamic>) {
    if (data['general'] is Map<String, dynamic>) {
      final general = data['general'] as Map<String, dynamic>;
      if (general['v2'] is Map<String, dynamic>) {
        result.addAll(general['v2'] as Map<String, dynamic>);
      }
    }

    // Merge device.v1 data
    if (data['device'] is Map<String, dynamic>) {
      final device = data['device'] as Map<String, dynamic>;
      if (device['v1'] is Map<String, dynamic>) {
        result.addAll(device['v1'] as Map<String, dynamic>);
      }
    }
  }

  try {
    return RingDeviceData.fromJson(result);
  } catch (e, stack) {
    logError('[flattenDeviceData] Error parsing device data: $e');
    logError('[flattenDeviceData] JSON was: ${result.toString().substring(0, 500)}...');
    logError('[flattenDeviceData] Stack: $stack');
    rethrow;
  }
}

/// Options for Location configuration
class LocationOptions {
  final bool hasHubs;
  final bool hasAlarmBaseStation;
  final int? locationModePollingSeconds;

  const LocationOptions({
    required this.hasHubs,
    required this.hasAlarmBaseStation,
    this.locationModePollingSeconds,
  });
}

/// Represents a physical Ring location (home/building)
///
/// Manages devices, WebSocket connections, alarm control, and location events.
/// Extends [Subscribed] to manage stream subscriptions.
class Location extends Subscribed {
  // WebSocket sequence number
  int _seq = 1;

  // Streams for WebSocket messages and updates
  final PublishSubject<SocketIoMessage> onMessage =
      PublishSubject<SocketIoMessage>();
  final PublishSubject<SocketIoMessage> onDataUpdate =
      PublishSubject<SocketIoMessage>();

  /// Stream of device data updates
  late final Stream<RingDeviceData> onDeviceDataUpdate;

  /// Stream of device list messages
  late final Stream<SocketIoMessage> onDeviceList;

  /// Stream of all devices
  late final Stream<List<RingDevice>> onDevices;

  /// Stream of session info messages
  late final Stream<List<AssetSession>> onSessionInfo;

  /// Stream of WebSocket connection status
  final BehaviorSubject<bool> onConnected = BehaviorSubject<bool>.seeded(false);

  /// Stream of location mode updates
  final ReplaySubject<LocationMode> onLocationMode =
      ReplaySubject<LocationMode>(maxSize: 1);

  /// Internal stream for location mode requests
  final PublishSubject<void> _onLocationModeRequested = PublishSubject<void>();

  // Connection state
  bool reconnecting = false;
  bool _disconnected = false;
  Future<WebSocket>? connectionPromise;

  // Security and device tracking
  RingDevice? securityPanel;
  List<TicketAsset>? assets;
  final List<String> receivedAssetDeviceLists = [];
  final List<String> offlineAssets = [];

  // Location properties
  final bool hasHubs;
  final bool hasAlarmBaseStation;
  final UserLocation locationDetails;
  final List<RingCamera> cameras;
  final List<RingChime> chimes;
  final List<RingIntercom> intercoms;
  final LocationOptions options;
  final RingRestClient restClient;

  /// Create a new Location
  ///
  /// [locationDetails] - Location metadata from the API
  /// [cameras] - List of cameras at this location
  /// [chimes] - List of chimes at this location
  /// [intercoms] - List of intercoms at this location
  /// [options] - Location configuration options
  /// [restClient] - REST client for API requests
  Location({
    required this.locationDetails,
    required this.cameras,
    required this.chimes,
    required this.intercoms,
    required this.options,
    required this.restClient,
  }) : hasHubs = options.hasHubs,
       hasAlarmBaseStation = options.hasAlarmBaseStation {
    // Initialize device data update stream
    onDeviceDataUpdate = onDataUpdate
        .where((message) {
          return message.datatype == MessageDataType.deviceInfoDocType &&
              message.body != null &&
              message.body!.isNotEmpty;
        })
        .expand((message) {
          // Flatten each device in the body
          return message.body!.map((data) => flattenDeviceData(data));
        });

    // Initialize device list stream
    onDeviceList = onMessage
        .where((m) {
          final isDeviceList = m.msg == MessageType.deviceInfoDocGetList;
          if (isDeviceList) {
            logDebug('[onDeviceList] Received device list message from ${m.src}');
          }
          return isDeviceList;
        });

    // Initialize devices stream with accumulation logic
    onDevices = onDeviceList
        .scan<List<RingDevice>>((accumulated, message, _) {
          final deviceList = message.body;
          final src = message.src;

          if (deviceList == null || deviceList.isEmpty) {
            return accumulated;
          }

          // Track that we received device list from this asset
          if (src != null && !receivedAssetDeviceLists.contains(src)) {
            receivedAssetDeviceLists.add(src);
          }

          // Update device list
          return deviceList.fold<List<RingDevice>>(accumulated, (
            updatedDevices,
            data,
          ) {
            RingDeviceData flatData;
            try {
              flatData = flattenDeviceData(data);
            } catch (e, stack) {
              logError('[onDevices.scan] Error in flattenDeviceData: $e');
              logError('[onDevices.scan] Stack: $stack');
              rethrow;
            }

            // Find existing device
            RingDevice? existingDevice;
            try {
              existingDevice = updatedDevices.firstWhere(
                (x) => x.zid == flatData.zid,
              );
            } catch (_) {
              existingDevice = null;
            }

            if (existingDevice != null) {
              existingDevice.updateData(flatData);
              return updatedDevices;
            }

            return [
              ...updatedDevices,
              RingDevice(initialData: flatData, location: this, assetId: src ?? ''),
            ];
          });
        }, <RingDevice>[])
        .distinct((a, b) => a.length == b.length)
        .where((deviceList) {
          // Only emit when we've received device lists from all assets
          final shouldEmit = assets != null &&
              assets!.every(
                (asset) => receivedAssetDeviceLists.contains(asset.uuid),
              );

          if (!shouldEmit) {
            logDebug('[onDevices] Not emitting yet. Received from: $receivedAssetDeviceLists, Total assets: ${assets?.length ?? 0}, Device count: ${deviceList.length}');
            if (assets != null) {
              for (final asset in assets!) {
                if (!receivedAssetDeviceLists.contains(asset.uuid)) {
                  logDebug('[onDevices] Still waiting for device list from asset: ${asset.uuid}');
                }
              }
            }
          } else {
            logDebug('[onDevices] Emitting ${deviceList.length} devices');
          }

          return shouldEmit;
        })
        .shareReplay(maxSize: 1);

    // Initialize session info stream
    onSessionInfo = onDataUpdate
        .where((m) => m.msg == MessageType.sessionInfo && m.body != null)
        .map(
          (m) => m.body!
              .map((item) {
                try {
                  return AssetSession.fromJson(item as Map<String, dynamic>);
                } catch (e, stack) {
                  logError('[AssetSession.fromJson] Error: $e');
                  logError('[AssetSession.fromJson] JSON: $item');
                  logError('[AssetSession.fromJson] Stack: $stack');
                  rethrow;
                }
              })
              .toList(),
        );

    // Subscribe to device stream immediately
    addSubscription(onDevices.listen((_) {}));

    // Watch for sessions coming online/offline
    addSubscription(
      onSessionInfo.listen((sessions) {
        for (final session in sessions) {
          final assetWasOffline = offlineAssets.contains(session.assetUuid);

          // Find asset safely
          TicketAsset? asset;
          try {
            asset = assets?.firstWhere((x) => x.uuid == session.assetUuid);
          } catch (_) {
            asset = null;
          }

          if (asset == null) {
            // We don't know about this asset, so don't worry about it
            continue;
          }

          if (session.connectionStatus == 'online') {
            if (assetWasOffline) {
              requestList(
                deviceListMessageType,
                session.assetUuid,
              ).catchError((_) {});
              offlineAssets.remove(session.assetUuid);
              logInfo(
                'Ring ${asset.kind} ${session.assetUuid} has come back online',
              );
            }
          } else if (!assetWasOffline) {
            logError(
              'Ring ${asset.kind} ${session.assetUuid} is offline or on cellular backup. '
              'Waiting for status to change',
            );
            offlineAssets.add(session.assetUuid);
          }
        }
      }),
    );

    // Set up location mode polling if needed
    if (!options.hasAlarmBaseStation &&
        options.locationModePollingSeconds != null) {
      addSubscription(
        Rx.merge([
              _onLocationModeRequested.map((_) => null),
              onLocationMode.map((_) => null),
            ])
            .debounceTime(
              Duration(seconds: options.locationModePollingSeconds!),
            )
            .listen((_) => getLocationMode()),
      );

      getLocationMode().catchError((error) {
        logError(error);
        return LocationModeResponse(
          mode: 'disabled',
          lastUpdateTimeMs: 0,
          securityStatus: const LocationModeSecurityStatus(
            md: 'none',
            returnTopic: '',
          ),
          readOnly: true,
        );
      });
    }
  }

  /// Get the location ID
  String get id => locationId;

  /// Get the location ID
  String get locationId => locationDetails.locationId ?? '';

  /// Get the location name
  String get name => locationDetails.name ?? '';

  /// Create a WebSocket connection to the Ring servers
  Future<WebSocket> createConnection() async {
    if (_disconnected) {
      throw Exception('Location has been disconnected');
    }

    logDebug('Creating location socket.io connection - $name');

    // Request ticket and assets from Ring API
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url: appApi(
          'clap/tickets?locationID=$id&enableExtendedEmergencyCellUsage=true&requestedTransport=ws',
        ),
      ),
    );

    final ticketData = response.data;
    final assets = (ticketData['assets'] as List)
        .map((item) => TicketAsset.fromJson(item as Map<String, dynamic>))
        .toList();
    final host = ticketData['host'] as String;
    final ticket = ticketData['ticket'] as String;

    // Filter to supported assets
    final supportedAssets = assets.where((asset) {
      return isWebSocketSupportedAsset(kind: asset.kind);
    }).toList();

    this.assets = supportedAssets;
    receivedAssetDeviceLists.clear();
    offlineAssets.clear();

    if (supportedAssets.isEmpty) {
      final errorMessage =
          'No assets (alarm hubs or beam bridges) found for location $name - $id';
      logError(errorMessage);
      throw Exception(errorMessage);
    }

    // Connect to WebSocket
    final url = 'wss://$host/ws?authcode=$ticket&ack=false';
    final socket = await WebSocket.connect(url);

    // Set up reconnection handler
    Future<WebSocket> reconnect() {
      // Don't reconnect if we're disconnecting
      if (_disconnected) {
        return Future.value(socket);
      }

      if (reconnecting && connectionPromise != null) {
        return connectionPromise!;
      }

      onConnected.add(false);
      logDebug('Reconnecting location socket.io connection');

      reconnecting = true;
      socket.close();
      return connectionPromise = delay(1000).then((_) => createConnection());
    }

    // Handle incoming messages
    socket.listen(
      (dynamic event) {
        // Ignore messages if we're disconnecting
        if (_disconnected) {
          return;
        }

        try {
          final data = jsonDecode(event as String) as Map<String, dynamic>;
          final messageData = data['msg'] as Map<String, dynamic>;
          final channel = data['channel'] as String;
          final message = SocketIoMessage.fromJson(messageData);

          logDebug('[Socket] Received message: msg=${message.msg}, datatype=${message.datatype}, src=${message.src}, channel=$channel');

          onMessage.add(message);

          if (message.datatype == MessageDataType.deviceInfoDocType) {
            logDebug('Location connection told to reconnect');
            reconnect();
            return;
          }

          if (channel == 'DataUpdate') {
            onDataUpdate.add(message);
          }
        } catch (e, stack) {
          logError('Error parsing message from server: $e');
          logError('Message was: $event');
          logError('Stack: $stack');
        }
      },
      onError: (error) {
        logDebug('WebSocket error: $error');
        reconnect();
      },
      onDone: () {
        logDebug('WebSocket connection closed');
        reconnect();
      },
    );

    reconnecting = false;
    onConnected.add(true);
    logDebug('Ring connected to socket.io server');

    // Request device lists from all assets
    for (final asset in supportedAssets) {
      requestList(deviceListMessageType, asset.uuid);
    }

    return socket;
  }

  /// Get or create a WebSocket connection
  Future<WebSocket> getConnection() {
    if (!hasHubs) {
      return Future.error(Exception('Location $name does not have any hubs'));
    }

    if (connectionPromise != null) {
      return connectionPromise!;
    }

    return connectionPromise = createConnection();
  }

  /// Send a message through the WebSocket
  Future<void> sendMessage({
    required MessageType msg,
    MessageDataType? datatype,
    required String dst,
    dynamic body,
    int? seq,
  }) async {
    final connection = await getConnection();

    // Convert enums to their JSON values
    final msgJson = _messageTypeToJson(msg);
    final datatypeJson = datatype != null ? _messageDataTypeToJson(datatype) : null;

    final message = {
      'msg': msgJson,
      if (datatypeJson != null) 'datatype': datatypeJson,
      'dst': dst,
      if (body != null) 'body': body,
      'seq': seq ?? _seq++,
    };

    logDebug('[sendMessage] Sending $msgJson to $dst');
    connection.add(jsonEncode({'channel': 'message', 'msg': message}));
  }

  /// Convert MessageType enum to its JSON string value
  String _messageTypeToJson(MessageType type) {
    switch (type) {
      case MessageType.roomGetList:
        return 'RoomGetList';
      case MessageType.sessionInfo:
        return 'SessionInfo';
      case MessageType.deviceInfoDocGetList:
        return 'DeviceInfoDocGetList';
      case MessageType.deviceInfoSet:
        return 'DeviceInfoSet';
      case MessageType.subscriptionTopicsInfo:
        return 'SubscriptionTopicsInfo';
      case MessageType.dataUpdate:
        return 'DataUpdate';
      case MessageType.passthru:
        return 'Passthru';
      case MessageType.empty:
        return '';
    }
  }

  /// Convert MessageDataType enum to its JSON string value
  String _messageDataTypeToJson(MessageDataType type) {
    switch (type) {
      case MessageDataType.roomListV2Type:
        return 'RoomListV2Type';
      case MessageDataType.sessionInfoType:
        return 'SessionInfoType';
      case MessageDataType.deviceInfoDocType:
        return 'DeviceInfoDocType';
      case MessageDataType.deviceInfoSetType:
        return 'DeviceInfoSetType';
      case MessageDataType.hubDisconnectionEventType:
        return 'HubDisconnectionEventType';
      case MessageDataType.subscriptionTopicType:
        return 'SubscriptionTopicType';
      case MessageDataType.passthruType:
        return 'PassthruType';
    }
  }

  /// Send a command to the security panel
  Future<void> sendCommandToSecurityPanel(
    String commandType, [
    Map<String, dynamic>? data,
  ]) async {
    final securityPanel = await getSecurityPanel();
    securityPanel.sendCommand(commandType, data ?? {});
  }

  /// Set the alarm mode
  ///
  /// [alarmMode] - Mode to set (all, some, none)
  /// [bypassSensorZids] - Optional list of sensor ZIDs to bypass
  Future<void> setAlarmMode(
    AlarmMode alarmMode, [
    List<String>? bypassSensorZids,
  ]) async {
    final securityPanel = await getSecurityPanel();
    final updatedDataFuture = securityPanel.onData.skip(1).first;

    await sendCommandToSecurityPanel('security-panel.switch-mode', {
      'mode': alarmMode.toString().split('.').last,
      if (bypassSensorZids != null) 'bypass': bypassSensorZids,
    });

    final updatedData = await updatedDataFuture;

    final modeString = alarmMode.toString().split('.').last;
    if (updatedData.mode != modeString) {
      throw Exception(
        'Failed to set alarm mode to "$modeString". '
        'Sensors may require bypass, which can only be done in the Ring app.',
      );
    }
  }

  /// Get the current alarm mode
  Future<AlarmMode> getAlarmMode() async {
    final securityPanel = await getSecurityPanel();
    final mode = securityPanel.data.mode;

    // Convert string mode to AlarmMode enum
    switch (mode) {
      case 'all':
        return AlarmMode.all;
      case 'some':
        return AlarmMode.some;
      case 'none':
        return AlarmMode.none;
      default:
        return AlarmMode.none;
    }
  }

  /// Sound the siren
  Future<void> soundSiren() {
    return sendCommandToSecurityPanel('security-panel.sound-siren');
  }

  /// Silence the siren
  Future<void> silenceSiren() {
    return sendCommandToSecurityPanel('security-panel.silence-siren');
  }

  /// Set a light group on/off
  ///
  /// [groupId] - ID of the light group
  /// [on] - Whether to turn lights on or off
  /// [durationSeconds] - How long to keep lights on (default 60)
  Future<void> setLightGroup(
    String groupId,
    bool on, [
    int durationSeconds = 60,
  ]) {
    return restClient.request<dynamic>(
      RequestOptions(
        method: 'POST',
        url:
            'https://api.ring.com/groups/v1/locations/$id/groups/$groupId/devices',
        json: {
          'lights_on': {'duration_seconds': durationSeconds, 'enabled': on},
        },
      ),
    );
  }

  /// Get the next message of a specific type from a specific source
  Future<List<dynamic>> getNextMessageOfType(MessageType type, String src) {
    return onMessage
        .where((m) => m.msg == type && m.src == src)
        .map((m) => m.body ?? [])
        .first;
  }

  /// Request a list from an asset
  Future<void> requestList(String listType, String assetId) {
    return sendMessage(
      msg: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == listType,
        orElse: () => MessageType.deviceInfoDocGetList,
      ),
      dst: assetId,
    );
  }

  /// Get a list from an asset
  Future<List<dynamic>> getList(String listType, String assetId) async {
    await requestList(listType, assetId);
    return getNextMessageOfType(
      MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == listType,
        orElse: () => MessageType.deviceInfoDocGetList,
      ),
      assetId,
    );
  }

  /// Get all devices at this location
  Future<List<RingDevice>> getDevices() async {
    if (!hasHubs) {
      return [];
    }

    if (connectionPromise == null) {
      await getConnection();
    }

    return onDevices.first;
  }

  /// Get the room list for an asset
  Future<List<dynamic>> getRoomList(String assetId) {
    return getList('RoomGetList', assetId);
  }

  /// Get the security panel device
  Future<RingDevice> getSecurityPanel() async {
    if (securityPanel != null) {
      return securityPanel!;
    }

    final devices = await getDevices();

    // Find security panel device
    RingDevice? panel;
    try {
      panel = devices.firstWhere(
        (device) => device.data.deviceType == RingDeviceType.securityPanel,
      );
    } catch (_) {
      panel = null;
    }

    if (panel == null) {
      throw Exception(
        'Could not find a security panel for location $name - $id',
      );
    }

    return securityPanel = panel;
  }

  /// Disarm the alarm
  Future<void> disarm() {
    return setAlarmMode(AlarmMode.none);
  }

  /// Arm the alarm in home mode
  ///
  /// [bypassSensorZids] - Optional list of sensor ZIDs to bypass
  Future<void> armHome([List<String>? bypassSensorZids]) {
    return setAlarmMode(AlarmMode.some, bypassSensorZids);
  }

  /// Arm the alarm in away mode
  ///
  /// [bypassSensorZids] - Optional list of sensor ZIDs to bypass
  Future<void> armAway([List<String>? bypassSensorZids]) {
    return setAlarmMode(AlarmMode.all, bypassSensorZids);
  }

  /// Get location history
  ///
  /// [options] - Optional filters for history query
  Future<List<RingDeviceHistoryEvent>> getHistory([
    HistoryOptions? options,
  ]) async {
    final opts = options ?? const HistoryOptions();
    final maxLevel = opts.maxLevel ?? 50;

    final queryOptions = {
      'accountId': id,
      if (opts.limit != null) 'limit': opts.limit,
      if (opts.offset != null) 'offset': opts.offset,
      if (opts.category != null) 'category': opts.category,
      'maxLevel': maxLevel,
    };

    final response = await restClient.request<List<dynamic>>(
      RequestOptions(
        url: appApi('rs/history${getSearchQueryString(queryOptions)}'),
      ),
    );

    return response.data
        .map(
          (item) =>
              RingDeviceHistoryEvent.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Get camera events
  ///
  /// [options] - Optional filters for event query
  Future<CameraEventResponse> getCameraEvents([
    CameraEventOptions? options,
  ]) async {
    final opts = options ?? const CameraEventOptions();
    final queryOptions = opts.toJson();

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        url: clientApi(
          'locations/$id/events${getSearchQueryString(queryOptions)}',
        ),
      ),
    );

    return CameraEventResponse.fromJson(response.data);
  }

  /// Get account monitoring status
  Future<AccountMonitoringStatus> getAccountMonitoringStatus() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: appApi('rs/monitoring/accounts/$id')),
    );

    return AccountMonitoringStatus.fromJson(response.data);
  }

  /// Trigger an alarm (internal method)
  Future<AccountMonitoringStatus> _triggerAlarm(String signalType) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final alarmSessionUuid = generateUuid();

    // Find base station asset
    TicketAsset? baseStationAsset;
    try {
      baseStationAsset = assets?.firstWhere((x) => x.kind == 'base_station_v1');
    } catch (_) {
      baseStationAsset = null;
    }

    if (baseStationAsset == null) {
      throw Exception(
        'Cannot dispatch panic events without an alarm base station',
      );
    }

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi(
          'rs/monitoring/accounts/$id/assets/${baseStationAsset.uuid}/userAlarm',
        ),
        json: {
          'alarmSessionUuid': alarmSessionUuid,
          'currentTsMs': now,
          'eventOccurredTime': now,
          'signalType': signalType,
        },
      ),
    );

    return AccountMonitoringStatus.fromJson(response.data);
  }

  /// Trigger a burglar alarm
  Future<AccountMonitoringStatus> triggerBurglarAlarm() {
    return _triggerAlarm(DispatchSignalType.burglar);
  }

  /// Trigger a fire alarm
  Future<AccountMonitoringStatus> triggerFireAlarm() {
    return _triggerAlarm(DispatchSignalType.fire);
  }

  /// Get the current location mode
  Future<LocationModeResponse> getLocationMode() async {
    _onLocationModeRequested.add(null);

    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(method: 'GET', url: appApi('mode/location/$id')),
    );

    final modeResponse = LocationModeResponse.fromJson(response.data);
    onLocationMode.add(modeResponse.mode);

    return modeResponse;
  }

  /// Set the location mode
  ///
  /// [mode] - Mode to set (home, away, disarmed)
  Future<LocationModeResponse> setLocationMode(LocationModeInput mode) async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi('mode/location/$id'),
        json: {'mode': mode},
      ),
    );

    final modeResponse = LocationModeResponse.fromJson(response.data);
    onLocationMode.add(modeResponse.mode);

    return modeResponse;
  }

  /// Disable location modes
  Future<void> disableLocationModes() async {
    await restClient.request<void>(
      RequestOptions(
        method: 'DELETE',
        url: appApi('mode/location/$id/settings'),
      ),
    );
    onLocationMode.add('disabled');
  }

  /// Enable location modes
  Future<LocationModeSettingsResponse> enableLocationModes() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi('mode/location/$id/settings/setup'),
      ),
    );

    await getLocationMode();

    return LocationModeSettingsResponse.fromJson(response.data);
  }

  /// Get location mode settings
  Future<LocationModeSettingsResponse> getLocationModeSettings() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(method: 'GET', url: appApi('mode/location/$id/settings')),
    );

    return LocationModeSettingsResponse.fromJson(response.data);
  }

  /// Set location mode settings
  ///
  /// [settings] - Settings to apply
  Future<LocationModeSettingsResponse> setLocationModeSettings(
    LocationModeSettings settings,
  ) async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi('mode/location/$id/settings'),
        json: settings.toJson(),
      ),
    );

    return LocationModeSettingsResponse.fromJson(response.data);
  }

  /// Get location mode sharing settings
  Future<LocationModeSharing> getLocationModeSharing() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(method: 'GET', url: appApi('mode/location/$id/sharing')),
    );

    return LocationModeSharing.fromJson(response.data);
  }

  /// Set location mode sharing
  ///
  /// [sharedUsersEnabled] - Whether to enable shared users
  Future<LocationModeSharing> setLocationModeSharing(
    bool sharedUsersEnabled,
  ) async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(
        method: 'POST',
        url: appApi('mode/location/$id/sharing'),
        json: {'sharedUsersEnabled': sharedUsersEnabled},
      ),
    );

    return LocationModeSharing.fromJson(response.data);
  }

  /// Check if location supports location mode switching
  Future<bool> supportsLocationModeSwitching() async {
    if (hasAlarmBaseStation || cameras.isEmpty) {
      return false;
    }

    final modeResponse = await getLocationMode();
    final mode = modeResponse.mode;
    final readOnly = modeResponse.readOnly;

    logDebug('Location Mode: ${jsonEncode(modeResponse.toJson())}');

    return !readOnly && !disabledLocationModes.contains(mode);
  }

  /// Disconnect from the location
  ///
  /// Closes WebSocket connection and cleans up all resources
  Future<void> disconnect() async {
    _disconnected = true;
    unsubscribe();

    // Disconnect all cameras
    for (final camera in cameras) {
      camera.disconnect();
    }

    // Disconnect all devices
    try {
      final devices = await getDevices().timeout(Duration(seconds: 2));
      for (final device in devices) {
        device.disconnect();
      }
    } catch (error, stack) {
      logError('[Location.disconnect getDevices] $error');
      logError('[Stack] $stack');
    }

    // Close WebSocket connection
    if (connectionPromise != null) {
      try {
        final connection = await connectionPromise!;
        await connection.close();
      } catch (error, stack) {
        // Ignore "Location has been disconnected" error - this is expected
        // when a reconnect is scheduled but we disconnect before it completes
        if (!error.toString().contains('Location has been disconnected')) {
          logError('[Location.disconnect connectionPromise] $error');
          logError('[Stack] $stack');
        }
      }
    }

    // Close all subjects
    await onMessage.close();
    await onDataUpdate.close();
    await onConnected.close();
    await onLocationMode.close();
    await _onLocationModeRequested.close();
  }

  @override
  void dispose() {
    // Fire off disconnect but don't await since dispose is synchronous
    disconnect().catchError((e) {
      logError('Error during dispose: $e');
    });
    super.dispose();
  }
}
