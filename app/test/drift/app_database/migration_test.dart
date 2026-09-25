// Шаблон создан `dart run drift_dev make-migrations`; схемы в generated/.
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachotime/data/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

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
}
