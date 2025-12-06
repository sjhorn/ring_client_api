# Ring Client API - Dart Port TODO

## Project Overview
This is a port of the TypeScript ring-client-api to Dart. The original project is located in `./ring/packages/ring-client-api/`.

**Source Stats (TypeScript Original):**
- ~6000 lines of TypeScript code
- 25 TypeScript files
- 8 example files
- 2 test files
- 2 CLI tools

**Port Stats (Dart):**
- ~13,500 lines of Dart code
- 18 core source files (lib/src/ including streaming/)
- 4 test files with 29 tests (all passing)
- 3 example files
- 4 CLI tools (including stream_camera.dart)
- Full RingDevice implementation with Location integration
- Full WebRTC streaming using webrtc_dart (pure Dart port of werift)
- Zero analyzer issues

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

- [x] Port `ring-device.ts` → `lib/src/ring_device.dart` (~178 lines)
  - [x] Full implementation with Location integration (no circular dependency issues)
  - [x] Implemented onComponentDevices stream for child devices
  - [x] Wired up device data updates from location
  - [x] Implemented setInfo method for device commands
  - [x] Volume control and device command support
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

**Full WebRTC streaming is now implemented** in this package using `webrtc_dart` (a pure Dart port of werift).

### Core Package (Pure Dart) - FULLY IMPLEMENTED
- [x] Port `streaming/streaming-messages.ts` → `lib/src/streaming/streaming_messages.dart` (~86 lines)
  - Full implementation with JSON serialization
- [x] Port `streaming/simple-webrtc-session.ts` → `lib/src/streaming/simple_webrtc_session.dart` (~55 lines)
  - **Fully functional** - REST-based simple streaming
- [x] Port `streaming/peer-connection.ts` → `lib/src/streaming/peer_connection.dart` (~300 lines)
  - **Fully implemented** using webrtc_dart (pure Dart port of werift)
  - WebRTCPeerConnection wraps RtcPeerConnection
  - ICE candidate handling, SDP offers/answers
  - Audio transceiver (sendrecv) for two-way audio
  - Video transceiver (recvonly) for receiving video
- [x] Port `streaming/webrtc-connection.ts` → `lib/src/streaming/webrtc_connection.dart` (~400 lines)
  - **Fully implemented** - WebSocket signaling to Ring servers
  - Connects to `wss://api.prod.signalling.ring.devices.a2z.com`
  - SDP/ICE exchange, session lifecycle management
  - 5-second ping for Ring Edge connections
- [x] Port `streaming/streaming-session.ts` → `lib/src/streaming/streaming_session.dart` (~440 lines)
  - **Fully implemented** - FFmpeg transcoding via dart:io Process
  - RtpSplitter for UDP packet forwarding
  - startTranscoding() for video recording
  - transcodeReturnAudio() for two-way audio

### CLI Tools
- [x] Create `bin/stream_camera.dart` - Record video from Ring camera
  - Uses WebRTC connection and FFmpeg transcoding
  - Command: `dart run bin/stream_camera.dart 30 recording.mp4`

### Documentation
- [x] Create `WEBRTC_OPTIONS.md` (~400+ lines)
- [x] Create `TYPESCRIPT_DIFFERENCES.md` (~500+ lines)

**WebRTC Implementation:**

This package now includes **full WebRTC streaming** using:
- `webrtc_dart` - Pure Dart port of werift (located at `../webrtc_dart`)
- FFmpeg - Spawned as subprocess via `dart:io` Process (no native libraries)

**What Works:**
- Full WebRTC peer connections (pure Dart)
- WebSocket signaling to Ring servers
- SDP offer/answer exchange
- ICE candidate handling
- RTP packet forwarding
- FFmpeg transcoding to MP4/other formats
- Two-way audio support
- Video recording from cameras

**Requirements:**
- FFmpeg must be installed and in PATH for transcoding
- webrtc_dart package (path dependency to ../webrtc_dart)

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
- [x] Port RingDevice unit tests (~160 lines)
  - [x] Device properties and data updates
  - [x] Volume control validation
  - [x] Resource cleanup
- [x] Verify all tests pass
  - **✅ All 29 tests passing! (17 unit + 12 integration)**

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
- [x] Stream/record example → `bin/stream_camera.dart` ✅ (CLI tool for recording)
- [x] Port `return-audio-example.ts` → `example/return_audio_example.dart` ✅ (two-way audio demo)
- [ ] Create browser example equivalent (if applicable)

**Note**: WebRTC streaming is now fully implemented using webrtc_dart. The `bin/stream_camera.dart` CLI tool demonstrates recording video from cameras.

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
- [x] Create `bin/list_cameras.dart`
  - Lists all cameras with names and IDs
  - Fully functional
- [x] Create `bin/stream_camera.dart`
  - Records video from Ring camera using WebRTC
  - Uses webrtc_dart for peer connection
  - Uses FFmpeg for transcoding
  - Command: `dart run bin/stream_camera.dart 30 recording.mp4`

---

## Phase 10: Documentation and Polish ✅ COMPLETE

- [x] Update CHANGELOG.md with version 0.1.0
  - Comprehensive release notes with all features
  - Testing summary
  - Migration guide from TypeScript
  - Known limitations documented
- [x] Run `dart format .`
  - All code follows Dart style guidelines
- [x] Run `dart analyze` and fix all issues
  - **Zero analyzer issues!**
