/// Crash reporting interface and its log-only fallback.
library;

import 'dart:developer' as developer;

/// Crash reports. Sentry implements it when the build has a DSN
/// (`SentryCrashReporter`); otherwise errors only go to the log.
abstract interface class CrashReporter {
  Future<void> init();

  void recordError(Object error, StackTrace stack, {bool fatal = false});
}

/// Crash reporter that writes errors to the developer log only.
class LogCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {}

  @override
  void recordError(Object error, StackTrace stack, {bool fatal = false}) {
    developer.log(
      fatal ? 'FATAL' : 'error',
      name: 'crash',
      error: error,
      stackTrace: stack,
    );
  }
}
