// Страна фирмы обязательна: два сокращённых недельных отдыха подряд в ней
// нельзя (ст. 8(6)), рабочие дни считаются относительно неё. Карточка на
// главной, строка в настройках, причина на экране недельного отдыха. Шаг
// онбординга — в onboarding_test. План тестов: UI-28 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/settings/base_country.dart';
import 'package:tachogo/features/settings/settings_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const Duration _h = Duration(hours: 1);
final DateTime t0 = DateTime.utc(2026, 9, 23, 6);

/// Выбор в шторке «Страна фирмы» поиском.
Future<void> pick(WidgetTester tester, String name) async {
  expect(find.text('Страна фирмы'), findsWidgets);
  await tester.enterText(find.byType(TextField), name);
  await tester.pumpAndSettle();
  await tester.tap(find.text(name).last);
  await settle(tester);
  await tester.pumpAndSettle();
}

void main() {
  group('UI-28: страна фирмы', () {
    testWidgets('не выбрана — карточка на главной, выбрал — пропала', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => t0),
      );
      expect(find.byType(BaseCountryCard), findsOneWidget);
      expect(find.text('Укажите страну фирмы'), findsOneWidget);
      await tester.tap(find.text('Укажите страну фирмы'));
      await tester.pumpAndSettle();
      await pick(tester, 'Литва');
      expect(find.text('Укажите страну фирмы'), findsNothing);
      expect(
        (await tester.runAsync(SettingsRepository(db).complianceSettings))!
            .baseCountry,
        'LT',
      );
      await unmount(tester);
    });

    testWidgets('выбрана — карточки нет', (tester) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: const [], now: t0),
      );
      expect(find.text('Укажите страну фирмы'), findsNothing);
    });

    testWidgets('в настройках расчёта — «Не выбрана», потом страна', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpScreen(
        tester,
        const SettingsScreen(),
        overrides: databaseOverrides(db, now: () => t0),
      );
      await tester.scrollUntilVisible(
        find.text('Страна фирмы'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Не выбрана'), findsOneWidget);
      expect(
        find.text(
          'Где зарегистрирована фирма: два сокращённых недельных отдыха '
          'подряд в ней брать нельзя',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Страна фирмы'));
      await tester.pumpAndSettle();
      await pick(tester, 'Румыния');
      expect(find.text('Румыния'), findsOneWidget);
      expect(find.text('Не выбрана'), findsNothing);
      await unmount(tester);
    });

    group('недельный отдых: второй сокращённый подряд', () {
      // Полный 45 ч, смена, сокращённый 24 ч, смена сейчас
      final start = t0.subtract(const Duration(hours: 45 + 13 + 24 + 2));
      final periods = consecutive(start, [
        (DriverMode.rest, _h * 45),
        (DriverMode.otherWork, _h * 13),
        (DriverMode.rest, _h * 24),
        (DriverMode.driving, _h * 2),
      ], open: true);
      final beforeReduced = start.add(_h * 45);
      final current = start.add(_h * (45 + 13 + 24));

      Future<void> pumpWeekly(
        WidgetTester tester,
        String reducedIn,
        String now,
      ) => pumpScreen(
        tester,
        const WeeklyRestScreen(),
        viewport: const Size(412, 2000),
        overrides: journalOverrides(
          periods: periods,
          now: t0,
          shiftMeta: {
            beforeReduced: ShiftMeta(startCountry: reducedIn),
            current: ShiftMeta(startCountry: now),
          },
        ),
      );

      testWidgets('за границей — доступен', (tester) async {
        await pumpWeekly(tester, 'D', 'D');
        expect(find.text('доступен · с компенсацией'), findsOneWidget);
        expect(find.text('в стране фирмы — нужен полный'), findsNothing);
      });

      testWidgets('прошлый в стране фирмы — недоступен, и сказано почему', (
        tester,
      ) async {
        await pumpWeekly(tester, 'PL', 'D');
        expect(find.text('в стране фирмы — нужен полный'), findsOneWidget);
        expect(find.text('доступен · с компенсацией'), findsNothing);
      });

      testWidgets('этот был бы в стране фирмы — тоже', (tester) async {
        await pumpWeekly(tester, 'D', 'PL');
        expect(find.text('в стране фирмы — нужен полный'), findsOneWidget);
      });
    });
  });
}
