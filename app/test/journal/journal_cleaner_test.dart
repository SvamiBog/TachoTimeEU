// «Очистить все данные». План тестов: UI-16 в docs/testing.md (экран —
// settings/settings_screen_test.dart).
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_cleaner.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 9, 23, 8);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('журнал, ручные смены, страны и считывания удалены, настройки '
      'остались, сервису сообщено', () async {
    final settings = SettingsRepository(db);
    await settings.setTheme(ThemeChoice.light);
    await settings.updateComplianceSettings(mobilityPackage: false);
    await settings.setAnalyticsConsent(granted: true);

    await ActivityRepository(
      db,
      clock: () => now,
    ).switchMode(DriverMode.driving);
    await CardDownloadRepository(db, clock: () => now).record();
    final edits = JournalEditRepository(db, settings, clock: () => now);
    await edits.saveManualShift(
      ManualShift(
        start: DateTime.utc(2026, 9, 10, 6),
        end: DateTime.utc(2026, 9, 10, 16),
        driving: const Duration(hours: 8),
      ),
      const ShiftMeta(startCountry: 'PL', note: 'до установки'),
    );
    await edits.setShiftMeta(now, const ShiftMeta(startCountry: 'D'));
    expect(await db.select(db.manualShifts).get(), isNotEmpty);
    expect(await db.select(db.shifts).get(), isNotEmpty);

    var changed = 0;
    await JournalCleaner(db, onChanged: () => changed++).clearAll();

    expect(await db.select(db.activityPeriods).get(), isEmpty);
    expect(await db.select(db.manualShifts).get(), isEmpty);
    expect(await db.select(db.shifts).get(), isEmpty);
    expect(await db.select(db.cardDownloads).get(), isEmpty);
    expect(changed, 1);

    expect((await settings.preferences()).theme, ThemeChoice.light);
    expect((await settings.complianceSettings()).mobilityPackage, isFalse);
    expect(await settings.watchAnalyticsConsent().first, isTrue);
  });
}
