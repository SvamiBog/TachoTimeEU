// Детали лимитов, выбор страны и паром на главной. План тестов: UI-03,
// UI-05, UI-06, UI-22 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/daily_rest_screen.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/limit_sections.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

final t0 = DateTime.utc(2026, 9, 23, 8);

Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> openRow(WidgetTester tester, String title) async {
  await scrollTo(tester, find.text(title));
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

Future<List<ActivityPeriod>> periods(
  WidgetTester tester,
  AppDatabase db,
) async => (await tester.runAsync(ActivityRepository(db).periods))!;

void main() {
  group('UI-05: детали лимитов', () {
    testWidgets('«Рабочий день»: 13 / 15 ч от начала смены, страна', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      final start = DateTime.utc(2026, 9, 23, 6, 49);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: week.periods,
          now: week.now,
          countries: {start: const ShiftCountries(start: 'PL')},
        ),
      );
      await openRow(tester, 'Рабочий день');
      expect(find.byType(WorkdayScreen), findsOneWidget);
      expect(find.text('Начало смены'), findsOneWidget);
      expect(find.text('PL'), findsOneWidget);
      expect(find.text(formatClock(start)), findsOneWidget);
      expect(find.text('13 ч — обычный день'), findsOneWidget);
      expect(
        find.text(formatClock(start.add(const Duration(hours: 13)))),
        findsOneWidget,
      );
      expect(find.text('затем полный отдых 11 ч · ещё 8:29'), findsOneWidget);
      expect(find.text('15 ч — удлинённый день'), findsOneWidget);
      expect(
        find.text('затем сокращённый отдых 9 ч · осталось ×3'),
        findsOneWidget,
      );
      expect(find.text('из 15:00'), findsOneWidget);
    });

    testWidgets('«Рабочий день» экипажа — 19 / 21 ч', (tester) async {
      final periods = consecutive(t0, [
        (DriverMode.driving, const Duration(hours: 2)),
      ], open: true);
      await pumpScreen(
        tester,
        const WorkdayScreen(),
        overrides: journalOverrides(
          periods: periods,
          now: t0.add(const Duration(hours: 2)),
          settings: const ComplianceSettings(crew: CrewMode.team),
        ),
      );
      expect(find.text('19 ч — обычный день'), findsOneWidget);
      expect(find.text('21 ч — удлинённый день'), findsOneWidget);
    });

    testWidgets('«Перерыв»: взята первая часть 15, нужна вторая 30', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      await openRow(tester, 'Непрерывное вождение');
      expect(find.byType(BreakScreen), findsOneWidget);
      expect(find.text('Перерыв после 4:30 вождения'), findsOneWidget);
      expect(find.text('0:15 / 0:45'), findsOneWidget);
      expect(find.text('15 мин ✓'), findsOneWidget);
      expect(find.text('30 мин — осталось'), findsOneWidget);
      final first = DateTime.utc(2026, 9, 23, 8, 48);
      expect(
        find.text(
          'Первая часть взята в ${formatClock(first)}–'
          '${formatClock(first.add(const Duration(minutes: 15)))}',
        ),
        findsOneWidget,
      );
      expect(find.text('Раздельный перерыв 15 + 30'), findsOneWidget);
    });

    testWidgets('«Перерыв» до первой части — 45 подряд или 15 + 30', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const BreakScreen(),
        overrides: journalOverrides(
          periods: consecutive(t0, [
            (DriverMode.driving, const Duration(hours: 2)),
          ], open: true),
          now: t0.add(const Duration(hours: 2)),
        ),
      );
      expect(find.text('0:00 / 0:45'), findsOneWidget);
      expect(find.text('15 мин'), findsOneWidget);
      expect(find.text('30 мин'), findsOneWidget);
      expect(
        find.text('Нужен перерыв 45 мин подряд или 15 + 30 мин.'),
        findsOneWidget,
      );
    });

    testWidgets('«Начать перерыв» пишет отдых без отметки «конец дня»', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await tester.runAsync(
        () => ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.driving),
      );
      final now = t0.add(const Duration(hours: 2));
      await pumpScreen(
        tester,
        const BreakScreen(),
        overrides: databaseOverrides(db, now: () => now),
      );
      await tester.tap(find.text('Начать перерыв'));
      await settle(tester);
      final last = (await periods(tester, db)).last;
      expect(
        (last.mode, last.start, last.dayEnd),
        (DriverMode.rest, now, false),
      );
      await unmount(tester);
    });

    testWidgets('«Недельный отдых»: срок 144 ч, 45 / 24 ч, прошлый, долг', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      final s = calculateCompliance(periods: week.periods, now: week.now);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      await openRow(tester, 'Рабочая неделя');
      expect(find.byType(WeeklyRestScreen), findsOneWidget);
      expect(find.text('НАЧАТЬ НЕ ПОЗЖЕ'), findsOneWidget);
      expect(
        find.text(formatDeadline(s.weeklyRestDeadline!, 'ru')),
        findsOneWidget,
      );
      expect(
        find.text(
          'через ${formatHm(s.workWeekRemaining!)} — конец рабочей недели '
          '(144 ч)',
        ),
        findsOneWidget,
      );
      expect(find.text('45 ч'), findsOneWidget);
      expect(find.text('24 ч'), findsOneWidget);
      expect(find.text('доступен · с компенсацией'), findsOneWidget);
      expect(find.text('Предыдущий · полный'), findsOneWidget);
      expect(find.text(formatHm(s.lastWeeklyRest!.duration)), findsOneWidget);
      expect(find.text('нет'), findsOneWidget);
      expect(find.textContaining('Пакет мобильности включён'), findsOneWidget);
    });

    testWidgets('«Недельный отдых»: сокращённый — долг и срок компенсации', (
      tester,
    ) async {
      // Недельный отдых 30 ч вместо 45 — долг 15 ч
      final start = DateTime.utc(2026, 9, 19, 20);
      final periods = consecutive(start, [
        (DriverMode.rest, const Duration(hours: 30)),
        (DriverMode.driving, const Duration(hours: 4)),
      ], open: true);
      final now = start.add(const Duration(hours: 34));
      final s = calculateCompliance(
        periods: periods,
        now: now,
        settings: const ComplianceSettings(mobilityPackage: false),
      );
      expect(s.compensation, isNotNull);
      await pumpScreen(
        tester,
        const WeeklyRestScreen(),
        overrides: journalOverrides(
          periods: periods,
          now: now,
          settings: const ComplianceSettings(mobilityPackage: false),
        ),
      );
      expect(find.text('Предыдущий · сокращённый'), findsOneWidget);
      expect(
        find.text(
          '${formatHm(s.compensation!.debt)} до '
          '${formatDayMonth(s.compensation!.dueBy)}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          s.reducedWeeklyRestAvailable
              ? 'доступен · с компенсацией'
              : 'недоступен — нужен полный',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('компенсируется до конца третьей недели'),
        findsOneWidget,
      );
      expect(find.textContaining('Пакет мобильности'), findsNothing);
    });

    testWidgets('«Недельный отдых» без данных и «Начать отдых» — конец дня', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await tester.runAsync(
        () => ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.driving),
      );
      final now = t0.add(const Duration(hours: 3));
      await pumpScreen(
        tester,
        const WeeklyRestScreen(),
        overrides: databaseOverrides(db, now: () => now),
      );
      expect(find.textContaining('Нет данных о прошлом'), findsOneWidget);
      await tester.tap(find.text('Начать отдых'));
      await tester.pumpAndSettle();
      // Как «Завершить день»: вождение за день — по записям
      await tester.tap(find.widgetWithText(PrimaryButton, 'Завершить день'));
      await settle(tester);
      final last = (await periods(tester, db)).last;
      expect((last.mode, last.dayEnd), (DriverMode.rest, true));
      await unmount(tester);
    });
  });

  group('UI-22: «Суточный отдых»', () {
    // Смена с 08:00: 4 ч вождения, с 12:00 — отдых
    final restAt = t0.add(const Duration(hours: 4));
    final resting = consecutive(t0, [
      (DriverMode.driving, const Duration(hours: 4)),
      (DriverMode.rest, Duration.zero),
    ], open: true);
    String at(Duration d) => formatClock(restAt.add(d));
    const h3 = Duration(hours: 3);
    const h9 = Duration(hours: 9);
    const h11 = Duration(hours: 11);

    Future<void> pumpRest(
      WidgetTester tester,
      DateTime now, [
      List<ActivityPeriod>? p,
    ]) => pumpScreen(
      tester,
      const DailyRestScreen(),
      viewport: const Size(412, 1600),
      overrides: journalOverrides(periods: p ?? resting, now: now),
    );

    testWidgets('нажали «Отдых» в смене — строка главной показывает отдых и '
        'открывает его экран, а не «Рабочий день»', (tester) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: resting,
          now: restAt.add(const Duration(hours: 2)),
        ),
      );
      // Перерыв засчитан — кольцо копит отдых к 11 ч
      expect(find.text('ОТДЫХ'), findsOneWidget);
      expect(find.text('из 11 ч'), findsOneWidget);

      await scrollTo(tester, find.text('Суточный отдых'));
      expect(find.text('идёт 2:00'), findsOneWidget);
      expect(find.text('9 ч: ещё 7:00 → ${at(h9)}'), findsOneWidget);
      expect(find.text('11 ч → ${at(h11)}'), findsOneWidget);

      await openRow(tester, 'Суточный отдых');
      expect(find.byType(DailyRestScreen), findsOneWidget);
      expect(find.byType(WorkdayScreen), findsNothing);
    });

    testWidgets('отдых в смене: сколько до 3, 9 и 11 ч и когда наберутся', (
      tester,
    ) async {
      await pumpRest(tester, restAt.add(const Duration(hours: 2)));
      expect(find.text('ОТДЫХ ИДЁТ'), findsOneWidget);
      expect(find.text('2:00'), findsOneWidget);
      expect(find.text('из 11 ч'), findsOneWidget);
      expect(find.text('с ${formatClock(restAt)}'), findsOneWidget);

      expect(find.text('3 ч — первая часть раздельного'), findsOneWidget);
      expect(find.text('ещё 1:00'), findsOneWidget);
      expect(find.text(at(h3)), findsOneWidget);
      expect(find.text('9 ч — сокращённый'), findsOneWidget);
      expect(find.text('ещё 7:00 · осталось ×3'), findsOneWidget);
      expect(find.text(at(h9)), findsOneWidget);
      expect(find.text('11 ч — полный'), findsOneWidget);
      expect(find.text('ещё 9:00'), findsOneWidget);
      expect(find.text(at(h11)), findsOneWidget);

      expect(find.textContaining('Пока отдых короче 9 ч'), findsOneWidget);
      expect(
        find.widgetWithText(PrimaryButton, 'Завершить день'),
        findsOneWidget,
      );
    });

    testWidgets('суточный отдых после смены — с кольца главной: 9 ч набран, '
        'до 11 ч ещё 1:30', (tester) async {
      final now = restAt.add(const Duration(hours: 9, minutes: 30));
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: resting, now: now),
      );
      await tester.tap(find.text('СУТОЧНЫЙ ОТДЫХ'));
      await tester.pumpAndSettle();
      expect(find.byType(DailyRestScreen), findsOneWidget);
      expect(find.text('9:30'), findsOneWidget);
      expect(find.text('3 ч — первая часть раздельного'), findsNothing);
      expect(find.text('набран'), findsOneWidget);
      expect(find.text('ещё 1:30'), findsOneWidget);
      expect(find.textContaining('Смена завершена'), findsOneWidget);
    });

    testWidgets('смена идёт, отдыха нет — до какого времени начать', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      final start = DateTime.utc(2026, 9, 23, 6, 49);
      String plus(int hours) => formatClock(start.add(Duration(hours: hours)));
      await pumpRest(tester, week.now, week.periods);
      expect(find.text('НАЧАТЬ ОТДЫХ НЕ ПОЗЖЕ'), findsOneWidget);
      expect(find.text(plus(13)), findsNWidgets(2));
      expect(find.text('сокращённый 9 ч — до ${plus(15)}'), findsOneWidget);
      expect(find.text('начать не позже'), findsOneWidget);
      expect(find.text('начать не позже · осталось ×3'), findsOneWidget);
    });

    testWidgets('недельный отдых — ссылка на его экран', (tester) async {
      await pumpRest(tester, restAt.add(const Duration(hours: 25)));
      expect(find.text('НЕДЕЛЬНЫЙ ОТДЫХ ИДЁТ'), findsOneWidget);
      expect(find.text('из 45 ч'), findsOneWidget);
      expect(find.text('Сколько отдыхать'), findsNothing);
      await tester.tap(find.widgetWithText(SecondaryButton, 'Недельный отдых'));
      await tester.pumpAndSettle();
      expect(find.byType(WeeklyRestScreen), findsOneWidget);
    });

    testWidgets('перерыв ещё не засчитан — кольцо ведёт на экран перерыва', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: resting,
          now: restAt.add(const Duration(minutes: 20)),
        ),
      );
      await tester.tap(find.text('ПЕРЕРЫВ'));
      await tester.pumpAndSettle();
      expect(find.byType(BreakScreen), findsOneWidget);
    });
  });

  group('UI-06: выбор страны', () {
    testWidgets('начало и конец смены, затем недавние сверху, без Premium', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final db = memoryDatabase();
      addTearDown(db.close);
      await tester.runAsync(
        () => ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.driving),
      );
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(
          db,
          now: () => t0.add(const Duration(hours: 1)),
        ),
      );
      expect(
        find.bySemanticsLabel('Страна смены не выбрана. Выбрать'),
        findsOneWidget,
      );

      await tester.tap(find.byType(CountryChip));
      await tester.pumpAndSettle();
      expect(find.text('Начало · —'), findsOneWidget);
      expect(find.text('ЧАСТО ИСПОЛЬЗУЕМЫЕ'), findsNothing);
      // Коды тахографа в списке, поиск по названию
      expect(find.text('A'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'польш');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Польша'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.text('Начало · PL'), findsOneWidget);
      expect(find.text('Конец · —'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'LT');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Литва'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.byType(CountrySheet), findsNothing);

      final rows = await tester.runAsync(() => db.select(db.shifts).get());
      expect(rows!.map((r) => (r.startUtc, r.startCountry, r.endCountry)), [
        (t0, 'PL', 'LT'),
      ]);
      expect(
        await tester.runAsync(SettingsRepository(db).defaultCountry),
        'LT',
      );
      expect(
        find.bySemanticsLabel('Страна начала PL, конечная LT. Изменить'),
        findsOneWidget,
      );

      // Часто используемые сверху; «Не указывать» убирает конечную
      await tester.tap(find.byType(CountryChip));
      await tester.pumpAndSettle();
      expect(find.text('ЧАСТО ИСПОЛЬЗУЕМЫЕ'), findsOneWidget);
      await tester.tap(find.text('Конец · LT'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Не указывать'));
      await settle(tester);
      await tester.pumpAndSettle();
      final after = await tester.runAsync(() => db.select(db.shifts).get());
      expect(after!.single.endCountry, isNull);
      semantics.dispose();
      await unmount(tester);
    });

    testWidgets('новая смена сразу получает страну по умолчанию', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final db = memoryDatabase();
      addTearDown(db.close);
      final shiftStart = t0.add(const Duration(hours: 15));
      await tester.runAsync(() async {
        await SettingsRepository(db).setDefaultCountry('D');
        var now = t0;
        final repo = ActivityRepository(db, clock: () => now);
        await repo.switchMode(DriverMode.driving);
        now = t0.add(const Duration(hours: 4));
        await repo.switchMode(DriverMode.rest);
        now = shiftStart;
        await repo.switchMode(DriverMode.driving);
      });
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(
          db,
          now: () => shiftStart.add(const Duration(minutes: 10)),
        ),
      );
      await settle(tester);
      final rows = await tester.runAsync(() => db.select(db.shifts).get());
      expect(rows!.map((r) => (r.startUtc, r.startCountry)), [
        (shiftStart, 'D'),
      ]);
      expect(
        find.bySemanticsLabel('Страна начала D, конечная не выбрана. Изменить'),
        findsOneWidget,
      );
      semantics.dispose();
      await unmount(tester);
    });

    testWidgets('без смены — страна следующей смены', (tester) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => t0),
      );
      await tester.tap(find.byType(CountryChip));
      await tester.pumpAndSettle();
      expect(find.text('Страна следующей смены'), findsOneWidget);
      expect(find.text('Начало · —'), findsNothing);
      await tester.enterText(find.byType(TextField), 'чех');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Чехия'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.byType(CountrySheet), findsNothing);
      expect(
        await tester.runAsync(SettingsRepository(db).defaultCountry),
        'CZ',
      );
      expect(await tester.runAsync(() => db.select(db.shifts).get()), isEmpty);
      await unmount(tester);
    });
  });

  group('UI-03: паром / поезд', () {
    testWidgets('переключатель отмечает текущую запись, новые наследуют', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await tester.runAsync(
        () => ActivityRepository(
          db,
          clock: () => t0,
        ).switchMode(DriverMode.driving),
      );
      var now = t0.add(const Duration(hours: 1));
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => now),
      );
      Future<void> toggle() async {
        await scrollTo(tester, find.byType(FerryRow));
        await tester.tap(
          find.descendant(
            of: find.byType(FerryRow),
            matching: find.byType(Switch),
          ),
        );
        await settle(tester);
      }

      await toggle();
      expect((await periods(tester, db)).single.ferry, isTrue);

      now = now.add(const Duration(minutes: 5));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('· паром', findRichText: true),
        findsOneWidget,
      );
      await tester.tap(find.text('Отдых').first);
      await settle(tester);
      expect((await periods(tester, db)).map((p) => p.ferry), [true, true]);

      await toggle();
      expect((await periods(tester, db)).map((p) => p.ferry), [true, false]);
      await unmount(tester);
    });

    testWidgets('без записей переключатель выключен', (tester) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: const [], now: t0),
      );
      await scrollTo(tester, find.byType(FerryRow));
      final ferry = tester.widget<Switch>(
        find.descendant(
          of: find.byType(FerryRow),
          matching: find.byType(Switch),
        ),
      );
      expect(ferry.onChanged, isNull);
      expect(ferry.value, isFalse);
    });
  });
}
