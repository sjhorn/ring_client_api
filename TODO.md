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

## Phase 1: Project Setup ✅

- [x] Initialize git repository
- [x] Add remote: https://github.com/sjhorn/ring_client_api
- [x] Create TODO.md
- [ ] Update README.md with Ring API documentation
- [ ] Copy LICENSE from ring project
- [ ] Update pubspec.yaml with required dependencies

---

## Phase 2: Core Types and Utilities

### Type Definitions
- [ ] Port `ring-types.ts` → `lib/src/ring_types.dart` (~1253 lines)
  - Device types enums
  - Camera model types
  - API response interfaces
  - Notification types

### Utilities
- [ ] Port `util.ts` → `lib/src/util.dart` (~187 lines)
  - Logging utilities
  - UUID generation
  - Hardware ID generation
  - Base64 encoding
  - Retry logic

- [ ] Port `device-data.ts` → `lib/src/device_data.dart` (~90 lines)

---

## Phase 3: Core API Client

- [ ] Port `refresh-token.ts` → `lib/src/refresh_token.dart` (~45 lines)
- [ ] Port `rest-client.ts` → `lib/src/rest_client.dart` (~625 lines)
  - HTTP client with retry logic
  - Authentication handling
  - Token refresh
  - Request/response handling
- [ ] Port `subscribed.ts` → `lib/src/subscribed.dart` (~13 lines)
  - Base class for RxJS subscription management

---

## Phase 4: Device Models

- [ ] Port `ring-device.ts` → `lib/src/ring_device.dart` (~125 lines)
- [ ] Port `ring-chime.ts` → `lib/src/ring_chime.dart` (~154 lines)
- [ ] Port `ring-intercom.ts` → `lib/src/ring_intercom.dart` (~125 lines)
- [ ] Port `ring-camera.ts` → `lib/src/ring_camera.dart` (~712 lines)
  - Video streaming
  - Snapshots
  - Motion detection
  - Doorbell events
  - Light/siren control
  - Recording URLs

---

## Phase 5: Location and Main API

- [ ] Port `location.ts` → `lib/src/location.dart` (~634 lines)
  - WebSocket connections
  - Device management
  - Alarm modes
  - Location history
- [ ] Port `api.ts` → `lib/src/api.dart` (~525 lines)
  - Main RingApi class
  - Location management
  - Camera access
  - Push notifications

---

## Phase 6: Streaming (WebRTC)

- [ ] Port `streaming/peer-connection.ts` → `lib/src/streaming/peer_connection.dart` (~175 lines)
- [ ] Port `streaming/streaming-messages.ts` → `lib/src/streaming/streaming_messages.dart` (~86 lines)
- [ ] Port `streaming/simple-webrtc-session.ts` → `lib/src/streaming/simple_webrtc_session.dart` (~55 lines)
- [ ] Port `streaming/streaming-session.ts` → `lib/src/streaming/streaming_session.dart` (~256 lines)
- [ ] Port `streaming/webrtc-connection.ts` → `lib/src/streaming/webrtc_connection.dart` (~336 lines)

---

## Phase 7: Testing

- [ ] Port `test/rest-client.spec.ts` → `test/rest_client_test.dart` (~377 lines)
- [ ] Port `test/ring-camera.spec.ts` → `test/ring_camera_test.dart` (~58 lines)
- [ ] Add integration tests
- [ ] Verify all tests pass

---

## Phase 8: Examples

- [ ] Port `example.ts` → `example/main.dart`
- [ ] Port `api-example.ts` → `example/api_example.dart`
- [ ] Port `chime-example.ts` → `example/chime_example.dart`
- [ ] Port `stream-example.ts` → `example/stream_example.dart`
- [ ] Port `record-example.ts` → `example/record_example.dart`
- [ ] Port `return-audio-example.ts` → `example/return_audio_example.dart`
- [ ] Create browser example equivalent (if applicable)
- [ ] Verify examples work with test data

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

## Key Dependencies to Add

```yaml
dependencies:
  # HTTP client
  http: ^1.2.0

  # Reactive programming (RxJS equivalent)
  rxdart: ^0.28.0

  # UUID generation
  uuid: ^4.5.0

  # JSON handling with big integers
  json_annotation: ^4.9.0

  # WebSocket support (built-in via dart:io)

  # WebRTC (if needed for streaming)
  flutter_webrtc: ^0.11.0  # or dart_webrtc for non-Flutter

  # System information
  device_info_plus: ^10.1.0
  platform_device_id: ^1.0.0

dev_dependencies:
  # Testing
  test: ^1.25.0
  mockito: ^5.4.0

  # Code generation
  build_runner: ^2.4.0
  json_serializable: ^6.8.0
```

---

## Porting Strategy

1. **Bottom-up approach**: Start with types and utilities, then build up to higher-level APIs
2. **Test as we go**: Port tests alongside implementation to verify correctness
3. **Match input/output**: Ensure Dart implementation produces same results as TypeScript
4. **Git commit per module**: Make a commit after each major file is ported
5. **Update this TODO.md**: Keep this file current as progress is made

---

## Notes

- The ring source code is read-only reference material in `./ring/`
- Focus on maintaining API compatibility where possible
- Dart naming conventions: `snake_case` for files, `camelCase` for methods/fields
- Use null-safety throughout
- Consider async/await patterns (Dart futures vs TypeScript promises)
- RxJS Observables → Dart Streams or RxDart Observables

---

## Progress Tracking

**Overall Progress**: 2/11 phases started

Last updated: 2025-11-09
