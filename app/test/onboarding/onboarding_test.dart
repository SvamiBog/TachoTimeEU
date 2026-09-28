// Онбординг (экраны 13–14, режимы, главные правила, автоопределение) на
// базе в памяти. План тестов: UI-12, UI-13, UI-14, UI-18 в docs/testing.md.
// «Показывается один раз» — в app_test.dart.

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    show NotificationPermission;
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/onboarding/onboarding_screen.dart';

import '../background/fake_tracking_platform.dart';
import '../support/app_harness.dart';

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

  Future<void> pump(WidgetTester tester) => pumpScreen(
    tester,
    const OnboardingScreen(),
    overrides: databaseOverrides(
      db,
      now: () => DateTime.utc(2026, 9, 23, 8),
      platform: platform,
    ),
  );

  Future<void> tap(WidgetTester tester, String text) async {
    // Шаги — ленивые списки: строки ниже экрана ещё не построены
    if (find.text(text).evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    }
    final finder = find.text(text).first;
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await settle(tester);
    await tester.pumpAndSettle();
  }

  bool selected(WidgetTester tester, String text) => tester
      .getSemantics(find.text(text))
      .flagsCollection
      .isSelected
      .toBoolOrNull()!;

  testWidgets('UI-13: язык, режимы, главные правила, транспорт, тахограф, '
      'пакет мобильности, уведомления, согласие на аналитику (UI-12), '
      'автоопределение, «Готово»', (tester) async {
    platform
      ..notificationPermission = NotificationPermission.denied
      ..notificationAnswer = NotificationPermission.granted;
    await pump(tester);

    // 1. Приветствие (экран 13) и язык
    expect(find.text('Время за рулём — под контролем'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
    expect(find.bySemanticsLabel('Шаг 1 из 5'), findsOneWidget);
    await tap(tester, 'Русский');
    expect(find.text('Как в телефоне'), findsOneWidget);
    await tap(tester, 'Как в телефоне');
    expect(find.text('Как в телефоне'), findsNothing);
    await tap(tester, 'Начать');

    // 2. Режимы и таймеры
    expect(find.text('Четыре режима — как на тахографе'), findsOneWidget);
    for (final mode in ['Вождение', 'Другая работа', 'Готовность', 'Отдых']) {
      expect(find.text(mode), findsOneWidget);
    }
    await tap(tester, 'Далее');

    // 3. Главные правила — значения из движка
    expect(find.text('Главные правила'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
    expect(find.text('Непрерывное вождение'), findsOneWidget);
    expect(find.text('Суточный отдых'), findsOneWidget);
    expect(find.text('Недельный отдых'), findsOneWidget);
    await tap(tester, 'Далее');

    // 4. Настройка (экран 14)
    expect(find.text('Настроим под вас'), findsOneWidget);
    expect(selected(tester, 'Грузовик или автобус'), isTrue);
    expect(selected(tester, 'Цифровой'), isTrue);
    await tap(tester, 'Аналоговый');
    expect(selected(tester, 'Аналоговый'), isTrue);
    await tap(tester, 'Пакет мобильности');
    expect(
      find.textContaining('Предупредим за 30 минут до перерыва'),
      findsOneWidget,
    );
    await tap(tester, 'Разрешить уведомления');
    expect(platform.calls, contains('requestNotificationPermission'));
    expect(find.text('Уведомления разрешены'), findsOneWidget);
    await tap(tester, 'Анонимная статистика');
    await tap(tester, 'Далее');

    // 5. Автоопределение
    expect(find.text('Автоопределение вождения'), findsOneWidget);
    await tap(tester, 'Включить автоопределение');
    expect(find.text('Автоопределение включено'), findsOneWidget);
    expect(find.text('Экономия батареи'), findsOneWidget);
    expect(find.text('Автозапуск и работа в фоне'), findsOneWidget);
    await tap(tester, 'Готово');

    final prefs = (await tester.runAsync(settings.preferences))!;
    expect(prefs.onboardingDone, isTrue);
    expect(prefs.language, isNull);
    expect(prefs.vehicle, VehicleType.truckOrBus);
    expect(prefs.tachograph, TachographType.analog);
    expect(
      (await tester.runAsync(settings.complianceSettings))!.mobilityPackage,
      isFalse,
    );
    expect(
      await tester.runAsync(() => settings.watchAnalyticsConsent().first),
      isTrue,
    );
    expect((await tester.runAsync(settings.autoDetect))!.enabled, isTrue);
    await unmount(tester);
  });

  testWidgets('UI-12: аналитика по умолчанию выключена; автоопределение — '
      'по желанию: без него «Готово» тоже работает', (tester) async {
    await pump(tester);
    await tap(tester, 'Начать');
    await tap(tester, 'Далее');
    await tap(tester, 'Далее');
    await tester.scrollUntilVisible(
      find.text('Анонимная статистика'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    final consent = tester.widget<Switch>(
      find.descendant(
        of: find.ancestor(
          of: find.text('Анонимная статистика'),
          matching: find.byType(InkWell),
        ),
        matching: find.byType(Switch),
      ),
    );
    expect(consent.value, isFalse);
    await tap(tester, 'Далее');
    await tap(tester, 'Готово');

    expect(
      await tester.runAsync(() => settings.watchAnalyticsConsent().first),
      isFalse,
    );
    final auto = (await tester.runAsync(settings.autoDetect))!;
    expect(auto.enabled, isFalse);
    expect(auto.rules.afterStop, DriverMode.otherWork);
    expect((await tester.runAsync(settings.preferences))!.onboardingDone, true);
    await unmount(tester);
  });

  testWidgets('«Назад» и системная кнопка возвращают на прошлый шаг', (
    tester,
  ) async {
    await pump(tester);
    await tap(tester, 'Начать');
    await tap(tester, 'Далее');
    await tap(tester, 'Далее');
    expect(find.text('Настроим под вас'), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Главные правила'), findsOneWidget);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Четыре режима — как на тахографе'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Время за рулём — под контролем'), findsOneWidget);
    expect(find.byTooltip('Назад'), findsNothing);
    await unmount(tester);
  });

  testWidgets('UI-14: отказ в геолокации навсегда — причина и кнопка в '
      'настройки телефона', (tester) async {
    platform.permission = LocationPermission.deniedForever;
    await pump(tester);
    for (final step in ['Начать', 'Далее', 'Далее', 'Далее']) {
      await tap(tester, step);
    }
    await tap(tester, 'Включить автоопределение');
    expect(find.textContaining('Доступ к геолокации запрещён'), findsOne);
    await tap(tester, 'Открыть настройки');
    expect(platform.calls, contains('openAppSettings'));
    expect((await tester.runAsync(settings.autoDetect))!.enabled, isFalse);
    await unmount(tester);
  });

  testWidgets('уведомления: после отказа — настройки системы', (tester) async {
    platform.notificationPermission = NotificationPermission.denied;
    await pump(tester);
    await tap(tester, 'Начать');
    await tap(tester, 'Далее');
    await tap(tester, 'Далее');
    await tap(tester, 'Разрешить уведомления');
    expect(find.text('Уведомления разрешены'), findsNothing);
    await tap(tester, 'Открыть настройки');
    expect(platform.calls, contains('openAppSettings'));
    await unmount(tester);
  });

  testWidgets('UI-18: фургон 2,5–3,5 т — тахограф цифровой без выбора, '
      'пояснение о правилах и переход к проверке рейса', (tester) async {
    await pump(tester);
    for (final step in ['Начать', 'Далее', 'Далее']) {
      await tap(tester, step);
    }
    await tap(tester, 'Аналоговый');
    // Касание прокрутило список — транспорт выше
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 800));
    await tester.pumpAndSettle();
    await tap(tester, 'Фургон 2,5–3,5 т');
    expect(selected(tester, 'Фургон 2,5–3,5 т'), isTrue);
    expect(selected(tester, 'Грузовик или автобус'), isFalse);
    expect(find.text('Тахограф в машине'.toUpperCase()), findsNothing);
    expect(find.text('Аналоговый'), findsNothing);
    expect(find.textContaining('действуют с 01.07.2026'), findsOneWidget);

    var prefs = (await tester.runAsync(settings.preferences))!;
    expect(prefs.vehicle, VehicleType.van);
    expect(prefs.tachograph, TachographType.digital);

    await tap(tester, 'Касаются ли правила вашего рейса');
    expect(find.text('Инструкция и правила'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.text('Инструкция и правила'), findsNothing);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 800));
    await tester.pumpAndSettle();
    await tap(tester, 'Грузовик или автобус');
    expect(find.text('Аналоговый'), findsOneWidget);
    prefs = (await tester.runAsync(settings.preferences))!;
    expect(prefs.vehicle, VehicleType.truckOrBus);
    await unmount(tester);
  });
}
