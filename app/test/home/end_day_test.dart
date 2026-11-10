// JRN-08 (docs/testing.md): «Завершить день» на главной — водитель вводит
// вождение за день. Журнал режимов по времени ему не нужен: смена с другим
// вождением становится ручной с итогом, отдых после неё идёт на главной.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/hm_field.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/home_screen.dart';

import '../support/app_harness.dart';

final t0 = DateTime.utc(2026, 9, 23, 6);
final DateTime now = t0.add(const Duration(hours: 12));

Future<void> pumpHome(WidgetTester tester, AppDatabase db) => pumpScreen(
  tester,
  const HomeScreen(),
  overrides: databaseOverrides(db, now: () => now),
);

/// Смена с 06:00, весь день — другая работа: режимы не переключали.
Future<void> seedWork(WidgetTester tester, AppDatabase db) => tester.runAsync(
  () =>
      ActivityRepository(db, clock: () => t0).switchMode(DriverMode.otherWork),
);

Future<List<ActivityPeriod>> periods(
  WidgetTester tester,
  AppDatabase db,
) async => (await tester.runAsync(ActivityRepository(db).periods))!;

Future<List<ManualShift>> manual(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(
      JournalEditRepository(db, SettingsRepository(db)).manualShifts,
    ))!;

Finder get confirm => find.widgetWithText(PrimaryButton, 'Завершить день');

/// Кнопка «Завершить день» в разделе «Сегодня»; на экране — после прокрутки.
Finder get endDayButton =>
    find.widgetWithText(SecondaryButton, 'Завершить день', skipOffstage: false);

Future<void> openSheet(WidgetTester tester) async {
  await tester.ensureVisible(endDayButton);
  await tester.pumpAndSettle();
  await tester.tap(endDayButton);
  await tester.pumpAndSettle();
}

Future<void> enterHm(WidgetTester tester, String digits) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(HmField),
      matching: find.byType(EditableText),
    ),
    digits,
  );
  await tester.pumpAndSettle();
}

String fieldText(WidgetTester tester) => tester
    .widget<EditableText>(
      find.descendant(
        of: find.byType(HmField),
        matching: find.byType(EditableText),
      ),
    )
    .controller
    .text;

/// Цифры по одной, как с клавиатуры телефона: каждая встаёт на место
/// выделения или курсора, а не заменяет поле целиком, как `enterText`.
Future<void> typeDigits(WidgetTester tester, String digits) async {
  for (final digit in digits.split('')) {
    final value = tester
        .state<EditableTextState>(find.byType(EditableText))
        .textEditingValue;
    final selection = value.selection;
    tester.testTextInput.updateEditingValue(
      TextEditingValue(
        text: value.text.replaceRange(selection.start, selection.end, digit),
        selection: TextSelection.collapsed(offset: selection.start + 1),
      ),
    );
    await tester.pump();
  }
}

