// «Ещё» (экран 4): экспорт, инструкция и правила, о приложении с
// лицензиями шрифтов. План тестов: UI-21 в docs/testing.md.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/more/more_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

void main() {
  Future<void> pump(WidgetTester tester) {
    final week = designWeek();
    return pumpScreen(
      tester,
      const MoreScreen(),
      overrides: journalOverrides(periods: week.periods, now: week.now),
    );
  }

  testWidgets('UI-21: экспорт, инструкция, о приложении с версией', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Ещё'), findsOneWidget);
    expect(find.text('Экспорт отчёта'), findsOneWidget);
    expect(find.text('Инструкция и правила'), findsOneWidget);
    expect(find.text('О приложении'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
    expect(find.textContaining('не заменяет тахограф'), findsOneWidget);
  });

  testWidgets('«Инструкция и правила» открывает экран 17, «назад» — '
      'обратно', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Инструкция и правила'));
    await tester.pumpAndSettle();
    expect(find.byType(GuideScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.byType(GuideScreen), findsNothing);
  });

  testWidgets('«Экспорт отчёта» открывает шторку отчёта', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Экспорт отчёта'));
    await tester.pumpAndSettle();
    expect(find.text('Создать отчёт'), findsOneWidget);
  });

  testWidgets('«О приложении» — название, версия и лицензии', (tester) async {
    await pump(tester);
    await tester.tap(find.text('О приложении'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('TachoGo'), findsWidgets);
    expect(find.text('0.1.0'), findsWidgets);
  });

  test('лицензии OFL шрифтов регистрируются из assets', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LicenseRegistry.reset();
    addTearDown(LicenseRegistry.reset);
    registerFontLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    expect({for (final e in entries) ...e.packages}, fontLicenses.keys.toSet());
    for (final e in entries) {
      final text = e.paragraphs.map((p) => p.text).join('\n');
      expect(text, contains('SIL OPEN FONT LICENSE'));
    }
  });
}
