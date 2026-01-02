# Ring Client API - Dart Port

## Project Status

**Current Version**: v0.2.3 | **Published**: https://pub.dev/packages/ring_client_api

| Metric | Value |
|--------|-------|
| Dart Code | ~13,500 lines |
| Source Files | 18 (lib/src/) |
| Tests | 29 (all passing) |
| Examples | 8 |
| CLI Tools | 4 |
| Analyzer Issues | 0 |

---

## Completed Phases

All phases complete. See git history for detailed implementation notes.

| Phase | Description | Key Files |
|-------|-------------|-----------|
| 1 | Project Setup | pubspec.yaml, .gitignore |
| 2 | Core Types | ring_types.dart (~1500 lines, ~300 @JsonKey) |
| 3 | API Client | rest_client.dart, refresh_token.dart |
| 4 | Device Models | ring_camera.dart, ring_device.dart, ring_chime.dart |
| 5 | Location & API | location.dart, api.dart |
| 6 | WebRTC Streaming | streaming/*.dart (webrtc_dart, FFmpeg) |
| 7 | Testing | 29 tests (unit + integration) |
| 8 | Examples | 8 examples (full parity with dgrief) |
| 9 | CLI Tools | ring_auth_cli, list_cameras, stream_camera |
| 10 | Documentation | README, CHANGELOG, TYPESCRIPT_DIFFERENCES |
| 11 | Publishing | v0.1.0, v0.1.1, v0.2.0, v0.2.1, v0.2.2, v0.2.3 on pub.dev |

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| 0.2.3 | 2026-01-02 | W3C API migration, webrtc_dart 0.23.1 |
| 0.2.2 | 2026-01-02 | webrtc_dart 0.22.13, RTP improvements |
| 0.2.1 | 2025-12-31 | Return audio fix, webrtc_dart 0.22.10 |
| 0.2.0 | 2025-12-06 | Full WebRTC streaming, two-way audio, FFmpeg |
| 0.1.1 | 2025-11-16 | Documentation fixes, list_cameras CLI |
| 0.1.0 | 2025-11-15 | Initial release |

---

## Documentation

- **[README.md](README.md)** - Setup guide and API usage
- **[CHANGELOG.md](CHANGELOG.md)** - Version history
- **[TYPESCRIPT_DIFFERENCES.md](TYPESCRIPT_DIFFERENCES.md)** - Feature parity and migration guide
- **[CLAUDE.md](CLAUDE.md)** - AI agent instructions

---

## Example Testing

Automated tests for all examples using Playwright (Chrome) and Dart.

Playwright config is in `test/examples/` to keep the package root clean.

### Running Tests

```bash
# Set credentials
export RING_REFRESH_TOKEN="your_token"

# Run all tests
./test/examples/test_examples.sh

# Run only Dart example tests (no browser)
./test/examples/test_examples.sh --no-browser

# Run only browser tests
./test/examples/test_examples.sh --browser

# Run specific example test
./test/examples/test_examples.sh record
```

### Test Structure

| Test | Type | Validates |
|------|------|-----------|
| api_example | Dart | Location/camera API calls |
| record_example | Dart | Video file creation |
| stream_example | Dart | Segmented streaming start |
| ring_client_api_example | Dart | Main example flow |
| camera_comparison | Dart | Camera listing |
| chime_example | Dart | Chime operations (skips if no chime) |
| return_audio_example | Dart | Two-way audio setup |
| browser_example | Playwright | HLS stream + web UI |

### Requirements

- FFmpeg (for streaming/recording tests)
- Node.js (for Playwright browser tests)
- Valid Ring credentials

---

## Future (v0.3.0+)

- [ ] Performance optimizations
- [ ] Additional device type support
- [ ] Community feedback integration

---

## File-by-File Review vs dgrief

### Core Library Files

| Dart File | TypeScript File | Status | Notes |
|-----------|-----------------|--------|-------|
| lib/src/api.dart | api.ts | [x] Done | Added externalPorts option |
| lib/src/rest_client.dart | rest-client.ts | [x] Done | Cleaned debug prints |
| lib/src/ring_camera.dart | ring-camera.ts | [x] Done | Match |
| lib/src/ring_chime.dart | ring-chime.ts | [x] Done | Match |
| lib/src/ring_device.dart | ring-device.ts | [x] Done | Match |
| lib/src/ring_intercom.dart | ring-intercom.ts | [x] Done | Match |
| lib/src/location.dart | location.ts | [x] Done | Match |
| lib/src/ring_types.dart | ring-types.ts | [x] Done | Larger due to explicit classes |
| lib/src/util.dart | util.ts | [x] Done | Match |
| lib/src/refresh_token.dart | refresh-token.ts | [x] Done | Match |
| lib/src/device_data.dart | device-data.ts | [x] Done | Match |
| lib/src/subscribed.dart | subscribed.ts | [x] Done | Match |

### Streaming Files

| Dart File | TypeScript File | Status | Notes |
|-----------|-----------------|--------|-------|
| lib/src/streaming/peer_connection.dart | streaming/peer-connection.ts | [x] Done | Match (same ICE, H264, PLI) |
| lib/src/streaming/webrtc_connection.dart | streaming/webrtc-connection.ts | [x] Done | Match (same signaling) |
| lib/src/streaming/streaming_session.dart | streaming/streaming-session.ts | [x] Done | Updated to parse Ring SDP |
| lib/src/streaming/simple_webrtc_session.dart | streaming/simple-webrtc-session.ts | [x] Done | Match |
| lib/src/streaming/streaming_messages.dart | streaming/streaming-messages.ts | [x] Done | Extended with typed classes |

### Examples (Priority Focus)

| Dart File | TypeScript File | Status | Notes |
|-----------|-----------------|--------|-------|
| example/ring_client_api_example.dart | example.ts | [x] Done | Enhanced with snapshots, events |
| example/chime_example.dart | chime-example.ts | [x] Done | Full feature parity |
| example/return_audio_example.dart | return-audio-example.ts | [x] Done | Enhanced with FFmpeg check |
| example/camera_comparison.dart | - | [x] Done | Dart-only debugging util |
| example/record_example.dart | record-example.ts | [x] Ported | Uses recordToFile() |
| example/stream_example.dart | stream-example.ts | [x] Ported | Segmented streaming |
| example/api_example.dart | api-example.ts | [x] Ported | Location/camera APIs |
| example/browser_example.dart | browser-example.ts | [x] Ported | HLS stream + web server |

### Tests

| Dart File | TypeScript File | Status | Notes |
|-----------|-----------------|--------|-------|
| test/rest_client_test.dart | test/rest-client.spec.ts | [x] Done | Match (same test cases) |
| test/ring_camera_test.dart | test/ring-camera.spec.ts | [x] Done | Match (same tests) |
| test/ring_device_test.dart | - | [x] Done | Dart-only |
| test/integration_test.dart | - | [x] Done | Dart-only |

### CLI Tools

| Dart File | TypeScript File | Status | Notes |
|-----------|-----------------|--------|-------|
| bin/ring_auth_cli.dart | ring-auth-cli.ts | [x] Done | Match |
| bin/ring_device_data_cli.dart | ring-device-data-cli.ts | [x] Done | Match (inline vs import) |
| bin/list_cameras.dart | - | [x] Done | Dart-only |
| bin/stream_camera.dart | - | [x] Done | Dart-only |

---

*Last updated: 2025-12-31*
