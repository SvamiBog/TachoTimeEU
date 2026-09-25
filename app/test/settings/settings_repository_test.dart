import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SettingsRepository(db);
  });
  tearDown(() => db.close());

  test('согласия на аналитику нет, пока водитель не ответил', () async {
    expect(await repo.watchAnalyticsConsent().first, isFalse);
  });

  test('согласие даётся и отзывается', () async {
    final consent = repo.watchAnalyticsConsent();

    await repo.setAnalyticsConsent(granted: true);
    expect(await consent.first, isTrue);

    await repo.setAnalyticsConsent(granted: false);
    expect(await consent.first, isFalse);
  });

  group('настройки расчёта', () {
    test(
      'по умолчанию: один водитель, пакет мобильности, порог 30 мин',
      () async {
        final s = await repo.complianceSettings();
        expect(s.crew, CrewMode.solo);
        expect(s.mobilityPackage, isTrue);
        expect(s.warningLead, const Duration(minutes: 30));
        expect(s.cardAlertDays, 7);
      },
    );

    test('сохраняются и читаются', () async {
      await repo.setComplianceSettings(
        const ComplianceSettings(
          crew: CrewMode.team,
          mobilityPackage: false,
          warningLead: Duration(minutes: 60),
          cardAlertDays: 3,
        ),
      );
      final s = await repo.watchComplianceSettings().first;
      expect(s.crew, CrewMode.team);
      expect(s.mobilityPackage, isFalse);
      expect(s.warningLead, const Duration(minutes: 60));
      expect(s.cardAlertDays, 3);
    });

    test('некорректные значения в БД заменяются умолчаниями', () async {
      for (final (key, value) in [
        ('crew_mode', 'trio'),
        ('mobility_package', 'yes'),
        ('warning_lead_minutes', '-5'),
        ('card_alert_days', 'abc'),
      ]) {
        await db
            .into(db.settings)
            .insertOnConflictUpdate(
              SettingsCompanion.insert(key: key, value: value),
            );
      }
      final s = await repo.complianceSettings();
      expect(s.crew, CrewMode.solo);
      expect(s.mobilityPackage, isTrue);
      expect(s.warningLead, const Duration(minutes: 30));
      expect(s.cardAlertDays, 7);
    });
  });

  group('автоопределение вождения', () {
    test('выключено, пока водитель не включит', () async {
      final s = await repo.autoDetect();
      expect(s.enabled, isFalse);
      expect(s.rules.afterStop, DriverMode.otherWork);
      expect(s.rules.startFromRest, isFalse);
    });

    test('сохраняется и читается', () async {
      const saved = AutoDetectSettings(
        enabled: true,
        rules: AutoSwitchSettings(
          afterStop: DriverMode.availability,
          startFromRest: true,
        ),
      );
      await repo.setAutoDetect(saved);
      expect(await repo.watchAutoDetect().first, saved);
    });

    test('вождение как режим после остановки не принимается', () async {
      await db
          .into(db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(key: 'auto_after_stop', value: 'driving'),
          );
      expect((await repo.autoDetect()).rules.afterStop, DriverMode.otherWork);
    });
  });
}
