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

## Phase 6: Streaming (WebRTC) 🚧 IN PROGRESS

- [ ] Port `streaming/peer-connection.ts` → `lib/src/streaming/peer_connection.dart` (~175 lines)
- [ ] Port `streaming/streaming-messages.ts` → `lib/src/streaming/streaming_messages.dart` (~86 lines)
- [ ] Port `streaming/simple-webrtc-session.ts` → `lib/src/streaming/simple_webrtc_session.dart` (~55 lines)
- [ ] Port `streaming/streaming-session.ts` → `lib/src/streaming/streaming_session.dart` (~256 lines)
- [ ] Port `streaming/webrtc-connection.ts` → `lib/src/streaming/webrtc_connection.dart` (~336 lines)

**Note**: Streaming requires WebRTC support which may have platform-specific implementations in Dart.

---

## Phase 7: Testing

- [ ] Port `test/rest-client.spec.ts` → `test/rest_client_test.dart` (~377 lines)
- [ ] Port `test/ring-camera.spec.ts` → `test/ring_camera_test.dart` (~58 lines)
- [ ] Add integration tests
- [ ] Verify all tests pass

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
- [ ] Port `chime-example.ts` → `example/chime_example.dart`
- [ ] Port `stream-example.ts` → `example/stream_example.dart`
- [ ] Port `record-example.ts` → `example/record_example.dart`
- [ ] Port `return-audio-example.ts` → `example/return_audio_example.dart`
- [ ] Create browser example equivalent (if applicable)

---

## Phase 9: CLI Tools (Optional)

- [ ] Port `ring-auth-cli.ts` → `bin/ring_auth_cli.dart`
- [ ] Port `ring-device-data-cli.ts` → `bin/ring_device_data_cli.dart`

---

## Phase 10: Documentation and Polish

- [ ] Update CHANGELOG.md with version 0.1.0
- [ ] Generate dartdoc comments for all public APIs
- [ ] Run `dart format .`
- [ ] Run `dart analyze` and fix all issues
- [ ] Ensure all examples run successfully
- [ ] Update README with Dart-specific usage examples

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

### Testing
- ✅ Live API testing with 20 cameras
- ✅ Battery data verified matching TypeScript implementation
- ✅ Camera comparison example working
- ✅ Main example demonstrating all major features

---

## Progress Tracking

**Overall Progress**: 5/11 phases complete, 1 in progress

- Phase 1: Project Setup ✅
- Phase 2: Core Types and Utilities ✅
- Phase 3: Core API Client ✅
- Phase 4: Device Models ✅
- Phase 5: Location and Main API ✅
- Phase 6: Streaming (WebRTC) 🚧
- Phase 7: Testing ⏳
- Phase 8: Examples ✅ (core example complete)
- Phase 9: CLI Tools ⏳
- Phase 10: Documentation ⏳
- Phase 11: Publishing ⏳

**Last updated**: 2025-11-10

---

## Next Steps

1. **Streaming Support** (Phase 6)
   - Evaluate WebRTC library options for Dart
   - Port streaming-related modules
   - Test with live camera streams

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
