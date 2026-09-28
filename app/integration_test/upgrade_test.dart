// INT-05 (docs/testing.md, раздел 14): обновление поверх версии с прошлой
// схемой БД — данные на месте. Файл базы создаётся схемой v1 (первая
// версия, снимок `drift_schemas/`), как у водителя до обновления, затем его
// открывает приложение текущей версии: миграции идут на SQLite устройства,
// журнал виден на главной и в журнале.
//
// Установку поверх старого APK это не заменяет — проверяем файл базы, а не
// менеджер пакетов. Миграции по шагам и целостность данных — в
// `test/drift/app_database/migration_test.dart`.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/activity_repository.dart';

import '../test/drift/app_database/generated/schema_v1.dart' as v1;
import 'support/harness.dart';

/// Запись журнала в схеме v1: время — строки ISO в UTC.
v1.ActivityPeriodsData period(
  int id,
  String mode,
  DateTime start, [
  DateTime? end,
]) => v1.ActivityPeriodsData(
  id: id,
  mode: mode,
  startUtc: start.toIso8601String(),
  endUtc: end?.toIso8601String(),
  utcOffsetMinutes: 180,
  source: 'live',
  createdAt: start.toIso8601String(),
  updatedAt: (end ?? start).toIso8601String(),
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('INT-05: база v1 открывается текущей версией — смена, режимы и '
      'настройки на месте', (tester) async {
    final path = (await tester.runAsync(() => databasePath('int05')))!;
    await tester.runAsync(() => deleteDatabase(path));

    // До обновления: смена с перерывом и идущий суточный отдых, онбординг
    // пройден, язык — русский.
    final old = v1.DatabaseAtV1(fileExecutor(path));
    await tester.runAsync(
      () => old.batch((b) {
        b
          ..insertAll(old.activityPeriods, [
            period(1, 'driving', monday, monday.add(h(4, 30))),
            period(2, 'rest', monday.add(h(4, 30)), monday.add(h(5, 15))),
            period(3, 'driving', monday.add(h(5, 15)), monday.add(h(9, 45))),
            period(4, 'rest', monday.add(h(9, 45))),
          ])
          ..insertAll(old.settings, [
            const v1.SettingsData(key: 'onboarding_done', value: 'true'),
            const v1.SettingsData(key: 'language', value: 'ru'),
          ])
          ..insert(
            old.cardDownloads,
            v1.CardDownloadsCompanion.insert(
              downloadedAtUtc: monday
                  .subtract(const Duration(days: 3))
                  .toIso8601String(),
            ),
          );
      }),
    );
    expect(old.schemaVersion, 1);
    await tester.runAsync(old.close);

    // После обновления
    final db = openFileDatabase(path);
    addTearDown(db.close);
    final version = await tester.runAsync(
      () => db.customSelect('PRAGMA user_version').getSingle(),
    );
    expect(version!.read<int>('user_version'), db.schemaVersion);

    final periods = (await tester.runAsync(ActivityRepository(db).periods))!;
    expect(periods.map((p) => (p.mode, p.start, p.end, p.ferry, p.dayEnd)), [
      (DriverMode.driving, monday, monday.add(h(4, 30)), false, false),
      (
        DriverMode.rest,
        monday.add(h(4, 30)),
        monday.add(h(5, 15)),
        false,
        false,
      ),
      (
        DriverMode.driving,
        monday.add(h(5, 15)),
        monday.add(h(9, 45)),
        false,
        false,
      ),
      (DriverMode.rest, monday.add(h(9, 45)), null, false, false),
    ]);

    // Главная открылась сразу (онбординг пройден), таймеры — по журналу
    final clock = ScenarioClock(monday.add(h(20)));
    await launchApp(tester, overrides: appOverrides(db, clock: clock));
    final s = await expectScreenMatchesEngine(tester, db, clock.now);
    expect(s.dailyDriving, Duration.zero, reason: 'новая смена не начата');
    expect(s.status, DriverStatus.dailyRest);
    expect(s.cardDaysLeft, 25);

    // Смена до обновления — в журнале: 9:00 вождения
    await tester.tap(find.text(ru.navJournal));
    await settle(tester);
    expect(find.text(formatHm(h(9))), findsWidgets);

    // Запись после обновления идёт в ту же базу
    await tester.tap(find.text(ru.navHome));
    await settle(tester);
    await tapMode(tester, DriverMode.driving);
    final after = (await tester.runAsync(ActivityRepository(db).periods))!;
    expect(after, hasLength(5));
    expect(after[3].end, clock.now);
    expect(after.last.mode, DriverMode.driving);
    // Ручных смен в v1 не было — таблица создана миграцией
    final manual = await tester.runAsync(
      () => db.select(db.manualShifts).get(),
    );
    expect(manual, isEmpty);
  });
}
