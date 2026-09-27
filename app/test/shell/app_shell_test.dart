// Нижняя навигация. План тестов: UI-17 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

void main() {
  testWidgets(
    'UI-17: «Главная · Журнал · Настройки · Ещё», переход не сбрасывает '
    'прокрутку',
    (tester) async {
      final week = designWeek(driving: true);
      await pumpScreen(
        tester,
        const AppShell(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(bar.destinations.map((d) => (d as NavigationDestination).label), [
        'Главная',
        'Журнал',
        'Настройки',
        'Ещё',
      ]);
      expect(bar.selectedIndex, 0);

      ScrollPosition homeScroll() => tester
          .state<ScrollableState>(
            find.descendant(
              of: find.byType(HomeScreen),
              matching: find.byType(Scrollable),
            ),
          )
          .position;
      await tester.drag(find.byType(HomeScreen), const Offset(0, -600));
      await tester.pumpAndSettle();
      final offset = homeScroll().pixels;
      expect(offset, greaterThan(0));

      for (final (i, tab) in ['Журнал', 'Настройки', 'Ещё'].indexed) {
        await tester.tap(
          find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text(tab),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<NavigationBar>(find.byType(NavigationBar))
              .selectedIndex,
          i + 1,
        );
        expect(switch (tab) {
          'Журнал' => find.byType(JournalScreen),
          'Настройки' => find.byType(SettingsScreen),
          _ => find.descendant(
            of: find.byType(TabPlaceholder),
            matching: find.text(tab),
          ),
        }, findsOneWidget);
        expect(find.byType(HomeScreen), findsNothing);
      }

      await tester.tap(find.text('Главная'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(homeScroll().pixels, offset);
    },
  );
}
