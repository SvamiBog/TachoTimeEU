// Настройки (экран 3) на базе в памяти. План тестов: UI-10, UI-11, UI-12,
// UI-14, UI-16 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show NotificationPermission;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/settings/settings_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';

import '../background/fake_tracking_platform.dart';
import '../notifications/fake_notification_platform.dart';
import '../support/app_harness.dart';

final t0 = DateTime.utc(2026, 9, 23, 12);

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late FakeTrackingPlatform platform;

  setUp(() {
    db = memoryDatabase();
    settings = SettingsRepository(db);
    platform = FakeTrackingPlatform();
  });
  tearDown(() => db.close());

  /// Вождение 3:40 без перерыва и карта, считанная 20 дней назад.
  Future<void> seedJournal(WidgetTester tester) => tester.runAsync(() async {
    await ActivityRepository(
      db,
      clock: () => t0.subtract(const Duration(hours: 3, minutes: 40)),
    ).switchMode(DriverMode.driving);
    await CardDownloadRepository(
      db,
      clock: () => t0.subtract(const Duration(days: 20)),
    ).record();
  });

  Future<void> pump(WidgetTester tester, {Widget? screen}) => pumpScreen(
    tester,
    screen ?? const SettingsScreen(),
    overrides: databaseOverrides(db, now: () => t0, platform: platform),
  );

  ProviderContainer container(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

  /// Прокручивает список до строки: он ленивый, ниже экрана строк нет.
  Future<void> show(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text(text).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await settle(tester);
  }

  /// Предупреждения движка. Экран настроек расчёт не показывает — тест
  /// подписывается сам, как подписана главная.
  Future<void> watchCompliance(WidgetTester tester) async {
    final sub = container(tester).listen(complianceProvider, (_, _) {});
    addTearDown(sub.close);
    await settle(tester);
  }

  Set<InfringementType> warnings(WidgetTester tester) {
    final snapshot = container(tester).read(complianceProvider).value!;
    return {for (final i in snapshot.infringements) i.type};
  }

  group('UI-10: настройки сразу меняют расчёт', () {
    testWidgets('порог 1 час — «скоро перерыв» при 50 мин до 4:30', (
      tester,
    ) async {
      await seedJournal(tester);
      await pump(tester);
      await watchCompliance(tester);
      expect(warnings(tester), isNot(contains(InfringementType.breakSoon)));

      await tapText(tester, '1 час');
      expect(
        (await tester.runAsync(settings.complianceSettings))!.warningLead,
        const Duration(hours: 1),
      );
      expect(warnings(tester), contains(InfringementType.breakSoon));

      await tapText(tester, '15 мин');
      expect(warnings(tester), isNot(contains(InfringementType.breakSoon)));
      await unmount(tester);
    });

    testWidgets('напоминание о карте за 14 дней — до срока 8 дней', (
      tester,
    ) async {
      await seedJournal(tester);
      await pump(tester);
      await watchCompliance(tester);
      expect(warnings(tester), isNot(contains(InfringementType.cardSoon)));

      await tapText(tester, '14 дней');
      expect(warnings(tester), contains(InfringementType.cardSoon));
      await tapText(tester, '3 дня');
      expect(warnings(tester), isNot(contains(InfringementType.cardSoon)));
      await unmount(tester);
    });

    testWidgets('пакет мобильности и экипаж', (tester) async {
      await pump(tester);
      ComplianceSettings current() =>
          container(tester).read(complianceSettingsProvider).value!;
      expect(current().mobilityPackage, isTrue);
      expect(current().crew, CrewMode.solo);

      await tapText(tester, 'Пакет мобильности');
      expect(current().mobilityPackage, isFalse);
      await tapText(tester, 'Экипаж из двух водителей');
      expect(current().crew, CrewMode.team);
      await unmount(tester);
    });

    testWidgets('категории уведомлений и тахограф сохраняются', (tester) async {
      await pump(tester);
      await tapText(tester, 'Аналоговый');
      await tapText(tester, 'Конец рабочего дня');
      await tapText(tester, 'Считывание карты');
      expect(
        await tester.runAsync(() => settings.watchNotifications().first),
        const NotificationSettings(shiftEnd: false, card: false),
      );
      expect(
        (await tester.runAsync(settings.preferences))!.tachograph,
        TachographType.analog,
      );
      await unmount(tester);
    });
  });

  testWidgets('UI-11: оформление «Система / Светлая / Тёмная», по умолчанию '
      'тёмная', (tester) async {
    await pump(tester);
    bool selected(String label) => tester
        .getSemantics(find.text(label))
        .flagsCollection
        .isSelected
        .toBoolOrNull()!;
    expect(selected('Тёмная'), isTrue);

    await tapText(tester, 'Светлая');
    expect(
      (await tester.runAsync(settings.preferences))!.theme,
      ThemeChoice.light,
    );
    expect(selected('Светлая'), isTrue);
    await tapText(tester, 'Система');
    expect(
      (await tester.runAsync(settings.preferences))!.theme,
      ThemeChoice.system,
    );
    await unmount(tester);
  });

  testWidgets('язык: шторка «Как в телефоне» и переводы, выбор сохраняется', (
    tester,
  ) async {
    await pump(tester);
    await tapText(tester, 'Язык');
    expect(find.text('Как в телефоне'), findsOneWidget);
    await tester.tap(find.text('Русский').last);
    await settle(tester);
    await tester.pumpAndSettle();
    expect(find.text('Как в телефоне'), findsNothing);
    expect((await tester.runAsync(settings.preferences))!.language, 'ru');
    await unmount(tester);
  });

  testWidgets('UI-12: согласие на аналитику по умолчанию выключено, '
      'переключатель в настройках', (tester) async {
    await pump(tester);
    await tester.scrollUntilVisible(
      find.text('Анонимная статистика'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    Switch consentSwitch() => tester.widget<Switch>(
      find.descendant(
        of: find.ancestor(
          of: find.text('Анонимная статистика'),
          matching: find.byType(InkWell),
        ),
        matching: find.byType(Switch),
      ),
    );
    expect(consentSwitch().value, isFalse);

    await tapText(tester, 'Анонимная статистика');
    expect(
      await tester.runAsync(() => settings.watchAnalyticsConsent().first),
      isTrue,
    );
    expect(consentSwitch().value, isTrue);
    await unmount(tester);
  });

  group('UI-14: включение автоопределения', () {
    Future<void> enable(WidgetTester tester) =>
        tapText(tester, 'Определять вождение по GPS');

    Future<bool> isEnabled(WidgetTester tester) async =>
        (await tester.runAsync(settings.autoDetect))!.enabled;

    testWidgets('отказ — понятная причина, без кнопки в настройки', (
      tester,
    ) async {
      platform.permissionAnswer = LocationPermission.denied;
      await pump(tester);
      await enable(tester);
      expect(find.textContaining('Без доступа к геолокации'), findsOneWidget);
      expect(find.text('Открыть настройки'), findsNothing);
      expect(await isEnabled(tester), isFalse);
      await unmount(tester);
    });

    testWidgets('отказ навсегда — кнопка в настройки приложения; вернулся '
        'с доступом — причина пропадает', (tester) async {
      platform.permission = LocationPermission.deniedForever;
      await pump(tester);
      await enable(tester);
      expect(find.textContaining('Доступ к геолокации запрещён'), findsOne);
      await tapText(tester, 'Открыть настройки');
      expect(platform.calls, contains('openAppSettings'));

      // Водитель разрешил доступ в настройках и вернулся в приложение
      platform.permission = LocationPermission.whileInUse;
      tester.binding
        ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
        ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(tester);
      expect(find.textContaining('Доступ к геолокации запрещён'), findsNothing);
      await unmount(tester);
    });

    testWidgets('геолокация выключена — кнопка в её настройки', (tester) async {
      platform.locationServiceEnabled = false;
      await pump(tester);
      await enable(tester);
      expect(find.textContaining('Геолокация выключена'), findsOneWidget);
      await tapText(tester, 'Открыть настройки');
      expect(platform.calls, contains('openLocationSettings'));
      await unmount(tester);
    });

    testWidgets('доступ дан — включено, правила и подсказки про батарею и '
        'автозапуск', (tester) async {
      await pump(tester);
      await enable(tester);
      expect(await isEnabled(tester), isTrue);
      expect(platform.calls, contains('startService'));

      await tapText(tester, 'Готовность');
      await tapText(tester, 'Вождение сразу после отдыха');
      final rules = (await tester.runAsync(settings.autoDetect))!.rules;
      expect(rules.afterStop, DriverMode.availability);
      expect(rules.startFromRest, isTrue);

      expect(
        find.textContaining('Уберите TachoGo из списка экономии'),
        findsOneWidget,
      );
      await tapText(tester, 'Экономия батареи');
      expect(platform.calls, contains('openIgnoreBatteryOptimizationSettings'));
      await tapText(tester, 'Автозапуск и работа в фоне');
      expect(platform.calls, contains('openAutostartSettings'));

      // Выключение останавливает сервис и сохраняет правила
      await enable(tester);
      expect(await isEnabled(tester), isFalse);
      expect(platform.calls, contains('stopService'));
      expect(
        (await tester.runAsync(settings.autoDetect))!.rules.startFromRest,
        isTrue,
      );
      expect(find.text('Экономия батареи'), findsNothing);
      await unmount(tester);
    });

    testWidgets('iOS: подсказок про батарею и автозапуск нет', (tester) async {
      platform = FakeTrackingPlatform(isAndroid: false, isIOS: true)
        ..permission = LocationPermission.whileInUse;
      await tester.runAsync(
        () => settings.setAutoDetect(const AutoDetectSettings(enabled: true)),
      );
      await pump(tester);
      await show(tester, 'После остановки');
      expect(find.text('После остановки'), findsOneWidget);
      expect(find.text('Экономия батареи'), findsNothing);
      expect(find.text('Автозапуск и работа в фоне'), findsNothing);
      await unmount(tester);
    });

    testWidgets('включено, но доступ к геолокации отозван — предупреждение', (
      tester,
    ) async {
      await tester.runAsync(
        () => settings.setAutoDetect(const AutoDetectSettings(enabled: true)),
      );
      await pump(tester);
      await show(tester, 'Определять вождение по GPS');
      expect(find.textContaining('Нет доступа к геолокации'), findsOneWidget);
      await unmount(tester);
    });
  });

  group('уведомления запрещены в телефоне', () {
    testWidgets('«Разрешить уведомления» — системный запрос, после '
        'разрешения строка пропадает', (tester) async {
      platform
        ..notificationPermission = NotificationPermission.denied
        ..notificationAnswer = NotificationPermission.granted;
      await pump(tester);
      expect(find.text('Сейчас уведомления запрещены в телефоне'), findsOne);
      await tapText(tester, 'Разрешить уведомления');
      expect(platform.calls, contains('requestNotificationPermission'));
      expect(find.text('Разрешить уведомления'), findsNothing);
      await unmount(tester);
    });

    testWidgets('отказ — дальше только настройки системы', (tester) async {
      platform.notificationPermission = NotificationPermission.denied;
      await pump(tester);
      await tapText(tester, 'Разрешить уведомления');
      expect(find.text('Разрешить уведомления'), findsNothing);
      await tapText(tester, 'Открыть настройки');
      expect(platform.calls, contains('openAppSettings'));
      await unmount(tester);
    });
  });

  group('NTF: точное время уведомлений', () {
    late FakeNotificationPlatform alerts;
    setUp(() => alerts = FakeNotificationPlatform());

    Future<void> pumpWithAlerts(WidgetTester tester) => pumpScreen(
      tester,
      const SettingsScreen(),
      overrides: databaseOverrides(
        db,
        now: () => t0,
        platform: platform,
        notifications: alerts,
      ),
    );

    testWidgets('будильники запрещены — строка; после разрешения пропадает, '
        'расписание — точными будильниками', (tester) async {
      alerts.exactAllowed = false;
      await seedJournal(tester);
      await pumpWithAlerts(tester);
      await show(tester, 'Точное время уведомлений');
      expect(find.textContaining('Будильники и напоминания'), findsOne);
      await tapText(tester, 'Точное время уведомлений');
      expect(alerts.calls, contains('requestExactAlarms'));
      expect(find.text('Точное время уведомлений'), findsNothing);
      expect(alerts.pending, isNotEmpty);
      expect(alerts.pending.values.every((p) => p.exact), isTrue);
      await unmount(tester);
    });

    testWidgets('будильники разрешены — строки нет', (tester) async {
      await pumpWithAlerts(tester);
      await show(tester, 'Перерыв');
      expect(find.text('Точное время уведомлений'), findsNothing);
      await unmount(tester);
    });

    testWidgets('«Конец рабочего дня» — это и недельный отдых', (tester) async {
      await pump(tester);
      await show(tester, 'Конец рабочего дня');
      expect(find.text('Суточный и недельный отдых'), findsOne);
      await unmount(tester);
    });
  });

  testWidgets('экспорт открывает шторку отчёта', (tester) async {
    await pump(tester);
    await tapText(tester, 'Экспорт отчёта');
    expect(find.text('Создать отчёт'), findsOneWidget);
    await unmount(tester);
  });

  group('UI-16: очистка данных', () {
    testWidgets('«Отмена» ничего не удаляет', (tester) async {
      await seedJournal(tester);
      await pump(tester);
      await tapText(tester, 'Очистить все данные');
      expect(find.text('Очистить все данные?'), findsOneWidget);
      await tester.tap(find.text('Отмена'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(
        await tester.runAsync(() => db.select(db.activityPeriods).get()),
        isNotEmpty,
      );
      await unmount(tester);
    });

    testWidgets('после подтверждения журнал пуст, смена не начата, '
        'настройки на месте', (tester) async {
      await seedJournal(tester);
      await tester.runAsync(() => settings.setTheme(ThemeChoice.light));
      await pump(tester, screen: const AppShell());
      expect(find.textContaining('смена с'), findsOneWidget);

      await tester.tap(find.text('Настройки'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Очистить все данные');
      await tester.tap(find.text('Очистить'));
      await settle(tester);
      expect(find.text('Данные удалены'), findsOneWidget);

      expect(
        await tester.runAsync(() => db.select(db.activityPeriods).get()),
        isEmpty,
      );
      expect(
        await tester.runAsync(() => db.select(db.cardDownloads).get()),
        isEmpty,
      );
      expect(
        (await tester.runAsync(settings.preferences))!.theme,
        ThemeChoice.light,
      );

      await tester.tap(find.text('Главная'));
      await settle(tester);
      expect(find.textContaining('смена не начата'), findsOneWidget);
      await unmount(tester);
    });
  });
}
