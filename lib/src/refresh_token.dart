/// Refresh token acquisition utilities
///
/// This file provides functions for obtaining refresh tokens from Ring API
/// using email/password authentication with optional 2FA support.
library;

import 'util.dart';

// Note: This file depends on RingRestClient which will be imported
// once we port rest-client.ts. For now, we'll define the interface.

/// Acquire a refresh token from Ring API
///
/// This function prompts the user for email and password, handles 2FA if required,
/// and returns a refresh token that can be used for subsequent API calls.
///
/// This is a placeholder that will be completed once we port rest-client.ts
Future<String> acquireRefreshToken() async {
  logInfo(
    'This function requires RingRestClient which will be available after porting rest-client.ts',
  );
  throw UnimplementedError(
    'acquireRefreshToken will be implemented after rest-client.ts is ported',
  );

  // Future implementation will look like:
  // final email = await requestInput('Email: ');
  // final password = await requestInput('Password: ');
  // final restClient = RingRestClient(email: email, password: password);
  //
  // Future<AuthTokenResponse> getAuthWith2fa() async {
  //   final code = await requestInput('2fa Code: ');
  //   try {
  //     return await restClient.getAuth(code);
  //   } catch (_) {
  //     logInfo('Incorrect 2fa code. Please try again.');
  //     return getAuthWith2fa();
  //   }
  // }
  //
  // try {
  //   final auth = await restClient.getCurrentAuth();
  //   return auth.refreshToken;
  // } catch (e) {
  //   if (restClient.promptFor2fa != null) {
  //     logInfo(restClient.promptFor2fa!);
  //     final auth = await getAuthWith2fa();
  //     return auth.refreshToken;
  //   }
  //   logError(e.toString());
  //   rethrow;
  // }
}

/// Log refresh token acquisition process
///
/// This is typically used by CLI tools to guide users through
/// obtaining a refresh token for configuration.
Future<void> logRefreshToken() async {
  logInfo(
    'This CLI will provide you with a refresh token which you can use to configure ring-client-api.',
  );

  final refreshToken = await acquireRefreshToken();

  logInfo(
    '\nSuccessfully logged in to Ring. Please add the following to your config:\n',
  );
  logInfo('"refreshToken": "$refreshToken"');
}
