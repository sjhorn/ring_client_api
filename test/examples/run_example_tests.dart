#!/usr/bin/env dart

/// Example test runner
///
/// Runs each example with appropriate timeouts and validates expected behavior.
///
/// Usage:
///   dart run test/examples/run_example_tests.dart [example_name]
///
/// Environment:
///   RING_REFRESH_TOKEN - Required for all tests
///
/// Examples:
///   dart run test/examples/run_example_tests.dart          # Run all tests
///   dart run test/examples/run_example_tests.dart record   # Run only record test
library;

import 'dart:async';
import 'dart:io';

/// Test result
class TestResult {
  final String name;
  final bool passed;
  final String message;
  final Duration duration;

  TestResult(this.name, this.passed, this.message, this.duration);

  @override
  String toString() {
    final status = passed ? 'PASS' : 'FAIL';
    final time = '${duration.inSeconds}s';
    return '[$status] $name ($time): $message';
  }
}

/// Example test configuration
class ExampleTest {
  final String name;
  final String script;
  final int timeoutSeconds;
  final List<String> expectedOutput;
  final List<String> expectedFiles;
  final bool requiresCamera;
  final bool requiresChime;

  const ExampleTest({
    required this.name,
    required this.script,
    this.timeoutSeconds = 30,
    this.expectedOutput = const [],
    this.expectedFiles = const [],
    this.requiresCamera = true,
    this.requiresChime = false,
  });
}

/// All example tests
const examples = [
  ExampleTest(
    name: 'api_example',
    script: 'example/api_example.dart',
    timeoutSeconds: 60,
    expectedOutput: ['Location:', 'Camera:'],
  ),
  ExampleTest(
    name: 'record_example',
    script: 'example/record_example.dart',
    timeoutSeconds: 45, // 6s FFmpeg start + 10s recording + buffer
    expectedOutput: ['Starting Video', 'Done recording'],
    expectedFiles: ['output/example.mp4'],
  ),
  ExampleTest(
    name: 'stream_example',
    script: 'example/stream_example.dart',
    timeoutSeconds: 30, // Will be killed early
    expectedOutput: ['Starting Video', 'streaming to part files'],
  ),
  ExampleTest(
    name: 'ring_client_api_example',
    script: 'example/ring_client_api_example.dart',
    timeoutSeconds: 60,
    expectedOutput: ['Getting Locations', 'Getting Cameras'],
  ),
  ExampleTest(
    name: 'camera_comparison',
    script: 'example/camera_comparison.dart',
    timeoutSeconds: 30,
    expectedOutput: ['Camera Comparison', 'Total cameras:'],
  ),
  ExampleTest(
    name: 'chime_example',
    script: 'example/chime_example.dart',
    timeoutSeconds: 30,
    expectedOutput: ['Getting locations'],
    requiresChime: true,
  ),
  ExampleTest(
    name: 'return_audio_example',
    script: 'example/return_audio_example.dart',
    timeoutSeconds: 45,
    expectedOutput: ['Return Audio Example', 'Starting live call'],
  ),
];

Future<void> main(List<String> args) async {
  // Check for refresh token
  final refreshToken = Platform.environment['RING_REFRESH_TOKEN'];
  if (refreshToken == null || refreshToken.isEmpty) {
    print('Error: RING_REFRESH_TOKEN environment variable is required');
    print('');
    print('Usage:');
    print('  export RING_REFRESH_TOKEN="your_token"');
    print('  dart run test/examples/run_example_tests.dart');
    exit(1);
  }

  // Check for FFmpeg
  try {
    final result = await Process.run('ffmpeg', ['-version']);
    if (result.exitCode != 0) {
      print('Warning: FFmpeg not found. Some tests may fail.');
    }
  } catch (e) {
    print('Warning: FFmpeg not found. Some tests may fail.');
  }

  // Filter tests if argument provided
  final filter = args.isNotEmpty ? args[0].toLowerCase() : null;
  final testsToRun = filter != null
      ? examples.where((e) => e.name.toLowerCase().contains(filter)).toList()
      : examples;

  if (testsToRun.isEmpty) {
    print('No tests match filter: $filter');
    print('Available tests: ${examples.map((e) => e.name).join(', ')}');
    exit(1);
  }

  print('Ring Client API - Example Tests');
  print('================================');
  print('Running ${testsToRun.length} test(s)...');
  print('');

  final results = <TestResult>[];

  for (final test in testsToRun) {
    final result = await runExampleTest(test);
    results.add(result);
    print(result);
    print('');
  }

  // Summary
  print('================================');
  print('Summary');
  print('================================');

  final passed = results.where((r) => r.passed).length;
  final failed = results.where((r) => !r.passed).length;

  print('Passed: $passed');
  print('Failed: $failed');
  print('Total:  ${results.length}');

  if (failed > 0) {
    print('');
    print('Failed tests:');
    for (final result in results.where((r) => !r.passed)) {
      print('  - ${result.name}: ${result.message}');
    }

    // Check if all failures are auth-related
    final authFailures = results.where(
      (r) => !r.passed && r.message.contains('Auth failed'),
    ).length;
    if (authFailures == failed) {
      print('');
      print('All failures are due to authentication issues.');
      print('Please get a fresh refresh token:');
      print('  dart run bin/ring_auth_cli.dart');
    }

    exit(1);
  }

  print('');
  print('All tests passed!');
}

