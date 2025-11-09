/// REST client for Ring API communication
///
/// This file handles all HTTP communication with Ring servers, including:
/// - Authentication with email/password or refresh token
/// - Two-factor authentication (2FA) handling
/// - Session management and caching
/// - Automatic token refresh
/// - Request retry logic with exponential backoff
/// - Error handling and recovery
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'util.dart';

/// Response type: JSON or buffer
enum ResponseType { json, buffer }

/// Extended response with timestamp information
class ExtendedResponse {
  final int? responseTimestamp;
  final int? timeMillis;

  const ExtendedResponse({this.responseTimestamp, this.timeMillis});
}

/// Response with data and metadata
class DataResponse<T> extends ExtendedResponse {
  final T data;

  const DataResponse({
    required this.data,
    super.responseTimestamp,
    super.timeMillis,
  });
}

/// Custom error for HTTP responses
class ResponseError implements Exception {
  final Map<String, String>? headers;
  final int? status;
  final dynamic body;
  final String message;
  final Exception? originalException;

  ResponseError({
    this.headers,
    this.status,
    this.body,
    required this.message,
    this.originalException,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ResponseError: $message');
    if (status != null) {
      buffer.write(' (status: $status)');
    }
    if (body != null) {
      buffer.write('\nBody: ${stringify(body)}');
    }
    return buffer.toString();
  }
}

/// Request options for HTTP calls
class RequestOptions {
  final String url;
  final String method;
  final Map<String, String>? headers;
  final dynamic body;
  final dynamic json;
  final ResponseType responseType;
  final Duration timeout;
  final bool allowNoResponse;

  const RequestOptions({
    required this.url,
    this.method = 'GET',
    this.headers,
    this.body,
    this.json,
    this.responseType = ResponseType.json,
    this.timeout = const Duration(seconds: 20),
    this.allowNoResponse = false,
  });