void main() {
  group('JRN-08: «Завершить день» — вождение за день', () {
    testWidgets('без смены кнопки на главной нет', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpHome(tester, db);
      expect(find.byType(EndDayButton, skipOffstage: false), findsOneWidget);
      expect(endDayButton, findsNothing);
      await unmount(tester);
    });

    testWidgets('режимы не переключали — вождение вводится, смена '
        'становится ручной, отдых идёт', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await seedWork(tester, db);
      await pumpHome(tester, db);

      await openSheet(tester);
      expect(find.text('Вождение за день'), findsOneWidget);
      // По записям вождения нет — в поле 0:00
      final field = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(HmField),
          matching: find.byType(EditableText),
        ),
      );
      expect(field.controller.text, '0:00');
      await enterHm(tester, '830');
      await tester.tap(confirm);
      await settle(tester);
      await tester.pumpAndSettle();

      final shift = (await manual(tester, db)).single;
      expect(shift.start, t0);
      expect(shift.end, now);
      expect(shift.driving, const Duration(hours: 8, minutes: 30));
      expect(shift.restKind, RestKind.daily);
      final rest = (await periods(tester, db)).single;
      expect(
        (rest.mode, rest.start, rest.dayEnd),
        (DriverMode.rest, now, true),
      );
      // Смена кончилась — на главной отдых, кнопки больше нет
      await tester.drag(find.byType(ListView), const Offset(0, 2000));
      await tester.pumpAndSettle();
      expect(find.text('СУТОЧНЫЙ ОТДЫХ'), findsOneWidget);
      expect(endDayButton, findsNothing);
      await unmount(tester);
    });

    testWidgets('с клавиатуры: касание поля и цифры по одной — вводится '
        'любое вождение', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await seedWork(tester, db);
      await pumpHome(tester, db);

      await openSheet(tester);
      // Поле уже в фокусе; водитель всё равно касается его, как любого поля
      await tester.tap(find.byType(HmField));
      await tester.pumpAndSettle();
      await typeDigits(tester, '830');
      expect(fieldText(tester), '8:30');
      await tester.tap(confirm);
      await settle(tester);
      await tester.pumpAndSettle();
      expect(
        (await manual(tester, db)).single.driving,
        const Duration(hours: 8, minutes: 30),
      );
      await unmount(tester);
    });

    testWidgets('вождение длиннее смены — ошибка, завершить нельзя', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await seedWork(tester, db);
      await pumpHome(tester, db);

      await openSheet(tester);
      await enterHm(tester, '1300');
      expect(find.text('Можно от 0:00 до 12:00'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.descendant(of: confirm, matching: find.byType(FilledButton)),
            )
            .onPressed,
        isNull,
      );
      await unmount(tester);
    });

    testWidgets('ENG-29: день завершён с итогом, через 3 ч водитель снова '
        'едет — на главной тот же рабочий день', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      // Смена с 06:00, в 15:00 — «Завершить день» с 8 ч вождения итогом,
      // в 18:00 — снова вождение; сейчас 19:00
      final ended = t0.add(const Duration(hours: 9));
      final back = t0.add(const Duration(hours: 12));
      final later = t0.add(const Duration(hours: 13));
      await tester.runAsync(() async {
        await ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.otherWork);
        await JournalEditRepository(
          db,
          SettingsRepository(db),
          clock: () => ended,
        ).endDay(driving: const Duration(hours: 8));
        await ActivityRepository(
          db,
          clock: () => back,
        ).switchMode(DriverMode.driving);
      });
      expect(await manual(tester, db), hasLength(1));

      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => later),
      );
      // Рабочий день — с 06:00, а не с возвращения в 18:00: 13 ч, вождение
      // за день — 8 ч итогом и час по записям
      expect(find.textContaining('смена с ${formatClock(t0)}'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('прошло 13:00'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('прошло 13:00'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('ENG-29: день продолжает ручную смену — в шторке итог за '
        'весь день, записывается разница', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      // 06:00–15:00 — 8 ч вождения итогом, с 18:00 — час вождения по
      // записям; сейчас 19:00
      final ended = t0.add(const Duration(hours: 9));
      final back = t0.add(const Duration(hours: 12));
      final later = t0.add(const Duration(hours: 13));
      await tester.runAsync(() async {
        await ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.otherWork);
        await JournalEditRepository(
          db,
          SettingsRepository(db),
          clock: () => ended,
        ).endDay(driving: const Duration(hours: 8));
        await ActivityRepository(
          db,
          clock: () => back,
        ).switchMode(DriverMode.driving);
      });
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => later),
      );

      await openSheet(tester);
      // Вождение за день: 8 ч итогом и час по записям
      expect(fieldText(tester), '9:00');
      // Больше, чем длится день, и меньше уже внесённого — нельзя
      await enterHm(tester, '930');
      expect(find.text('Можно от 8:00 до 9:00'), findsOneWidget);
      await enterHm(tester, '730');
      expect(find.text('Можно от 8:00 до 9:00'), findsOneWidget);
      // За последний час за рулём — только полчаса: за день 8:30
      await enterHm(tester, '830');
      await tester.tap(confirm);
      await settle(tester);
      await tester.pumpAndSettle();

      final shifts = await manual(tester, db);
      expect(shifts, hasLength(2));
      expect(shifts.first.driving, const Duration(hours: 8));
      expect(shifts.last.start, back);
      expect(shifts.last.driving, const Duration(minutes: 30));
      await unmount(tester);
    });

    testWidgets('JRN-13: запись не удалась — водитель видит сообщение, '
        'ошибка уходит в отчёт, смена идёт дальше', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await seedWork(tester, db);
      // База отказывает в записи ручной смены — как при полном диске
      await tester.runAsync(
        () => db.customStatement(
          'CREATE TRIGGER fail_manual BEFORE INSERT ON manual_shifts '
          "BEGIN SELECT RAISE(ABORT, 'disk full'); END",
        ),
      );
      await pumpHome(tester, db);

      await openSheet(tester);
      await enterHm(tester, '830');
      await tester.tap(confirm);
      await settle(tester);
      await tester.pumpAndSettle();

      expect(
        find.text('Не удалось сохранить. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      expect('${tester.takeException()}', contains('disk full'));
      // Транзакция отменена: журнал прежний, смена идёт
      expect(await manual(tester, db), isEmpty);
      expect((await periods(tester, db)).single.isOpen, isTrue);
      expect(endDayButton, findsOneWidget);
      await unmount(tester);
    });

    testWidgets('«Отмена» — смена идёт дальше', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await seedWork(tester, db);
      await pumpHome(tester, db);

      await openSheet(tester);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(await manual(tester, db), isEmpty);
      expect((await periods(tester, db)).single.isOpen, isTrue);
      expect(endDayButton, findsOneWidget);
      await unmount(tester);
    });
  });
}
