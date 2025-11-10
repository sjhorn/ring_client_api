/// REST Client Tests
///
/// Tests for RingRestClient authentication and HTTP request handling.
/// Uses mock HTTP clients to simulate Ring API behavior without making
/// real network requests.
///
/// Ported from: ring/packages/ring-client-api/test/rest-client.spec.ts
library;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:ring_client_api/src/rest_client.dart';
import 'package:ring_client_api/src/util.dart';

void main() {
  int sessionCreatedCount = 0;
  late RingRestClient client;

  const email = 'some@one.com';
  const password = 'abc123!';
  const phone = '+1xxxxxxxx89';
  const twoFactorAuthCode = '123456';
  const accessToken = 'ey__accees_token';
  const secondAccessToken = 'ey__second_accees_token';
  const refreshToken = 'ey__refresh_token';
  const secondRefreshToken = 'ey__second_refresh_token';
  const thirdRefreshToken = 'ey__third_refresh_token';

  late Future<String> hardwareIdPromise;

  /// Helper function to wrap refresh token with hardware ID
  Future<String> wrapRefreshToken(String rt) async {
    return toBase64(jsonEncode({'rt': rt, 'hid': await hardwareIdPromise}));
  }

  /// Mock HTTP client factory that simulates Ring API behavior
  ///
  /// This creates a MockClient that handles:
  /// - OAuth token endpoint (password and refresh_token grants)
  /// - Session creation endpoint
  /// - General API endpoints
  ///
  /// Parameters:
  /// - invalidateFirstAccessToken: When true, the first access token will be
  ///   rejected with a 401, forcing a token refresh
  http.Client createMockClient({bool invalidateFirstAccessToken = false}) {
    return MockClient((request) async {
      final url = request.url.toString();
      final method = request.method;

      // OAuth token endpoint - handles authentication and token refresh
      if (method == 'POST' && url == 'https://oauth.ring.com/oauth/token') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final hardwareId = await hardwareIdPromise;

        // Validate required authentication headers
        if (request.headers['2fa-support'] != 'true' ||
            request.headers['User-Agent'] != 'android:com.ringapp' ||
            request.headers['hardware_id'] != hardwareId) {
          return http.Response(
            jsonEncode({
              'code': 1,
              'error': 'Invalid auth headers: ${jsonEncode(request.headers)}',
            }),
            400,
          );
        }

        // Handle refresh token grant type
        if (body['grant_type'] == 'refresh_token') {
          // First refresh: refreshToken -> accessToken + secondRefreshToken
          if (body['refresh_token'] == refreshToken) {
            return http.Response(
              jsonEncode({
                'access_token': accessToken,
                'expires_in': 3600,
                'refresh_token': secondRefreshToken,
                'scope': 'client',
                'token_type': 'Bearer',
              }),
              200,
            );
          }

          // Second refresh: secondRefreshToken -> secondAccessToken + thirdRefreshToken
          if (body['refresh_token'] == secondRefreshToken) {
            return http.Response(
              jsonEncode({
                'access_token': secondAccessToken,
                'expires_in': 3600,
                'refresh_token': thirdRefreshToken,
                'scope': 'client',
                'token_type': 'Bearer',
              }),
              200,
            );
          }

          // Invalid refresh token
          return http.Response(
            jsonEncode({
              'error': 'invalid_grant',
              'error_description': 'token is invalid or does not exists',
            }),
            401,
          );
        }

        // Validate password grant type and required fields
        if (body['grant_type'] != 'password' ||
            body['client_id'] != 'ring_official_android' ||
            body['scope'] != 'client') {
          return http.Response(
            jsonEncode({
              'code': 1,
              'error': 'Invalid auth request: ${jsonEncode(body)}',
            }),
            400,
          );
        }

        // Validate user credentials
        if (body['username'] != email || body['password'] != password) {
          return http.Response(
            jsonEncode({
              'error': 'access_denied',
              'error_description': 'invalid user credentials',
            }),
            401,
          );
        }

        // Handle 2FA code validation
        final twoFaCode = request.headers['2fa-code'];
        if (twoFaCode != null && twoFaCode.isNotEmpty) {
          if (twoFaCode != twoFactorAuthCode) {
            // Invalid 2FA code
            return http.Response(
              jsonEncode({
                'err_msg': 'bad request response from dependency service',
                'error': 'Verification Code is invalid or expired',
              }),
              400,
            );
          }

          // Successful login with valid 2FA code
          return http.Response(
            jsonEncode({
              'access_token': accessToken,
              'expires_in': 3600,
              'refresh_token': refreshToken,
              'scope': 'client',
              'token_type': 'Bearer',
              'responseTimestamp': DateTime.now().millisecondsSinceEpoch,
            }),
            200,
          );
        }

        // No 2FA code provided - return 2FA prompt
        return http.Response(
          jsonEncode({
            'next_time_in_secs': 60,
            'phone': phone,
            'tsv_state': 'sms',
          }),
          412, // Precondition Failed - requires 2FA
        );
      }

      // Session endpoint - creates and validates user sessions
      if (method == 'POST' &&
          url == 'https://api.ring.com/clients_api/session') {
        final authHeader = request.headers['authorization'];

        // Validate access token
        if (authHeader != 'Bearer $accessToken' &&
            authHeader != 'Bearer $secondAccessToken') {
          return http.Response(jsonEncode({}), 401);
        }

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final device = body['device'] as Map<String, dynamic>;
        final metadata = device['metadata'] as Map<String, dynamic>;
        final hardwareId = await hardwareIdPromise;

        // Validate session request format
        if (device['hardware_id'] != hardwareId ||
            metadata['api_version'] != 11 ||
            metadata['device_model'] != 'ring-client-api' ||
            device['os'] != 'android') {
          return http.Response('Bad session request: ${jsonEncode(body)}', 400);
        }

        // Create session and return profile
        sessionCreatedCount++;
        return http.Response(
          jsonEncode({
            'profile': {
              'id': 1234,
              'email': email,
              'first_name': 'Test',
              'last_name': 'User',
              'phone_number': phone,
              'authentication_token': 'test_auth_token',
              'features': {},
              'user_preferences': {},
              'hardware_id': hardwareId,
              'explorer_program_terms': null,
              'user_flow': 'ring',
              'app_brand': 'ring',
              'country': 'US',
              'status': 'active',
              'created_at': '2020-01-01T00:00:00.000Z',
              'tfa_enabled': false,
              'tfa_phone_number': null,
              'account_type': 'standard',
            },
          }),
          200,
        );
      }

      // General API endpoint - tests authenticated requests
      if (method == 'GET' &&
          url == 'https://api.ring.com/clients_api/some_endpoint') {
        final authHeader = request.headers['authorization'];

        // Simulate expired token scenario
        if (invalidateFirstAccessToken && authHeader == 'Bearer $accessToken') {
          return http.Response(jsonEncode({}), 401);
        }

        // Validate access token
        if (authHeader != 'Bearer $accessToken' &&
            authHeader != 'Bearer $secondAccessToken') {
          return http.Response(jsonEncode({}), 401);
        }

        // Check if session has been created
        if (sessionCreatedCount == 0) {
          return http.Response(
            jsonEncode({
              'error':
                  'Session not found for ${request.headers['hardware_id']}',
            }),
            404,
          );
        }

        // Return successful response
        return http.Response(jsonEncode([]), 200);
      }

      // Fallback for unmatched requests
      return http.Response('Not Found', 404);
    });
  }

  setUp(() {
    sessionCreatedCount = 0;
    hardwareIdPromise = getHardwareId();
  });

  tearDown(() {
    client.clearTimeouts();
    clearTimeouts();
  });

  group('getAuth', () {
    test('should throw and set the 2fa prompt', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const EmailAuth(email: email, password: password),
        httpClient: mockClient,
      );

      await expectLater(
        () => client.getAuth(),
        throwsA(
          predicate<Exception>(
            (e) => e.toString().contains('2-factor authentication'),
          ),
        ),
      );

      expect(
        client.promptFor2fa,
        equals('Please enter the code sent to $phone via sms'),
      );
      expect(client.using2fa, equals(true));

      mockClient.close();
    });

    test('should accept a 2fa code', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const EmailAuth(email: email, password: password),
        httpClient: mockClient,
      );

      // Ignore the first reject, it's tested above
      await expectLater(() => client.getAuth(), throwsException);

      // Call getAuth again with the 2fa code, which should succeed
      final auth = await client.getAuth(twoFactorAuthCode);
      expect(auth.accessToken, equals(accessToken));
      expect(auth.refreshToken, equals(await wrapRefreshToken(refreshToken)));
      expect(client.refreshToken, equals(await wrapRefreshToken(refreshToken)));

      mockClient.close();
    });

    test('should handle invalid credentials', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const EmailAuth(email: email, password: 'incorrect password'),
        httpClient: mockClient,
      );

      await expectLater(
        () => client.getAuth(),
        throwsA(
          predicate<Exception>(
            (e) =>
                e.toString().contains(
                  'Failed to fetch oauth token from Ring',
                ) &&
                e.toString().contains('email and password are correct') &&
                e.toString().contains('error: access_denied'),
          ),
        ),
      );

      mockClient.close();
    });

    test('should handle invalid 2fa code', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const EmailAuth(email: email, password: password),
        httpClient: mockClient,
      );

      // Ignore the first reject
      await expectLater(() => client.getAuth(), throwsException);

      // Call getAuth again with an invalid 2fa code, which should fail
      await expectLater(
        () => client.getAuth('invalid 2fa code'),
        throwsA(
          predicate<Exception>(
            (e) => e.toString().contains(
              'Verification Code is invalid or expired',
            ),
          ),
        ),
      );
      expect(
        client.promptFor2fa,
        equals('Invalid 2fa code entered. Please try again.'),
      );

      mockClient.close();
    });

    test(
      'should establish a valid auth token with a valid refresh token',
      () async {
        final mockClient = createMockClient();

        client = RingRestClient(
          const RefreshTokenAuth(refreshToken: refreshToken),
          httpClient: mockClient,
        );

        final auth = await client.getCurrentAuth();
        expect(auth.accessToken, equals(accessToken));
        expect(
          auth.refreshToken,
          equals(await wrapRefreshToken(secondRefreshToken)),
        );
        expect(
          client.refreshToken,
          equals(await wrapRefreshToken(secondRefreshToken)),
        );

        mockClient.close();
      },
    );

    test('should emit an event when a new refresh token is created', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      final refreshedCompleter = Completer<RefreshTokenUpdate>();
      final subscription = client.onRefreshTokenUpdated.listen((update) {
        if (!refreshedCompleter.isCompleted) {
          refreshedCompleter.complete(update);
        }
      });

      final auth = await client.getAuth();
      expect(auth.accessToken, equals(accessToken));
      expect(
        auth.refreshToken,
        equals(await wrapRefreshToken(secondRefreshToken)),
      );

      final refreshed = await refreshedCompleter.future;
      expect(refreshed.oldRefreshToken, equals(refreshToken));
      expect(
        refreshed.newRefreshToken,
        equals(await wrapRefreshToken(secondRefreshToken)),
      );

      await subscription.cancel();
      mockClient.close();
    });
  });

  group('fetch', () {
    setUp(() {
      // Reset state before each fetch test
    });

    test('should include the auth token as a header', () async {
      final mockClient = createMockClient();

      client = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      final response = await client.request<List<dynamic>>(
        const RequestOptions(
          url: 'https://api.ring.com/clients_api/some_endpoint',
        ),
      );

      expect(response.data, equals([]));

      mockClient.close();
    });

    test(
      'should fetch a new auth token if the first is no longer valid',
      () async {
        // Configure mock to invalidate first access token
        final mockClient = createMockClient(invalidateFirstAccessToken: true);

        client = RingRestClient(
          const RefreshTokenAuth(refreshToken: refreshToken),
          httpClient: mockClient,
        );

        final response = await client.request<List<dynamic>>(
          const RequestOptions(
            url: 'https://api.ring.com/clients_api/some_endpoint',
          ),
        );

        expect(response.data, equals([]));

        mockClient.close();
      },
    );
  });
}
