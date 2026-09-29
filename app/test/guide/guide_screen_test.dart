// Инструкция и правила (экран 17): лимиты из движка, объяснения для тех,
// кто впервые с тахографом, проверка рейса фургона 2,5–3,5 т. План тестов:
// UI-19, UI-20 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/features/guide/guide_screen.dart';

import '../support/app_harness.dart';

final now = DateTime.utc(2026, 9, 23, 12);

void main() {
  Future<void> pump(WidgetTester tester, {DateTime? at}) => pumpScreen(
    tester,
    const GuideScreen(),
    overrides: journalOverrides(periods: const [], now: at ?? now),
  );

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text(text).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  Future<void> show(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  /// Проверка рейса — после правил: прокрутить, чтобы она встала вверху
  /// экрана, вопросы и ответ — под ней.
  Future<void> showCheck(WidgetTester tester) async {
    await show(tester, 'Касаются ли правила вашего рейса');
    await tester.ensureVisible(find.text('Касаются ли правила вашего рейса'));
    await tester.pumpAndSettle();
  }

  /// Какой ответ показывает проверка рейса.
  String? verdict() {
    for (final text in ['Правила действуют', 'Правила не действуют']) {
      if (find.text(text).evaluate().isNotEmpty) return text;
    }
    return null;
  }

  testWidgets('UI-19: лимиты — из EuLimits, как в макете 17', (tester) async {
    await pump(tester);
    expect(find.text('Инструкция и правила'), findsOneWidget);
    expect(find.text('КАК ПОЛЬЗОВАТЬСЯ'), findsOneWidget);
    for (final (value, title) in [
      ('4:30', 'Непрерывное вождение'),
      ('9 ч', 'Вождение за день'),
      ('56 ч', 'Вождение за неделю'),
      ('11 ч', 'Суточный отдых'),
      ('13/15', 'Рабочий день'),
      ('45 ч', 'Недельный отдых'),
      ('144 ч', 'Рабочая неделя'),
      ('28 дн', 'Карта водителя'),
    ]) {
      await show(tester, title);
      expect(find.text(value), findsOneWidget, reason: title);
    }
    expect(
      find.text(
        'Затем перерыв 45 мин. Можно разделить: сначала 15 мин, '
        'потом 30 мин.',
      ),
      findsOneWidget,
    );
    await show(tester, 'Карта водителя');
    expect(
      find.text('Данные карты нужно считывать не реже раза в 28 дней.'),
      findsOneWidget,
    );
  });

  testWidgets('диктор читает лимит длительностью: «4 часа 30 минут»', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    expect(find.bySemanticsLabel('4 часа 30 минут'), findsOneWidget);
    expect(find.bySemanticsLabel('4:30'), findsNothing);
    await show(tester, 'Рабочий день');
    expect(find.bySemanticsLabel('13 или 15 часов'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('UI-19: объяснения для тех, кто впервые с тахографом, и '
      'цвета режимов', (tester) async {
    await pump(tester);
    for (final title in [
      'Карта — в тахографе всю смену',
      'Приложение не заменяет тахограф',
      'Перерыв — только отдых',
      'Где отдыхать',
      'Страны',
    ]) {
      await show(tester, title);
    }
    await show(tester, 'ЦВЕТА И ЗНАЧКИ');
    for (final mode in ['Вождение', 'Отдых', 'Другая работа', 'Готовность']) {
      await show(tester, mode);
    }
    await tester.scrollUntilVisible(
      find.textContaining('Официальный текст правил'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
  });

  group('UI-20: касаются ли правила рейса фургона', () {
    testWidgets('по найму за границу — действуют; внутри страны — нет', (
      tester,
    ) async {
      await pump(tester);
      await showCheck(tester);
      expect(verdict(), 'Правила действуют');
      expect(find.text('Регламент 561/2006, ст. 2(1)(aa)'), findsOneWidget);
      expect(find.text('Вождение — ваша основная работа?'), findsNothing);

      await tapText(tester, 'Внутри страны');
      expect(verdict(), 'Правила не действуют');
      expect(find.textContaining('Проверьте правила своей страны'), findsOne);
    });

    testWidgets('свой груз: исключение ст. 3(ha), только если вождение — не '
        'основная работа', (tester) async {
      await pump(tester);
      await showCheck(tester);
      await tapText(tester, 'Свой груз');
      expect(find.text('Вождение — ваша основная работа?'), findsOneWidget);
      expect(verdict(), 'Правила действуют');

      await tapText(tester, 'Нет');
      expect(verdict(), 'Правила не действуют');
      expect(find.text('Регламент 561/2006, ст. 3(ha)'), findsOneWidget);

      await tapText(tester, 'По найму');
      expect(find.text('Вождение — ваша основная работа?'), findsNothing);
      expect(verdict(), 'Правила действуют');
    });

    testWidgets('некоммерческая перевозка — исключение ст. 3(h)', (
      tester,
    ) async {
      await pump(tester);
      await showCheck(tester);
      await tapText(tester, 'Некоммерческая');
      expect(verdict(), 'Правила не действуют');
      expect(find.text('Регламент 561/2006, ст. 3(h)'), findsOneWidget);
    });

    testWidgets('до 01.07.2026 — фургоны в правила не входили', (tester) async {
      await pump(tester, at: vanRulesFrom.subtract(const Duration(minutes: 1)));
      await showCheck(tester);
      expect(verdict(), 'Правила не действуют');
      expect(
        find.text('До 01.07.2026 фургоны в правила не входили.'),
        findsOneWidget,
      );
    });

    testWidgets('раздел фургона — один для всех, после правил', (tester) async {
      String firstSection() =>
          tester.widgetList<SectionTitle>(find.byType(SectionTitle)).first.text;
      await pump(tester);
      expect(firstSection(), 'Как пользоваться');
      expect(find.text('ФУРГОН 2,5–3,5 Т'), findsNothing);
      await show(tester, 'ФУРГОН 2,5–3,5 Т');
      expect(find.text('Касаются ли правила вашего рейса'), findsOneWidget);
    });
  });
}
