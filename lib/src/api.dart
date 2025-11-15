/// Main entry point for the Ring Client API
///
/// This file provides the RingApi class, which is the primary interface for
/// interacting with Ring devices. It handles:
/// - Authentication (refresh token or email/password)
/// - Location and device management
/// - Camera discovery and monitoring
/// - Push notifications via Firebase Cloud Messaging
/// - Polling for device status updates
/// - Amazon Key lock integration
library;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'location.dart';
import 'ring_camera.dart';
import 'ring_chime.dart';
import 'ring_intercom.dart';
import 'rest_client.dart';
import 'ring_types.dart';
import 'util.dart';
import 'subscribed.dart';

/// Options for configuring the Ring API client
class RingApiOptions {
  /// List of location IDs to filter to (optional - if provided but empty, no devices will be found)
  final List<String>? locationIds;

  /// How often to poll for camera status updates (in seconds)
  final int? cameraStatusPollingSeconds;

  /// How often to poll for location mode updates (in seconds)
  final int? locationModePollingSeconds;

  /// Whether to avoid draining battery on battery-powered cameras when requesting snapshots
  final bool avoidSnapshotBatteryDrain;

  /// Whether to enable debug logging
  final bool debug;

  /// Path to ffmpeg binary for video streaming/transcoding
  final String? ffmpegPath;

  /// System ID for generating hardware ID (optional - uses platform UUID if not provided)
  final String? systemId;

  /// Display name for this device in the Ring Control Center
  final String? controlCenterDisplayName;

  const RingApiOptions({
    this.locationIds,
    this.cameraStatusPollingSeconds,
    this.locationModePollingSeconds,
    this.avoidSnapshotBatteryDrain = false,
    this.debug = false,
    this.ffmpegPath,
    this.systemId,
    this.controlCenterDisplayName,
  });
}

/// Response from fetchRingDevices containing all device types
class RingDevicesResponse {
  final List<CameraData> doorbots;
  final List<ChimeData> chimes;
  final List<CameraData> authorizedDoorbots;
  final List<CameraData> stickupCams;
  final List<AnyCameraData> allCameras;
  final List<BaseStation> baseStations;
  final List<BeamBridge> beamBridges;
  final List<OnvifCameraData> onvifCameras;
  final List<ThirdPartyGarageDoorOpener> thirdPartyGarageDoorOpeners;
  final List<IntercomHandsetAudioData> intercoms;
  final List<dynamic> unknownDevices;

  const RingDevicesResponse({
    required this.doorbots,
    required this.chimes,
    required this.authorizedDoorbots,
    required this.stickupCams,
    required this.allCameras,
    required this.baseStations,
    required this.beamBridges,
    required this.onvifCameras,
    required this.thirdPartyGarageDoorOpeners,
    required this.intercoms,
    required this.unknownDevices,
  });
}

/// Main Ring API client
///
/// This is the primary entry point for interacting with Ring devices.
/// Create an instance with either a refresh token or email/password.
///
/// Example:
/// ```dart
/// final api = RingApi(
///   RefreshTokenAuth(refreshToken: 'your-token'),
///   options: RingApiOptions(debug: true),
/// );
///
/// final locations = await api.getLocations();
/// final cameras = await api.getCameras();
/// ```
class RingApi extends Subscribed {
  /// The REST client for making API requests
  final RingRestClient restClient;

  /// Stream of refresh token updates
  ///
  /// Listen to this stream to save the updated refresh token when it changes.
  /// The refresh token is automatically updated when authentication is refreshed.
  late final Stream<RefreshTokenUpdate> onRefreshTokenUpdated;

  /// Configuration options for this API instance
  final RingApiOptions options;

  /// Cached locations promise
  Future<List<Location>>? _locationsPromise;

