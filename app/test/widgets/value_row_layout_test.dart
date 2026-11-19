// Строка карточки со значением справа (core/widgets/value_row_layout.dart):
// в одну строку, как Row; на узком экране или с крупным шрифтом чип и
// значение уходят под название, а не выталкивают строку за край.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/value_row_layout.dart';

/// Название: самое длинное слово — 80 dp, целиком — 130 dp.
const _title = Text('Rest duration', style: TextStyle(fontSize: 10));
const _chip = SizedBox(key: Key('chip'), width: 40, height: 20);
const _value = SizedBox(key: Key('value'), width: 50, height: 30);

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required double width,
    Widget? chip = _chip,
    TextDirection direction = TextDirection.ltr,
  }) => tester.pumpWidget(
    Directionality(
      textDirection: direction,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: ValueRowLayout(text: _title, chip: chip, value: _value),
        ),
      ),
    ),
  );

  Rect rectOf(WidgetTester tester, String key) =>
      tester.getRect(find.byKey(Key(key)));

  testWidgets('всё помещается — одна строка, как Row: значение у правого '
      'края, чип перед ним, всё по центру строки', (tester) async {
    await pump(tester, width: 300);
    final text = tester.getRect(find.text('Rest duration'));
    final chip = rectOf(tester, 'chip');
    final value = rectOf(tester, 'value');

    expect(tester.getSize(find.byType(ValueRowLayout)), const Size(300, 30));
    expect(value.right, 300);
    expect(chip.right, value.left - AppSpacing.s8);
    expect(text.left, 0);
    expect(text.center.dy, value.center.dy);
    expect(chip.center.dy, value.center.dy);
  });

  testWidgets('слово названия не помещается рядом — чип и значение строкой '
      'под названием: чип слева, значение справа', (tester) async {
    await pump(tester, width: 150);
    final text = tester.getRect(find.text('Rest duration'));
    final chip = rectOf(tester, 'chip');
    final value = rectOf(tester, 'value');

    expect(value.top, text.bottom + AppSpacing.s4);
    expect(value.right, 150);
    expect(chip.left, 0);
    expect(chip.center.dy, value.center.dy);
    expect(tester.getSize(find.byType(ValueRowLayout)).height, value.bottom);
    expect(tester.takeException(), isNull);
  });

  testWidgets('без чипа значение так же уходит под название', (tester) async {
    await pump(tester, width: 120, chip: null);
    final text = tester.getRect(find.text('Rest duration'));
    final value = rectOf(tester, 'value');

    expect(value.top, text.bottom + AppSpacing.s4);
    expect(value.right, 120);
  });

  testWidgets('чип и значение не помещаются рядом — чип своей строкой, '
      'не сокращается; значение под ним справа', (tester) async {
    await pump(tester, width: 90);
    final text = tester.getRect(find.text('Rest duration'));
    final chip = rectOf(tester, 'chip');
    final value = rectOf(tester, 'value');

    expect(chip.topLeft, Offset(0, text.bottom + AppSpacing.s4));
    expect(chip.width, 40);
    expect(value.top, chip.bottom + AppSpacing.s4);
    expect(value.right, 90);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ширина по содержимому: самое узкое — длинное слово названия '
      'или самая широкая часть, самое широкое — всё в строку', (tester) async {
    await pump(tester, width: 300);
    final row = tester.renderObject<RenderValueRow>(
      find.byType(ValueRowLayout),
    );
    expect(row.getMinIntrinsicWidth(double.infinity), 80);
    expect(
      row.getMaxIntrinsicWidth(double.infinity),
      130 + AppSpacing.s8 + 40 + AppSpacing.s8 + 50,
    );
    // По высоте — как после раскладки той же ширины
    expect(
      row.getMinIntrinsicHeight(90),
      row.getDryLayout(const BoxConstraints(maxWidth: 90)).height,
    );
  });

  testWidgets('справа налево — зеркально', (tester) async {
    await pump(tester, width: 300, direction: TextDirection.rtl);
    expect(tester.getRect(find.text('Rest duration')).right, 300);
    expect(rectOf(tester, 'value').left, 0);
    expect(rectOf(tester, 'chip').left, 50 + AppSpacing.s8);
  });

  testWidgets('диктор читает название, чип и значение по порядку, даже если '
      'чип появился позже', (tester) async {
    final semantics = tester.ensureSemantics();
    Widget row({required bool chip}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MergeSemantics(
        child: ValueRowLayout(
          text: const Text('Rest'),
          chip: chip ? const Text('short') : null,
          value: const Text('40:00'),
        ),
      ),
    );
    await tester.pumpWidget(row(chip: false));
    await tester.pumpWidget(row(chip: true));
    expect(
      tester.getSemantics(find.byType(ValueRowLayout)),
      isSemantics(label: 'Rest\nshort\n40:00'),
    );
    semantics.dispose();
  });
}
