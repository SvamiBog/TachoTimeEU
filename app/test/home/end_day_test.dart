// JRN-08 (docs/testing.md): «Завершить день» на главной — водитель вводит
// вождение за день. Журнал режимов по времени ему не нужен: смена с другим
// вождением становится ручной с итогом, отдых после неё идёт на главной.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
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