  /// Create a new Ring API client
  ///
  /// Provide either [RefreshTokenAuth] or [EmailAuth] along with optional [RingApiOptions].
  ///
  /// Example with refresh token:
  /// ```dart
  /// final api = RingApi(
  ///   RefreshTokenAuth(refreshToken: 'your-token'),
  ///   options: RingApiOptions(debug: true),
  /// );
  /// ```
  ///
  /// Example with email/password:
  /// ```dart
  /// final api = RingApi(
  ///   EmailAuth(email: 'user@example.com', password: 'password'),
  ///   options: RingApiOptions(debug: true),
  /// );
  /// ```
  RingApi(dynamic authOptions, {this.options = const RingApiOptions()})
    : restClient = RingRestClient(_mergeAuthOptions(authOptions, options)) {
    // Set up refresh token update stream
    onRefreshTokenUpdated = restClient.onRefreshTokenUpdated;

    // Enable debug logging if requested
    if (options.debug) {
      enableDebug();
    }

    // Validate locationIds configuration
    final locationIds = options.locationIds;
    if (locationIds != null && locationIds.isEmpty) {
      logError(
        'Your Ring config has locationIds set to an empty list, which means '
        'no locations will be used and no devices will be found.',
      );
    }

    // Set ffmpeg path if provided
    // Note: FFmpeg functionality is platform-specific and not implemented in this
    // core package. For video transcoding, use platform-specific implementations
    // or the ring_camera package for Flutter apps.
    if (options.ffmpegPath != null) {
      logDebug('ffmpegPath provided: ${options.ffmpegPath}');
      logDebug(
        'Note: FFmpeg functionality requires platform-specific implementation',
      );
    }
  }

  /// Merge auth options with RingApiOptions
  static dynamic _mergeAuthOptions(
    dynamic authOptions,
    RingApiOptions options,
  ) {
    // Merge systemId and controlCenterDisplayName from options into auth
    if (authOptions is RefreshTokenAuth) {
      return RefreshTokenAuth(
        refreshToken: authOptions.refreshToken,
        systemId: authOptions.systemId ?? options.systemId,
        controlCenterDisplayName:
            authOptions.controlCenterDisplayName ??
            options.controlCenterDisplayName,
      );
    } else if (authOptions is EmailAuth) {
      return EmailAuth(
        email: authOptions.email,
        password: authOptions.password,
        systemId: authOptions.systemId ?? options.systemId,
        controlCenterDisplayName:
            authOptions.controlCenterDisplayName ??
            options.controlCenterDisplayName,
      );
    }
    return authOptions;
  }

