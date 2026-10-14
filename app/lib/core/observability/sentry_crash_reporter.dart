/// Crash reports in Sentry (EU region).
library;

import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';

/// Crash reports in Sentry. The organisation is in the EU region — the DSN sets
/// the region. No personal data: the IP address is not sent, and screenshots
/// and the widget tree are not attached (Sentry's defaults).
///
/// `bootstrap.dart` installs the Flutter error handlers after [init]; they
/// replace Sentry's own, so each error is sent once.
class SentryCrashReporter implements CrashReporter {
  new(this._dsn, {required this._environment, this._backgroundIsolate = false});

  final String _dsn;
  final String _environment;

  /// Фоновый изолят (сервис автоопределения): нативный SDK уже поднят
  /// основным изолятом, повторно его не инициализируем.
  final bool _backgroundIsolate;

  @override
  Future<void> init() => SentryFlutter.init(configure);

  /// Настройки SDK: окружение, без персональных данных, в фоновом изоляте —
  /// без повторной инициализации нативного SDK.
  void configure(SentryFlutterOptions options) => options
    ..dsn = _dsn
    ..environment = _environment
    ..sendDefaultPii = false
    ..autoInitializeNativeSdk = !_backgroundIsolate;

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
