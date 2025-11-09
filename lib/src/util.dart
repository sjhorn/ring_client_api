/// Utility functions for the Ring Client API
///
/// This file provides logging, UUID generation, hardware ID retrieval,
/// retry logic, and other helper functions.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

/// UUID namespace for generating deterministic UUIDs
const String _uuidNamespace = 'e53ffdc0-e91d-4ce1-bec2-df939d94739d';

/// Logger instance for Ring API
final Logger _logger = Logger('ring');

/// UUID generator instance
const Uuid _uuid = Uuid();

/// Debug mode flag
bool _debugEnabled = false;

/// Set of active timers for cleanup
final Set<Timer> _timers = <Timer>{};

/// Logger interface for custom logging implementations
abstract class RingLogger {
  void logInfo(String message);
  void logError(String message);
}

/// Default logger implementation using the logging package
class _DefaultLogger implements RingLogger {
  @override
  void logInfo(String message) {
    _logger.info(message);
  }

  @override
  void logError(String message) {
    _logger.severe(message);
  }
}

/// Current logger instance
RingLogger _currentLogger = _DefaultLogger();

/// Clear all active timers
void clearTimeouts() {
  for (final timer in _timers) {
    timer.cancel();
  }
  _timers.clear();
}

/// Delay execution for a specified number of milliseconds
Future<void> delay(int milliseconds) {
  final completer = Completer<void>();
  Timer? delayTimer;
  delayTimer = Timer(Duration(milliseconds: milliseconds), () {
    if (delayTimer != null) {
      _timers.remove(delayTimer);
    }
    completer.complete();
  });
  _timers.add(delayTimer);
  return completer.future;
}

/// Log a debug message (only if debug is enabled)
void logDebug(dynamic message) {
  if (_debugEnabled) {
    _currentLogger.logInfo(message.toString());
  }
}

/// Log an info message
void logInfo(dynamic message) {
  _currentLogger.logInfo(message.toString());
}

/// Log an error message
void logError(dynamic message) {
  _currentLogger.logError(message.toString());
}

/// Set a custom logger
void useLogger(RingLogger logger) {
  _currentLogger = logger;
}

/// Enable debug logging
void enableDebug() {
  _debugEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

/// Generate a UUID, optionally from a seed
String generateUuid([String? seed]) {
  if (seed != null) {
    // Generate UUID v5 from seed and namespace
    return _uuid.v5(_uuidNamespace, seed);
  }
  // Generate random UUID v4
  return _uuid.v4();
}

/// Get a hardware ID for this system
///
/// If [systemId] is provided, generates a deterministic UUID from it.
/// Otherwise, attempts to get the system UUID from the platform.
/// Falls back to a random UUID if system UUID cannot be retrieved.
Future<String> getHardwareId([String? systemId]) async {
  if (systemId != null) {
    return generateUuid(systemId);
  }

  try {
    // Try to get a platform-specific hardware ID
    String? hardwareId;

    if (Platform.isMacOS || Platform.isLinux) {
      // Try to get machine ID on Unix-like systems
      try {
        if (Platform.isMacOS) {
          final result = await Process.run('ioreg', [
            '-rd1',
            '-c',
            'IOPlatformExpertDevice',
          ]);
          final output = result.stdout as String;
          final match = RegExp(
            r'"IOPlatformUUID"\s*=\s*"([^"]+)"',
          ).firstMatch(output);
          hardwareId = match?.group(1);
        } else if (Platform.isLinux) {
          // Try /etc/machine-id first
          final machineIdFile = File('/etc/machine-id');
          if (await machineIdFile.exists()) {
            hardwareId = (await machineIdFile.readAsString()).trim();
          } else {
            // Try /var/lib/dbus/machine-id
            final dbusIdFile = File('/var/lib/dbus/machine-id');
            if (await dbusIdFile.exists()) {
              hardwareId = (await dbusIdFile.readAsString()).trim();
            }
          }
        }
      } catch (e) {
        logDebug('Error getting hardware ID: $e');
      }
    } else if (Platform.isWindows) {
      // Try to get Windows machine GUID
      try {
        final result = await Process.run('wmic', ['csproduct', 'get', 'UUID']);
        final output = result.stdout as String;
        final lines = output.split('\n');
        if (lines.length > 1) {
          hardwareId = lines[1].trim();
        }
      } catch (e) {
        logDebug('Error getting hardware ID: $e');
      }
    }

    if (hardwareId == null || hardwareId.isEmpty || hardwareId == '-') {
      logError('Unable to get system uuid. Falling back to random session id');
      return generateUuid();
    }

    return generateUuid(hardwareId);
  } catch (e) {
    logError(
      'Error getting hardware ID: $e. Falling back to random session id',
    );
    return generateUuid();
  }
}

/// Request input from stdin (for CLI tools)
Future<String> requestInput(String question) async {
  stdout.write(question);
  final answer = stdin.readLineSync();
  return answer?.trim() ?? '';
}

/// Convert any data to a string representation
String stringify(dynamic data) {
  if (data is String) {
    return data;
  }

  if (data is List<int>) {
    return utf8.decode(data);
  }

  return jsonEncode(data);
}

/// Map a list of items asynchronously
Future<List<U>> mapAsync<T, U>(
  List<T> records,
  Future<U> Function(T record) asyncMapper,
) {
  return Future.wait(records.map((record) => asyncMapper(record)));
}

/// Generate a random integer
int randomInteger() {
  return (DateTime.now().millisecondsSinceEpoch % 99999999) + 100000;
}

/// Generate a random string of specified length
String randomString(int length) {
  final uuid = generateUuid();
  return uuid.replaceAll('-', '').substring(0, length).toLowerCase();
}

/// Encode string to base64
String toBase64(String input) {
  return base64Encode(utf8.encode(input));
}

/// Decode base64 string
String fromBase64(String encodedInput) {
  return utf8.decode(base64Decode(encodedInput));
}

/// Build a URL query string from a map
String buildSearchString(Map<String, dynamic> search) {
  final params = search.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  return params.isEmpty ? '' : '?$params';
}

/// Retry a function with exponential backoff
Future<T> retryWithDelay<T>(
  Future<T> Function() fn, {
  int maxRetries = 3,
  int initialDelayMs = 1000,
  double backoffMultiplier = 2.0,
}) async {
  int attempt = 0;
  int delayMs = initialDelayMs;

  while (true) {
    try {
      return await fn();
    } catch (e) {
      attempt++;
      if (attempt >= maxRetries) {
        rethrow;
      }

      logDebug('Retry attempt $attempt after error: $e');
      await delay(delayMs);
      delayMs = (delayMs * backoffMultiplier).round();
    }
  }
}