  RequestOptions copyWith({
    String? url,
    String? method,
    Map<String, String>? headers,
    dynamic body,
    dynamic json,
    ResponseType? responseType,
    Duration? timeout,
    bool? allowNoResponse,
  }) {
    return RequestOptions(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      json: json ?? this.json,
      responseType: responseType ?? this.responseType,
      timeout: timeout ?? this.timeout,
      allowNoResponse: allowNoResponse ?? this.allowNoResponse,
    );
  }
}

/// Ring API error codes
const Map<int, String> ringErrorCodes = {
  7050: 'NO_ASSET',
  7019: 'ASSET_OFFLINE',
  7061: 'ASSET_CELL_BACKUP',
  7062: 'UPDATING',
  7063: 'MAINTENANCE',
};

/// API base URLs
const String clientApiBaseUrl = 'https://api.ring.com/clients_api/';
const String deviceApiBaseUrl = 'https://api.ring.com/devices/v1/';
const String commandsApiBaseUrl = 'https://api.ring.com/commands/v1/';
const String appApiBaseUrl = 'https://prd-api-us.prd.rings.solutions/api/v1/';
const int apiVersion = 11;

/// Helper function to build client API URL
String clientApi(String path) => clientApiBaseUrl + path;

/// Helper function to build device API URL
String deviceApi(String path) => deviceApiBaseUrl + path;

/// Helper function to build commands API URL
String commandsApi(String path) => commandsApiBaseUrl + path;

/// Helper function to build app API URL
String appApi(String path) => appApiBaseUrl + path;

/// Convert HTTP response to error
Future<ResponseError> _responseToError(http.Response response) async {
  dynamic body;

  try {
    final bodyText = response.body;
    try {
      body = jsonDecode(bodyText);
    } catch (_) {
      body = bodyText;
    }
  } catch (_) {
    // ignore
  }

  return ResponseError(
    headers: response.headers,
    status: response.statusCode,
    body: body,
    message: 'HTTP request failed with status ${response.statusCode}',
  );
}

/// Make HTTP request with retry logic
Future<DataResponse<T>> requestWithRetry<T>(
  RequestOptions options, {
  int retryCount = 0,
}) async {
  try {
    // Prepare headers
    final headers = <String, String>{...?options.headers};

    // Handle JSON content type
    if (options.json != null || options.responseType == ResponseType.json) {
      headers['Content-Type'] = 'application/json';
      headers['Accept'] = 'application/json';
    }

    // Prepare request body
    String? bodyString;
    if (options.json != null) {
      bodyString = jsonEncode(options.json);
    } else if (options.body != null) {
      bodyString = options.body.toString();
    }

    // Create HTTP request
    final request = http.Request(options.method, Uri.parse(options.url));
    request.headers.addAll(headers);
    if (bodyString != null) {
      request.body = bodyString;
      if (options.url.contains('oauth.ring.com')) {
        // ignore: avoid_print
        print('[DEBUG] OAuth request body: ${bodyString.length} chars');
        // ignore: avoid_print
        print('[DEBUG] OAuth headers: ${headers.keys.toList()}');
      }
    }

    // Make the request with timeout
    final client = http.Client();
    try {
      final streamedResponse = await client
          .send(request)
          .timeout(
            options.timeout,
            onTimeout: () {
              throw TimeoutException(
                'Request timed out after ${options.timeout.inSeconds}s',
              );
            },
          );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (options.url.contains('oauth.ring.com')) {
          // ignore: avoid_print
          print('[DEBUG] OAuth response status: ${response.statusCode}');
          // ignore: avoid_print
          print('[DEBUG] OAuth response body: ${response.body}');
        }
        final error = await _responseToError(response);
        throw error;
      }

      // Parse response data
      T data;
      if (options.responseType == ResponseType.buffer) {
        data = response.bodyBytes as T;
      } else {
        final text = response.body;
        if (text.isEmpty) {
          data = null as T;
        } else {
          try {
            data = jsonDecode(text) as T;
          } catch (_) {
            data = text as T;
          }
        }
      }

      // Extract timestamps from headers
      int? responseTimestamp;
      int? timeMillis;

      final dateHeader = response.headers['date'];
      if (dateHeader != null) {
        try {
          responseTimestamp = DateTime.parse(dateHeader).millisecondsSinceEpoch;
        } catch (_) {
          // ignore
        }
      }

      final xTimeHeader = response.headers['x-time-millis'];
      if (xTimeHeader != null) {
        timeMillis = int.tryParse(xTimeHeader);
      }

      return DataResponse<T>(
        data: data,
        responseTimestamp: responseTimestamp,
        timeMillis: timeMillis,
      );
    } finally {
      client.close();
    }
  } catch (e) {
    // Check if this is a network error (no response from server)
    final isNetworkError = e is! ResponseError;

    if (isNetworkError && !options.allowNoResponse) {
      if (retryCount > 0) {
        String detailedError = 'Error: ${e.toString()}';
        if (e is Exception) {
          detailedError += ', Exception: ${e.runtimeType}';
        }
        logError(
          'Retry #$retryCount failed to reach Ring server at ${options.url}. '
          '$detailedError. Trying again in 5 seconds...',
        );
        logDebug(e);
      }

      await delay(5000);
      return requestWithRetry<T>(options, retryCount: retryCount + 1);
    }

    rethrow;
  }
}

/// Email-based authentication
class EmailAuth {
  final String email;
  final String password;
  final String? systemId;
  final String? controlCenterDisplayName;

  const EmailAuth({
    required this.email,
    required this.password,
    this.systemId,
    this.controlCenterDisplayName,
  });
}

/// Refresh token-based authentication
class RefreshTokenAuth {
  final String refreshToken;
  final String? systemId;
  final String? controlCenterDisplayName;

  const RefreshTokenAuth({
    required this.refreshToken,
    this.systemId,
    this.controlCenterDisplayName,
  });
}

/// Auth configuration stored in refresh token
class _AuthConfig {
  final String rt; // Refresh Token
  final String? hid; // Hardware ID
  final Map<String, dynamic>? pnc; // Push Notification Credentials

  const _AuthConfig({required this.rt, this.hid, this.pnc});

  Map<String, dynamic> toJson() {
    return {'rt': rt, if (hid != null) 'hid': hid, if (pnc != null) 'pnc': pnc};
  }

  factory _AuthConfig.fromJson(Map<String, dynamic> json) {
    try {
      return _AuthConfig(
        rt: json['rt'] as String,
        hid: json['hid'] as String?,
        pnc: json['pnc'] != null ? json['pnc'] as Map<String, dynamic> : null,
      );
    } catch (e) {
      // ignore: avoid_print
      print('[ERROR] Failed to parse auth config from JSON: $e');
      // ignore: avoid_print
      print('[ERROR] JSON keys: ${json.keys.toList()}');
      rethrow;
    }
  }
}

