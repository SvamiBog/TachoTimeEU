import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachotime/data/db/app_database.dart';
import 'package:tachotime/data/db/tables.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('период активности сохраняется и читается в UTC', () async {
    final start = DateTime.utc(2026, 9, 23, 6, 49);
    final now = DateTime.utc(2026, 9, 23, 7);
    await db
        .into(db.activityPeriods)
        .insert(
          ActivityPeriodsCompanion.insert(
            mode: DriverMode.driving,
            startUtc: start,
            utcOffsetMinutes: 120,
            source: EntrySource.live,
            createdAt: now,
            updatedAt: now,
          ),
        );

    final row = await db.select(db.activityPeriods).getSingle();
    expect(row.mode, DriverMode.driving);
    expect(row.startUtc, start);
    expect(row.startUtc.isUtc, isTrue);
    expect(row.endUtc, isNull);
  });

  test('настройка перезаписывается по ключу', () async {
    Future<void> put(String v) => db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: 'theme', value: v),
        );
    await put('dark');
    await put('light');

    final rows = await db.select(db.settings).get();
    expect(rows.single.value, 'light');
  });
}
