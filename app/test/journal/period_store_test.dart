// Чтение журнала для расчёта: только нужные движку колонки и свой разбор
// дат — те же записи, что читает Drift. План тестов: DB-04 в
// docs/testing.md.

import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/db/utc_date_time_converter.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/period_store.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> insert(
    DriverMode mode,
    DateTime start,
    DateTime? end, {
    bool ferry = false,
    bool dayEnd = false,
    bool weeklyRest = false,
  }) => db
      .into(db.activityPeriods)
      .insert(
        ActivityPeriodsCompanion.insert(
          mode: mode,
          startUtc: start,
          endUtc: Value(end),
          utcOffsetMinutes: 120,
          source: EntrySource.manual,
          note: const Value('заметка'),
          ferry: Value(ferry),
          dayEnd: Value(dayEnd),
          weeklyRest: Value(weeklyRest),
          createdAt: start,
          updatedAt: end ?? start,
        ),
      );

  /// Журнал так, как его читает Drift: все колонки, даты — его разбором.
  Future<List<ActivityPeriod>> viaDrift() async => [
    for (final r in await orderedPeriods(db).get()) periodFromRow(r),
  ];

  group('DB-04: журнал для расчёта', () {
    test('те же записи, что читает Drift: режимы, отметки, открытая запись, '
        'микросекунды, порядок по началу и id', () async {
      final t = DateTime.utc(2026, 9, 21, 6);
      // Вставлены не по порядку; у двух записей одно начало
      await insert(
        DriverMode.rest,
        t.add(const Duration(hours: 9)),
        null,
        dayEnd: true,
        weeklyRest: true,
      );
      await insert(
        DriverMode.driving,
        t,
        t.add(const Duration(hours: 4, minutes: 30)),
      );
      await insert(
        DriverMode.otherWork,
        t.add(const Duration(hours: 4, minutes: 30)),
        t.add(const Duration(hours: 5, microseconds: 123456)),
        ferry: true,
      );
      await insert(
        DriverMode.availability,
        t.add(const Duration(hours: 5, microseconds: 123456)),
        t.add(const Duration(hours: 9)),
      );
      await insert(DriverMode.rest, t, t.add(const Duration(minutes: 1)));

      final periods = await ActivityRepository(db).periods();

      expect(periods, await viaDrift());
      expect(periods, hasLength(5));
      expect(periods.every((p) => p.start.isUtc), isTrue);
      expect(periods.last.isOpen, isTrue);
      expect([for (final p in periods) p.id], [2, 5, 3, 4, 1]);
    });

    test('поток журнала обновляется после записи', () async {
      final repo = ActivityRepository(db, clock: () => DateTime.utc(2026));
      final seen = <int>[];
      final sub = repo.watchPeriods().listen((p) => seen.add(p.length));
      addTearDown(sub.cancel);
      await pumpEventQueue();
      await repo.switchMode(DriverMode.driving);
      await pumpEventQueue();

      expect(seen, [0, 1]);
    });

    test('дата, записанная не приложением, читается разбором Drift', () async {
      // Без «Z» и со смещением пояса: такие строки пишет не конвертер
      await db.customStatement(
        'INSERT INTO activity_periods (mode, start_utc, end_utc, '
        'utc_offset_minutes, source, created_at, updated_at) VALUES '
        "('driving', '2026-09-21T08:00:00.000+02:00', "
        "'2026-09-21 07:30:00', 0, 'live', "
        "'2026-09-21T06:00:00.000Z', '2026-09-21T06:00:00.000Z')",
      );

      final periods = await ActivityRepository(db).periods();

      expect(periods, await viaDrift());
      expect(periods.single.start, DateTime.utc(2026, 9, 21, 6));
    });
  });

  group('DB-04: разбор даты из базы', () {
    DateTime drift(String raw) =>
        db.typeMapping.read(DriftSqlType.dateTime, raw)!.toUtc();
    DateTime parse(String raw) => parseStoredUtc(raw, drift);

    test('дата UTC — та же, что записана: миллисекунды, микросекунды, '
        'границы года и суток', () {
      final random = Random(561);
      final dates = [
        DateTime.utc(2026, 9, 21, 6),
        DateTime.utc(2026, 12, 31, 23, 59, 59, 999, 999),
        DateTime.utc(2027),
        DateTime.utc(2028, 2, 29, 12, 0, 0, 0, 1),
        DateTime.utc(1970),
        for (var i = 0; i < 2000; i++)
          DateTime.fromMicrosecondsSinceEpoch(
            // 2000…2100 годы, половина — с микросекундами
            946684800000000 +
                random.nextInt(1 << 31) * 1469 * (i.isEven ? 1000 : 1) +
                (i.isEven ? 0 : random.nextInt(1000)),
            isUtc: true,
          ),
      ];
      for (final d in dates) {
        final raw = d.toIso8601String();
        expect(parse(raw), d, reason: raw);
        expect(parse(raw).isUtc, isTrue);
        expect(parse(raw), drift(raw), reason: raw);
      }
    });

    test('другой формат — разбором Drift', () {
      for (final raw in [
        '2026-09-21T08:00:00.000+02:00',
        '2026-09-21 06:00:00',
        '2026-09-21T06:00:00Z',
        '2026-09-21T06:00:00.000',
        '2026-13-21T06:00:00.000Z',
        '2026-09-21T24:00:00.000Z',
        '2026-09-2 T06:00:00.000Z',
        '+022026-09-21T06:00:00.000Z',
      ]) {
        var asked = false;
        final result = parseStoredUtc(raw, (r) {
          asked = true;
          return DateTime.utc(1999);
        });
        expect(asked, isTrue, reason: raw);
        expect(result, DateTime.utc(1999), reason: raw);
      }
    });
  });
}
