// Главная: показывает расчёт движка, пишет режимы и считывание карты,
// предупреждает о лимитах, читается экранным диктором и не перестраивается
// каждую секунду. План тестов: UI-01…04, UI-07, UI-08, DES-04, DES-05,
// PERF-02 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/alerts.dart';
import 'package:tachogo/features/home/card_reading.dart';
import 'package:tachogo/features/home/hero_card.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/limit_sections.dart';
import 'package:tachogo/features/home/mode_buttons.dart';
import 'package:tachogo/features/home/workday_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

final t0 = DateTime.utc(2026, 9, 23, 8);

/// Строка лимита с данным названием.
Finder row(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(LimitRow));

/// Текст внутри строки лимита.
Finder inRow(String title, String text) =>
    find.descendant(of: row(title), matching: find.text(text));

Future<void> showRow(WidgetTester tester, String title) async {
  await tester.scrollUntilVisible(
    find.text(title),
    300,
    scrollable: find.byType(Scrollable).first,
  );
}

/// Цвет фона ближайшей плашки или чипа над [finder].
Color? backgroundOf(WidgetTester tester, Finder finder) {
  final box = tester
      .widgetList<DecoratedBox>(
        find.ancestor(of: finder, matching: find.byType(DecoratedBox)),
      )
      .first;
  return (box.decoration as BoxDecoration).color;
}

