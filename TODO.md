# Ring Client API - Dart Port TODO

## Project Overview
This is a port of the TypeScript ring-client-api to Dart. The original project is located in `./ring/packages/ring-client-api/`.

**Source Stats:**
- ~6000 lines of TypeScript code
- 25 TypeScript files
- 8 example files
- 2 test files
- 2 CLI tools

---

## Phase 1: Project Setup ✅ COMPLETE

- [x] Initialize git repository
- [x] Add remote: https://github.com/sjhorn/ring_client_api
- [x] Create TODO.md
- [x] Update README.md with Ring API documentation
- [x] Copy LICENSE from ring project
- [x] Update pubspec.yaml with required dependencies
- [x] Configure .gitignore for .env file
- [x] Create .env.example template

---

## Phase 2: Core Types and Utilities ✅ COMPLETE

### Type Definitions
- [x] Port `ring-types.ts` → `lib/src/ring_types.dart` (~1253 lines)
  - [x] Device types enums
  - [x] Camera model types
  - [x] API response interfaces
  - [x] Notification types
  - [x] Add ~300 @JsonKey annotations for snake_case mapping
  - [x] Fix type flexibility (dynamic fields for varying API responses)

### Utilities
- [x] Port `util.ts` → `lib/src/util.dart` (~187 lines)
  - [x] Logging utilities
  - [x] UUID generation
  - [x] Hardware ID generation
  - [x] Base64 encoding
  - [x] Retry logic

- [x] Port `device-data.ts` → `lib/src/device_data.dart` (~90 lines)

---

## Phase 3: Core API Client ✅ COMPLETE

- [x] Port `refresh-token.ts` → `lib/src/refresh_token.dart` (~45 lines)
- [x] Port `rest-client.ts` → `lib/src/rest_client.dart` (~625 lines)
  - [x] HTTP client with retry logic
  - [x] Authentication handling
  - [x] Token refresh
  - [x] Request/response handling
- [x] Port `subscribed.ts` → `lib/src/subscribed.dart` (~13 lines)
  - [x] Base class for RxDart subscription management

---

## Phase 4: Device Models ✅ COMPLETE

- [x] Port `ring-device.ts` → `lib/src/ring_device.dart` (~125 lines)
- [x] Port `ring-chime.ts` → `lib/src/ring_chime.dart` (~154 lines)
- [x] Port `ring-intercom.ts` → `lib/src/ring_intercom.dart` (~125 lines)
- [x] Port `ring-camera.ts` → `lib/src/ring_camera.dart` (~712 lines)
  - [x] Video streaming
  - [x] Snapshots
  - [x] Motion detection
  - [x] Doorbell events
  - [x] Light/siren control
  - [x] Recording URLs
  - [x] Battery level calculation fix

---

## Phase 5: Location and Main API ✅ COMPLETE

- [x] Port `location.ts` → `lib/src/location.dart` (~634 lines)
  - [x] WebSocket connections
  - [x] Device management
  - [x] Alarm modes
  - [x] Location history
  - [x] Convert debug logging from logInfo to logDebug
- [x] Port `api.ts` → `lib/src/api.dart` (~525 lines)
  - [x] Main RingApi class
  - [x] Location management
  - [x] Camera access
  - [x] Push notifications
  - [x] Convert debug logging from logInfo to logDebug

---

## Phase 6: Streaming (WebRTC) ✅ COMPLETE

**IMPORTANT**: Full WebRTC streaming is **NOT implemented in this package** (`ring_client_api`).
The `ring_client_api` package is a pure Dart library that provides REST API and WebSocket functionality only.

