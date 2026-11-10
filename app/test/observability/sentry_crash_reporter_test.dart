// Sentry: без персональных данных, окружение, фоновый изолят, уровень
// fatal; данные журнала из текста ошибок не уходят. План тестов: OBS-04,
// OBS-07 в docs/testing.md.
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/observability/sentry_crash_reporter.dart';
import 'package:tachogo/data/db/app_database.dart';

import '../support/app_harness.dart';

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

  group('OBS-07: данные журнала не уходят в Sentry', () {
    test('фильтр стоит в настройках SDK', () {
      expect(configured().beforeSend, same(scrubEvent));
      expect(configured(backgroundIsolate: true).beforeSend, same(scrubEvent));
    });

    test('параметры запроса SQLite вырезаются, запрос остаётся', () {
      const text =
          'SqliteException(2067): while executing statement, UNIQUE '
          'constraint failed: shifts.start_utc, constraint failed (code 2067)\n'
          '  Causing statement: INSERT INTO "shifts" ("start_utc", "note") '
          'VALUES (?, ?), parameters: 1790143200, паром до Клайпеды, PL';
      final scrubbed = scrubCrashText(text);
      expect(scrubbed, contains('UNIQUE constraint failed: shifts.start_utc'));
      expect(scrubbed, contains('INSERT INTO "shifts"'));
      expect(scrubbed, isNot(contains('паром')));
      expect(scrubbed, isNot(contains('1790143200')));
      expect(scrubbed, endsWith('parameters: <removed>'));
    });

    test('строка таблицы из ошибки проверки drift вырезается', () {
      const text =
          'InvalidDataException: Sorry, ShiftsCompanion(id: Value.absent(), '
          'note: Value(паром до Клайпеды), startCountry: Value(PLXX)) cannot '
          'be used for that because: \n• startCountry: Must at most be 3 '
          'characters long.';
      final scrubbed = scrubCrashText(text);
      expect(scrubbed, isNot(contains('паром')));
      expect(scrubbed, isNot(contains('PLXX')));
      expect(scrubbed, contains('startCountry: Must at most be 3'));
    });

    test('дата и время записей журнала вырезаются', () {
      final scrubbed = scrubCrashText(
        'Invalid argument (end): раньше start (2026-09-23 06:00:00.000Z): '
        '2026-09-23T05:00:00.000Z, день 2026-09-22',
      );
      expect(scrubbed, isNot(contains('2026')));
      expect(scrubbed, contains('Invalid argument (end): раньше start'));
    });

    test('обычный текст ошибки не меняется', () {
      const text = 'Bad state: No element';
      expect(scrubCrashText(text), text);
    });

    group('в событии', () {
      final events = <SentryEvent>[];

      setUp(() async {
        events.clear();
        await Sentry.init((o) {
          o
            ..dsn = _dsn
            ..beforeSend = (event, hint) {
              events.add(scrubEvent(event, hint)!);
              return null;
            };
        });
      });
      tearDown(Sentry.close);

      Future<String> reported(Object error) async {
        SentryCrashReporter(
          _dsn,
          environment: 'staging',
        ).recordError(error, StackTrace.current);
        for (var i = 0; i < 50 && events.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        return [
          for (final e in events.single.exceptions ?? <SentryException>[])
            e.value ?? '',
        ].join('\n');
      }

      test('ошибка записи в базу — без заметки водителя', () async {
        final db = memoryDatabase();
        addTearDown(db.close);
        final shift = ShiftsCompanion.insert(
          id: const Value(1),
          startUtc: DateTime.utc(2026, 9, 23, 6),
          startCountry: 'PL',
          utcOffsetMinutes: 120,
          note: const Value('паром до Клайпеды'),
        );
        await db.into(db.shifts).insert(shift);
        late Object error;
        try {
          await db.into(db.shifts).insert(shift);
        } on Object catch (e) {
          error = e;
        }
        // Сама ошибка заметку несёт — иначе тест ничего не проверяет
        expect('$error', contains('паром до Клайпеды'));

        final text = await reported(error);
        expect(text, contains('UNIQUE constraint failed'));
        expect(text, isNot(contains('паром')));
      });

      test('ошибка движка — без времени записи', () async {
        late Object error;
        try {
          ActivityPeriod(
            mode: DriverMode.rest,
            start: DateTime.utc(2026, 9, 23, 6),
            end: DateTime.utc(2026, 9, 23, 5),
          );
        } on Object catch (e) {
          error = e;
        }
        expect('$error', contains('2026-09-23'));

        final text = await reported(error);
        expect(text, contains('Invalid argument'));
        expect(text, isNot(contains('2026-09-23')));
      });
    });
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
