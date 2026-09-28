// INT-01, INT-02 (docs/testing.md, раздел 14): смена целиком и разрыв
// сессии в настоящем приложении — нижняя навигация, главная, журнал —
// на базе-файле SQLite. На эмуляторе база лежит в каталоге приложения и
// открывается через drift_flutter, как у водителя.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/features/home/hero_card.dart';
import 'package:tachogo/features/home/mode_buttons.dart';
import 'package:tachogo/features/home/workday_screen.dart';

import 'support/harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'INT-01: вождение → перерыв → вождение → «Завершить день»; таймеры на '
    'экране равны расчёту движка',
    (tester) async {
      final db = await freshDatabase(tester, 'int01');
      final clock = ScenarioClock(monday);
      await launchApp(tester, overrides: appOverrides(db, clock: clock));
      expect(find.byType(ModeButtons), findsOneWidget, reason: 'главная');

      // 4:30 за рулём: ровно лимит — ещё не нарушение
      await tapMode(tester, DriverMode.driving);
      clock.now = monday.add(h(4, 30));
      await settle(tester);
      var s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(s.continuousDriving, h(4, 30));
      expect(
        s.infringements.map((i) => i.type),
        isNot(contains(InfringementType.continuousExceeded)),
      );
      expect(find.text(ru.heroUntilBreak.toUpperCase()), findsOneWidget);

      // Перерыв 45 мин засчитан — непрерывное вождение с нуля
      await tapMode(tester, DriverMode.rest);
      clock.now = monday.add(h(5, 15));
      await settle(tester);
      s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(find.text(ru.heroBreak.toUpperCase()), findsOneWidget);

      await tapMode(tester, DriverMode.driving);
      clock.now = monday.add(h(9, 45));
      await settle(tester);
      s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(s.continuousDriving, h(4, 30));
      expect(s.dailyDriving, h(9));
      expect(s.shiftDuration, h(9, 45));

      // «Завершить день» с экрана «Рабочий день»
      await tester.tap(find.text(ru.rowWorkday));
      await settleFrames(tester);
      expect(find.byType(WorkdayScreen), findsOneWidget);
      await tester.tap(find.text(ru.workdayEndDay));
      await settle(tester);
      expect(find.byType(WorkdayScreen), findsNothing);
      expect(find.text(ru.heroDailyRest.toUpperCase()), findsOneWidget);

      final end = monday.add(h(9, 45));
      expect(await journalOf(tester, db), [
        (DriverMode.driving, monday, monday.add(h(4, 30))),
        (DriverMode.rest, monday.add(h(4, 30)), monday.add(h(5, 15))),
        (DriverMode.driving, monday.add(h(5, 15)), end),
        (DriverMode.rest, end, null),
      ]);
      final periods = await tester.runAsync(ActivityRepository(db).periods);
      expect(periods!.last.dayEnd, isTrue);

      // Смена в журнале: 9:00 вождения
      clock.now = end.add(h(1));
      await settle(tester);
      s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(s.status, DriverStatus.dailyRest);
      await tester.tap(find.text(ru.navJournal));
      await settle(tester);
      expect(find.text(formatHm(h(9))), findsWidgets);
    },
  );

  testWidgets(
    'INT-02: приложение закрыто во время вождения и открыто через 2 ч — '
    'вождение продолжилось, таймеры сошлись',
    (tester) async {
      final path = (await tester.runAsync(() => databasePath('int02')))!;
      await tester.runAsync(() => deleteDatabase(path));
      final first = openFileDatabase(path);
      await tester.runAsync(() => prepareDriver(first));

      // Первый запуск: вождение с 06:00, в 07:00 приложение закрыли
      final clock = ScenarioClock(monday);
      final app = await launchApp(
        tester,
        overrides: appOverrides(first, clock: clock),
      );
      await tapMode(tester, DriverMode.driving);
      clock.now = monday.add(h(1));
      await settle(tester);
      await expectScreenMatchesEngine(tester, first, clock.now);
      await closeApp(tester, app);
      await tester.runAsync(first.close);

      // Второй запуск: новый контейнер и соединение с тем же файлом, 09:00
      final second = openFileDatabase(path);
      addTearDown(second.close);
      final later = ScenarioClock(monday.add(h(3)));
      await launchApp(tester, overrides: appOverrides(second, clock: later));
      final s = await expectScreenMatchesEngine(tester, second, later.now);
      expect(s.currentMode, DriverMode.driving);
      expect(s.continuousDriving, h(3));
      expect(s.dailyDriving, h(3));
      expect(
        find.descendant(
          of: find.byType(CurrentModeRow),
          matching: find.text(formatHm(h(3))),
        ),
        findsOneWidget,
      );

      // Журнал продолжается: перерыв закрывает запись, начатую до закрытия
      await tapMode(tester, DriverMode.rest);
      expect(await journalOf(tester, second), [
        (DriverMode.driving, monday, monday.add(h(3))),
        (DriverMode.rest, monday.add(h(3)), null),
      ]);
    },
  );
}
