// Sentry: без персональных данных, окружение, фоновый изолят, уровень
// fatal. План тестов: OBS-04 в docs/testing.md.
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tachogo/core/observability/sentry_crash_reporter.dart';

const _dsn = 'https://public@o0.ingest.de.sentry.io/1';

void main() {
  SentryFlutterOptions configured({bool backgroundIsolate = false}) {
    final options = SentryFlutterOptions();
    SentryCrashReporter(
      _dsn,
      environment: 'staging',
      backgroundIsolate: backgroundIsolate,
    ).configure(options);
    return options;
  }

  test('DSN, окружение и никаких персональных данных', () {
    final o = configured();
    expect(o.dsn, _dsn);
    expect(o.environment, 'staging');
    expect(o.sendDefaultPii, isFalse);
    expect(o.autoInitializeNativeSdk, isTrue);
  });

  test('в фоновом изоляте нативный SDK повторно не поднимается', () {
    expect(
      configured(backgroundIsolate: true).autoInitializeNativeSdk,
      isFalse,
    );
  });

  group('уровень ошибки', () {
    final events = <SentryEvent>[];

    setUp(() async {
      events.clear();
      await Sentry.init((o) {
        o
          ..dsn = _dsn
          ..beforeSend = (event, hint) {
            events.add(event);
            return null;
          };
      });
    });
    tearDown(Sentry.close);

    Future<SentryEvent> record({required bool fatal}) async {
      SentryCrashReporter(
        _dsn,
        environment: 'staging',
      ).recordError(StateError('x'), StackTrace.current, fatal: fatal);
      for (var i = 0; i < 50 && events.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      return events.single;
    }

    test('fatal — уровень fatal', () async {
      expect((await record(fatal: true)).level, SentryLevel.fatal);
    });

    test('обычная ошибка — не fatal', () async {
      expect((await record(fatal: false)).level, isNot(SentryLevel.fatal));
    });
  });
}
