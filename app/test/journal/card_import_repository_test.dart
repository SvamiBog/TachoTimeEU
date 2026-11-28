import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/card_import_repository.dart';
import 'package:tachogo/data/journal/period_store.dart';

import '../support/app_harness.dart' show memoryDatabase;

DateTime t(int d, int h) => DateTime.utc(2026, 11, d, h);

CardPeriod card(DateTime start, DateTime end, DriverMode mode) =>
    (start: start, end: end, mode: mode, crew: false, slot: CardSlot.driver);

const me = CardHolder(
  cardNumber: '1930317178980001',
  surname: 'KOWALSKI',
  firstNames: 'JAN',
);

void main() {
  late AppDatabase db;
  late CardImportRepository repo;
  var changed = 0;
  final now = DateTime.utc(2026, 11, 12, 9);

  setUp(() {
    db = memoryDatabase();
    changed = 0;
    repo = CardImportRepository(
      db,
      clock: () => now,
      onChanged: () => changed++,
    );
  });
  tearDown(() => db.close());

  Future<void> addPeriod(DateTime start, DateTime? end, DriverMode mode) => db
      .into(db.activityPeriods)
      .insert(
        ActivityPeriodsCompanion.insert(
          mode: mode,
          startUtc: start,
          endUtc: Value(end),
          utcOffsetMinutes: 60,
          source: EntrySource.live,
          createdAt: start,
          updatedAt: start,
        ),
      );

  Future<List<ActivityPeriodRow>> rows() => orderedPeriods(db).get();

  /// Карта за 10.11: отдых, вождение 8–12, отдых до 11.11 6:00.
  final cardDay = [
    card(t(10, 0), t(10, 8), DriverMode.rest),
    card(t(10, 8), t(10, 12), DriverMode.driving),
    card(t(10, 12), t(11, 6), DriverMode.rest),
  ];

  group('BT-24: перенос карты в журнал и «Вернуть как было»', () {
    test('журнал за дни карты — с карты, источник card; вернуть — журнал '
        'как был, со своими id', () async {
      await addPeriod(t(10, 0), t(10, 9), DriverMode.rest);
      await addPeriod(t(10, 9), t(10, 13), DriverMode.driving);
      await addPeriod(t(10, 13), null, DriverMode.rest);
      final before = await rows();
      expect(await repo.canUndo(), isFalse);

      expect(
        await repo.import(cardDay, holder: me),
        CardImportOutcome.imported,
      );
      final after = await rows();
      expect(
        [for (final r in after) r.mode],
        [DriverMode.rest, DriverMode.driving, DriverMode.rest, DriverMode.rest],
      );
      expect(after.take(3).every((r) => r.source == EntrySource.card), isTrue);
      // Идущий отдых продолжается с момента считывания
      expect(after.last.id, before.last.id);
      expect(after.last.startUtc, t(11, 6));
      expect(after.last.endUtc, isNull);
      expect(changed, 1);
      expect(await repo.canUndo(), isTrue);

      expect(await repo.undo(), isTrue);
      expect(await rows(), before);
      expect(await repo.canUndo(), isFalse);
      expect(await repo.undo(), isFalse);
    });

    test('смена итогом на днях карты удаляется — иначе вождение дважды; '
        'вернуть — смена на месте', () async {
      await db
          .into(db.manualShifts)
          .insert(
            ManualShiftsCompanion.insert(
              startUtc: t(10, 6),
              endUtc: Value(t(10, 16)),
              drivingMinutes: 300,
              restKind: RestKind.values.first,
              utcOffsetMinutes: 60,
              createdAt: now,
              updatedAt: now,
            ),
          );
      final shifts = await db.select(db.manualShifts).get();
      await repo.import(cardDay, holder: me);
      expect(await db.select(db.manualShifts).get(), isEmpty);
      await repo.undo();
      expect(await db.select(db.manualShifts).get(), shifts);
    });

    test(
      'карта другого водителя не переносится: журнал привязан к первой',
      () async {
        await repo.import(cardDay, holder: me);
        final journal = await rows();
        const other = CardHolder(
          cardNumber: '9999999999999901',
          surname: 'NOWAK',
          firstNames: 'ADAM',
        );
        expect(
          await repo.import(cardDay, holder: other),
          CardImportOutcome.foreignCard,
        );
        expect(await rows(), journal);
        // Та же карта после замены (другие два последних знака) — своя
        const renewed = CardHolder(
          cardNumber: '1930317178980012',
          surname: 'KOWALSKI',
          firstNames: 'JAN',
        );
        expect(
          await repo.import(cardDay, holder: renewed),
          CardImportOutcome.imported,
        );
      },
    );
  });
}
