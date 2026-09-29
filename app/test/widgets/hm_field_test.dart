// Поле «Ч:ММ» с цифровой клавиатуры (время смены, вождение за день,
// корректировки). Ввод — как с клавиатуры телефона: цифра встаёт на место
// выделения или курсора. План тестов: JRN-08 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/widgets/hm_field.dart';

import '../support/app_harness.dart';

void main() {
  late Duration? value;

  Future<void> pump(WidgetTester tester, Duration initial) async {
    value = initial;
    await pumpScreen(
      tester,
      Scaffold(
        body: Center(
          child: HmField(
            label: 'Вождение за день',
            value: initial,
            clock: false,
            maxHours: 99,
            autofocus: true,
            onChanged: (v) => value = v,
          ),
        ),
      ),
      overrides: const [],
    );
    await tester.pumpAndSettle();
  }

  TextEditingValue editing(WidgetTester tester) => tester
      .state<EditableTextState>(find.byType(EditableText))
      .textEditingValue;

  /// Цифра, как её отдаёт клавиатура: на место выделения или курсора.
  Future<void> type(WidgetTester tester, String digits) async {
    for (final digit in digits.split('')) {
      final v = editing(tester);
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: v.text.replaceRange(v.selection.start, v.selection.end, digit),
          selection: TextSelection.collapsed(offset: v.selection.start + 1),
        ),
      );
      await tester.pump();
    }
  }

  testWidgets('касание поля, уже стоящего в фокусе, выделяет значение — '
      'цифры его заменяют', (tester) async {
    await pump(tester, const Duration(hours: 8, minutes: 20));
    await tester.tap(find.byType(HmField));
    await tester.pumpAndSettle();
    final v = editing(tester);
    expect((v.selection.start, v.selection.end), (0, '8:20'.length));

    await type(tester, '930');
    expect(editing(tester).text, '9:30');
    expect(value, const Duration(hours: 9, minutes: 30));
  });

  testWidgets('курсор в конце полного поля: новая цифра вытесняет самую '
      'старую — четыре набранные цифры и есть значение', (tester) async {
    await pump(tester, const Duration(hours: 8, minutes: 20));
    // Курсор в конец, как ручкой выделения
    final v = editing(tester);
    tester.testTextInput.updateEditingValue(
      v.copyWith(selection: TextSelection.collapsed(offset: v.text.length)),
    );
    await tester.pump();

    await type(tester, '0945');
    expect(editing(tester).text, '09:45');
    expect(value, const Duration(hours: 9, minutes: 45));
  });

  test('разбор: «6» — 6:00, «630» — 6:30, «06:30», часы сверх предела и '
      'минуты сверх 59 — не время', () {
    expect(parseHm('6'), const Duration(hours: 6));
    expect(parseHm('630'), const Duration(hours: 6, minutes: 30));
    expect(parseHm('06:30'), const Duration(hours: 6, minutes: 30));
    expect(parseHm('24:00'), isNull);
    expect(parseHm('24:00', maxHours: 99), const Duration(hours: 24));
    expect(parseHm('8:75'), isNull);
  });
}
