/// Refresh token acquisition utilities
///
/// This file provides functions for obtaining refresh tokens from Ring API
/// using email/password authentication with optional 2FA support.
library;

import 'dart:io';
import 'rest_client.dart';
import 'ring_types.dart';
import 'util.dart';

/// Acquire a refresh token from Ring API
///
/// This function prompts the user for email and password, handles 2FA if required,
/// and returns a refresh token that can be used for subsequent API calls.
Future<String> acquireRefreshToken() async {
  final email = await requestInput('Email: ');
  final password = await requestInput('Password: ');
  final restClient = RingRestClient(EmailAuth(email: email, password: password));

  Future<AuthTokenResponse> getAuthWith2fa() async {
    final code = await requestInput('2fa Code: ');
    try {
      return await restClient.getAuth(code);
    } catch (_) {
      print('Incorrect 2fa code. Please try again.');
      return getAuthWith2fa();
    }
  }

  try {
    final auth = await restClient.getCurrentAuth();
    restClient.dispose();
    return auth.refreshToken;
  } catch (e) {
    if (restClient.promptFor2fa != null) {
      print(restClient.promptFor2fa!);
      final auth = await getAuthWith2fa();
      restClient.dispose();
      return auth.refreshToken;
    }
    stderr.writeln(e.toString());
    restClient.dispose();
    exit(1);
  }
}

/// Log refresh token acquisition process
///
/// This is typically used by CLI tools to guide users through
/// obtaining a refresh token for configuration.
Future<void> logRefreshToken() async {
  print(
    'This CLI will provide you with a refresh token which you can use to configure ring-client-api.',
  );

  final refreshToken = await acquireRefreshToken();

  print(
    '\nSuccessfully logged in to Ring. Please add the following to your config:\n',
  );
  print('"refreshToken": "$refreshToken"');
}
