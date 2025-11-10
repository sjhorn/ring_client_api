# Differences Between TypeScript and Dart Versions

This document outlines the key differences between the original TypeScript `ring-client-api` and this Dart port. Understanding these differences is important for developers familiar with the TypeScript version or those contributing to this port.

## Language & Platform Differences

### 1. Null Safety

**TypeScript:**
```typescript
interface CameraData {
  battery_life?: string  // Optional
  description: string    // Required
}
```

**Dart:**
```dart
@JsonSerializable()
class CameraData {
  @JsonKey(name: 'battery_life')
  final String? batteryLife;  // Nullable
  final String description;    // Non-nullable

  CameraData({
    this.batteryLife,
    required this.description,
  });
}
```

**Key Differences:**
- Dart enforces null safety at compile time
- All nullable fields must be explicitly marked with `?`
- Accessing nullable fields requires null-checking
- Dart's null safety is stricter than TypeScript's optional chaining

### 2. JSON Serialization

**TypeScript:**
```typescript
// Automatic with TypeScript's structural typing
const data: CameraData = response.json()
```

**Dart:**
```dart
// Requires explicit serialization with json_serializable
@JsonSerializable()
class CameraData {
  // ...
  factory CameraData.fromJson(Map<String, dynamic> json) =>
      _$CameraDataFromJson(json);
  Map<String, dynamic> toJson() => _$CameraDataToJson(this);
}

// Usage
final data = CameraData.fromJson(response.data);
```

**Key Differences:**
- Dart requires code generation for JSON serialization (~300 @JsonKey annotations added)
- Field names must be mapped from snake_case to camelCase explicitly
- Build runner must be run to generate serialization code: `dart run build_runner build`

### 3. Naming Conventions

**TypeScript (camelCase):**
```typescript
class RingCamera {
  getBatteryLevel() { }
  onMotionDetected: Observable<boolean>
}
```

**Dart (camelCase for methods, lowerCamelCase for fields):**
```dart
class RingCamera {
  Future<double?> getBatteryLevel() { }
  Stream<bool> get onMotionDetected => ...
}
```

**Field Name Mapping:**
- `battery_life` (API) → `batteryLife` (Dart)
- `device_id` (API) → `deviceId` (Dart)
- All snake_case API fields converted to camelCase

### 4. Async/Await Patterns

**TypeScript:**
```typescript
async function getAuth(): Promise<AuthToken> {
  const response = await fetch(url)
  return response.json()
}
```

**Dart:**
```dart
Future<AuthToken> getAuth() async {
  final response = await client.get(Uri.parse(url));
  return AuthToken.fromJson(jsonDecode(response.body));
}
```

**Key Differences:**
- Dart uses `Future<T>` instead of `Promise<T>`
- Dart requires explicit JSON parsing
- Error handling uses try/catch (similar to TypeScript)

### 5. Streams vs Observables

**TypeScript (RxJS):**
```typescript
import { Observable, Subject } from 'rxjs'

class RingCamera {
  onData = new Subject<CameraData>()

  getData(): Observable<CameraData> {
    return this.onData.asObservable()
  }
}
```

**Dart (RxDart):**
```dart
import 'package:rxdart/rxdart.dart';

class RingCamera {
  final onData = BehaviorSubject<CameraData>();

  Stream<CameraData> get dataStream => onData.stream;
}
```

**Key Differences:**
- Dart uses `Stream<T>` instead of `Observable<T>`
- RxDart provides similar operators to RxJS
- Dart has both `Stream` (built-in) and RxDart's enhanced streams
- Subscription management is similar but uses different APIs

## Architectural Differences

### 6. Module System

**TypeScript (ES Modules):**
```typescript
export { RingApi } from './api'
export { RingCamera } from './ring-camera'
export * from './ring-types'
```

**Dart (Package/Library System):**
```dart
// In lib/ring_client_api.dart
library ring_client_api;

export 'src/api.dart';
export 'src/ring_camera.dart';
export 'src/ring_types.dart';
```

