// Шаблон создан `dart run drift_dev make-migrations`; схемы в generated/.
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/data/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('миграции схемы без данных', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('с $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('на $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'v1 → v2: записи журнала сохраняются, паром и конец дня — нет',
    () async {
      const start = '2026-09-23T06:49:00.000Z';
      const end = '2026-09-23T09:00:00.000Z';
      const created = '2026-09-23T06:49:00.000Z';
      final oldPeriods = [
        const v1.ActivityPeriodsData(
          id: 1,
          mode: 'driving',
          startUtc: start,
          endUtc: end,
          utcOffsetMinutes: 120,
          source: 'live',
          createdAt: created,
          updatedAt: created,
        ),
        const v1.ActivityPeriodsData(
          id: 2,
          mode: 'rest',
          startUtc: end,
          utcOffsetMinutes: 120,
          source: 'live',
          note: 'стоянка',
          createdAt: created,
          updatedAt: created,
        ),
      ];
      final expected = [
        const v2.ActivityPeriodsData(
          id: 1,
          mode: 'driving',
          startUtc: start,
          endUtc: end,
          utcOffsetMinutes: 120,
          source: 'live',
          ferry: 0,
          dayEnd: 0,
          createdAt: created,
          updatedAt: created,
        ),
        const v2.ActivityPeriodsData(
          id: 2,
          mode: 'rest',
          startUtc: end,
          utcOffsetMinutes: 120,
          source: 'live',
          note: 'стоянка',
          ferry: 0,
          dayEnd: 0,
          createdAt: created,
          updatedAt: created,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.activityPeriods, oldPeriods);
        },
        validateItems: (newDb) async {
          expect(await newDb.select(newDb.activityPeriods).get(), expected);
        },
      );
    },
  );

  test('JRN-04: v2 → v3 — страны смен сохраняются, ручных смен нет', () async {
    const start = '2026-09-22T06:30:00.000Z';
    const periodStart = '2026-09-22T06:30:00.000Z';
    const created = '2026-09-22T06:30:00.000Z';
    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(
            oldDb.shifts,
            const v2.ShiftsData(
              id: 1,
              startUtc: start,
              startCountry: 'PL',
              endCountry: 'D',
              utcOffsetMinutes: 120,
            ),
          )
          ..insert(
            oldDb.activityPeriods,
            const v2.ActivityPeriodsData(
              id: 1,
              mode: 'driving',
              startUtc: periodStart,
              utcOffsetMinutes: 120,
              source: 'live',
              ferry: 0,
              dayEnd: 1,
              createdAt: created,
              updatedAt: created,
            ),
          );
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.shifts).get(), [
          const v3.ShiftsData(
            id: 1,
            startUtc: start,
            startCountry: 'PL',
            endCountry: 'D',
            utcOffsetMinutes: 120,
          ),
        ]);
        expect(await newDb.select(newDb.activityPeriods).get(), hasLength(1));
        expect(await newDb.select(newDb.manualShifts).get(), isEmpty);
      },
    );
  });

  test('ENG-24: v3 → v4 — записи журнала сохраняются, недельной отметки '
      'у них нет', () async {
    const start = '2026-09-30T16:00:00.000Z';
    const created = '2026-09-30T16:00:00.000Z';
    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.activityPeriods,
          const v3.ActivityPeriodsData(
            id: 1,
            mode: 'rest',
            startUtc: start,
            utcOffsetMinutes: 120,
            source: 'live',
            ferry: 0,
            dayEnd: 1,
            createdAt: created,
            updatedAt: created,
          ),
        );
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.activityPeriods).get(), [
          const v4.ActivityPeriodsData(
            id: 1,
            mode: 'rest',
            startUtc: start,
            utcOffsetMinutes: 120,
            source: 'live',
            ferry: 0,
            dayEnd: 1,
            weeklyRest: 0,
            createdAt: created,
            updatedAt: created,
          ),
        ]);
      },
    );
  });
}