/// Parse auth config from refresh token
_AuthConfig? _parseAuthConfig(String? rawRefreshToken) {
  if (rawRefreshToken == null || rawRefreshToken.isEmpty) {
    return null;
  }

  try {
    final decoded = fromBase64(rawRefreshToken);
    // ignore: avoid_print
    print('[DEBUG] Decoded refresh token: ${decoded.substring(0, min(100, decoded.length))}...');
    final config = jsonDecode(decoded) as Map<String, dynamic>;
    if (config['rt'] == null) {
      // ignore: avoid_print
      print('[DEBUG] No rt field found in config');
      return null;
    }
    // ignore: avoid_print
    print('[DEBUG] Successfully parsed auth config with rt field (length: ${(config['rt'] as String).length})');
    return _AuthConfig.fromJson(config);
  } catch (e) {
    // ignore: avoid_print
    print('[DEBUG] Failed to parse refresh token as JSON: $e');
    // If parsing fails, treat the entire string as a simple refresh token
    return _AuthConfig(rt: rawRefreshToken);
  }
}

/// Refresh token update event
class RefreshTokenUpdate {
  final String? oldRefreshToken;
  final String newRefreshToken;

  const RefreshTokenUpdate({
    this.oldRefreshToken,
    required this.newRefreshToken,
  });
}

/// Main REST client for Ring API
class RingRestClient {
  String? refreshToken;
  _AuthConfig? _authConfig;
  late final Future<String> _hardwareIdPromise;
  Promise<AuthTokenResponse>? _authPromise;
  final List<Timer> _timeouts = [];
  Promise<SessionResponse>? _sessionPromise;
  bool using2fa = false;
  String? promptFor2fa;

  /// Stream of refresh token updates
  final BehaviorSubject<RefreshTokenUpdate> onRefreshTokenUpdated =
      BehaviorSubject<RefreshTokenUpdate>();

  /// Stream of session updates
  final BehaviorSubject<SessionResponse> onSession =
      BehaviorSubject<SessionResponse>();

  /// Base session metadata
  final Map<String, dynamic> baseSessionMetadata;

  final dynamic _authOptions;

  /// Create a new Ring REST client
  ///
  /// Provide either [EmailAuth] or [RefreshTokenAuth] for authentication.
  /// Optionally provide [SessionOptions] for custom session configuration.
  RingRestClient(dynamic authOptions)
    : _authOptions = authOptions,
      baseSessionMetadata = {
        'api_version': apiVersion,
        'device_model': 'ring-client-api',
      } {
    // Extract refresh token if present
    if (authOptions is RefreshTokenAuth) {
      refreshToken = authOptions.refreshToken;
      // ignore: avoid_print
      print('[DEBUG] Got refresh token from auth options: ${refreshToken?.substring(0, min(50, refreshToken?.length ?? 0))}...');
    }

    // Parse auth config
    _authConfig = _parseAuthConfig(refreshToken);
    // ignore: avoid_print
    print('[DEBUG] Auth config parsed: ${_authConfig != null ? "success (rt length: ${_authConfig!.rt.length})" : "null"}');

    // Initialize hardware ID
    final systemId = authOptions is EmailAuth
        ? authOptions.systemId
        : authOptions is RefreshTokenAuth
        ? authOptions.systemId
        : null;
    _hardwareIdPromise = _authConfig?.hid != null
        ? Future.value(_authConfig!.hid!)
        : getHardwareId(systemId);

    // Update base session metadata with display name if provided
    String? displayName;
    if (authOptions is EmailAuth) {
      displayName = authOptions.controlCenterDisplayName;
    } else if (authOptions is RefreshTokenAuth) {
      displayName = authOptions.controlCenterDisplayName;
    }

    if (displayName != null) {
      baseSessionMetadata['device_model'] = displayName;
    }
  }

  /// Clear previous authentication
  void _clearPreviousAuth() {
    _authPromise = null;
  }