  /// Fetch all Ring devices from the API
  ///
  /// Returns a [RingDevicesResponse] containing all device types organized by category.
  /// This includes cameras, doorbots, chimes, base stations, intercoms, and more.
  Future<RingDevicesResponse> fetchRingDevices() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: clientApi('ring_devices')),
    );

    final data = response.data;
    final doorbots = (data['doorbots'] as List)
        .map((item) => CameraData.fromJson(item as Map<String, dynamic>))
        .toList();
    final chimes = (data['chimes'] as List)
        .map((item) => ChimeData.fromJson(item as Map<String, dynamic>))
        .toList();
    final authorizedDoorbots = (data['authorized_doorbots'] as List)
        .map((item) => CameraData.fromJson(item as Map<String, dynamic>))
        .toList();
    final stickupCams = (data['stickup_cams'] as List)
        .map((item) => CameraData.fromJson(item as Map<String, dynamic>))
        .toList();
    final baseStations = (data['base_stations'] as List)
        .map((item) => BaseStation.fromJson(item as Map<String, dynamic>))
        .toList();
    final beamBridges = (data['beams_bridges'] as List)
        .map((item) => BeamBridge.fromJson(item as Map<String, dynamic>))
        .toList();
    final otherDevices = data['other'] as List;

    // Categorize "other" devices
    final onvifCameras = <OnvifCameraData>[];
    final intercoms = <IntercomHandsetAudioData>[];
    final thirdPartyGarageDoorOpeners = <ThirdPartyGarageDoorOpener>[];
    final unknownDevices = <dynamic>[];

    for (final device in otherDevices) {
      final deviceMap = device as Map<String, dynamic>;
      final kind = deviceMap['kind'] as String?;

      switch (kind) {
        case RingDeviceType.onvifCamera:
          onvifCameras.add(OnvifCameraData.fromJson(deviceMap));
          break;
        case RingDeviceType.intercomHandsetAudio:
          intercoms.add(IntercomHandsetAudioData.fromJson(deviceMap));
          break;
        case RingDeviceType.thirdPartyGarageDoorOpener:
          thirdPartyGarageDoorOpeners.add(
            ThirdPartyGarageDoorOpener.fromJson(deviceMap),
          );
          break;
        default:
          unknownDevices.add(device);
          break;
      }
    }

    // Combine all camera types
    final allCameras = <AnyCameraData>[
      ...doorbots,
      ...stickupCams,
      ...authorizedDoorbots,
      ...onvifCameras,
    ];

    return RingDevicesResponse(
      doorbots: doorbots,
      chimes: chimes,
      authorizedDoorbots: authorizedDoorbots,
      stickupCams: stickupCams,
      allCameras: allCameras,
      baseStations: baseStations,
      beamBridges: beamBridges,
      onvifCameras: onvifCameras,
      thirdPartyGarageDoorOpeners: thirdPartyGarageDoorOpeners,
      intercoms: intercoms,
      unknownDevices: unknownDevices,
    );
  }

  /// Listen for device updates and handle polling
  ///
  /// Sets up automatic polling for device status updates if configured.
  /// Updates are throttled to prevent excessive API calls.
  void _listenForDeviceUpdates(
    List<RingCamera> cameras,
    List<RingChime> chimes,
    List<RingIntercom> intercoms,
  ) {
    final cameraStatusPollingSeconds = options.cameraStatusPollingSeconds;
    if (cameraStatusPollingSeconds == null) {
      return;
    }

    final devices = [...cameras, ...chimes, ...intercoms];
    if (devices.isEmpty) {
      return;
    }

    // Merge all device update requests
    final updateStreams = <Stream<void>>[];
    for (final camera in cameras) {
      updateStreams.add(camera.onRequestUpdate);
    }
    for (final chime in chimes) {
      updateStreams.add(chime.onRequestUpdate);
    }
    for (final intercom in intercoms) {
      updateStreams.add(intercom.onRequestUpdate);
    }
    final onDeviceRequestUpdate = Rx.merge(updateStreams);

    // Set up polling trigger
    final onUpdateReceived = PublishSubject<void>();
    final onPollForStatusUpdate = onUpdateReceived.debounceTime(
      Duration(seconds: cameraStatusPollingSeconds),
    );

    // Create device lookup maps for efficient updates
    final camerasById = <int, RingCamera>{};
    for (final camera in cameras) {
      camerasById[camera.id] = camera;
    }

    final chimesById = <int, RingChime>{};
    for (final chime in chimes) {
      chimesById[chime.id] = chime;
    }

    final intercomsById = <int?, RingIntercom>{};
    for (final intercom in intercoms) {
      intercomsById[intercom.id] = intercom;
    }

    // Subscribe to update triggers
    addSubscription(
      Rx.merge([onDeviceRequestUpdate, onPollForStatusUpdate])
          .throttleTime(const Duration(milliseconds: 500))
          .switchMap((_) {
            return Stream.fromFuture(
              fetchRingDevices().catchError((error) {
                logError('Error fetching device updates: $error');
                // Return an empty response on error
                return RingDevicesResponse(
                  doorbots: const [],
                  chimes: const [],
                  authorizedDoorbots: const [],
                  stickupCams: const [],
                  allCameras: const [],
                  baseStations: const [],
                  beamBridges: const [],
                  onvifCameras: const [],
                  thirdPartyGarageDoorOpeners: const [],
                  intercoms: const [],
                  unknownDevices: const [],
                );
              }),
            );
          })
          .listen((response) {
            // Trigger next poll
            onUpdateReceived.add(null);

            // Update all cameras
            for (final data in response.allCameras) {
              final id = data is CameraData
                  ? data.id
                  : data is OnvifCameraData
                  ? data.id
                  : null;
              if (id != null) {
                final camera = camerasById[id];
                camera?.updateData(data);
              }
            }

            // Update all chimes
            for (final data in response.chimes) {
              final chime = chimesById[data.id];
              chime?.updateData(data);
            }

            // Update all intercoms
            for (final data in response.intercoms) {
              final intercom = intercomsById[data.id];
              intercom?.updateData(data);
            }
          }),
    );

    // Kick off initial poll
    if (cameraStatusPollingSeconds > 0) {
      onUpdateReceived.add(null);
    }
  }

  /// Register for push notifications (placeholder - requires Firebase implementation)
  ///
  /// Push notifications are a planned future feature.
  ///
  /// FUTURE ENHANCEMENT: Firebase Cloud Messaging integration
  /// The TypeScript version uses @eneris/push-receiver which connects to FCM.
  /// To implement this in Dart/Flutter, you would need to:
  /// 1. Use firebase_messaging package or implement FCM protocol directly
  /// 2. Register with Ring's FCM project using these credentials:
  ///    - apiKey: 'AIzaSyCv-hdFBmmdBBJadNy-TFwB-xN_H5m3Bk8'
  ///    - projectId: 'ring-17770'
  ///    - messagingSenderId: '876313859327'
  ///    - appId: '1:876313859327:android:e10ec6ddb3c81f39'
  /// 3. Handle credential persistence and updates
  /// 4. Route notifications to appropriate devices
  ///
  /// For now, use WebSocket connections (via Location) for real-time updates.
  Future<void> _registerPushReceiver(
    List<RingCamera> cameras,
    List<RingIntercom> intercoms,
  ) async {
    // Push notifications not yet implemented - use WebSocket for real-time updates
    logDebug(
      'Push notifications are a future enhancement. '
      'Using WebSocket connections for real-time device updates.',
    );

    // The TypeScript implementation does the following:
    // 1. Creates a PushReceiver with Firebase config and stored credentials
    // 2. Listens for credential changes and updates the REST client
    // 3. Sends FCM token to Ring servers via PATCH to clientApi('device')
    // 4. Handles incoming push notifications and routes them to devices
    // 5. Filters out duplicate notifications received in first 2 seconds
    //
    // When implementing, you would:
    // - Store credentials in restClient.internalOnlyPushNotificationCredentials
    // - Send token updates when credentials change
    // - Parse notification messages (each field is a JSON string)
    // - Route to cameras/intercoms based on device ID in notification
    // - Handle both v1 and v2 notification formats
  }

  /// Fetch raw location data from the API
  ///
  /// Returns a list of [UserLocation] objects for all locations accessible
  /// to the authenticated account.
  Future<List<UserLocation>> fetchRawLocations() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: deviceApi('locations')),
    );

    final userLocations = response.data['user_locations'] as List?;
    if (userLocations == null || userLocations.isEmpty) {
      throw Exception(
        'The Ring account which you used to generate a refresh token does not '
        'have any associated locations. Please use an account that has access '
        'to at least one location.',
      );
    }

    return userLocations
        .map((item) => UserLocation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetch Amazon Key lock associations
  ///
  /// Returns a list of lock devices associated with Amazon Key service.
  Future<List<dynamic>> fetchAmazonKeyLocks() async {
    final response = await restClient.request<List<dynamic>>(
      RequestOptions(
        url:
            'https://api.ring.com/integrations/amazonkey/v2/devices/lock_associations',
      ),
    );

    return response.data;
  }

  /// Fetch and build all locations with their devices
  ///
  /// This is called internally by [getLocations] to fetch location data,
  /// create Location objects, and set up device monitoring.
  Future<List<Location>> _fetchAndBuildLocations() async {
    // Fetch all raw data in parallel
    final rawLocations = await fetchRawLocations();
    final devicesResponse = await fetchRingDevices();

    // DEBUG: Log devices response
    logDebug('[getLocations] Devices response:');
    logDebug('  Base stations: ${devicesResponse.baseStations.length}');
    logDebug('  Beam bridges: ${devicesResponse.beamBridges.length}');
    logDebug('  Doorbots: ${devicesResponse.doorbots.length}');
    logDebug('  Chimes: ${devicesResponse.chimes.length}');
    logDebug('  All cameras: ${devicesResponse.allCameras.length}');

    // Determine which locations have hubs
    final locationIdsWithHubs = <String>[
      ...devicesResponse.baseStations.map((x) {
        logDebug('[getLocations] Base station: ${x.toJson()}');
        logDebug('[getLocations] Base station locationId: ${x.locationId}');
        return x.locationId ?? '';
      }),
      ...devicesResponse.beamBridges.map((x) => x.locationId),
    ];
    logDebug('[getLocations] Location IDs with hubs: $locationIdsWithHubs');

    // Create RingCamera instances
    final cameras = devicesResponse.allCameras.map((data) {
      final isDoorbot = data is CameraData
          ? (devicesResponse.doorbots.contains(data) ||
                devicesResponse.authorizedDoorbots.contains(data) ||
                data.kind.startsWith('doorbell'))
          : data is OnvifCameraData
          ? data.kind.startsWith('doorbell')
          : false;

      return RingCamera(
        initialData: data,
        isDoorbot: isDoorbot,
        restClient: restClient,
        avoidSnapshotBatteryDrain: options.avoidSnapshotBatteryDrain,
      );
    }).toList();

    // Create RingChime instances
    final ringChimes = devicesResponse.chimes
        .map((data) => RingChime(initialData: data, restClient: restClient))
        .toList();

    // Create RingIntercom instances
    final ringIntercoms = devicesResponse.intercoms
        .map((data) => RingIntercom(initialData: data, restClient: restClient))
        .toList();

    // Filter locations based on configuration
    final filteredLocations = rawLocations.where((location) {
      return options.locationIds == null ||
          options.locationIds!.contains(location.locationId);
    }).toList();

    // Create Location instances
    final locations = filteredLocations.map((location) {
      final locationId = location.locationId;
      final hasHubs = locationIdsWithHubs.contains(locationId);
      final hasAlarmBaseStation = devicesResponse.baseStations.any(
        (station) => station.locationId == locationId,
      );

      return Location(
        locationDetails: location,
        cameras: cameras.where((x) {
          final data = x.data;
          final cameraLocationId = data is CameraData
              ? data.locationId
              : data is OnvifCameraData
              ? data.locationId
              : null;
          return cameraLocationId == locationId;
        }).toList(),
        chimes: ringChimes.where((x) {
          return x.data.locationId == locationId;
        }).toList(),
        intercoms: ringIntercoms.where((x) {
          return x.data.locationId == locationId;
        }).toList(),
        options: LocationOptions(
          hasHubs: hasHubs,
          hasAlarmBaseStation: hasAlarmBaseStation,
          locationModePollingSeconds: options.locationModePollingSeconds,
        ),
        restClient: restClient,
      );
    }).toList();

    // Set up device update listeners
    _listenForDeviceUpdates(cameras, ringChimes, ringIntercoms);

    // Register for push notifications (placeholder for now)
    _registerPushReceiver(cameras, ringIntercoms).catchError((e) {
      logError('Failed to register push receiver: $e');
    });

    return locations;
  }

  /// Get all locations
  ///
  /// Returns a cached list of [Location] objects. The locations are fetched
  /// once and cached for the lifetime of this RingApi instance.
  ///
  /// Each location contains cameras, chimes, intercoms, and other devices.
  Future<List<Location>> getLocations() {
    _locationsPromise ??= _fetchAndBuildLocations();
    return _locationsPromise!;
  }

  /// Get all cameras across all locations
  ///
  /// Returns a flattened list of all [RingCamera] instances from all locations.
  Future<List<RingCamera>> getCameras() async {
    final locations = await getLocations();
    final cameras = <RingCamera>[];
    for (final location in locations) {
      cameras.addAll(location.cameras);
    }
    return cameras;
  }

  /// Get a specific camera by ID
  ///
  /// Returns the [RingCamera] with the matching ID, or null if not found.
  Future<RingCamera?> getCamera(int cameraId) async {
    final cameras = await getCameras();
    try {
      return cameras.firstWhere((camera) => camera.id == cameraId);
    } catch (_) {
      return null;
    }
  }

  /// Get user profile information
  ///
  /// Returns the [ProfileResponse] containing account details.
  Future<ProfileResponse> getProfile() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: clientApi('profile')),
    );

    return ProfileResponse.fromJson(response.data);
  }

  /// Disconnect and cleanup all resources
  ///
  /// Unsubscribes from all streams, disconnects all locations,
  /// and clears all timers. Call this when you're done using the API.
  Future<void> disconnect() async {
    // Unsubscribe from all subscriptions
    unsubscribe();

    // Disconnect all locations if they were loaded
    if (_locationsPromise != null) {
      try {
        final locations = await _locationsPromise!;
        for (final location in locations) {
          await location.disconnect();
        }
      } catch (e, stack) {
        logError('Error disconnecting locations: $e');
        logError('Stack: $stack');
      }
    }

    // Clear REST client timeouts
    restClient.clearTimeouts();

    // Clear global timeouts
    clearTimeouts();
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