- [x] Clean up all TODO comments in source code
  - Removed all stale TODOs from core files
  - Documented future features (WebRTC, FFmpeg, FCM) clearly
- [x] Delete unused boilerplate files
  - Removed ring_client_api_base.dart
- [x] Ensure all examples run successfully
  - Main example works with live Ring API
  - Camera comparison example functional
  - Chime example functional
  - All examples properly demonstrate API usage
- [x] Update README with Dart-specific usage examples
  - Updated API initialization code
  - Added refresh token event handling example
  - Proper Dart syntax and conventions

---

## Phase 11: Publishing ✅ COMPLETE

- [x] Run `dart pub publish --dry-run`
  - **✅ Zero warnings, zero errors!**
  - Package size: 111 KB (v0.1.1)
  - All validations passed
- [x] Address any pub.dev publishing warnings
  - No warnings to address
- [x] Verify all tests pass
  - 29/29 tests passing
- [x] Verify analyzer
  - Zero issues found
- [x] Publish to pub.dev
  - **✅ Published v0.1.0 successfully!** (2025-11-15)
  - **✅ Published v0.1.1 successfully!** (2025-11-16)
  - Available at https://pub.dev/packages/ring_client_api
- [x] Create git tags (v0.1.0, v0.1.1)
- [ ] Push to GitHub

**Published!** 🎉

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

**Overall Progress**: 11/11 phases complete 🎉

- Phase 1: Project Setup ✅
- Phase 2: Core Types and Utilities ✅
- Phase 3: Core API Client ✅
- Phase 4: Device Models ✅
- Phase 5: Location and Main API ✅
- Phase 6: Streaming (WebRTC) ✅
- Phase 7: Testing ✅
- Phase 8: Examples ✅
- Phase 9: CLI Tools ✅
- Phase 10: Documentation and Polish ✅
- Phase 11: Publishing ✅

**Last updated**: 2025-12-06

---

## 🎯 Project Status: v0.2.0 Ready

### ✅ All Phases Complete (1-11)
- Project setup, core types, API client, device models, location management
- **Full WebRTC streaming implementation using webrtc_dart (pure Dart)**
- FFmpeg transcoding via dart:io Process
- Two-way audio support
- Comprehensive testing suite with 29 tests
- Working examples and CLI tools
- Complete documentation and polish

### 📦 Package Status
- **Package**: https://pub.dev/packages/ring_client_api
- **Version**: 0.2.0 (latest)
- **Previous**: v0.1.1

### Version History
- **v0.2.0** (2025-12-06) - Full WebRTC streaming, two-way audio, FFmpeg transcoding
- **v0.1.1** (2025-11-16) - Documentation fixes, new CLI tool, release process
- **v0.1.0** (2025-11-15) - Initial release

---

## Code Quality Review ✅ COMPLETE

### TODO Comment Analysis (Pre-Publishing)

Conducted comprehensive review of all TODO comments in source code before publishing. Found 12 TODO comments:

**✅ Documented & Acceptable (8)** - Intentional exclusions:
- FFmpeg Integration - Now implemented via dart:io Process
- Push Notifications (api.dart) - Platform-specific, stub with documentation
- WebRTC Streaming - Now fully implemented using webrtc_dart

**✅ Stale TODOs - RESOLVED (4)**:
- RingDevice circular dependency issues - **FIXED** by implementing full functionality
- Location class references - **IMPLEMENTED** with proper Location integration
- onComponentDevices stream - **IMPLEMENTED** with device parent/child relationships
- Device data updates - **IMPLEMENTED** with WebSocket integration

**✅ Boilerplate - REMOVED (1)**:
- ring_client_api_base.dart template file - **DELETED**

### Resolution Actions Taken:
1. ✅ **Option B: Full Implementation** - Chose to implement complete RingDevice functionality
2. ✅ Resolved circular dependency (RingDevice ↔ Location)
3. ✅ Implemented onComponentDevices stream
4. ✅ Wired up device data updates from location
5. ✅ Implemented setInfo method for device commands
6. ✅ Added 4 RingDevice unit tests
7. ✅ Implemented full WebRTC streaming using webrtc_dart
8. ✅ Created GAP_ANALYSIS.md documenting 100% feature parity

---

## Documentation Files

This project includes comprehensive documentation:

- **[README.md](README.md)** - Main package documentation, setup guide, and API usage examples
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes for v0.1.0
- **[TODO.md](TODO.md)** - This file - complete project implementation checklist and progress tracking
- **[TYPESCRIPT_DIFFERENCES.md](TYPESCRIPT_DIFFERENCES.md)** - Detailed guide to differences between TypeScript original and Dart port
- **[GAP_ANALYSIS.md](GAP_ANALYSIS.md)** - Comprehensive comparison of TypeScript vs Dart implementation showing 100% REST API coverage
- **[AGENTS.md](AGENTS.md)** - Development workflow and agent instructions for AI-assisted development
- **[CLAUDE.md](CLAUDE.md)** - Project-specific Claude Code configuration

---

## v0.2.0 Complete ✅

- [x] Full WebRTC streaming implementation using webrtc_dart
- [x] FFmpeg transcoding via dart:io Process
- [x] stream_camera.dart CLI tool
- [x] Two-way audio example (return_audio_example.dart)

## Next Steps for v0.3.0 (Future)

- [ ] Performance optimizations
- [ ] Additional device type support
- [ ] Community feedback integration