  /// Get or create auth promise
  Future<AuthTokenResponse> get _authPromiseFuture {
    if (_authPromise == null) {
      final authPromise = getAuth();
      _authPromise = authPromise;

      authPromise
          .then((authToken) {
            // Clear the existing auth promise 1 minute before it expires
            final timeout = Timer(
              Duration(seconds: (authToken.expiresIn - 60)),
              () {
                if (_authPromise == authPromise) {
                  _clearPreviousAuth();
                }
              },
            );
            _timeouts.add(timeout);
          })
          .catchError((error) {
            // Ignore errors here, they should be handled by the function making the request
          });
    }

    return _authPromise!;
  }

  /// Get grant data for authentication
  Map<String, String> _getGrantData(String? twoFactorAuthCode) {
    if (_authConfig?.rt != null && twoFactorAuthCode == null) {
      return {'grant_type': 'refresh_token', 'refresh_token': _authConfig!.rt};
    }

    if (_authOptions is EmailAuth) {
      return {
        'grant_type': 'password',
        'password': _authOptions.password,
        'username': _authOptions.email,
      };
    }

    throw Exception(
      'Refresh token is not valid. Unable to authenticate with Ring servers. '
      'See https://github.com/dgreif/ring/wiki/Refresh-Tokens',
    );
  }

  /// Authenticate with Ring servers
  Future<AuthTokenResponse> getAuth([String? twoFactorAuthCode]) async {
    final grantData = _getGrantData(twoFactorAuthCode);

    try {
      final hardwareId = await _hardwareIdPromise;
      // ignore: avoid_print
      print('[DEBUG] Auth request:');
      // ignore: avoid_print
      print('[DEBUG]   hardwareId: $hardwareId');
      // ignore: avoid_print
      print('[DEBUG]   grantData: $grantData');
      // ignore: avoid_print
      print('[DEBUG]   refresh_token length: ${grantData['refresh_token']?.length}');
      final response = await requestWithRetry<Map<String, dynamic>>(
        RequestOptions(
          url: 'https://oauth.ring.com/oauth/token',
          method: 'POST',
          json: {
            'client_id': 'ring_official_android',
            'scope': 'client',
            ...grantData,
          },
          headers: {
            '2fa-support': 'true',
            '2fa-code': twoFactorAuthCode ?? '',
            'hardware_id': hardwareId,
            'User-Agent': 'android:com.ringapp',
          },
        ),
      );

      // ignore: avoid_print
      print('[DEBUG] Auth response received, parsing...');
      // ignore: avoid_print
      print('[DEBUG] Response data type: ${response.data.runtimeType}');
      final data = response.data as Map<String, dynamic>;
      // ignore: avoid_print
      print('[DEBUG] Response data keys: ${data.keys.toList()}');
      // ignore: avoid_print
      print('[DEBUG] access_token: ${data['access_token']?.runtimeType} (null: ${data['access_token'] == null})');
      // ignore: avoid_print
      print('[DEBUG] expires_in: ${data['expires_in']?.runtimeType} (null: ${data['expires_in'] == null})');
      // ignore: avoid_print
      print('[DEBUG] refresh_token: ${data['refresh_token']?.runtimeType} (null: ${data['refresh_token'] == null})');
      // ignore: avoid_print
      print('[DEBUG] scope: ${data['scope']?.runtimeType} (null: ${data['scope'] == null})');
      // ignore: avoid_print
      print('[DEBUG] token_type: ${data['token_type']?.runtimeType} (null: ${data['token_type'] == null})');
      final authTokenResponse = AuthTokenResponse.fromJson(response.data);
      final oldRefreshToken = refreshToken;

      // Store the new refresh token and auth config
      _authConfig = _AuthConfig(
        rt: authTokenResponse.refreshToken,
        hid: hardwareId,
        pnc: _authConfig?.pnc,
      );
      refreshToken = toBase64(jsonEncode(_authConfig!.toJson()));

      // Emit an event with the new token
      onRefreshTokenUpdated.add(
        RefreshTokenUpdate(
          oldRefreshToken: oldRefreshToken,
          newRefreshToken: refreshToken!,
        ),
      );

      // Return response with wrapped refresh token
      return AuthTokenResponse(
        accessToken: authTokenResponse.accessToken,
        expiresIn: authTokenResponse.expiresIn,
        refreshToken: refreshToken!,
        scope: authTokenResponse.scope,
        tokenType: authTokenResponse.tokenType,
      );
    } catch (requestError) {
      if (grantData.containsKey('refresh_token')) {
        // Failed request with refresh token - try with email/password
        // ignore: avoid_print
        print('[DEBUG] Auth with refresh token failed: $requestError');
        refreshToken = null;
        _authConfig = null;
        logError(requestError);
        return getAuth();
      }

      // Handle 2FA errors
      if (requestError is ResponseError) {
        final response = requestError;
        final responseData = response.body;

        // Parse 2FA response
        String? responseError;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('error')) {
          responseError = responseData['error']?.toString() ?? '';
        }

        // Check for 2FA required or invalid code
        if (response.status == 412 ||
            (response.status == 400 &&
                (responseError?.startsWith('Verification Code') ?? false))) {
          using2fa = true;

          if (response.status == 400) {
            promptFor2fa = 'Invalid 2fa code entered. Please try again.';
            throw Exception(responseError ?? 'Invalid 2fa code');
          }

          // Parse 2FA details
          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('tsv_state')) {
            final tsvState = responseData['tsv_state']?.toString() ?? '';
            final phone = responseData['phone']?.toString() ?? '';
            final prompt = tsvState == 'totp'
                ? 'from your authenticator app'
                : 'sent to $phone via $tsvState';

            promptFor2fa = 'Please enter the code $prompt';
          } else {
            promptFor2fa = 'Please enter the code sent to your text/email';
          }

          throw Exception(
            'Your Ring account is configured to use 2-factor authentication (2fa). '
            'See https://github.com/dgreif/ring/wiki/Refresh-Tokens for details.',
          );
        }

        // Handle other auth errors
        final authTypeMessage = _authOptions is RefreshTokenAuth
            ? 'refresh token is'
            : 'email and password are';

        String errorMessage = 'Failed to fetch oauth token from Ring. ';

        if (responseData is Map<String, dynamic> &&
            responseData['error_description'] ==
                'too many requests from dependency service') {
          errorMessage +=
              'You have requested too many 2fa codes. Ring limits 2fa to 10 codes within 10 minutes. '
              'Please try again in 10 minutes.';
        } else {
          errorMessage += 'Verify that your $authTypeMessage correct.';
        }

        errorMessage += ' (error: $responseError)';
        logError(response);
        logError(errorMessage);
        throw Exception(errorMessage);
      }