**Key Differences:**
- Dart uses library directives
- Private members use `_` prefix instead of not being exported
- Package imports use `package:` prefix

### 7. Dependency Injection

**TypeScript:**
```typescript
class RingRestClient {
  constructor(authOptions: AuthOptions) {
    // Can use any Node.js HTTP library
  }
}
```

**Dart:**
```dart
class RingRestClient {
  final http.Client? _httpClient;

  RingRestClient(
    AuthOptions authOptions,
    {http.Client? httpClient}  // Injectable for testing
  ) : _httpClient = httpClient;
}
```

**Key Differences:**
- Dart version adds explicit HTTP client injection for testing
- Enables better mock testing with MockClient
- TypeScript version relies on module mocking

### 8. Constructor Patterns

**TypeScript:**
```typescript
class RingCamera {
  constructor(
    public id: number,
    private restClient: RingRestClient,
    data: CameraData
  ) {
    this.setupStreams()
  }
}
```

**Dart:**
```dart
class RingCamera extends Subscribed {
  final int id;
  final RingRestClient _restClient;
  final BehaviorSubject<CameraData> onData;

  RingCamera({
    required this.id,
    required RingRestClient restClient,
    required CameraData initialData,
  }) : _restClient = restClient,
       onData = BehaviorSubject<CameraData>.seeded(initialData) {
    _setupStreams();
  }
}
```

**Key Differences:**
- Dart requires named parameters (`required` keyword)
- Initializer lists (`:`) used for field initialization
- Private fields use `_` prefix
- No `public` keyword (everything is public by default unless prefixed with `_`)

## WebRTC & Streaming Differences

### 9. WebRTC Implementation

**TypeScript (werift):**
```typescript
import { RTCPeerConnection } from 'werift'

class WeriftPeerConnection {
  private pc = new RTCPeerConnection({
    codecs: { /* ... */ },
    iceServers: ringIceServers.map(server => ({ urls: server }))
  })
}
```

**Dart (Stub Implementation):**
```dart
// Core package: Interface only
abstract class BasicPeerConnection {
  Future<SessionDescription> createOffer();
  Future<void> acceptAnswer(SessionDescription answer);
  Stream<RTCIceCandidate> get onIceCandidate;
}

// Flutter package: Actual implementation using flutter_webrtc
class FlutterPeerConnection implements BasicPeerConnection {
  // Uses flutter_webrtc package
}
```

**Key Differences:**
- **TypeScript**: Uses `werift` - pure JavaScript WebRTC
- **Dart Core**: Provides interface stubs and SimpleWebRtcSession (REST-based)
- **Dart Flutter**: Full implementation in separate `ring_client_api_flutter` package
- **Dart CLI**: Not feasible without pure Dart WebRTC (pure_dart_webrtc is incomplete)

### 10. FFmpeg Integration

**TypeScript:**
```typescript
import { FfmpegProcess } from '@homebridge/camera-utils'

class StreamingSession {
  async startTranscoding(options: FfmpegOptions) {
    const ff = new FfmpegProcess({
      ffmpegPath: getFfmpegPath(),
      ffmpegArgs: [/* ... */]
    })
  }
}
```

**Dart:**
```dart
// Not implemented in core package
// Would require platform-specific FFI or process spawning

class StreamingSession {
  Future<void> startTranscoding(FfmpegOptions options) async {
    throw UnimplementedError(
      'Transcoding requires platform-specific implementation'
    );
  }
}
```

**Key Differences:**
- TypeScript has access to Node.js process spawning for FFmpeg
- Dart would need `Process.start()` from `dart:io` or FFI bindings
- Dart version documents this as unimplemented in core package
- Flutter package could use platform channels for native media handling

## Testing Differences

### 11. Mocking Strategies

**TypeScript (Jest):**
```typescript
jest.mock('./rest-client')

test('authenticates correctly', async () => {
  const mockClient = new RingRestClient(auth)
  mockClient.getCurrentAuth = jest.fn().mockResolvedValue(mockAuth)
})
```