**For WebRTC video streaming**, use the separate **[ring_client_api_flutter](https://pub.dev/packages/ring_client_api_flutter)** package which provides full streaming support using flutter_webrtc.

### Core Package (Pure Dart)
- [x] Port `streaming/streaming-messages.ts` → `lib/src/streaming/streaming_messages.dart` (~86 lines)
  - Full implementation with JSON serialization
- [x] Port `streaming/simple-webrtc-session.ts` → `lib/src/streaming/simple_webrtc_session.dart` (~55 lines)
  - **Fully functional** - REST-based simple streaming
- [x] Create stub `streaming/peer-connection.ts` → `lib/src/streaming/peer_connection.dart` (~175 lines)
  - Interface definitions provided
  - Documentation for WebRTC implementation
- [x] Create stub `streaming/webrtc-connection.ts` → `lib/src/streaming/webrtc_connection.dart` (~336 lines)
  - Interface definitions provided
  - Documentation for WebRTC implementation
- [x] Create stub `streaming/streaming-session.ts` → `lib/src/streaming/streaming_session.dart` (~256 lines)
  - Interface definitions provided
  - Documentation for WebRTC implementation

### Companion Flutter Package ✅
- [x] Create `ring_client_api_flutter` package
  - [x] Package structure and pubspec.yaml
  - [x] Implement `FlutterPeerConnection` using flutter_webrtc
  - [x] Create `RingCameraViewer` widget (live streaming)
  - [x] Create `RingCameraSnapshotViewer` widget (battery-friendly)
  - [x] Write comprehensive README
  - [x] Create example Flutter app
    - Camera list with authentication
    - Live streaming viewer
    - Snapshot viewer
    - Camera controls (light, siren)
    - Two-way audio toggle
  - [x] Pass all analyzer checks

### Documentation
- [x] Create `WEBRTC_OPTIONS.md` (~400+ lines)
  - Detailed analysis of Dart WebRTC options
  - Comparison of pure_dart_webrtc, flutter_webrtc, dart_webrtc
  - Recommendations for implementation approaches
- [x] Create `TYPESCRIPT_DIFFERENCES.md` (~500+ lines)
  - Complete guide to differences between TypeScript and Dart implementations
  - Language differences, null safety, JSON serialization
  - Streams vs Observables, testing approaches
  - Migration guide for developers following the port

**WebRTC Implementation Strategy:**

The TypeScript implementation uses `werift`, a pure JavaScript WebRTC library for Node.js. Dart does not have an equivalent pure-Dart WebRTC implementation suitable for non-browser, non-Flutter applications.

**Two-Package Architecture:**
- ✅ `ring_client_api` - Core pure Dart package with interface definitions
- ✅ `ring_client_api_flutter` - Full WebRTC implementation using flutter_webrtc

**What Works:**
- Message type definitions
- Simple WebRTC session (REST API only)
- Interface definitions for platform implementations
- **Full WebRTC streaming in Flutter apps** (via ring_client_api_flutter)
- Two-way audio support
- Snapshot viewer for battery-powered cameras

**What's Platform-Specific:**
- Full WebRTC peer connections (use flutter_webrtc for Flutter)
- Video/audio transcoding with FFmpeg
- RTP packet handling
- Native platform support (iOS, Android, Web, macOS, Windows, Linux)

---

## Phase 7: Testing ✅ COMPLETE

- [x] Port `test/rest-client.spec.ts` → `test/rest_client_test.dart` (~533 lines)
  - [x] Implement HTTP client dependency injection in rest_client.dart
  - [x] Create comprehensive mock HTTP client
  - [x] Port all 8 authentication and request tests
  - [x] All tests passing
- [x] Port `test/ring-camera.spec.ts` → `test/ring_camera_test.dart` (~80 lines)
  - [x] Battery level calculation tests (5 tests)
  - [x] Snapshot UUID cleaning tests (3 tests)
  - [x] All tests passing
- [x] Add integration tests (~400 lines)
  - [x] API initialization flow
  - [x] Location and camera discovery
  - [x] Authentication error handling
  - [x] Network retry logic
  - [x] Refresh token update events
  - [x] Mock data validation
- [x] Verify all tests pass
  - **✅ All 26 tests passing!**

---

## Phase 8: Examples ✅ COMPLETE

- [x] Port `example.ts` → `example/ring_client_api_example.dart`
  - [x] Basic API usage
  - [x] Refresh token handling
  - [x] Location and camera listing
  - [x] Snapshot retrieval
  - [x] Event listeners
  - [x] Device discovery
- [x] Create `example/camera_comparison.dart` for testing
- [x] Verify examples work with live Ring API data

Remaining examples (optional):
- [x] Port `chime-example.ts` → `example/chime_example.dart` ✅
- [ ] Port `stream-example.ts` → `example/stream_example.dart` ⚠️ Requires WebRTC
- [ ] Port `record-example.ts` → `example/record_example.dart` ⚠️ Requires WebRTC
- [ ] Port `return-audio-example.ts` → `example/return_audio_example.dart` ⚠️ Requires WebRTC
- [ ] Create browser example equivalent (if applicable)

**Note**: Examples marked with ⚠️ require full WebRTC streaming support. For WebRTC functionality in Flutter apps, use the companion package `ring_client_api_flutter`.

---

## Phase 9: CLI Tools ✅ COMPLETE

- [x] Port `ring-auth-cli.ts` → `bin/ring_auth_cli.dart`
  - Complete authentication CLI for obtaining refresh tokens
  - Handles email/password auth and 2FA
  - Fully functional
- [x] Port `ring-device-data-cli.ts` → `bin/ring_device_data_cli.dart`
  - Fetches and anonymizes device data for debugging
  - Removes sensitive information
  - Fully functional

---

## Phase 10: Documentation and Polish ✅ COMPLETE

- [x] Update CHANGELOG.md with version 0.1.0
  - Comprehensive release notes with all features
  - Testing summary
  - Migration guide from TypeScript
  - Known limitations documented
- [x] Run `dart format .`
  - Formatted 21 files (8 changed)
  - All code now follows Dart style guidelines
- [x] Run `dart analyze` and fix all issues
  - Fixed 8 analyzer warnings
  - Removed dead code
  - Removed unnecessary casts
  - Cleaned up unused imports
  - Only 1 warning remaining (in generated code - safe to ignore)
- [x] Ensure all examples run successfully
  - Main example works with live Ring API
  - Camera comparison example functional
  - All examples properly demonstrate API usage
- [x] Update README with Dart-specific usage examples
  - Updated API initialization code
  - Added refresh token event handling example
  - Proper Dart syntax and conventions

---

## Phase 11: Publishing Preparation

- [ ] Run `dart pub publish --dry-run`
- [ ] Address any pub.dev publishing warnings
- [ ] Create git tag v0.1.0
- [ ] Push to GitHub
- [ ] Publish to pub.dev

---

## Key Dependencies ✅ ADDED

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

---

## Completed Work Summary

### JSON Field Mapping (Major Achievement!)
- Systematically added **~300 @JsonKey annotations** across **70+ classes**
- Fixed snake_case to camelCase mapping issues
- Made types more flexible to handle API variability
- All camera data now parsing correctly including battery levels

### Core API Implementation
- ✅ Full authentication and token refresh
- ✅ REST client with retry logic
- ✅ WebSocket connections for real-time updates
- ✅ Device discovery and management
- ✅ Camera, chime, and intercom support
- ✅ Event notifications (motion, doorbell, etc.)
- ✅ Location and device management
- ✅ Snapshot retrieval
- ✅ Camera health and battery monitoring

### Testing & Examples
- ✅ Live API testing with 20 cameras
- ✅ Battery data verified matching TypeScript implementation
- ✅ Camera comparison example working
- ✅ Main example demonstrating all major features
- ✅ Chime example for Ring Chime device control

---

## Progress Tracking

**Overall Progress**: 10/11 phases complete

- Phase 1: Project Setup ✅
- Phase 2: Core Types and Utilities ✅
- Phase 3: Core API Client ✅
- Phase 4: Device Models ✅
- Phase 5: Location and Main API ✅
- Phase 6: Streaming (WebRTC) ✅ - completed in ../ring_camera companion project
- Phase 7: Testing ✅
- Phase 8: Examples ✅
- Phase 9: CLI Tools ✅
- Phase 10: Documentation and Polish ✅
- Phase 11: Publishing ⏳

**Last updated**: 2025-11-11

---

## Next Steps

2. **Testing** (Phase 7)
   - Port existing TypeScript tests
   - Add integration tests
   - Verify all functionality

3. **Documentation** (Phase 10)
   - Add dartdoc comments
   - Create comprehensive API documentation
   - Write usage guides

4. **Publishing** (Phase 11)
   - Final polish and cleanup
   - Publish to pub.dev
