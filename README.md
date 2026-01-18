# ring_client_api

[![pub package](https://img.shields.io/pub/v/ring_client_api.svg)](https://pub.dev/packages/ring_client_api)

This is an unofficial Dart API for [Ring Doorbells](https://shop.ring.com/pages/doorbell-cameras),
[Ring Cameras](https://shop.ring.com/pages/security-cameras),
the [Ring Alarm System](https://shop.ring.com/pages/security-system),
[Ring Smart Lighting](https://shop.ring.com/pages/smart-lighting),
and third party devices that connect to the Ring Alarm System.

This package is a Dart port of the popular [ring-client-api](https://github.com/dgreif/ring) TypeScript library.

## Features

- Full access to Ring API (Application Programming Interface) with Dart null-safety
- Support for Ring Doorbells and Cameras
- Ring Alarm System integration
- Smart Lighting control
- Real-time push notifications via WebSocket
- **Full WebRTC (Web Real-Time Communication) video streaming** using pure Dart (webrtc_dart)
- FFmpeg transcoding for video recording
- Two-way audio support
- Historical event data
- Device status monitoring and control
- Camera snapshots
- Event history and playback
- 2FA (Two-Factor Authentication) support
- CLI (Command-Line Interface) tools for authentication, device data, and video recording

## Streaming Support

This package now includes **full WebRTC video streaming** using `webrtc_dart` (a pure Dart port of werift):

```dart
// Record 30 seconds of video from a camera
final session = await camera.startLiveCall();
await session.startTranscoding(FfmpegOptions(
  output: ['-t', '30', 'recording.mp4'],
));
await session.onCallEnded.first;
```

**Requirements:**
- FFmpeg must be installed and in PATH for video transcoding
- `webrtc_dart` package (included as dependency)

### Advanced WebRTC (Web Real-Time Communication) Configuration

For real-time applications like Flutter video players, you can configure aggressive PLI (Picture Loss Indication) handling to get IDR (Instantaneous Decoder Refresh) keyframes faster:

```dart
import 'package:ring_client_api/ring_client_api.dart';

// Use aggressive PLI config for faster keyframe delivery
final pc = WebRTCPeerConnection(pliConfig: PliConfig.aggressive);

// Or customize PLI behavior
final pc = WebRTCPeerConnection(
  pliConfig: PliConfig(
    earlyPli: true,              // Send PLI with SSRC (Synchronization Source) = 0 before real SSRC arrives
    earlyPliInterval: Duration(milliseconds: 200),
    earlyPliMaxDuration: Duration(seconds: 2),
    pliOnFirstPacketCount: 3,    // Burst of 3 PLIs when first RTP (Real-time Transport Protocol) packet arrives
    periodicPliInterval: Duration(seconds: 2),
  ),
);
```

| PliConfig Option | Default | Description |
|------------------|---------|-------------|
| `earlyPli` | `false` | Send PLI requests with SSRC (Synchronization Source) = 0 before real SSRC arrives |
| `earlyPliInterval` | 200ms | Interval between early PLI requests |
| `earlyPliMaxDuration` | 2s | Maximum duration for early PLI requests |
| `pliOnFirstPacketCount` | 0 | Number of PLI bursts when real SSRC arrives (at 0, 200, 500ms) |
| `periodicPliInterval` | 4s | Interval for periodic PLI requests |

`PliConfig.aggressive` preset uses: `earlyPli: true`, `pliOnFirstPacketCount: 3`, `periodicPliInterval: 2s`

### Audio Codec Detection

After SDP (Session Description Protocol) answer exchange, you can detect the negotiated audio codec:

```dart
await pc.acceptAnswer(answer);
print(pc.audioCodec); // AudioCodec.opus or AudioCodec.pcmu (Pulse Code Modulation mu-law)
```

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

// SIP (Session Initiation Protocol) session for RTP (Real-time Transport Protocol) control
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

## CLI Tools

This package includes command-line tools to help with authentication and debugging:

### ring_auth_cli.dart
Obtain a refresh token by authenticating with your Ring account:
```bash
dart run bin/ring_auth_cli.dart
```
This interactive CLI will prompt for your email/password and handle 2FA if required.

### ring_device_data_cli.dart
Fetch and anonymize device data for debugging purposes:
```bash
dart run bin/ring_device_data_cli.dart <refresh_token>
```
Outputs device information with sensitive data removed.

### list_cameras.dart
List all cameras associated with your Ring account:
```bash
dart run bin/list_cameras.dart <refresh_token>
```
Displays camera names and IDs for quick reference.

### stream_camera.dart
Record video from a Ring camera using WebRTC:
```bash
# Set credentials
export RING_REFRESH_TOKEN="your_token"

# Record 30 seconds to file
dart run bin/stream_camera.dart 30 recording.mp4
```
Requires FFmpeg to be installed.

## Example

See the [example](example/) directory for a complete example application.

## Documentation

- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[TODO.md](TODO.md)** - Project implementation checklist and progress
- **[TYPESCRIPT_DIFFERENCES.md](TYPESCRIPT_DIFFERENCES.md)** - Feature parity summary and TypeScript→Dart migration guide

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