void main() {
  group('UI-01: главная показывает снимок движка', () {
    testWidgets('кольцо, текущий режим, «Сегодня», «Неделя», карта', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      final lastCard = week.now.subtract(const Duration(days: 23));
      final s = calculateCompliance(
        periods: week.periods,
        now: week.now,
        lastCardDownload: lastCard,
      );
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: week.periods,
          now: week.now,
          lastCard: lastCard,
        ),
      );

      // Кольцо «до перерыва» и текущий режим
      expect(find.text('ДО ПЕРЕРЫВА'), findsOneWidget);
      expect(find.text(formatHm(s.drivingUntilBreak)), findsOneWidget);
      expect(find.text('непрерывно 4:01 из 4:30'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CurrentModeRow),
          matching: find.text(formatHm(s.currentModeDuration)),
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('с ${formatClock(s.currentModeStart!)}'),
        findsOneWidget,
      );

      // «Сегодня»
      expect(
        inRow('Непрерывное вождение', formatHm(s.continuousDriving)),
        findsOneWidget,
      );
      expect(inRow('Рабочий день', formatHm(s.shiftDuration)), findsOneWidget);
      expect(
        inRow('Суточное вождение', formatHm(s.dailyDriving)),
        findsOneWidget,
      );
      expect(inRow('Перерыв', '0:15'), findsOneWidget);

      // «Отдых» и «Неделя»
      await showRow(tester, 'Рабочая неделя');
      expect(
        inRow('Недельное вождение', formatHm(s.weeklyDriving)),
        findsOneWidget,
      );
      expect(
        inRow('Двухнедельное вождение', formatHm(s.fortnightDriving)),
        findsOneWidget,
      );
      expect(
        inRow('Двухнедельное вождение', 'ограничивает'),
        s.fortnightLimiting ? findsOneWidget : findsNothing,
      );
      expect(
        inRow('Рабочая неделя', formatHm(s.workWeekDuration)),
        findsOneWidget,
      );
      expect(inRow('Суточный отдых', 'не начат'), findsOneWidget);

      // Считывание карты
      await tester.scrollUntilVisible(
        find.byType(CardReadingTile),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('${s.cardDaysLeft} дн'), findsOneWidget);
    });

    testWidgets('пустой журнал: до перерыва 4:30, смена не начата', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: const [], now: t0),
      );
      expect(find.text('ДО ПЕРЕРЫВА'), findsOneWidget);
      expect(find.text('4:30'), findsOneWidget);
      expect(find.text('Режим не выбран'), findsOneWidget);
      expect(find.textContaining('смена не начата'), findsOneWidget);
      expect(inRow('Рабочий день', 'Смена не начата'), findsOneWidget);
      expect(find.byType(AlertCard), findsNothing);
    });

    testWidgets('суточный отдых после смены — кольцо отдыха', (tester) async {
      final periods = consecutive(t0, [
        (DriverMode.driving, const Duration(hours: 4)),
        (DriverMode.rest, Duration.zero),
      ], open: true);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: periods,
          now: t0.add(const Duration(hours: 13, minutes: 30)),
        ),
      );
      expect(find.text('СУТОЧНЫЙ ОТДЫХ'), findsOneWidget);
      expect(find.text('9:30'), findsWidgets);
      expect(find.text('из 11 ч'), findsOneWidget);
      await showRow(tester, 'Суточный отдых');
      expect(inRow('Суточный отдых', 'идёт 9:30'), findsOneWidget);
    });
  });

  group('UI-02: кнопка режима пишет журнал', () {
    testWidgets('через switchMode; повторное нажатие журнал не меняет', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      var now = t0;
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => now),
      );
      final repo = ActivityRepository(db);

      Future<void> tap(String mode) async {
        await tester.tap(
          find.descendant(
            of: find.byType(ModeButtons),
            matching: find.text(mode),
          ),
        );
        await settle(tester);
      }

      await tap('Вождение');
      var periods = await tester.runAsync(repo.periods);
      expect(periods!.map((p) => (p.mode, p.start, p.end)), [
        (DriverMode.driving, t0, null),
      ]);

      now = t0.add(const Duration(minutes: 10));
      await tap('Вождение');
      periods = await tester.runAsync(repo.periods);
      expect(periods, hasLength(1), reason: 'активный режим — без записи');

      await tap('Работа');
      periods = await tester.runAsync(repo.periods);
      expect(periods!.map((p) => (p.mode, p.start, p.end)), [
        (DriverMode.driving, t0, now),
        (DriverMode.otherWork, now, null),
      ]);
      expect(
        tester.getSemantics(find.text('Работа')),
        isSemantics(isSelected: true),
      );
      await unmount(tester);
    });
  });

  group('UI-03: «Завершить день»', () {
    testWidgets('экран «Рабочий день» пишет отдых с отметкой dayEnd', (
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
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => now),
      );
      await tester.tap(find.text('Рабочий день'));
      await tester.pumpAndSettle();
      expect(find.byType(WorkdayScreen), findsOneWidget);
      expect(find.text('Начало смены'), findsOneWidget);
      expect(find.text(formatClock(t0)), findsOneWidget);

      await tester.tap(find.text('Завершить день'));
      await tester.pumpAndSettle();
      // Шторка: вождение по записям — 3:00, водитель его подтверждает
      expect(find.text('Вождение за день'), findsOneWidget);
      await tester.tap(
        find.widgetWithText(PrimaryButton, 'Завершить день').last,
      );
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.byType(WorkdayScreen), findsNothing);

      final periods = await tester.runAsync(ActivityRepository(db).periods);
      expect(periods!.last.mode, DriverMode.rest);
      expect(periods.last.dayEnd, isTrue);
      expect(periods.last.start, now);
      expect(find.text('СУТОЧНЫЙ ОТДЫХ'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('без смены кнопка выключена', (tester) async {
      await pumpScreen(
        tester,
        const WorkdayScreen(),
        overrides: journalOverrides(periods: const [], now: t0),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.text('Смена не начата'), findsOneWidget);
    });
  });

  group('UI-04: предупреждения из движка', () {
    testWidgets('текст со статьёй, цвет по важности, нарушения выше', (
      tester,
    ) async {
      // Непрерывно 4:45 — нарушение ст. 7; карта считана 25 дней назад —
      // предупреждение 581/2010.
      final periods = consecutive(t0, [
        (DriverMode.driving, const Duration(hours: 4, minutes: 45)),
      ], open: true);
      final now = t0.add(const Duration(hours: 4, minutes: 45));
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: periods,
          now: now,
          lastCard: now.subtract(const Duration(days: 25)),
        ),
      );
      await tester.scrollUntilVisible(
        find.byType(AlertCard).last,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      final cards = tester.widgetList<AlertCard>(find.byType(AlertCard));
      expect(cards.map((c) => c.infringement.type), [
        InfringementType.continuousExceeded,
        InfringementType.cardSoon,
      ]);
      expect(find.text('Превышено непрерывное вождение'), findsWidgets);
      expect(
        find.text(
          'Вождение без перерыва больше 4:30 на 0:15. Остановитесь и '
          'сделайте перерыв 45 мин.',
        ),
        findsOneWidget,
      );
      expect(find.text('ЕС 561/2006 · ст. 7'), findsOneWidget);
      expect(find.text('Скоро считывание карты'), findsOneWidget);
      expect(find.text('Осталось 3 дня.'), findsOneWidget);
      expect(find.text('ЕС 581/2010 · ст. 1'), findsOneWidget);

      expect(
        backgroundOf(tester, find.text('ЕС 561/2006 · ст. 7')),
        AppColors.dark.errorBg,
      );
      expect(
        backgroundOf(tester, find.text('ЕС 581/2010 · ст. 1')),
        AppColors.dark.warningBg,
      );
    });

    testWidgets('«Скоро перерыв» — плашкой под кольцом, не в списке', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      expect(
        find.descendant(
          of: find.byType(HeroBanner),
          matching: find.text(
            'Нужен перерыв 30 мин — вторая часть раздельного 15 + 30',
          ),
        ),
        findsOneWidget,
      );
      expect(find.byType(AlertCard), findsNothing);
    });

    test('у каждого вида нарушения — заголовок, текст и статья', () async {
      // Текст берётся switch по всем видам — проверяем, что строки
      // подставлены, а не пустые.
      final l = await AppLocalizations.delegate.load(const Locale('ru'));
      for (final type in InfringementType.values) {
        final text = l.infringement(
          Infringement(
            type,
            time: const Duration(minutes: 20),
            limit: const Duration(hours: 9),
            requiredBreak: const Duration(minutes: 45),
            count: 2,
            days: 5,
          ),
        );
        expect(text.title, isNotEmpty, reason: type.name);
        expect(text.text, isNotEmpty, reason: type.name);
        expect(
          text.article,
          contains('ст. ${type.article}'),
          reason: type.name,
        );
        expect(text.text, isNot(contains('{')), reason: type.name);
      }
    });
  });

  group('UI-07: считывание карты', () {
    testWidgets('«Считано сегодня» записывает считывание, 28 дней заново', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: databaseOverrides(db, now: () => t0),
      );
      await tester.scrollUntilVisible(
        find.byType(CardReadingTile),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Отметьте последнее считывание'), findsOneWidget);

      await tester.ensureVisible(find.byType(CardReadingTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CardReadingTile));
      await tester.pumpAndSettle();
      expect(find.text('Считывание ещё не отмечено.'), findsOneWidget);
      await tester.tap(find.text('Считано сегодня'));
      await settle(tester);
      await tester.pumpAndSettle();

      final rows = await tester.runAsync(
        () => db.select(db.cardDownloads).get(),
      );
      expect(rows!.map((r) => r.downloadedAtUtc), [t0]);
      expect(find.byType(CardSheet), findsNothing);
      expect(find.text('28 дн'), findsOneWidget);
      expect(
        find.text(
          'последнее ${formatDayMonth(t0)} · '
          'до ${formatDayMonth(t0.add(const Duration(days: 28)))}',
        ),
        findsOneWidget,
      );
      await unmount(tester);
    });
  });

  group('UI-08: время — местное, длительности — от пояса не зависят', () {
    testWidgets('начало смены, режима и перерыва — по часам телефона', (
      tester,
    ) async {
      final week = designWeek(driving: true);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      String local(DateTime utc) {
        final t = utc.toLocal();
        return '${t.hour.toString().padLeft(2, '0')}:'
            '${t.minute.toString().padLeft(2, '0')}';
      }

      final shiftStart = DateTime.utc(2026, 9, 23, 6, 49);
      expect(
        find.textContaining('смена с ${local(shiftStart)}'),
        findsOneWidget,
      );
      expect(
        find.textContaining('с ${local(DateTime.utc(2026, 9, 23, 9, 3))}'),
        findsOneWidget,
      );
      expect(
        inRow(
          'Перерыв',
          'Взято 15 мин в ${local(DateTime.utc(2026, 9, 23, 8, 48))}',
        ),
        findsOneWidget,
      );
      // Длительности считаются в UTC: в любом поясе CI те же цифры
      expect(find.text('0:29'), findsOneWidget);
      expect(inRow('Рабочий день', '4:31'), findsOneWidget);
    });
  });

  group('DES-04: экранный диктор', () {
    testWidgets('кнопка режима — название и «выбран»', (tester) async {
      final week = designWeek(driving: true);
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: week.now),
      );
      final handle = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.text('Вождение').last),
        isSemantics(
          label: 'Вождение',
          isButton: true,
          isSelected: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.text('Отдых').last),
        isSemantics(label: 'Отдых', isButton: true, isSelected: false),
      );
      handle.dispose();
    });

    testWidgets('таймер читается как длительность, а не «4:30»', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: const [], now: t0),
      );
      expect(
        find.bySemanticsLabel('До перерыва, 4 часа 30 минут'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('4:30'), findsNothing);
      handle.dispose();
    });

    testWidgets('превышение читается как «превышение …»', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(
          periods: consecutive(t0, [
            (DriverMode.driving, const Duration(hours: 5, minutes: 31)),
          ], open: true),
          now: t0.add(const Duration(hours: 5, minutes: 31)),
        ),
      );
      expect(find.text('−1:01'), findsOneWidget);
      expect(
        find.bySemanticsLabel('До перерыва, превышение 1 час 1 минута'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('DES-05: строка лимита', () {
    Future<void> pumpContinuous(
      WidgetTester tester,
      Duration driving,
    ) => pumpScreen(
      tester,
      const HomeScreen(),
      overrides: journalOverrides(
        periods: consecutive(t0, [(DriverMode.driving, driving)], open: true),
        now: t0.add(driving),
        settings: const ComplianceSettings(warningLead: Duration(minutes: 15)),
      ),
    );

    Color? valueColor(WidgetTester tester, String value) => tester
        .widget<Text>(
          find.descendant(
            of: row('Непрерывное вождение'),
            matching: find.text(value),
          ),
        )
        .style
        ?.color;

    testWidgets('норма — без чипа, полоса цвета вождения', (tester) async {
      // Порог из настроек — 15 мин: за 16 мин до 4:30 — ещё норма
      await pumpContinuous(tester, const Duration(hours: 4, minutes: 14));
      expect(inRow('Непрерывное вождение', 'скоро перерыв'), findsNothing);
      expect(inRow('Непрерывное вождение', 'превышено'), findsNothing);
      expect(valueColor(tester, '4:14'), isNull);
    });

    testWidgets('меньше порога из настроек — янтарная плашка', (tester) async {
      await pumpContinuous(tester, const Duration(hours: 4, minutes: 15));
      expect(inRow('Непрерывное вождение', 'скоро перерыв'), findsOneWidget);
      expect(
        backgroundOf(tester, inRow('Непрерывное вождение', 'скоро перерыв')),
        AppColors.dark.warningBg,
      );
      expect(valueColor(tester, '4:15'), AppColors.dark.drive);
    });

    testWidgets('превышение — красная плашка и значение', (tester) async {
      await pumpContinuous(tester, const Duration(hours: 4, minutes: 31));
      expect(inRow('Непрерывное вождение', 'превышено'), findsOneWidget);
      expect(
        backgroundOf(tester, inRow('Непрерывное вождение', 'превышено')),
        AppColors.dark.errorBg,
      );
      expect(valueColor(tester, '4:31'), AppColors.dark.errorText);
    });
  });

  group('PERF-02: тик часов перестраивает только таймеры', () {
    testWidgets('в пределах минуты — ничего, через минуту — только таймеры', (
      tester,
    ) async {
      // 11:20:10 — не на границе минуты ни для прошедшего, ни для остатка
      final week = designWeek(driving: true);
      final start = week.now.add(const Duration(seconds: 10));
      await pumpScreen(
        tester,
        const HomeScreen(),
        overrides: journalOverrides(periods: week.periods, now: start),
      );
      final clock =
          tester.element(find.byType(HomeScreen)).read(clockProvider.notifier)
              as TestClock;

      // Виджеты главной; служебные виджеты Riverpod и Flutter не считаем
      const home = {
        HomeScreen,
        HomeHeader,
        HeroCard,
        HeroRing,
        HeroBanner,
        CurrentModeRow,
        ModeButtons,
        AlertsSection,
        ContinuousRow,
        WorkdayRow,
        DailyDrivingRow,
        BreakRow,
        RestSection,
        WeeklyDrivingRow,
        FortnightRow,
        WorkWeekRow,
        CardReadingTile,
      };
      final rebuilt = <Type>{};
      debugOnRebuildDirtyWidget = (e, _) {
        if (home.contains(e.widget.runtimeType)) {
          rebuilt.add(e.widget.runtimeType);
        }
      };
      addTearDown(() => debugOnRebuildDirtyWidget = null);

      clock.now = start.add(const Duration(seconds: 20));
      await tester.pump();
      expect(rebuilt, isEmpty, reason: 'минута на экране не сменилась');

      clock.now = start.add(const Duration(minutes: 1));
      await tester.pump();
      expect(rebuilt, containsAll([HeroRing, CurrentModeRow, ContinuousRow]));
      expect(
        rebuilt.intersection({HomeScreen, HomeHeader, ModeButtons, HeroCard}),
        isEmpty,
      );
    });
  });
}

extension on Element {
  T read<T>(ProviderListenable<T> provider) =>
      ProviderScope.containerOf(this).read(provider);
}