**Dart (Mockito):**
```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  test('authenticates correctly', () async {
    final mockClient = MockClient();
    when(mockClient.get(any)).thenAnswer((_) async =>
      http.Response(jsonEncode(mockAuth), 200));
  });
}
```

**Key Differences:**
- Dart uses code generation for mocks: `@GenerateMocks`
- Mockito annotations instead of jest.mock()
- Requires build_runner to generate mock classes
- More explicit mock setup in Dart

### 12. Test Structure

**TypeScript (Jest):**
```typescript
describe('RingCamera', () => {
  let camera: RingCamera

  beforeEach(() => {
    camera = new RingCamera(/* ... */)
  })

  it('should calculate battery level', () => {
    expect(camera.batteryLevel).toBe(85)
  })
})
```

**Dart (package:test):**
```dart
void main() {
  group('RingCamera', () {
    late RingCamera camera;

    setUp(() {
      camera = RingCamera(/* ... */);
    });

    test('should calculate battery level', () {
      expect(camera.batteryLevel, equals(85));
    });
  });
}
```

**Key Differences:**
- `describe` → `group`
- `it` → `test`
- `beforeEach` → `setUp`
- Different matcher syntax (`equals` instead of `toBe`)

## CLI Tools Differences

### 13. Command-Line I/O

**TypeScript (Node.js):**
```typescript
import { createInterface } from 'readline'

async function requestInput(question: string): Promise<string> {
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  })

  return new Promise(resolve => {
    rl.question(question, answer => {
      rl.close()
      resolve(answer)
    })
  })
}
```

**Dart:**
```dart
import 'dart:io';

Future<String> requestInput(String question) async {
  stdout.write(question);
  return stdin.readLineSync() ?? '';
}
```

**Key Differences:**
- Dart has simpler built-in stdin/stdout
- No need for readline-style interface
- Dart's `dart:io` is more straightforward for CLI tools

## Package Structure Differences

### 14. Directory Layout

**TypeScript:**
```
ring-client-api/
├── src/
│   ├── api.ts
│   ├── ring-camera.ts
│   └── streaming/
├── examples/
├── test/
└── package.json
```

**Dart:**
```
ring_client_api/
├── lib/
│   ├── ring_client_api.dart  # Public API
│   └── src/                   # Implementation
│       ├── api.dart
│       ├── ring_camera.dart
│       └── streaming/
├── example/
├── test/
├── bin/                       # CLI tools
└── pubspec.yaml
```

**Key Differences:**
- `lib/` instead of `src/` at root level
- `lib/src/` for private implementation
- `lib/<package_name>.dart` as main export file
- `bin/` directory for executables
- `pubspec.yaml` instead of `package.json`

## Feature Availability Matrix

| Feature | TypeScript | Dart Core | Dart Flutter |
|---------|-----------|-----------|--------------|
| **REST API** | ✅ | ✅ | ✅ |
| **WebSocket Events** | ✅ | ✅ | ✅ |
| **Device Control** | ✅ | ✅ | ✅ |
| **Snapshots** | ✅ | ✅ | ✅ |
| **Event History** | ✅ | ✅ | ✅ |
| **Simple Streaming** | ✅ | ✅ (REST-only) | ✅ |
| **WebRTC P2P** | ✅ (werift) | ❌ (stubs) | ✅ (flutter_webrtc) |
| **Video Display** | ✅ (FFmpeg) | ❌ | ✅ (Widgets) |
| **Two-way Audio** | ✅ | ❌ | ✅ |
| **CLI Tools** | ✅ | ✅ | N/A |
| **Web Support** | ✅ (Browser) | ⚠️ (Limited) | ✅ |
| **Mobile Support** | ❌ | ✅ (API only) | ✅ (Full) |
| **Desktop Support** | ✅ (Node.js) | ✅ (API only) | ✅ (Full) |

## Migration Guide (TypeScript → Dart)

### For TypeScript Developers Using This Port:

1. **Import Changes:**
   ```typescript
   // TypeScript
   import { RingApi } from 'ring-client-api'
   ```
   ```dart
   // Dart
   import 'package:ring_client_api/ring_client_api.dart';
   ```

