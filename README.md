# ring_client_api

[![pub package](https://img.shields.io/pub/v/ring_client_api.svg)](https://pub.dev/packages/ring_client_api)

This is an unofficial Dart API for [Ring Doorbells](https://shop.ring.com/pages/doorbell-cameras),
[Ring Cameras](https://shop.ring.com/pages/security-cameras),
the [Ring Alarm System](https://shop.ring.com/pages/security-system),
[Ring Smart Lighting](https://shop.ring.com/pages/smart-lighting),
and third party devices that connect to the Ring Alarm System.

This package is a Dart port of the popular [ring-client-api](https://github.com/dgreif/ring) TypeScript library.

## Features

- Full access to Ring API with Dart null-safety
- Support for Ring Doorbells and Cameras
- Ring Alarm System integration
- Smart Lighting control
- Real-time push notifications via WebSocket
- WebRTC video streaming support (via companion Flutter package)
- Historical event data
- Device status monitoring and control
- Camera snapshots
- Event history and playback
- Two-factor authentication (2FA) support
- CLI tools for authentication and device data

## Streaming Support

This core package provides REST API and WebSocket functionality. For full WebRTC video streaming in Flutter apps, use the companion package:

**[ring_client_api_flutter](https://pub.dev/packages/ring_client_api_flutter)** - Full video streaming with flutter_webrtc

See [WEBRTC_OPTIONS.md](WEBRTC_OPTIONS.md) for detailed information about streaming options.

## Troubleshooting Issues

If you are having issues, please search existing [Issues](https://github.com/sjhorn/ring_client_api/issues) before opening a new one.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ring_client_api: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Setup and Config

First, generate a `refreshToken` using the Ring authentication process. You will need to authenticate with your Ring account credentials.

```dart
import 'package:ring_client_api/ring_client_api.dart';

void main() async {
  // Create API instance with refresh token authentication
  final ringApi = RingApi(
    RefreshTokenAuth(refreshToken: 'your_refresh_token_here'),
    options: RingApiOptions(
      debug: false,
      cameraStatusPollingSeconds: 20,
      locationModePollingSeconds: 20,
      avoidSnapshotBatteryDrain: false,
      controlCenterDisplayName: 'My Dart App',
    ),
  );

  // Listen for refresh token updates to save the new token
  ringApi.onRefreshTokenUpdated.listen((update) {
    print('New refresh token: ${update.newRefreshToken}');
    // Save the updated token to secure storage
  });

  // Get locations and cameras
  final locations = await ringApi.getLocations();
  final cameras = await ringApi.getCameras();

  // Clean up when done
  await ringApi.disconnect();
}
```

### Optional Parameters

| Option                       | Default                      | Explanation                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ---------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `cameraStatusPollingSeconds` | `null` (No Polling)          | How frequently to poll for updates to your cameras and chimes (in seconds). Information like light/siren/volume/snooze status do not update in real time and need to be requested periodically.                                                                                                                                                                                                                                                                          |
| `locationModePollingSeconds` | `null` (No Polling)          | How frequently to poll for location mode updates (in seconds). This is only useful if you are using location modes to control camera settings and want to keep an up-to-date reference of the current mode for each location. Polling is automatically disabled for locations equipped with a Ring Alarm.                                                                                                                                                                |
| `locationIds`                | All Locations                | Allows you to limit the results to a specific set of locations. This is mainly useful for limiting results, but can also be used if you only care about listening for events at a subset of your locations and don't want to create websocket connections to _all_ of your locations. This will also limit the results for `ringApi.getCameras()` to the configured locations. If this option is not included, all locations will be returned.                         |
| `debug`                      | false                        | Turns on additional logging. In particular, ffmpeg logging.                                                                                                                                                                                                                                                                                                                                                                                                              |
| `controlCenterDisplayName`   | 'ring-client-api'            | This allows you to change the displayed name for the Authorized Device within Control Center in the Ring app                                                                                                                                                                                                                                                                                                                                                             |
| `avoidSnapshotBatteryDrain`  | false                        | Causes snapshots for battery cameras to be fetched at a minimum 10 minute interval to avoid draining the battery.                                                                                                                                                                                                                                                                                                                                                        |

## Locations

```dart
final locations = await ringApi.getLocations();
final location = locations[0];

// Check if location has hubs (alarm and/or lighting bridge)
print(location.hasHubs);

// Arm/disarm location
await location.disarm();
await location.armHome([
  /* optional array of zids for devices to bypass */
]);
await location.armAway([
  /* bypass zids */
]);

// Get alarm mode
final mode = await location.getAlarmMode(); // returns 'all', 'some', or 'none'

// Siren control
await location.soundSiren();
await location.silenceSiren();

// Access cameras and history
final cameras = location.cameras;
final history = await location.getHistory();
final cameraEvents = await location.getCameraEvents();
```

`locations` is a list of your Ring locations. Each location can be armed or disarmed,
and used to interact with all devices in that location.

## Devices

Once you have acquired the desired location, you can start
to interact with associated devices. These devices include ring alarm, ring lighting,
and third party devices connected to ring alarm.

```dart
import 'package:ring_client_api/ring_client_api.dart';

final devices = await location.getDevices();
final baseStation = devices.firstWhere(
  (device) => device.data.deviceType == RingDeviceType.baseStation
);

// Set volume (base station and keypad support volume settings between 0 and 1)
await baseStation.setVolume(0.75);

// Access device data
print(baseStation.data); // object containing properties like zid, name, roomId, faulted, tamperStatus, etc.

// Listen for data updates
baseStation.onData.listen((data) {
  // called any time data is updated for this specific device
});
```

## Cameras

You can get all cameras using `await ringApi.getCameras()` or cameras for a particular
location with `location.cameras`.

```dart
final camera = location.cameras[0];

// Access camera data
print(camera.data); // camera info including motion zones, light status, battery, etc.

// Listen for data updates
camera.onData.listen((data) {
  // called every time new data is fetched for this camera
});

// Control camera features
await camera.setLight(true); // turn light on/off
await camera.setSiren(true); // turn siren on/off

// Get camera information
final health = await camera.getHealth(); // fetch health info like wifi status
await camera.startVideoOnDemand(); // ask the camera to start a new video stream

// SIP session for RTP control
final sipSession = await camera.createSipSession();

// Event history and recordings
final events = await camera.getEvents(); // fetch ding events for the camera
final recordingUrl = await camera.getRecordingUrl(dingIdStr, transcoded: true);
final snapshot = await camera.getSnapshot(); // returns Uint8List of latest snapshot
```

Camera also includes the following streams:

- `onNewNotification`: triggered any time a new push notification is received
- `onActiveNotifications`: notifications received within the last minute
- `onDoorbellPressed`: includes the sip info and ding information every time a new ding is created
- `onActiveDings`: dings created within the last 65 seconds
- `onDoorbellPressed`: emits a ding every time the doorbell is pressed
- `onMotionDetected`: `true` or `false` based on `onActiveDings` containing a motion ding

Some other useful properties:

- `id`
- `name`: same as `description` from `data`
- `hasLight`: does this camera have a light
- `hasSiren`: does this camera have a siren
- `isDoorbot`: is this camera a doorbell

## Refresh Token

Ring has restrictions on refresh tokens that may cause them to expire. Make sure to handle token refresh properly in your application to maintain a stable connection.

## Example

See the [example](example/) directory for a complete example application.

## Additional information

This package is a port of the TypeScript [ring-client-api](https://github.com/dgreif/ring) library by Dusty Greif.

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Issues

Please file issues at the [GitHub issue tracker](https://github.com/sjhorn/ring_client_api/issues).

### License

MIT License - see [LICENSE](LICENSE) file for details.

Original TypeScript library Copyright (c) 2022 Dusty Greif

Dart port Copyright (c) 2025 Scott Horn
