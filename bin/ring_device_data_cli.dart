#!/usr/bin/env dart

/// Ring Device Data CLI
///
/// This CLI tool fetches all device data from your Ring account,
/// anonymizes it by removing sensitive information, and outputs it
/// for debugging purposes or discovering new device types.
///
/// The anonymized data is safe to share for troubleshooting.
library;

import 'package:ring_client_api/ring_client_api.dart';
import 'package:ring_client_api/src/refresh_token.dart';
import 'package:ring_client_api/src/device_data.dart';

Future<void> main() async {
  try {
    print(
      'This CLI will log data from your Ring Account to help debug issues and discover new device types.',
    );
    print(
      'The logged data is anonymized and should not compromise your account in any way.',
    );

    final token = await acquireRefreshToken();
    final ringApi = RingApi(RefreshTokenAuth(refreshToken: token));

    print('Successfully logged in. Fetching devices...');

    final locations = await ringApi.getLocations();
    final amazonKeyLocks = await ringApi.fetchAmazonKeyLocks();

    final locationsWithDevices = <Map<String, dynamic>>[];
    for (final location in locations) {
      final devices = await location.getDevices();
      locationsWithDevices.add({
        'name': location.name,
        'cameras': location.cameras.map((camera) {
          try {
            return (camera.data as dynamic).toJson() as Map<String, dynamic>;
          } catch (e) {
            return <String, dynamic>{};
          }
        }).toList(),
        'chimes': location.chimes.map((chime) => chime.data.toJson()).toList(),
        'intercoms': location.intercoms
            .map((intercom) => intercom.data.toJson())
            .toList(),
        'devices': devices.map((device) {
          try {
            return (device.data as dynamic).toJson() as Map<String, dynamic>;
          } catch (e) {
            return <String, dynamic>{};
          }
        }).toList(),
      });
    }

    final anonymizedData = getAnonymizedDeviceData(
      locationsWithDevices,
      amazonKeyLocks,
    );

    print('\nPlease copy and paste everything AFTER THIS LINE:\n');
    print(anonymizedData);

    await ringApi.disconnect();
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
