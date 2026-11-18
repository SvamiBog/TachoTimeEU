// Общие блоки экранов-списков (core/widgets/sections.dart): шапка вкладки,
// карточка-сводка, строка карточки и строка с числом. Размеры — из
// docs/design/README.md: строка списка ≥ 56 dp, шапка — 64 dp, поля
// экрана и карточки — 16 dp.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/sections.dart';

import '../support/app_harness.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => pumpScreen(
    tester,
    Scaffold(body: ListView(children: [child])),
    overrides: const [],
  );

  testWidgets('шапка вкладки — заголовок для диктора высотой 64 dp', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, const TabTitle('Ещё'));
    expect(tester.getSize(find.byType(TabTitle)).height, 64);
    expect(
      tester.getSemantics(find.text('Ещё')),
      isSemantics(label: 'Ещё', isHeader: true),
    );
    expect(
      tester.getTopLeft(find.text('Ещё')).dx,
      AppSpacing.screenPadding + 4,
    );
    semantics.dispose();
  });

  testWidgets('карточка-сводка растягивает содержимое на ширину карточки', (
    tester,
  ) async {
    await pump(tester, const HeroCard(children: [Text('4:30')]));
    final card = tester.getRect(find.byType(DecoratedBox).first);
    final text = tester.getRect(find.text('4:30'));
    expect(card.left, AppSpacing.screenPadding);
    expect(text.left - card.left, 20);
    expect(card.right - text.right, 20);
  });

  testWidgets('строка карточки — не ниже 56 dp, поля карточки по бокам', (
    tester,
  ) async {
    await pump(tester, const CardRow(child: Text('Перерыв')));
    final row = tester.getRect(find.byType(CardRow));
    expect(row.height, AppSize.listRow);
    expect(
      tester.getTopLeft(find.text('Перерыв')).dx - row.left,
      AppSpacing.cardPadding,
    );
  });

  testWidgets('строка карточки растёт под высокое содержимое', (tester) async {
    await pump(
      tester,
      const CardRow(vertical: 12, child: SizedBox(height: 80)),
    );
    expect(tester.getSize(find.byType(CardRow)).height, 80 + 2 * 12);
  });

  testWidgets('строка с числом: диктор читает число и подпись вместе', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      const CardGroup(children: [CountRow(count: 3, label: 'нарушения')]),
    );
    expect(
      tester.getSemantics(find.byType(CountRow)),
      isSemantics(label: '3\nнарушения'),
    );
    semantics.dispose();
  });
}
