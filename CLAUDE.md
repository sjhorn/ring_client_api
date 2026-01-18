# AGENTS.md

## 1. Project Setup

## Project Overview
This repository is for the Dart package **`ring_client_api`**.
This is a port of the ring-client-api available as reference only in ./ring/packages/ring-client-api we will refer to as dgrief port. Keep this in `.gitignore` - it's for reference only, not committed.

### Directory Structure
Mirror the TypeScript source structure where possible:
| TypeScript | Dart |
|------------|------|
| `ring/packages/ring-client-api/` | `lib/src/` |
| `ring/packages/ring-client-api/tests/` | `test/` |
| `ring/packages/examples/` | `example/` |

### Initial Documentation Files

The TODO.md will maintain our progress along with our git log history, and add a git commit and message for each step we take on this porting journey including refactoring and debugging. We should not duplicate in TODO.md what we have in our git history, just keep a concise summary. 

For typescript types and json mapping be sure to address the snake_case to camelCase. The quirks have been documented in TYPESCRIPT_DIFFERENCES.md that we will keep up to date as we progress. Also we aim to use ./ring for the source code rather than web calls to github.com.

Let's aim to avoid using the word comprehensive in our commits, documentation and tests. 

---

## 2. Porting Philosophy

### Core Principles

1. **Structure Matching**
   - Mimic directory structure, filenames, classnames of TypeScript source
   - Follow Dart conventions (snake_case files, UpperCamelCase classes)
   - Example: `peerConnection.ts` → `peer_connection.dart`

2. **Behavior Matching**
   - Match input/output behavior exactly
   - Create test scripts to capture TypeScript outputs for given inputs
   - Use captured outputs as golden test cases in Dart

3. **Language-Idiomatic Adaptations**

   | TypeScript | Dart |
   |------------|------|
   | Promises | Futures + async/await |
   | Custom Event class | Stream-based events |
   | `Buffer` | `Uint8List` + `ByteData.view` |
   | `null ?? default` | `??` operator (same) |
   | Interface | Abstract class / mixin |

4. **Crypto Handling**
   - Replicate TypeScript approach where directly implemented
   - Use `package:cryptography` where TypeScript uses crypto libraries
   - Validate against RFC test vectors

---

## 3. Testing Strategy

### Unit Tests
- Use descriptive test names
- Follow arrange/act/assert pattern
- Golden tests for binary serialization (encode/decode round-trips)
- Validate crypto against RFC test vectors

### Capturing TypeScript Outputs
```javascript
// create_test_vectors.js - Run in Node.js with TypeScript source
const { SomeClass } = require('./dist/some-class');
const input = Buffer.from([0x01, 0x02, 0x03]);
const result = SomeClass.process(input);
console.log(JSON.stringify({
  input: Array.from(input),
  output: Array.from(result),
}));
```

Then use in Dart tests:
```dart
test('SomeClass.process matches TypeScript', () {
  final input = Uint8List.fromList([0x01, 0x02, 0x03]);
  final result = SomeClass.process(input);
  expect(result, equals(Uint8List.fromList([/* captured output */])));
});
```
---
## 4. Example Verification

### TODO.md Structure

Track each example's verification status:

```markdown
| Example | Status | Method | Notes |
|---------|--------|--------|-------|
| `datachannel/offer.dart` | [x] | Playwright | Chrome/Firefox/Safari pass |
| `media/sendonly.dart` | [~] | Manual | In progress |
| `media/complex.dart` | [ ] | - | Not started |
```

### Verification Methods
- **Dart-to-Dart**: Two Dart processes communicating
- **Playwright**: Automated browser test
- **Manual Browser**: Run server, open browser manually
- **Terminal**: Run with TypeScript counterpart

---
## 5. Common Porting Patterns

### Binary Data Handling

TypeScript `Buffer`:
```typescript
const buf = Buffer.alloc(10);
buf.writeUInt32BE(value, 0);
```

Dart equivalent:
```dart
final data = Uint8List(10);
final view = ByteData.view(data.buffer);
view.setUint32(0, value, Endian.big);
```

### Event Emitters

TypeScript:
```typescript
class Foo extends EventEmitter {
  emit('data', payload);
}
foo.on('data', (payload) => { ... });
```

Dart:
```dart
class Foo {
  final _dataController = StreamController<Payload>.broadcast();
  Stream<Payload> get onData => _dataController.stream;

  void _emitData(Payload payload) => _dataController.add(payload);
}
foo.onData.listen((payload) { ... });
```

