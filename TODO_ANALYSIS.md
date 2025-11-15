# TODO Comment Analysis - Pre-Publishing Review

## Summary
Found 12 TODO comments across the codebase. Analysis categorized into:
- ✅ **Documented & Acceptable** (8) - TODOs that are intentionally not implemented
- ⚠️ **Stale/Misleading** (3) - TODOs that reference already-implemented features
- 🗑️ **Boilerplate** (1) - Leftover from project template

---

## ✅ Documented & Acceptable TODOs (Keep As Documentation)

These TODOs document features intentionally NOT implemented in this core package:

### 1. FFmpeg Integration (api.dart:165)
```dart
// TODO: setFfmpegPath(options.ffmpegPath) when ffmpeg module is ported
```
**Status**: Acceptable - FFmpeg is platform-specific, documented in TYPESCRIPT_DIFFERENCES.md
**Action**: Keep as documentation

### 2. Push Notifications (api.dart:398, 415)
```dart
/// TODO: Implement push notification receiver using Firebase Cloud Messaging.
// TODO: Implement push notification receiver
```
**Status**: Acceptable - FCM integration is a future feature, well-documented
**Action**: Keep with clear documentation that this is a future enhancement

### 3. WebRTC Streaming (ring_camera.dart:161, 174, 189)
```dart
// TODO: WebRTC streaming classes - not implemented in this package
/// Streaming session (placeholder - TODO: implement when streaming module is ported)
/// Simple WebRTC session (placeholder - TODO: implement when streaming module is ported)
```
**Status**: Acceptable - WebRTC is in companion `ring_camera` package
**Action**: Keep but clarify that streaming is in the Flutter package

---

## ⚠️ Stale/Misleading TODOs (MUST FIX)

These TODOs reference features that ARE already implemented:

### 4. Location Class References (ring_device.dart:12, 43, 63, 68, 131)
```dart
// TODO: Import Location class when location.dart is ported
location; // TODO: Change to Location type when location.dart is available
// TODO: Implement when Location class is available (appears 3x)
```

**Status**: STALE - location.dart EXISTS (30KB, fully ported!)
**Problem**:
- Location class IS imported and used in location.dart
- RingDevice is used extensively by Location
- The TODOs imply work is pending but it's complete

**Action Required**:
1. Check if RingDevice needs circular import fix
2. Either implement the commented-out functionality OR
3. Remove TODOs and document why functionality is simplified

---

## 🗑️ Boilerplate TODOs (Remove)

### 5. Template Boilerplate (ring_client_api_base.dart:1)
```dart
// TODO: Put public facing types in this file.
```
**Status**: Leftover from `dart create` template
**Problem**: This file only contains the template "Awesome" class
**Action**: Delete this file entirely - it serves no purpose

---

## Detailed Analysis: ring_device.dart Issues

The ring_device.dart file has **circular dependency concerns**:

### Current State:
- ✅ `location.dart` imports `ring_device.dart`
- ❌ `ring_device.dart` has commented-out import of `location.dart`
- ❌ RingDevice uses `dynamic location` instead of proper type

### Why This Happened:
Circular import issue: Location needs RingDevice, RingDevice needs Location

### Commented-Out Functionality:
```dart
// TODO: Implement when Location class is available
// This should filter devices from location.onDevices where parentZid == this.id
onComponentDevices = const Stream.empty();

// TODO: Implement when Location class is available
// addSubscription(
//   location.onDeviceDataUpdate
//       .where((update) => update.zid == zid)
//       .listen((update) => updateData(update)),
// );
```

### Options to Fix:

**Option A: Keep Simplified (Recommended for v0.1.0)**
1. Remove all TODOs
2. Add clear documentation explaining the simplified implementation
3. Note that full RingDevice functionality requires Location reference
4. Document this as a known limitation for v0.1.0

**Option B: Implement Full Functionality**
1. Create interface/abstract base classes to break circular dependency
2. Implement the onComponentDevices stream properly
3. Wire up device data updates from location
4. More complex, delays publishing

---

## Recommendations for v0.1.0 Publishing

### High Priority (Must Do Before Publishing):
1. ✅ **Fix ring_client_api_base.dart** - Delete the file or remove boilerplate
2. ✅ **Fix ring_device.dart TODOs** - Either implement OR document as simplified
3. ✅ **Clarify WebRTC TODOs** - Add references to ring_camera package

### Medium Priority (Should Do):
4. **Update TODO.md** - Add section about code TODOs vs project TODOs
5. **Add Known Limitations** - Document RingDevice simplifications in README

### Low Priority (Nice to Have):
6. **Add ROADMAP.md** - Move future features (FCM, full RingDevice) to roadmap

---

## Proposed Changes

### 1. ring_client_api_base.dart
```dart
// DELETE THIS FILE - it's unused boilerplate
```

### 2. ring_device.dart - Update TODOs
```dart
// BEFORE:
// TODO: Import Location class when location.dart is ported
location; // TODO: Change to Location type when location.dart is available

// AFTER:
// Note: Location type not used here to avoid circular imports.
// Location imports RingDevice, so RingDevice uses dynamic for location reference.
final dynamic location;
```

### 3. ring_camera.dart - Clarify Streaming TODOs
```dart
// BEFORE:
// TODO: WebRTC streaming classes - not implemented in this package

// AFTER:
// WebRTC streaming is NOT implemented in this core package.
// For full WebRTC video streaming, use the companion package:
// https://github.com/sjhorn/ring_camera
```

### 4. api.dart - Keep FCM TODO but improve
```dart
// CURRENT: Good - keep as is but maybe move to ROADMAP.md
```

---

## Next Steps

Choose approach for v0.1.0:

**Fast Track (Recommended):**
1. Delete ring_client_api_base.dart
2. Update TODOs in ring_device.dart to explain simplified implementation
3. Clarify WebRTC TODOs to point to Flutter package
4. Add "Known Limitations" section to README
5. Publish v0.1.0

**Full Implementation:**
1. Fix circular dependency with interfaces
2. Implement full RingDevice functionality
3. Add tests for new functionality
4. Delays publishing by several days

**Recommendation**: Fast Track for v0.1.0, full implementation for v0.2.0
