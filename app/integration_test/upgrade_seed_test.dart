// UPG-01, шаг 1 (docs/testing.md, раздел 14): версия до обновления пишет
// журнал в настоящую базу приложения — `AppDatabase()`, как на телефоне
// водителя, — и снимок всех таблиц рядом. Шаг 2 — upgrade_check_test.dart
// новой версии, поставленной поверх, как обновление из Google Play.
// Порядок и установка — tool/integration/upgrade_on_emulator.sh.
//
// Файл запускается из кода прошлой версии: при смене API репозиториев его
// правят вместе с ними. Новая версия сверяет базу со снимком, а не с этими
// значениями, поэтому данные здесь можно менять.

import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

import 'support/upgrade_snapshot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('UPG-01: прошлая версия записала журнал в базу приложения', (
    tester,
  ) async {
    await tester.runAsync(() async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final db = AppDatabase();
      try {
        final settings = SettingsRepository(db);
        await settings.setLanguage('ru');
        await settings.setOnboardingDone();
        await settings.updateComplianceSettings(mobilityPackage: false);
        await settings.setDefaultCountry('PL');

        // Смена с перерывом, паромом и «Завершить день»; отдых идёт
        final start = DateTime.utc(2026, 9, 21, 6);
        var t = start;
        final activity = ActivityRepository(db, clock: () => t);
        await activity.switchMode(DriverMode.driving);
        t = t.add(const Duration(hours: 4, minutes: 30));
        await activity.switchMode(DriverMode.rest);
        t = t.add(const Duration(minutes: 45));
        await activity.switchMode(DriverMode.driving, ferry: true);
        t = t.add(const Duration(hours: 3));
        await activity.endDay();

        final edits = JournalEditRepository(db, settings, clock: () => t);
        await edits.setShiftMeta(
          start,
          const ShiftMeta(
            startCountry: 'PL',
            endCountry: 'D',
            note: 'до обновления',
          ),
        );
        await edits.saveManualShift(
          ManualShift(
            start: DateTime.utc(2026, 9, 14, 6),
            end: DateTime.utc(2026, 9, 14, 16),
            driving: const Duration(hours: 8),
          ),
          const ShiftMeta(startCountry: 'LT'),
        );
        await CardDownloadRepository(
          db,
          clock: () => start.subtract(const Duration(days: 5)),
        ).record();

        final snapshot = await databaseSnapshot(db);
        await (await upgradeSnapshotFile()).writeAsString(jsonEncode(snapshot));
      } finally {
        await db.close();
      }
    });
  });
}
