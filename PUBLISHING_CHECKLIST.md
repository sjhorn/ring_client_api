# Publishing Checklist

## Status

Both packages are ready for publishing with only minor changes needed.

## Core Package (ring_client_api)

### ✅ Completed

- [x] All code complete and functional
- [x] Tests passing (26/26 tests)
- [x] Documentation complete
- [x] CHANGELOG.md updated for v0.1.0
- [x] README.md comprehensive
- [x] Examples working
- [x] CLI tools functional
- [x] Analyzer passing (0 errors)
- [x] False secrets configuration added for Firebase API key
- [x] Generated files excluded from analysis

### Dry-Run Results

```
Package validation found the following potential issue:
* 14 checked-in files are modified in git.
```

**Action Required**: Commit all changes before publishing.

### Publishing Steps

1. Commit all changes:
```bash
cd /Users/shorn/dev/dart/ring_client_api
git add .
git commit -m "Prepare for v0.1.0 release

- Complete Dart port of TypeScript ring-client-api
- Full REST API and WebSocket support
- Streaming interface definitions
- 26 passing tests
- CLI tools for authentication and device data
- Comprehensive documentation"
```

2. Create and push tag:
```bash
git tag v0.1.0
git push origin main
git push origin v0.1.0
```

3. Publish to pub.dev:
```bash
dart pub publish
```

---

## Flutter Package (ring_client_api_flutter)

### ✅ Completed

- [x] Package structure created
- [x] FlutterPeerConnection implemented
- [x] Camera viewer widgets created
- [x] Example app complete and functional
- [x] Documentation comprehensive
- [x] CHANGELOG.md updated for v0.1.0
- [x] README.md with setup instructions
- [x] Analyzer passing (0 errors, 1 expected warning)
- [x] Tests created

### Dry-Run Warning

```
warning • Publishable packages can't have 'path' dependencies • pubspec.yaml:18:5
```

**This is expected** - we use path dependency for local development.

### Pre-Publishing Changes

**IMPORTANT**: Before publishing, update `pubspec.yaml`:

**Current (development):**
```yaml
dependencies:
  ring_client_api:
    path: ../ring_client_api
```

**Change to (publishing):**
```yaml
dependencies:
  ring_client_api: ^0.1.0
```

### Publishing Steps

1. **Publish core package first** (see above)

2. Update dependency in pubspec.yaml:
```bash
cd /Users/shorn/dev/dart/ring_client_api_flutter

# Edit pubspec.yaml to use ^0.1.0 instead of path dependency
```

3. Run final checks:
```bash
flutter pub get
flutter analyze
flutter test
```

4. Commit dependency change:
```bash
git add pubspec.yaml pubspec.lock
git commit -m "Update dependency for v0.1.0 release"
```

5. Create and push tag:
```bash
git tag v0.1.0
git push origin main
git push origin v0.1.0
```

6. Publish to pub.dev:
```bash
flutter pub publish
```

7. **After publishing**, revert to path dependency for continued development:
```bash
# Revert pubspec.yaml back to path dependency
git revert HEAD
```

---

## Publishing Order

**CRITICAL**: Packages must be published in this order:

1. ✅ **ring_client_api** (core package) - Must be published first
2. ✅ **ring_client_api_flutter** - Depends on published core package

---

## Post-Publishing

After both packages are published:

1. Update TODO.md marking Phase 11 as complete
2. Update README files if needed
3. Announce release on GitHub
4. Consider creating GitHub release notes
5. Share on relevant Dart/Flutter communities

---

## Repository URLs

- Core Package: https://github.com/sjhorn/ring_client_api
- Flutter Package: https://github.com/sjhorn/ring_client_api_flutter (to be created)

**Note**: You may want to use a monorepo structure instead of separate repos. If so:
- Keep both packages in the same repository
- Use workspace structure with packages/ directory
- Single GitHub repo with both packages

---

## Important Notes

1. **First-time Publishing**: You'll need to login to pub.dev and authorize the publishing
2. **Verification**: Both packages will need email verification on pub.dev
3. **Package Names**: Ensure package names are available on pub.dev
4. **License**: MIT license included in both packages
5. **Documentation**: All packages have comprehensive documentation ready

---

## Testing Before Publishing

### Core Package
```bash
cd /Users/shorn/dev/dart/ring_client_api
dart test
dart analyze
dart pub publish --dry-run
```

### Flutter Package
```bash
cd /Users/shorn/dev/dart/ring_client_api_flutter
flutter test
flutter analyze
flutter pub publish --dry-run  # (expect path dependency warning)
```

---

## Summary

**Ready to publish** with these actions:
1. Commit all changes in core package
2. Publish core package to pub.dev
3. Update Flutter package pubspec.yaml dependency
4. Publish Flutter package to pub.dev

**Total time estimate**: 30-60 minutes (including pub.dev review times)
