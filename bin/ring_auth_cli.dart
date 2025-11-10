#!/usr/bin/env dart
/// Ring Authentication CLI
///
/// This CLI tool helps you obtain a refresh token for use with ring_client_api.
/// It will prompt for your Ring email and password, handle 2FA if required,
/// and output a refresh token that can be saved for future use.
library;

import 'package:ring_client_api/src/refresh_token.dart';

Future<void> main() async {
  try {
    await logRefreshToken();
  } catch (e) {
    print('Error: $e');
    // Exit with error code
    rethrow;
  }
}