2. **Async/Await:**
   - Nearly identical, but use `Future` instead of `Promise`
   - Use `await` the same way

3. **Streams:**
   - Subscribe to Dart `Stream<T>` instead of RxJS `Observable<T>`
   - Use `.listen()` instead of `.subscribe()`

4. **Error Handling:**
   - Use try/catch blocks (same as TypeScript)
   - Dart has stronger typing for exceptions

5. **WebRTC Streaming:**
   - Use `ring_client_api_flutter` package for Flutter apps
   - Core package provides REST-based SimpleWebRtcSession

### Code Comparison Example:

**TypeScript:**
```typescript
import { RingApi } from 'ring-client-api'

async function main() {
  const ringApi = new RingApi({
    refreshToken: process.env.RING_REFRESH_TOKEN!
  })

  const locations = await ringApi.getLocations()
  const cameras = await ringApi.getCameras()

  cameras[0].onMotionDetected.subscribe(detected => {
    console.log('Motion:', detected)
  })
}
```

**Dart:**
```dart
import 'package:ring_client_api/ring_client_api.dart';

Future<void> main() async {
  final ringApi = RingApi(
    RefreshTokenAuth(
      refreshToken: Platform.environment['RING_REFRESH_TOKEN']!,
    ),
  );

  final locations = await ringApi.getLocations();
  final cameras = await ringApi.getCameras();

  cameras[0].onMotionDetected.listen((detected) {
    print('Motion: $detected');
  });

  // Cleanup
  await ringApi.disconnect();
}
```

## Summary of Port Decisions

### What Changed and Why:

1. **JSON Serialization**: Added explicit code generation for type safety
2. **HTTP Client**: Made injectable for better testing
3. **Null Safety**: Embraced Dart's stricter null safety
4. **WebRTC**: Split into core (stubs) and flutter (implementation) packages
5. **Naming**: Followed Dart conventions (camelCase, underscores for private)
6. **Testing**: Used Dart's test package and mockito
7. **Logging**: Used Dart's logging patterns
8. **CLI**: Leveraged Dart's simpler I/O libraries

### What Stayed the Same:

1. **API Structure**: Same classes, methods, and workflows
2. **Authentication**: Identical flow (refresh tokens, 2FA)
3. **WebSocket Logic**: Same event handling patterns
4. **Device Control**: Same capabilities and commands
5. **Snapshot Retrieval**: Identical implementation
6. **Battery Calculations**: Same algorithms

## Contributing Notes

### For Contributors Familiar with TypeScript Version:

- **Read TypeScript code first**: The TypeScript version is the reference
- **Check this document**: Understand the porting decisions
- **Follow Dart conventions**: Use Dart idioms, not literal TypeScript translations
- **Test thoroughly**: Dart's type system catches different issues
- **Document differences**: Update this file when making porting decisions

### For Dart-First Contributors:

- **Review TypeScript version**: Understand the original design intent
- **Maintain API compatibility**: Keep similar method names and signatures
- **Test against Ring API**: Use real Ring devices when possible
- **Document Dart idioms**: Help TypeScript developers understand Dart patterns

## Version Correspondence

| TypeScript Version | Dart Port Version | Status |
|-------------------|-------------------|--------|
| v13.x | 0.1.0 | Core API complete, WebRTC stubs |
| v13.x | 0.2.0 (planned) | + flutter_webrtc integration |
| v13.x | 0.3.0 (planned) | + dart_webrtc for web |

## Questions or Issues?

If you notice discrepancies between the TypeScript and Dart versions not documented here:

1. Check if it's intentional (Dart idiom vs TypeScript pattern)
2. Open an issue on GitHub with:
   - TypeScript code reference
   - Current Dart implementation
   - Expected behavior
   - Your proposed fix

## Resources

- **TypeScript Original**: https://github.com/dgreif/ring
- **Dart Port**: https://github.com/sjhorn/ring_client_api
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Flutter WebRTC**: https://github.com/flutter-webrtc
- **RxDart**: https://pub.dev/packages/rxdart
