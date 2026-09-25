import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';

/// Отчёты о падениях в Sentry. Организация заведена в регионе ЕС — регион
/// задаёт DSN. Персональных данных нет: IP не передаётся, скриншоты
/// и дерево виджетов не прикладываются (так в Sentry по умолчанию).
///
/// Перехватчики ошибок Flutter ставит `main.dart` после [init] — они
/// заменяют встроенные в Sentry, поэтому каждая ошибка уходит один раз.
class SentryCrashReporter implements CrashReporter {
  new(this._dsn, {required this._environment});

  final String _dsn;
  final String _environment;

  @override
  Future<void> init() => SentryFlutter.init((options) {
    options
      ..dsn = _dsn
      ..environment = _environment
      ..sendDefaultPii = false;
  });

  @override
  void recordError(Object error, StackTrace stack, {bool fatal = false}) {
    unawaited(
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          if (fatal) scope.level = SentryLevel.fatal;
        },
      ),
    );
  }
}