      rethrow;
    }
  }

  /// Fetch a new session from Ring servers
  Future<SessionResponse> _fetchNewSession(AuthTokenResponse authToken) async {
    final response = await requestWithRetry<Map<String, dynamic>>(
      RequestOptions(
        url: clientApi('session'),
        method: 'POST',
        json: {
          'device': {
            'hardware_id': await _hardwareIdPromise,
            'metadata': baseSessionMetadata,
            'os': 'android',
          },
        },
        headers: {'authorization': 'Bearer ${authToken.accessToken}'},
      ),
    );

    return ProfileResponse.fromJson(response.data);
  }

  /// Get current session
  Future<SessionResponse> getSession() async {
    final authToken = await _authPromiseFuture;

    try {
      final session = await _fetchNewSession(authToken);
      onSession.add(session);
      return session;
    } catch (e) {
      if (e is ResponseError) {
        final response = e;

        if (response.status == 401) {
          await _refreshAuth();
          return getSession();
        }

        if (response.status == 429) {
          final retryAfter = response.headers?['retry-after'];
          final waitSeconds = retryAfter != null
              ? (int.tryParse(retryAfter) ?? 200)
              : 200;

          logError(
            'Session response rate limited. Waiting to retry after $waitSeconds seconds',
          );
          await delay((waitSeconds + 1) * 1000);

          logInfo('Retrying session request');
          return getSession();
        }
      }
      rethrow;
    }
  }

  /// Refresh authentication
  Future<void> _refreshAuth() async {
    _clearPreviousAuth();
    await _authPromiseFuture;
  }

  /// Refresh session
  void _refreshSession() {
    _sessionPromise = getSession();

    _sessionPromise!
        .then((_) {
          // Refresh the session every 12 hours
          final timeout = Timer(const Duration(hours: 12), () {
            _refreshSession();
          });
          _timeouts.add(timeout);
        })
        .catchError((e) {
          logError(e);
        });
  }

  /// Make an authenticated request to Ring API
  Future<DataResponse<T>> request<T>(RequestOptions options) async {
    final hardwareId = await _hardwareIdPromise;
    final url = options.url;
    final initialSessionPromise = _sessionPromise;

    try {
      if (initialSessionPromise != null) {
        await initialSessionPromise;
      }
      final authTokenResponse = await _authPromiseFuture;

      return await requestWithRetry<T>(
        options.copyWith(
          headers: {
            ...?options.headers,
            'authorization': 'Bearer ${authTokenResponse.accessToken}',
            'hardware_id': hardwareId,
            'User-Agent': 'android:com.ringapp',
          },
        ),
      );
    } catch (e) {
      if (e is ResponseError) {
        final response = e;

        if (response.status == 401) {
          await _refreshAuth();
          return request<T>(options);
        }

        if (response.status == 504) {
          // Gateway Timeout - recoverable
          await delay(5000);
          return request<T>(options);
        }

        if (response.status == 404 &&
            response.body != null &&
            response.body is Map<String, dynamic>) {
          final body = response.body as Map<String, dynamic>;
          if (body.containsKey('errors') && body['errors'] is List) {
            final errors = body['errors'] as List;
            final errorText = errors
                .where(
                  (code) => code is int && ringErrorCodes.containsKey(code),
                )
                .map((code) => ringErrorCodes[code as int])
                .join(', ');

            if (errorText.isNotEmpty) {
              logError(
                'http request failed. $url returned errors: ($errorText). '
                'Trying again in 20 seconds',
              );
              await delay(20000);
              return request<T>(options);
            }
            logError(
              'http request failed. $url returned unknown errors: ${stringify(errors)}.',
            );
          }
        }

        if (response.status == 404 && url.startsWith(clientApiBaseUrl)) {
          logError('404 from endpoint $url');
          if (response.body is Map<String, dynamic>) {
            final body = response.body as Map<String, dynamic>;
            final errorMsg = body['error']?.toString() ?? '';
            if (errorMsg.contains(hardwareId)) {
              logError(
                'Session hardware_id not found. Creating a new session and trying again.',
              );
              if (_sessionPromise == initialSessionPromise) {
                _refreshSession();
              }
              return request<T>(options);
            }
          }
          throw Exception(
            'Not found with response: ${stringify(response.body)}',
          );
        }

        if (response.status != null) {
          logError(
            'Request to $url failed with status ${response.status}. '
            'Response body: ${stringify(response.body)}',
          );
        } else if (!options.allowNoResponse) {
          logError('Request to $url failed:');
          logError(e);
        }
      }

      rethrow;
    }
  }

  /// Get current authentication token
  Future<AuthTokenResponse> getCurrentAuth() {
    return _authPromiseFuture;
  }

  /// Clear all active timers
  void clearTimeouts() {
    for (final timeout in _timeouts) {
      timeout.cancel();
    }
    _timeouts.clear();
  }

  /// Get push notification credentials (internal use only)
  Map<String, dynamic>? get internalOnlyPushNotificationCredentials {
    return _authConfig?.pnc;
  }

  /// Set push notification credentials (internal use only)
  set internalOnlyPushNotificationCredentials(
    Map<String, dynamic>? credentials,
  ) {
    if (refreshToken == null || _authConfig == null) {
      throw Exception(
        'Cannot set push notification credentials without a refresh token',
      );
    }

    final oldRefreshToken = refreshToken;
    _authConfig = _AuthConfig(
      rt: _authConfig!.rt,
      hid: _authConfig!.hid,
      pnc: credentials,
    );

    final newRefreshToken = toBase64(jsonEncode(_authConfig!.toJson()));
    if (newRefreshToken == oldRefreshToken) {
      // No change, so we don't need to emit an updated refresh token
      return;
    }

    // Save and emit the updated refresh token
    refreshToken = newRefreshToken;
    onRefreshTokenUpdated.add(
      RefreshTokenUpdate(
        oldRefreshToken: oldRefreshToken,
        newRefreshToken: newRefreshToken,
      ),
    );
  }

  /// Dispose of resources
  void dispose() {
    clearTimeouts();
    onRefreshTokenUpdated.close();
    onSession.close();
  }
}

/// Type alias for Promise (Future)
typedef Promise<T> = Future<T>;
