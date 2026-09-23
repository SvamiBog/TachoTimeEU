import 'dart:developer' as developer;

/// Отчёты о падениях. Провайдер (Sentry / Crashlytics) подключается позже;
/// до этого ошибки только пишутся в лог.
abstract interface class CrashReporter {
  Future<void> init();

  void recordError(Object error, StackTrace stack, {bool fatal = false});
}

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
