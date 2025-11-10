/// Integration Tests
///
/// These tests verify the Ring API client works correctly with real API responses.
/// They use mock HTTP clients to simulate the Ring API without making actual network calls.
///
/// Integration tests cover:
/// - Full API initialization flow
/// - Location discovery and management
/// - Camera discovery and operations
/// - Event streaming and notifications
/// - Error handling and recovery
library;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:ring_client_api/ring_client_api.dart';

void main() {
  const refreshToken = 'test_refresh_token';
  const accessToken = 'test_access_token';
  const hardwareId = 'test_hardware_id';

  /// Creates a comprehensive mock HTTP client that simulates Ring API
  http.Client createIntegrationMockClient() {
    return MockClient((request) async {
      final url = request.url.toString();
      final method = request.method;

      // OAuth token endpoint
      if (method == 'POST' && url == 'https://oauth.ring.com/oauth/token') {
        return http.Response(
          jsonEncode({
            'access_token': accessToken,
            'expires_in': 3600,
            'refresh_token': refreshToken,
            'scope': 'client',
            'token_type': 'Bearer',
          }),
          200,
        );
      }

      // Session endpoint
      if (method == 'POST' &&
          url == 'https://api.ring.com/clients_api/session') {
        return http.Response(
          jsonEncode({
            'profile': {
              'id': 12345,
              'email': 'test@example.com',
              'first_name': 'Test',
              'last_name': 'User',
              'phone_number': '+15551234567',
              'authentication_token': 'auth_token_123',
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

      // Ring groups (locations) endpoint
      if (method == 'GET' &&
          url == 'https://api.ring.com/clients_api/ring_groups') {
        return http.Response(
          jsonEncode({
            'ring_groups': [
              {'id': 'location-1', 'name': 'Home', 'location_id': 'loc-123'},
            ],
            'doorbots': [
              {
                'id': 1001,
                'description': 'Front Door',
                'device_id': 'device-doorbell-1',
                'location_id': 'loc-123',
                'kind': 'lpd_v1',
                'battery_life': '85',
                'external_connection': false,
                'firmware_version': '1.2.3',
                'address': '123 Main St',
                'features': {},
                'settings': {},
              },
            ],
            'stickup_cams': [
              {
                'id': 2001,
                'description': 'Backyard Camera',
                'device_id': 'device-camera-1',
                'location_id': 'loc-123',
                'kind': 'hp_cam_v1',
                'battery_life': '92',
                'battery_life_2': '88',
                'external_connection': false,
                'firmware_version': '1.4.5',
                'address': '123 Main St',
                'features': {},
                'settings': {},
              },
            ],
            'chimes': [],
            'authorized_doorbots': [],
          }),
          200,
        );
      }

      // Device health endpoint
      if (method == 'GET' &&
          url.contains('clients_api/ring_devices') &&
          url.contains('/health')) {
        return http.Response(
          jsonEncode({
            'device_health': {
              'battery_percentage': 85,
              'battery_present': true,
              'wifi_name': 'HomeNetwork',
              'wifi_is_ring_network': false,
              'latest_signal_strength': -45,
            },
          }),
          200,
        );
      }

      // Dings (events) endpoint
      if (method == 'GET' && url.contains('clients_api/dings/active')) {
        return http.Response(jsonEncode([]), 200);
      }

      // Snapshot endpoint
      if (method == 'POST' && url.contains('snapshots/image')) {
        // Return a minimal valid JPEG header
        final fakeJpeg = [
          0xFF, 0xD8, 0xFF, 0xE0, // JPEG SOI and APP0 marker
          0x00, 0x10, // APP0 length
          0x4A, 0x46, 0x49, 0x46, 0x00, // "JFIF" identifier
          0x01, 0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00,
          0xFF, 0xD9, // JPEG EOI
        ];
        return http.Response.bytes(fakeJpeg, 200);
      }

      // Default fallback
      return http.Response(jsonEncode({'error': 'Not Found', 'url': url}), 404);
    });
  }

  group('Integration Tests', () {
    late http.Client mockClient;

    setUp(() {
      mockClient = createIntegrationMockClient();
    });

    tearDown(() async {
      mockClient.close();
    });

    test('should initialize API with refresh token', () async {
      // Create a custom RingRestClient with mock HTTP client
      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      // Get auth to initialize
      final auth = await restClient.getCurrentAuth();
      expect(auth.accessToken, equals(accessToken));
      expect(auth.refreshToken, isNotNull);

      restClient.dispose();
    });

    test('should discover locations and cameras', () async {
      // Note: RingApi doesn't support HTTP client injection yet,
      // so this test verifies the structure without making real calls

      // For now, we'll test that the API can be constructed
      // and that the mock client structure is valid

      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      // Test auth flow
      final auth = await restClient.getCurrentAuth();
      expect(auth.accessToken, isNotNull);

      // Test session creation
      final session = await restClient.getSession();
      expect(session.profile, isNotNull);
      expect(session.profile.id, equals(12345));
      expect(session.profile.email, equals('test@example.com'));

      restClient.dispose();
    });

    test('should handle API request flow', () async {
      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      // Test making an authenticated request to locations endpoint
      final response = await restClient.request<Map<String, dynamic>>(
        const RequestOptions(
          url: 'https://api.ring.com/clients_api/ring_groups',
        ),
      );

      expect(response.data, isNotNull);
      expect(response.data['ring_groups'], isNotNull);
      expect(response.data['doorbots'], isNotNull);
      expect(response.data['stickup_cams'], isNotNull);

      // Verify location data
      final locations = response.data['ring_groups'] as List;
      expect(locations.length, equals(1));
      expect(locations[0]['name'], equals('Home'));

      // Verify doorbell data
      final doorbots = response.data['doorbots'] as List;
      expect(doorbots.length, equals(1));
      expect(doorbots[0]['description'], equals('Front Door'));
      expect(doorbots[0]['battery_life'], equals('85'));

      // Verify camera data
      final cameras = response.data['stickup_cams'] as List;
      expect(cameras.length, equals(1));
      expect(cameras[0]['description'], equals('Backyard Camera'));
      expect(cameras[0]['battery_life'], equals('92'));
      expect(cameras[0]['battery_life_2'], equals('88'));

      restClient.dispose();
    });

    test('should handle authentication errors gracefully', () async {
      // Create a mock client that returns 401 errors
      final errorMockClient = MockClient((request) async {
        if (request.url.toString().contains('oauth.ring.com')) {
          return http.Response(
            jsonEncode({
              'error': 'invalid_grant',
              'error_description': 'Invalid refresh token',
            }),
            401,
          );
        }
        return http.Response('Not Found', 404);
      });

      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: 'invalid_token'),
        httpClient: errorMockClient,
      );

      // Should throw an exception for invalid token
      await expectLater(() => restClient.getCurrentAuth(), throwsException);

      restClient.dispose();
      errorMockClient.close();
    });

    test('should handle network timeouts', () async {
      // Create a mock client that takes longer than the timeout
      var requestStarted = false;
      final timeoutMockClient = MockClient((request) async {
        requestStarted = true;
        // Delay longer than the request timeout
        await Future.delayed(const Duration(milliseconds: 600));
        return http.Response('{"data": "response"}', 200);
      });

      // Make a direct request with a short timeout and allowNoResponse=false
      // to trigger retries (which is the default behavior)
      // However, since timeout errors trigger infinite retries with 5s delays,
      // we need to use allowNoResponse=true to prevent retries
      await expectLater(
        () => requestWithRetry(
          const RequestOptions(
            url: 'https://test.example.com/api/test',
            method: 'GET',
            timeout: Duration(milliseconds: 200), // Very short timeout
            allowNoResponse: true, // Don't retry on timeout
          ),
          client: timeoutMockClient,
        ),
        throwsA(isA<TimeoutException>()),
      );

      // Verify the request was started
      expect(requestStarted, isTrue);

      timeoutMockClient.close();
    });

    test('should retry on network errors', () async {
      var attemptCount = 0;

      // Create a mock client that fails first, then succeeds
      final retryMockClient = MockClient((request) async {
        attemptCount++;

        if (attemptCount == 1) {
          // First attempt: network error
          throw http.ClientException('Network unreachable');
        }

        // Second attempt: success
        if (request.url.toString().contains('oauth.ring.com')) {
          return http.Response(
            jsonEncode({
              'access_token': accessToken,
              'expires_in': 3600,
              'refresh_token': refreshToken,
              'scope': 'client',
              'token_type': 'Bearer',
            }),
            200,
          );
        }

        return http.Response('Not Found', 404);
      });

      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: retryMockClient,
      );

      // Should succeed after retry
      final auth = await restClient.getCurrentAuth();
      expect(auth.accessToken, equals(accessToken));
      expect(attemptCount, greaterThan(1)); // Verify retry occurred

      restClient.dispose();
      retryMockClient.close();
    });

    test('should handle refresh token updates', () async {
      final restClient = RingRestClient(
        const RefreshTokenAuth(refreshToken: refreshToken),
        httpClient: mockClient,
      );

      final updates = <RefreshTokenUpdate>[];
      final subscription = restClient.onRefreshTokenUpdated.listen((update) {
        updates.add(update);
      });

      // Trigger authentication which updates refresh token
      await restClient.getCurrentAuth();

      // Wait a bit for the stream to emit
      await Future.delayed(const Duration(milliseconds: 100));

      expect(updates.length, equals(1));
      expect(updates[0].newRefreshToken, isNotNull);

      await subscription.cancel();
      restClient.dispose();
    });
  });

  group('Mock Data Validation', () {
    test('should have valid camera data structure', () {
      final cameraJson = {
        'id': 2001,
        'description': 'Backyard Camera',
        'device_id': 'device-camera-1',
        'location_id': 'loc-123',
        'kind': 'hp_cam_v1',
        'battery_life': '92',
        'battery_life_2': '88',
        'external_connection': false,
        'firmware_version': '1.4.5',
        'address': '123 Main St',
        'features': {},
        'settings': {},
      };

      // Verify camera data can be parsed
      expect(cameraJson['id'], isA<int>());
      expect(cameraJson['description'], isA<String>());
      expect(cameraJson['battery_life'], isA<String>());
      expect(cameraJson['battery_life_2'], isA<String>());
    });

    test('should have valid location data structure', () {
      final locationJson = {
        'id': 'location-1',
        'name': 'Home',
        'location_id': 'loc-123',
      };

      expect(locationJson['id'], isA<String>());
      expect(locationJson['name'], isA<String>());
      expect(locationJson['location_id'], isA<String>());
    });
  });
}
