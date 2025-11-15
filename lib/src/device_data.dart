/// Device data logging utilities
///
/// This file provides functionality to log device data from Ring accounts
/// for debugging and discovering new device types. Data is anonymized.
library;

import 'dart:convert';

/// List of sensitive fields that should be stripped from device data
const List<String> sensitiveFields = [
  'id',
  'device_id',
  'latitude',
  'longitude',
  'address',
  'email',
  'time_zone',
  'location_id',
  'serialNumber',
  'catalogId',
  'adapterZid',
  'fingerprint',
  'owner',
  'ssid',
  'ap_address',
  'codes',
  'groupId',
  'group',
  'groupMembers',
];

/// Strip sensitive fields from device data
///
/// This function recursively removes or anonymizes sensitive information
/// from device data to make it safe for logging and debugging.
void stripSensitiveFields(dynamic input) {
  if (input is Map) {
    final Map<String, dynamic> map = input as Map<String, dynamic>;
    final keysToRemove = <String>[];
    final keysToRename = <String, String>{};

    for (final key in map.keys) {
      // Remove sensitive fields
      if (sensitiveFields.contains(key) || key.endsWith('_id')) {
        keysToRemove.add(key);
        continue;
      }

      final data = map[key];

      // Anonymize UUID-like keys (36 characters)
      if (key.length == 36) {
        final newKey = '${key.substring(0, 13)}-uuid';
        keysToRename[key] = newKey;
      }

      // Anonymize UUID-like values
      if (data is String && data.length == 36) {
        map[key] = '${data.substring(0, 13)}-uuid';
      } else {
        // Recursively strip nested objects
        stripSensitiveFields(data);
      }
    }

    // Apply removals and renames
    for (final key in keysToRemove) {
      map.remove(key);
    }

    for (final entry in keysToRename.entries) {
      map[entry.value] = map[entry.key];
      map.remove(entry.key);
    }
  } else if (input is List) {
    for (final item in input) {
      stripSensitiveFields(item);
    }
  }
}

/// Get anonymized device data for debugging
///
/// This function takes locations and amazonKeyLocks data and anonymizes it
/// by stripping sensitive fields before returning as JSON.
String getAnonymizedDeviceData(dynamic locations, dynamic amazonKeyLocks) {
  final results = {'locations': locations, 'amazonKeyLocks': amazonKeyLocks};

  stripSensitiveFields(results);

  return jsonEncode(results);
}

/// Log device data from Ring account for debugging
///
/// This CLI tool fetches all device data from a Ring account,
/// anonymizes it, and outputs it for debugging and discovering new device types.
///
/// Note: This function is defined here but should be called from a CLI script
/// in the bin/ directory to avoid circular dependencies.