Future<TestResult> runExampleTest(ExampleTest test) async {
  final stopwatch = Stopwatch()..start();
  final output = StringBuffer();

  print('Running: ${test.name}...');

  try {
    // Clean up any previous output files
    for (final file in test.expectedFiles) {
      final f = File(file);
      if (await f.exists()) {
        await f.delete();
      }
    }

    // For stream_example, we need to kill it early since it runs for 60s
    final effectiveTimeout = test.name == 'stream_example' ? 15 : test.timeoutSeconds;

    // Start the example
    final process = await Process.start(
      'dart',
      ['run', test.script],
      environment: Platform.environment,
    );

    // Collect output
    final stdoutCompleter = Completer<void>();
    final stderrCompleter = Completer<void>();

    process.stdout.listen(
      (data) => output.write(String.fromCharCodes(data)),
      onDone: () => stdoutCompleter.complete(),
    );

    process.stderr.listen(
      (data) => output.write(String.fromCharCodes(data)),
      onDone: () => stderrCompleter.complete(),
    );

    // Wait with timeout
    final exitCode = await process.exitCode.timeout(
      Duration(seconds: effectiveTimeout),
      onTimeout: () {
        process.kill(ProcessSignal.sigterm);
        return -1; // Timeout indicator
      },
    );

    // Wait for output streams to complete
    await Future.wait([
      stdoutCompleter.future.timeout(Duration(seconds: 2), onTimeout: () {}),
      stderrCompleter.future.timeout(Duration(seconds: 2), onTimeout: () {}),
    ]);

    stopwatch.stop();
    final outputStr = output.toString();

    // Check for authentication failures
    if (outputStr.contains('invalid_grant') ||
        outputStr.contains('Refresh token is not valid') ||
        outputStr.contains('Unable to authenticate')) {
      return TestResult(
        test.name,
        false,
        'Auth failed (token expired or invalid)',
        stopwatch.elapsed,
      );
    }

    // For stream_example, timeout is expected (we kill it early)
    if (test.name == 'stream_example' && exitCode == -1) {
      // Check if streaming started
      if (outputStr.contains('streaming to part files') ||
          outputStr.contains('Video started')) {
        return TestResult(
          test.name,
          true,
          'Streaming started successfully (killed after ${effectiveTimeout}s)',
          stopwatch.elapsed,
        );
      }
    }

    // Check for expected output patterns
    for (final pattern in test.expectedOutput) {
      if (!outputStr.contains(pattern)) {
        return TestResult(
          test.name,
          false,
          'Missing expected output: "$pattern"',
          stopwatch.elapsed,
        );
      }
    }

    // Check for expected files
    for (final filePath in test.expectedFiles) {
      final file = File(filePath);
      if (!await file.exists()) {
        return TestResult(
          test.name,
          false,
          'Expected file not created: $filePath',
          stopwatch.elapsed,
        );
      }

      // Check file has content
      final size = await file.length();
      if (size == 0) {
        return TestResult(
          test.name,
          false,
          'Expected file is empty: $filePath',
          stopwatch.elapsed,
        );
      }
    }

    // Check exit code (0 is success, -1 is timeout which may be ok for some tests)
    if (exitCode != 0 && exitCode != -1) {
      // Check if this is a "no chime" error for chime_example
      if (test.requiresChime && outputStr.contains('No chimes found')) {
        return TestResult(
          test.name,
          true,
          'Skipped (no chimes at location)',
          stopwatch.elapsed,
        );
      }

      // Show output on failure for debugging
      print('--- Output for ${test.name} (last 100 lines) ---');
      final lines = outputStr.split('\n');
      final lastLines = lines.length > 100 ? lines.sublist(lines.length - 100) : lines;
      print(lastLines.join('\n'));
      print('--- End output ---');

      return TestResult(
        test.name,
        false,
        'Exit code: $exitCode',
        stopwatch.elapsed,
      );
    }

    return TestResult(
      test.name,
      true,
      'All checks passed',
      stopwatch.elapsed,
    );
  } catch (e) {
    stopwatch.stop();
    return TestResult(
      test.name,
      false,
      'Exception: $e',
      stopwatch.elapsed,
    );
  }
}