### Async Patterns

TypeScript:
```typescript
async function doWork(): Promise<Result> {
  const data = await fetchData();
  return process(data);
}
```

Dart:
```dart
Future<Result> doWork() async {
  final data = await fetchData();
  return process(data);
}
```

### Optional Chaining

TypeScript:
```typescript
const value = obj?.prop?.nested ?? defaultValue;
```

Dart:
```dart
final value = obj?.prop?.nested ?? defaultValue;
```

---
## 6. Build & Publish

### Release Process (Default Standard)

This is the standard process for publishing releases to pub.dev:

**1. Update Dependencies (if applicable)**
```bash
# Update pubspec.yaml with new dependency versions
dart pub get
```

**2. Run Unit Tests**
```bash
dart test
```
All tests must pass before proceeding.

**3. Run Automated Tests**
```bash
# Run Playwright browser tests if applicable
cd test/examples && npm test
```

**4. Format Code**
```bash
dart format .
```
This applies formatting to all files. Do not use `--set-exit-if-changed` during release - apply the formatting.

**5. Run Static Analysis**
```bash
dart analyze
```
Fix any issues before proceeding.

**6. Bump Version in `pubspec.yaml`**
```yaml
version: X.Y.Z  # Update according to semantic versioning
```

**7. Update `CHANGELOG.md`**
Add release notes under a new version heading:
```markdown
## X.Y.Z - YYYY-MM-DD

### Added
- New features

### Changed
- Modified features

### Fixed
- Bug fixes

### Removed
- Deprecated features
```

**8. Update `README.md` (if needed)**
- Update any version references
- Add documentation for new features
- Update examples if API changed

**9. Dry Run Publish**
```bash
dart pub publish --dry-run
```
Verify no warnings before proceeding.

**10. Commit All Changes**
```bash
git add .
git commit -m "Bump version to vX.Y.Z"
```

**11. Publish to pub.dev**
```bash
dart pub publish --force
```

**12. Push to GitHub**
```bash
git push origin master
```

**13. Create and Push Git Tag**
```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z - Brief description

- Change 1
- Change 2

Published to pub.dev: https://pub.dev/packages/ring_client_api"

git push origin vX.Y.Z
```

**14. Create GitHub Release** (Optional)
- Go to https://github.com/sjhorn/ring_client_api/releases
- Create release from tag vX.Y.Z
- Copy CHANGELOG.md content for release notes

### Pre-Release Checklist Summary
Before publishing, ensure:
- [ ] Dependencies updated: `dart pub get`
- [ ] Unit tests pass: `dart test`
- [ ] Automated tests pass (if applicable)
- [ ] Code formatted: `dart format .`
- [ ] No analyzer issues: `dart analyze`
- [ ] Version bumped in `pubspec.yaml`
- [ ] `CHANGELOG.md` updated
- [ ] `README.md` updated (if needed)
- [ ] Dry run succeeds: `dart pub publish --dry-run`

### CLI Tools

This package includes four command-line tools:

**ring_auth_cli.dart** - Obtain refresh tokens via interactive authentication
```bash
dart run bin/ring_auth_cli.dart
```

**ring_device_data_cli.dart** - Fetch and anonymize device data for debugging
```bash
dart run bin/ring_device_data_cli.dart <refresh_token>
```

**list_cameras.dart** - List all cameras with names and IDs
```bash
dart run bin/list_cameras.dart <refresh_token>
```

**stream_camera.dart** - Record video from a Ring camera using WebRTC
```bash
# Requires FFmpeg installed
export RING_REFRESH_TOKEN="your_token"
dart run bin/stream_camera.dart 30 recording.mp4
```

---

## Code Style & Conventions
- Follow the official Dart style guide: https://dart.dev/guides/language/effective-dart/style
- Use **two spaces** for indentation (Dart default)
- Prefer `final` and `const` where possible
- Public API should be documented with Dartdoc comments: `///`
- Private members start with an underscore `_`
- Avoid using `dynamic` unless absolutely necessary
- Use null-safety (`--null-safety` enforced)
- Organize imports:
  1. Dart SDK imports
  2. Third-party package imports
  3. Local package imports
  Each group separated by a blank line.
- Line length: aim for ≤ 80-100 characters for readability, but up to 120 acceptable for long doc comments or URLs.

