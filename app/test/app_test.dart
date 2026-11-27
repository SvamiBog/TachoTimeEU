// Запуск приложения. План тестов: UI-11, UI-13 в docs/testing.md.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/onboarding/onboarding_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';

import 'support/app_harness.dart';

void main() {
  Future<void> launch(WidgetTester tester, List<Override> overrides) async {
    // Телефон на русском: язык при первом запуске — как в телефоне
    tester.platformDispatcher.localesTestValue = const [Locale('ru')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const TachoGoApp()),
    );
    await settle(tester);
  }

  testWidgets('первый запуск — онбординг; после «Готово» — главная с пустым '
      'журналом, и онбординг больше не показывается', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final overrides = databaseOverrides(
      db,
      now: () => DateTime.utc(2026, 9, 23, 8),
    );
    await launch(tester, overrides);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);

    for (final button in ['Начать', 'Далее', 'Далее']) {
      await tester.tap(find.text(button));
      await settle(tester);
    }
    // Страна фирмы обязательна: без неё «Далее» на настройке не нажать
    await tester.ensureVisible(find.text('Страна фирмы'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Страна фирмы'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Польша');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Польша').last);
    await settle(tester);
    await tester.pumpAndSettle();
    for (final button in ['Далее', 'Готово']) {
      await tester.tap(find.text(button));
      await settle(tester);
    }
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('TachoGo'), findsOneWidget);
    expect(find.text('ДО ПЕРЕРЫВА'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
    expect((await SettingsRepository(db).preferences()).onboardingDone, isTrue);

    // Новый запуск на той же базе
    await unmount(tester);
    await launch(tester, overrides);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(AppShell), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('журнал читается с первого кадра, не дожидаясь настроек и '
      'главной', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: databaseOverrides(db, now: () => DateTime.utc(2026, 9, 23, 8)),
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TachoGoApp(),
      ),
    );
    // Настройки ещё не прочитаны: на экране нет ни онбординга, ни главной
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(AppShell), findsNothing);
    for (final source in journalSources) {
      expect(container.exists(source), isTrue, reason: '$source');
    }
    await settle(tester);
    await unmount(tester);
  });

  testWidgets('свёрнутое приложение останавливает часы, открытое — '
      'запускает', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: databaseOverrides(db, now: () => DateTime.utc(2026, 9, 23, 8)),
    );
    addTearDown(container.dispose);
    addTearDown(
      () => tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      ),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TachoGoApp(),
      ),
    );
    await settle(tester);
    expect(container.read(appVisibleProvider), isTrue);

    // Шторка уведомлений или системный диалог: приложение ещё видно
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    expect(container.read(appVisibleProvider), isTrue);
    for (final hidden in [AppLifecycleState.hidden, AppLifecycleState.paused]) {
      tester.binding.handleAppLifecycleStateChanged(hidden);
      expect(container.read(appVisibleProvider), isFalse, reason: '$hidden');
    }
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(container.read(appVisibleProvider), isTrue);
    await unmount(tester);
  });

  testWidgets('UI-11: тема из настроек — по умолчанию тёмная, светлая и '
      '«система» по выбору', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final repo = SettingsRepository(db);
    await tester.runAsync(repo.setOnboardingDone);
    await launch(
      tester,
      databaseOverrides(db, now: () => DateTime.utc(2026, 9, 23, 8)),
    );
    ThemeMode mode() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(AppShell))).brightness;
    expect(mode(), ThemeMode.dark);
    expect(brightness(), Brightness.dark);

    await tester.runAsync(() => repo.setTheme(ThemeChoice.light));
    await settle(tester);
    await tester.pumpAndSettle();
    expect(mode(), ThemeMode.light);
    expect(brightness(), Brightness.light);

    // «Система» следует за телефоном
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.runAsync(() => repo.setTheme(ThemeChoice.system));
    await settle(tester);
    await tester.pumpAndSettle();
    expect(mode(), ThemeMode.system);
    expect(brightness(), Brightness.dark);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
    await unmount(tester);
  });

  test('язык: из настроек, если есть перевод; иначе — как в телефоне', () {
    expect(localeOf('ru'), const Locale('ru'));
    expect(localeOf(null), isNull);
    expect(localeOf('xx'), isNull);
  });
}
