# REST Client Tests

## Overview

This document describes the test suite for `RingRestClient`, ported from the TypeScript implementation at `ring/packages/ring-client-api/test/rest-client.spec.ts`.

## Current Status

**All tests are currently skipped** because they require modifications to the `rest_client.dart` implementation to support dependency injection of HTTP clients.

## Test Structure

The test suite is organized into two main groups:

### 1. Authentication Tests (`getAuth`)

These tests verify the authentication and token management functionality:

- **2FA Prompt Handling**: Verifies that the client properly detects when 2FA is required and sets appropriate prompts
- **2FA Code Acceptance**: Tests that valid 2FA codes are accepted and proper tokens are returned
- **Invalid Credentials**: Ensures proper error handling for incorrect email/password combinations
- **Invalid 2FA Code**: Verifies error messages when incorrect 2FA codes are provided
- **Refresh Token Authentication**: Tests authentication using a refresh token instead of email/password
- **Token Update Events**: Validates that the `onRefreshTokenUpdated` stream emits events when tokens are refreshed

### 2. Request Tests (`fetch`)

These tests verify authenticated API request functionality:

- **Authorization Headers**: Ensures requests include proper Bearer token authentication headers
- **Automatic Token Refresh**: Tests that expired access tokens are automatically refreshed and requests are retried

## Mock HTTP Client

The test file includes a comprehensive `createMockClient()` function that simulates Ring API behavior:

### OAuth Token Endpoint (`https://oauth.ring.com/oauth/token`)

Handles:
- Password grant type (email/password authentication)
- Refresh token grant type
- 2FA validation
- Header validation (2fa-support, User-Agent, hardware_id)

Response scenarios:
- Invalid auth headers → 400 with error message
- Invalid credentials → 401 with access_denied
- Valid credentials without 2FA → 412 with 2FA prompt
- Invalid 2FA code → 400 with verification error
- Valid 2FA code → 200 with access and refresh tokens
- Valid refresh token → 200 with new access and refresh tokens
- Invalid refresh token → 401 with invalid_grant error

### Session Endpoint (`https://api.ring.com/clients_api/session`)

Handles:
- Access token validation
- Session request format validation
- Session creation

Response scenarios:
- Invalid access token → 401
- Invalid session request → 400
- Valid request → 200 with profile data

### General API Endpoint (`https://api.ring.com/clients_api/some_endpoint`)

Handles:
- Access token validation
- Session existence check
- Token expiration simulation

Response scenarios:
- Expired token (when configured) → 401
- Invalid token → 401
- No session created → 404
- Valid request → 200 with empty array

## Required Implementation Changes

To enable these tests, the following changes need to be made to `rest_client.dart`:

### 1. Add HTTP Client Parameter to `requestWithRetry`

```dart
Future<DataResponse<T>> requestWithRetry<T>(
  RequestOptions options, {
  int retryCount = 0,
  http.Client? httpClient,  // Add this parameter
}) async {
  // Use httpClient ?? http.Client() when creating requests
}
```

### 2. Add HTTP Client Parameter to `RingRestClient`

```dart
class RingRestClient {
  final http.Client? _httpClient;

  RingRestClient(
    dynamic authOptions, {
    http.Client? httpClient,  // Add this parameter
  }) : _httpClient = httpClient,
       // ... rest of constructor
}
```

### 3. Pass HTTP Client Through Request Chain

Ensure all internal calls to `requestWithRetry` pass through the injected HTTP client:

```dart
final response = await requestWithRetry<Map<String, dynamic>>(
  RequestOptions(...),
  httpClient: _httpClient,
);
```

### 4. Update HTTP Request Creation

Modify the HTTP client creation in `requestWithRetry`:

```dart
// Instead of:
final client = http.Client();

// Use:
final client = httpClient ?? http.Client();
```

## Running the Tests

Once the implementation changes are made, uncomment the test assertions and run:

```bash
dart test test/rest_client_test.dart
```

To run with verbose output:

```bash
dart test test/rest_client_test.dart --reporter=expanded
```

## Test Data

The tests use the following mock data:

- **Email**: `some@one.com`
- **Password**: `abc123!`
- **Phone**: `+1xxxxxxxx89`
- **2FA Code**: `123456`
- **Access Token**: `ey__accees_token`
- **Second Access Token**: `ey__second_accees_token`
- **Refresh Token**: `ey__refresh_token`
- **Second Refresh Token**: `ey__second_refresh_token`
- **Third Refresh Token**: `ey__third_refresh_token`

## Helper Functions

### `wrapRefreshToken(String rt)`

Wraps a refresh token with hardware ID in the format expected by the API:

```json
{
  "rt": "refresh_token_value",
  "hid": "hardware_id_value"
}
```

This is then base64-encoded for transmission.

### `createMockClient({bool invalidateFirstAccessToken = false})`

Creates a `MockClient` that simulates all Ring API endpoints needed for testing.

Parameters:
- `invalidateFirstAccessToken`: When `true`, the first access token will be rejected with 401, forcing a token refresh scenario

## Integration with CI/CD

Currently, all tests are skipped, so they won't block CI/CD pipelines. Once the implementation changes are made:

1. Remove the `skip` parameter from test definitions
2. Uncomment the test assertions
3. Verify all tests pass
4. Add to CI/CD pipeline test suite

## Future Enhancements

Potential improvements to the test suite:

1. **Error Recovery Tests**: Test network failure scenarios and retry logic
2. **Rate Limiting Tests**: Verify proper handling of 429 responses
3. **Session Management Tests**: Test session creation and refresh cycles
4. **Concurrent Request Tests**: Verify token refresh behavior with multiple simultaneous requests
5. **Token Expiration Tests**: Test behavior near token expiration boundaries

## References

- Original TypeScript tests: `./ring/packages/ring-client-api/test/rest-client.spec.ts`
- Dart implementation: `/Users/shorn/dev/dart/ring_client_api/lib/src/rest_client.dart`
- Test file: `/Users/shorn/dev/dart/ring_client_api/test/rest_client_test.dart`