### Documentation Acronym Standards
- **Expand acronyms on first use** in documentation (README.md, CHANGELOG.md, code comments)
- Format: `ACRONYM (Full Expansion)` - e.g., `PLI (Picture Loss Indication)`
- Common acronyms in this project:
  - API (Application Programming Interface)
  - CLI (Command-Line Interface)
  - 2FA (Two-Factor Authentication)
  - WebRTC (Web Real-Time Communication)
  - RTP (Real-time Transport Protocol)
  - RTCP (Real-time Transport Control Protocol)
  - SDP (Session Description Protocol)
  - ICE (Interactive Connectivity Establishment)
  - STUN (Session Traversal Utilities for NAT)
  - DTLS (Datagram Transport Layer Security)
  - SRTP (Secure Real-time Transport Protocol)
  - PLI (Picture Loss Indication)
  - SSRC (Synchronization Source)
  - IDR (Instantaneous Decoder Refresh)
  - NAL (Network Abstraction Layer)
  - SIP (Session Initiation Protocol)
  - PCMU (Pulse Code Modulation mu-law)
- After first expansion, subsequent uses can use just the acronym

---

## Testing Instructions
- All new features must include one or more tests in `test/`  
- Use descriptive test names and clearly arrange `arrange` / `act` / `assert` pattern  
- For widget or UI tests (if this is a Flutter package), ensure you use `flutter_test` and mock external dependencies  
- Before merging a pull request (PR), ensure:
  ```bash
  dart format --set-exit-if-changed .
  dart analyze
  dart test
  ```
- If you add new dependencies, update `pubspec.yaml` and run `dart pub get` in CI.

---

## Pull Request (PR) Guidelines
- Title format: `<component>: <short description>` or `bugfix(<component>): <short description>`  
- PR description should contain:
  - Summary of change  
  - Motivation / context  
  - How to test the change  
- Link to any relevant issue(s) or discussion(s)  
- When ready, mark the PR as ready for review and assign relevant reviewers  
- After approval, merge via “Squash & merge” (unless otherwise directed)  
- Post-merge: create a new release tag (`vX.Y.Z`) and update `CHANGELOG.md`

---

## Versioning & CHANGELOG
- Use [Semantic Versioning](https://semver.org): `MAJOR.MINOR.PATCH`  
- Update `CHANGELOG.md` for each version change under appropriate sections: Added, Changed, Fixed, Removed  
- Tag the release in Git:  
  ```bash
  git tag -a vX.Y.Z -m "Release version X.Y.Z"
  git push origin vX.Y.Z
  ```

---

## Security & Compliance
- Avoid committing secrets (API keys, credentials) in the repository  
- Use `gitignore` for local settings, build artefacts, and analysis caches  
- Renew any keys/certificates when they expire  
- For dependencies: review license compliance and check for vulnerabilities (e.g., `dart pub outdated --severity=high`)  
- If your package interacts with platform channels (Flutter) or native code, validate memory safety and concurrency issues

---

## Agent & Automation Tips
- Place this `AGENTS.md` at the root—agents will pick it up automatically.  
- Agents should avoid modifying files outside of the package directories without explicit instruction.  
- Ensure agents run the setup commands first, and then apply changes (formatting, tests, code) so they respect project conventions.  
- If the package becomes part of a mono-repo, consider adding nested `AGENTS.md` in sub-packages for more granular guidance.

---

## FAQ
**Q: Are there required fields in `AGENTS.md`?**  
A: No. It’s just Markdown. Use any headings and content that help agents and contributors.  [oai_citation:0‡agents.md](https://agents.md/)  

**Q: What if instructions conflict?**  
A: The closest `AGENTS.md` (in the directory tree) takes precedence. Also human instruction overrides automated instructions.  [oai_citation:1‡agents.md](https://agents.md/)  

**Q: Can we update `AGENTS.md` later?**  
A: Yes — treat it as living documentation.  [oai_citation:2‡agents.md](https://agents.md/)  

---

## Change History of this File
- **v0.1.0** — Initial draft based on generic Dart package template
- **v0.1.0 Post-Publish** — Added detailed release process with version bumping, documented CLI tools, added pre-release checklist
- **v0.2.5** — Improved release process: reordered steps to run tests first, added explicit git tag push step, added README.md update step, moved checklist to end as summary
- **v0.2.8** — Added documentation acronym standards: expand acronyms on first use with full expansion in brackets  