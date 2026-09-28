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

    test('не повторяется, когда меняются другие настройки (REP-04)', () async {
      final values = <AutoDetectSettings>[];
      final sub = repo.watchAutoDetect().listen(values.add);
      addTearDown(sub.cancel);
      await pumpEventQueue();

      await repo.setAnalyticsConsent(granted: true);
      await repo.setComplianceSettings(
        const ComplianceSettings(crew: CrewMode.team),
      );
      await pumpEventQueue();
      expect(values, [const AutoDetectSettings()]);

      await repo.setAutoDetect(const AutoDetectSettings(enabled: true));
      await pumpEventQueue();
      expect(values, [
        const AutoDetectSettings(),
        const AutoDetectSettings(enabled: true),
      ]);
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

  group('настройки расчёта по одной', () {
    test('меняется только переданная, остальные остаются', () async {
      await repo.setComplianceSettings(
        const ComplianceSettings(
          crew: CrewMode.team,
          warningLead: Duration(minutes: 15),
        ),
      );
      await repo.updateComplianceSettings(mobilityPackage: false);
      var s = await repo.complianceSettings();
      expect(s.crew, CrewMode.team);
      expect(s.mobilityPackage, isFalse);
      expect(s.warningLead, const Duration(minutes: 15));
      expect(s.cardAlertDays, 7);

      await repo.updateComplianceSettings(
        crew: CrewMode.solo,
        warningLead: const Duration(hours: 1),
        cardAlertDays: 14,
      );
      s = await repo.complianceSettings();
      expect(s.crew, CrewMode.solo);
      expect(s.mobilityPackage, isFalse);
      expect(s.warningLead, const Duration(hours: 1));
      expect(s.cardAlertDays, 14);
    });

    test('смена темы не повторяет настройки расчёта', () async {
      var count = 0;
      final sub = repo.watchComplianceSettings().listen((_) => count++);
      addTearDown(sub.cancel);
      await pumpEventQueue();
      expect(count, 1);

      await repo.setTheme(ThemeChoice.light);
      await repo.setAnalyticsConsent(granted: true);
      await pumpEventQueue();
      expect(count, 1);

      await repo.updateComplianceSettings(cardAlertDays: 3);
      await pumpEventQueue();
      expect(count, 2);
    });
  });

  test('правила автоопределения меняются, включение — нет', () async {
    await repo.setAutoDetect(const AutoDetectSettings(enabled: true));
    await repo.setAutoDetectRules(
      const AutoSwitchSettings(afterStop: DriverMode.rest, startFromRest: true),
    );
    final s = await repo.autoDetect();
    expect(s.enabled, isTrue);
    expect(s.rules.afterStop, DriverMode.rest);
    expect(s.rules.startFromRest, isTrue);
  });

  group('интерфейс: тема, язык, онбординг, транспорт, тахограф', () {
    test('по умолчанию: тёмная тема, язык телефона, онбординг не пройден, '
        'грузовик или автобус, цифровой тахограф', () async {
      expect(await repo.preferences(), const AppPreferences());
      const d = AppPreferences();
      expect(d.theme, ThemeChoice.dark);
      expect(d.language, isNull);
      expect(d.onboardingDone, isFalse);
      expect(d.vehicle, VehicleType.truckOrBus);
      expect(d.tachograph, TachographType.digital);
    });

    test('сохраняются и читаются', () async {
      final prefs = repo.watchPreferences();
      await repo.setTheme(ThemeChoice.system);
      await repo.setLanguage('ru');
      await repo.setOnboardingDone();
      await repo.setTachograph(TachographType.analog);
      expect(
        await prefs.first,
        const AppPreferences(
          theme: ThemeChoice.system,
          language: 'ru',
          onboardingDone: true,
          tachograph: TachographType.analog,
        ),
      );
      expect(
        const AppPreferences(vehicle: VehicleType.van),
        isNot(const AppPreferences()),
      );

      await repo.setLanguage(null);
      expect((await repo.preferences()).language, isNull);
    });

    test('некорректные значения в БД заменяются умолчаниями', () async {
      for (final (key, value) in [
        ('theme', 'sepia'),
        ('language', ''),
        ('onboarding_done', 'yes'),
        ('vehicle', 'tractor'),
        ('tachograph', 'smart3'),
      ]) {
        await db
            .into(db.settings)
            .insertOnConflictUpdate(
              SettingsCompanion.insert(key: key, value: value),
            );
      }
      expect(await repo.preferences(), const AppPreferences());
    });
  });

  test('фургон: тахограф становится цифровым, у грузовика выбор остаётся '
      '(UI-18)', () async {
    await repo.setTachograph(TachographType.analog);
    await repo.setVehicle(VehicleType.van);
    var p = await repo.preferences();
    expect(p.vehicle, VehicleType.van);
    expect(p.tachograph, TachographType.digital);

    await repo.setVehicle(VehicleType.truckOrBus);
    await repo.setTachograph(TachographType.analog);
    p = await repo.preferences();
    expect(p.vehicle, VehicleType.truckOrBus);
    expect(p.tachograph, TachographType.analog);
  });

  test('тип транспорта не пересчитывает таймеры', () async {
    final emitted = <ComplianceSettings>[];
    final sub = repo.watchComplianceSettings().listen(emitted.add);
    await pumpEventQueue();
    await repo.setVehicle(VehicleType.van);
    await pumpEventQueue();
    await sub.cancel();
    expect(emitted, hasLength(1));
  });

  group('уведомления', () {
    test('по умолчанию включены все категории', () async {
      expect(
        await repo.watchNotifications().first,
        const NotificationSettings(),
      );
      const d = NotificationSettings();
      expect([d.breaks, d.shiftEnd, d.driving, d.card], everyElement(isTrue));
    });

    test('сохраняются и читаются', () async {
      const saved = NotificationSettings(shiftEnd: false, card: false);
      await repo.setNotifications(saved);
      expect(await repo.watchNotifications().first, saved);
      expect(
        saved.copyWith(card: true),
        const NotificationSettings(shiftEnd: false),
      );
    });
  });
}
