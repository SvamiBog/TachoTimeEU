// UPG-01, шаг 2 (docs/testing.md, раздел 14): новая версия поставлена
// поверх прошлой, как обновление из Google Play (`adb install -r`, тот же
// пакет и ключ подписи). База и снимок прошлой версии
// (upgrade_seed_test.dart) на месте, миграции прошли на SQLite устройства,
// все строки прошлой версии сохранились, приложение открывается сразу на
// главной с тем же журналом.
//
// Если миграция намеренно меняет значения в колонке, сверку строк ниже
// нужно научить этому — как `test/drift/app_database/migration_test.dart`.

import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';

import 'support/harness.dart';
import 'support/upgrade_snapshot.dart';

/// Таблицы снимка: имя → строки.
Map<String, List<Map<String, Object?>>> tablesOf(Map<String, Object?> s) => {
  for (final MapEntry(:key, :value) in (s['tables']! as Map).entries)
    key as String: [
      for (final row in value as List) (row as Map).cast<String, Object?>(),
    ],
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('UPG-01: после обновления поверх прошлой версии журнал на '
      'месте', (tester) async {
    final file = (await tester.runAsync(upgradeSnapshotFile))!;
    expect(
      file.existsSync(),
      isTrue,
      reason:
          'нет снимка прошлой версии: данные приложения пропали — '
          'приложение переустановлено, а не обновлено',
    );
    final before = jsonDecode(
      (await tester.runAsync(file.readAsString))!,
    ) as Map<String, Object?>;

    // Первое открытие базы новой версией — миграции
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase();
    addTearDown(db.close);
    final after = (await tester.runAsync(() => databaseSnapshot(db)))!;
    expect(after['userVersion'], db.schemaVersion);

    // Каждая строка прошлой версии — на месте, с теми же значениями;
    // новые колонки миграций — дополнительно
    final oldTables = tablesOf(before);
    final newTables = tablesOf(after);
    for (final MapEntry(key: table, value: oldRows) in oldTables.entries) {
      final newRows = newTables[table];
      expect(newRows, isNotNull, reason: 'таблица $table пропала');
      expect(newRows, hasLength(oldRows.length), reason: table);
      for (final (i, old) in oldRows.indexed) {
        for (final MapEntry(key: column, :value) in old.entries) {
          expect(newRows![i][column], value, reason: '$table[$i].$column');
        }
      }
    }
    expect(oldTables['activity_periods'], isNotEmpty);

    // Журнал читается новой версией
    final periods = (await tester.runAsync(ActivityRepository(db).periods))!;
    expect(periods, hasLength(oldTables['activity_periods']!.length));

    // Приложение открывается на главной (онбординг пройден), таймеры — по
    // журналу прошлой версии
    final clock = ScenarioClock(
      periods.last.start.add(const Duration(hours: 1)),
    );
    await launchApp(tester, overrides: appOverrides(db, clock: clock));
    await expectScreenMatchesEngine(tester, db, clock.now);
    await tester.tap(find.text(ru.navJournal));
    await settle(tester);
    expect(find.text(ru.navJournal), findsWidgets);
  });
}
