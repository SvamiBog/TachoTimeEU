/// Crash reports in Sentry (EU region).
library;

import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';

/// Crash reports in Sentry. The organisation is in the EU region — the DSN sets
/// the region. No personal data: the IP address is not sent, screenshots and
/// the widget tree are not attached (Sentry's defaults), and journal contents
/// are cut out of error texts before an event is sent ([scrubEvent]).
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

  /// Настройки SDK: окружение, без персональных данных и данных журнала
  /// ([scrubEvent]), в фоновом изоляте — без повторной инициализации
  /// нативного SDK.
  void configure(SentryFlutterOptions options) => options
    ..dsn = _dsn
    ..environment = _environment
    ..sendDefaultPii = false
    ..beforeSend = scrubEvent
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

/// Убирает из события данные журнала: текст исключений, сообщение и
/// «хлебные крошки» проходят через [scrubCrashText]. Стоит в `beforeSend`:
/// событие, собранное SDK, уходит уже без них.
SentryEvent? scrubEvent(SentryEvent event, Hint hint) {
  for (final exception in event.exceptions ?? const <SentryException>[]) {
    exception.value = _scrubbed(exception.value);
  }
  final message = event.message;
  if (message != null) message.formatted = scrubCrashText(message.formatted);
  for (final crumb in event.breadcrumbs ?? const <Breadcrumb>[]) {
    crumb.message = _scrubbed(crumb.message);
  }
  return event;
}

String? _scrubbed(String? text) => text == null ? null : scrubCrashText(text);

/// Текст ошибки без данных журнала. Журнал водителя — персональные данные
/// и с телефона не уходит, а исключения несут его куски:
/// - `SqliteException` — параметры запроса: заметки, время, страны записей;
/// - `InvalidDataException` drift — всю строку таблицы;
/// - ошибки движка и переноса — дату и время записей.
/// Сам запрос (drift пишет его с `?` вместо значений), код и причина ошибки
/// остаются: по ним ошибку и разбирают.
String scrubCrashText(String text) => text
    .replaceAll(_sqlParameters, ', parameters: <removed>')
    .replaceAll(_driftRow, 'Sorry, <row> cannot be used')
    .replaceAll(_time, '<time>');

/// Параметры запроса в конце текста `SqliteException`.
final _sqlParameters = RegExp(', parameters: .*', dotAll: true);

/// Строка таблицы в `InvalidDataException`: «Sorry, …Companion(…) cannot be
/// used for that because: …».
final _driftRow = RegExp('Sorry, .*? cannot be used', dotAll: true);

/// Дата с временем или без: «2026-09-23 06:00:00.000Z», «2026-09-23T06:00».
final _time = RegExp(r'\d{4}-\d{2}-\d{2}([ T]\d{2}:\d{2}(:\d{2}(\.\d+)?)?Z?)?');
