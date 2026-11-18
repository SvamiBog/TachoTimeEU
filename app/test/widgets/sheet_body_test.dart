// Тело шторки (core/widgets/sheet_body.dart): диктор объявляет шторку
// отдельным экраном с названием, содержимое — на ширину шторки за
// вычетом полей, длинное прокручивается.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/sheet_body.dart';

import '../support/app_harness.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget sheet) => pumpScreen(
    tester,
    Scaffold(
      body: Align(alignment: Alignment.bottomCenter, child: sheet),
    ),
    overrides: const [],
  );

  testWidgets('шторка — отдельный экран для диктора с названием', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      const SheetBody(label: 'Экспорт отчёта', children: [Text('Период')]),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Экспорт отчёта')),
      isSemantics(label: 'Экспорт отчёта', scopesRoute: true, namesRoute: true),
    );
    semantics.dispose();
  });

  testWidgets('содержимое — на ширину шторки за вычетом полей', (tester) async {
    await pump(
      tester,
      const SheetBody(label: 'Шторка', children: [Text('Период')]),
    );
    final text = tester.getRect(find.text('Период'));
    final width = tester.getSize(find.byType(Scaffold)).width;
    expect(text.left, AppSpacing.screenPadding + 4);
    expect(text.right, width - (AppSpacing.screenPadding + 4));
  });

  testWidgets('длинное содержимое прокручивается', (tester) async {
    await pump(
      tester,
      const SheetBody(
        label: 'Шторка',
        children: [SizedBox(height: 3000), Text('Внизу')],
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Внизу'), 500);
    expect(find.text('Внизу'), findsOneWidget);
  });
}
