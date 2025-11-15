## 0.1.0 - Initial Release

### Overview
First release of the Dart port of the TypeScript ring-client-api library. This release provides comprehensive access to Ring devices including doorbells, cameras, alarms, and smart lighting.

### Features

#### Core API
- **Authentication**: Full OAuth2 authentication with refresh token support
- **Auto token refresh**: Automatic token renewal and event notifications
- **Session management**: Robust session handling with caching
- **HTTP retry logic**: Automatic retry with exponential backoff for network errors
- **WebSocket support**: Real-time push notifications for device events

#### Devices
- **Ring Cameras**: Full support for all Ring camera models
  - Doorbell cameras (Video Doorbell, Video Doorbell Pro, etc.)
  - Security cameras (Stick Up Cam, Spotlight Cam, etc.)
  - Snapshot retrieval
  - Video recording access
  - Motion detection events
  - Doorbell press notifications
  - Battery status monitoring
  - Light and siren control

- **Ring Chimes**: Support for Ring Chime and Chime Pro
  - Volume control
  - Snooze functionality
  - Health monitoring

- **Ring Intercoms**: Basic intercom support
  - Device status and configuration

- **Ring Locations**: Location and site management
  - Multiple location support
  - Alarm mode control (Home, Away, Disarmed)
  - Device discovery per location
  - Historical event access

#### API Features
- Null-safe Dart implementation
- Comprehensive type definitions with JSON serialization
- RxDart streams for event handling
- Configurable polling intervals
- Debug logging support
- Battery-friendly snapshot intervals

### Tested Features
- ✅ Authentication with refresh tokens
- ✅ Two-factor authentication (2FA) support
- ✅ Camera discovery and management
- ✅ Snapshot retrieval from cameras
- ✅ Device health monitoring
- ✅ Battery level reporting (single and dual batteries)
- ✅ Motion detection events
- ✅ Doorbell press events
- ✅ Location management
- ✅ Real-time push notifications via WebSocket
- ✅ Automatic token refresh
- ✅ Event history retrieval

### Testing
- **Unit Tests**: 17 tests covering core functionality
  - Battery level calculations
  - UUID cleaning
  - HTTP client and authentication flows
- **Integration Tests**: 8 tests for end-to-end scenarios
  - API initialization
  - Authentication error handling
  - Network retry logic
  - Token refresh events
- **Total**: 25 tests, all passing

### Known Limitations
- **WebRTC Streaming**: Not implemented in this package. For full WebRTC video streaming support, use the companion **[ring_camera](https://github.com/sjhorn/ring_camera)** package which provides complete streaming functionality via flutter_webrtc.
- **FFmpeg Integration**: Platform-specific video transcoding is not included in this core package. Recording functionality is planned for ring_camera v0.3.0.
- **Push Notifications**: Firebase Cloud Messaging integration is not included. This feature is planned for ring_camera v0.4.0+.
- **Browser Support**: Primarily tested on Dart VM, browser support may vary

**Note**: Intentional feature exclusions (WebRTC, FFmpeg, Push Notifications) are tracked with detailed implementation plans in [ring_camera/TODO.md](https://github.com/sjhorn/ring_camera/blob/main/TODO.md#features-tracked-from-ring_client_api).

### Dependencies
```yaml
dependencies:
  http: ^1.2.2
  rxdart: ^0.28.0
  uuid: ^4.5.1
  json_annotation: ^4.9.0
  socket_io_client: ^3.0.2
  dio: ^5.7.0

dev_dependencies:
  test: ^1.25.8
  mockito: ^5.4.4
  build_runner: ^2.4.13
  json_serializable: ^6.8.0
  lints: ^5.0.0
```

### Migration from TypeScript
This is a direct port of the TypeScript ring-client-api library. Key differences:
- Dart's null-safety requires explicit null handling
- Constructor syntax differs (named parameters, factory constructors)
- Streams use RxDart instead of RxJS
- JSON serialization uses json_serializable code generation
- Async/await syntax is similar but with different error handling patterns

### Breaking Changes from TypeScript Version
- API initialization requires `RefreshTokenAuth` or `EmailAuth` objects instead of plain strings
- Configuration moved to `RingApiOptions` object
- Event streams use Dart/RxDart `Stream` instead of RxJS `Observable`
- Some method names follow Dart conventions (camelCase)

### Documentation
- Comprehensive README with setup instructions
- Example code demonstrating all major features
- API documentation in source code
- TODO list tracking implementation progress

### Acknowledgments
This library is a Dart port of the excellent [ring-client-api](https://github.com/dgreif/ring) TypeScript library by dgreif and contributors. Special thanks to the original authors and the Ring developer community.

### Repository
- **GitHub**: https://github.com/sjhorn/ring_client_api
- **Issues**: https://github.com/sjhorn/ring_client_api/issues
- **License**: MIT (same as original TypeScript library)
