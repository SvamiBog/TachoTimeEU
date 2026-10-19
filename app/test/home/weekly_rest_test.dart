// Недельный отдых на главной и на экране 9 (отзыв водителя 19.10.2026): во
// время отдыха — сколько ещё до 24 и 45 ч и когда они наберутся; после двух
// сокращённых подряд — один долг на оба: сколько, до какого времени отдыхать,
// чтобы погасить его целиком, и в журнале — у обоих отдыхов. Правила — в
// движке (art8_weekly_rest_test). План тестов: UI-27 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const _h = Duration(hours: 1);

/// Пять дней по 13 ч работы и 11 ч отдыха.
final List<(DriverMode, Duration)> _days = [
  for (var i = 0; i < 5; i++) ...[
    (DriverMode.otherWork, _h * 13),
    (DriverMode.rest, _h * 11),
  ],
];

/// Два сокращённых недельных по 24 ч подряд: с сб 19.09 20:00 и с сб 26.09
/// 06:00 — один долг 21 + 21 = 42 ч до пн 12.10, дальше [after].
List<ActivityPeriod> twoReduced(List<(DriverMode, Duration)> after) =>
    consecutive(DateTime.utc(2026, 9, 19, 20), [
      (DriverMode.rest, _h * 24),
      ..._days,
      (DriverMode.otherWork, _h * 10),
      (DriverMode.rest, _h * 24),
      ...after,
    ], open: true);

/// Следующий недельный отдых после двух сокращённых — с пт 02.10 16:00.
final DateTime nextRestStart = DateTime.utc(2026, 10, 2, 16);
final List<ActivityPeriod> onNextRest = twoReduced([
  ..._days,
  (DriverMode.otherWork, _h * 10),
  (DriverMode.rest, _h * 30),
]);

/// Раньше пары — сокращённый 30 ч с сб 05.09 20:00 (свой долг 15 ч до пн
/// 28.09) и полный 45 ч; водитель работает после пары.
final List<ActivityPeriod> singleThenPair = [
  ...consecutive(DateTime.utc(2026, 9, 5, 20), [
    (DriverMode.rest, _h * 30),
    ..._days,
    (DriverMode.otherWork, _h * 10),
    (DriverMode.rest, _h * 45),
    ..._days,
    (DriverMode.otherWork, _h * 11),
  ]),
  ...twoReduced([(DriverMode.driving, _h * 2)]),
];

Future<void> pumpHome(
  WidgetTester tester,
  List<ActivityPeriod> periods,
  DateTime now,
) async {
  await pumpScreen(
    tester,
    const HomeScreen(),
    viewport: const Size(412, 2400),
    overrides: journalOverrides(periods: periods, now: now),
  );
  await tester.pumpAndSettle();
}

/// Текст в строке лимита главной с названием [title].
Finder inRow(String title, String text) => find.descendant(
  of: find.ancestor(of: find.text(title), matching: find.byType(InkWell)),
  matching: find.text(text),
);

String at(DateTime t) => formatWeekdayClock(t, 'ru');

void main() {
  group('UI-27: недельный отдых на главной — до 24 и 45 ч', () {
    // Смена 4 ч, затем «Начать недельный отдых» с пн 21.09 10:00
    final restStart = DateTime.utc(2026, 9, 21, 10);
    final declared = () {
      final log = consecutive(DateTime.utc(2026, 9, 21, 6), [
        (DriverMode.driving, _h * 4),
        (DriverMode.rest, _h),
      ], open: true);
      return [log.first, log.last.withWeeklyRest(weeklyRest: true)];
    }();

    testWidgets('до 24 ч — сколько ещё и когда, затем 45 ч', (tester) async {
      await pumpHome(tester, declared, restStart.add(_h * 10));
      expect(inRow('Недельный отдых', 'идёт 10:00'), findsOneWidget);
      expect(
        inRow(
          'Недельный отдых',
          '24 ч: ещё 14:00 → ${at(restStart.add(_h * 24))}',
        ),
        findsOneWidget,
      );
      expect(
        inRow('Недельный отдых', '45 ч → ${at(restStart.add(_h * 45))}'),
        findsOneWidget,
      );
    });

    testWidgets('24 ч набраны — сколько ещё до 45 ч', (tester) async {
      await pumpHome(tester, declared, restStart.add(_h * 30));
      expect(
        inRow(
          'Недельный отдых',
          '45 ч: ещё 15:00 → ${at(restStart.add(_h * 45))}',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('24 ч: ещё'), findsNothing);
    });

    testWidgets('суточный отдых набрал 11 ч — когда он станет недельным', (
      tester,
    ) async {
      final periods = consecutive(DateTime.utc(2026, 9, 21, 6), [
        (DriverMode.driving, _h * 4),
        (DriverMode.rest, _h * 12),
      ], open: true);
      await pumpHome(tester, periods, restStart.add(_h * 12));
      expect(
        inRow('Суточный отдых', '24 ч → ${at(restStart.add(_h * 24))}'),
        findsOneWidget,
      );
      expect(inRow('Недельный отдых', 'не начат'), findsOneWidget);
    });

    testWidgets('сокращённый недоступен — сразу 45 ч', (tester) async {
      await pumpHome(tester, onNextRest, nextRestStart.add(_h * 30));
      expect(inRow('Недельный отдых', 'только 45 ч'), findsOneWidget);
      expect(
        inRow(
          'Недельный отдых',
          '45 ч: ещё 15:00 → ${at(nextRestStart.add(_h * 45))}',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('24 ч: ещё'), findsNothing);
    });
  });

  group('UI-27: компенсация после двух сокращённых по 24 ч', () {
    testWidgets('водитель работает — один долг 42:00 со сроком первого', (
      tester,
    ) async {
      final periods = twoReduced([(DriverMode.driving, _h * 2)]);
      await pumpHome(tester, periods, DateTime.utc(2026, 9, 27, 8));
      expect(inRow('Компенсация', '42:00'), findsOneWidget);
      expect(
        inRow('Компенсация', 'присоединить к отдыху от 9 ч'),
        findsOneWidget,
      );
      expect(
        inRow(
          'Компенсация',
          'до ${formatDayMonth(DateTime.utc(2026, 10, 12))}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('ещё и одиночный сокращённый — всего и ближайший долг', (
      tester,
    ) async {
      await pumpHome(tester, singleThenPair, DateTime.utc(2026, 9, 27, 8));
      expect(inRow('Компенсация', '57:00'), findsOneWidget);
      expect(
        inRow(
          'Компенсация',
          '15:00 до ${formatDayMonth(DateTime.utc(2026, 9, 28))}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('на следующем недельном — отдыхать 45 + 42 = 87 ч, по '
        'частям не гасится', (tester) async {
      await pumpHome(tester, onNextRest, nextRestStart.add(_h * 30));
      expect(inRow('Компенсация', '42:00'), findsOneWidget);
      expect(
        inRow('Компенсация', 'отдыхать до ${at(nextRestStart.add(_h * 87))}'),
        findsOneWidget,
      );
      await unmount(tester);

      // 66 ч = 45 + 21: половина долга не погашена, отдыхать до тех же 87 ч
      await pumpHome(tester, onNextRest, nextRestStart.add(_h * 66));
      expect(inRow('Компенсация', '42:00'), findsOneWidget);
      expect(inRow('Компенсация', 'погашена'), findsNothing);
      expect(
        inRow('Компенсация', 'отдыхать до ${at(nextRestStart.add(_h * 87))}'),
        findsOneWidget,
      );
      await unmount(tester);

      await pumpHome(tester, onNextRest, nextRestStart.add(_h * 87));
      expect(inRow('Компенсация', 'погашена'), findsOneWidget);
      expect(inRow('Компенсация', '42:00'), findsOneWidget);
    });

    testWidgets('в журнале — долг на оба у каждого из двух отдыхов', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const JournalScreen(),
        viewport: const Size(412, 4000),
        overrides: journalOverrides(
          periods: twoReduced([(DriverMode.driving, _h * 2)]),
          now: DateTime.utc(2026, 9, 27, 8),
        ),
      );
      await tester.pumpAndSettle();
      final debt =
          'долг 42:00 — присоединить до '
          '${formatDayMonth(DateTime.utc(2026, 10, 12))}';
      expect(
        find.text(
          '$debt · вместе с отдыхом '
          '${formatDayMonth(DateTime.utc(2026, 9, 26, 6))}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '$debt · вместе с отдыхом '
          '${formatDayMonth(DateTime.utc(2026, 9, 19, 20))}',
        ),
        findsOneWidget,
      );
    });
  });

  group('UI-27: экран «Недельный отдых»', () {
    Future<void> pumpWeekly(
      WidgetTester tester, {
      List<ActivityPeriod>? periods,
      DateTime? now,
      Size viewport = const Size(412, 2400),
      double textScale = 1,
      Locale locale = const Locale('ru'),
    }) async {
      await pumpScreen(
        tester,
        const WeeklyRestScreen(),
        viewport: viewport,
        textScale: textScale,
        locale: locale,
        overrides: journalOverrides(
          periods: periods ?? onNextRest,
          now: now ?? nextRestStart.add(_h * 30),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> pumpDebts(
      WidgetTester tester, {
      Size viewport = const Size(412, 2400),
      double textScale = 1,
      Locale locale = const Locale('ru'),
    }) => pumpWeekly(
      tester,
      periods: singleThenPair,
      now: DateTime.utc(2026, 9, 27, 8),
      viewport: viewport,
      textScale: textScale,
      locale: locale,
    );

    const twoReducedNote =
        'Два сокращённых подряд — один долг 42:00: его берут целиком, одним '
        'блоком, после второго из них и перед следующим недельным отдыхом; '
        'по частям и между ними нельзя. Вместе с полным недельным — 87:00 '
        'отдыха подряд.';

    testWidgets('отдых идёт — вехи 24 и 45 ч, компенсация', (tester) async {
      await pumpWeekly(tester);
      expect(find.text('НЕДЕЛЬНЫЙ ОТДЫХ ИДЁТ'), findsOneWidget);
      expect(find.text('с ${at(nextRestStart)}'), findsOneWidget);
      expect(find.text('СКОЛЬКО ОТДЫХАТЬ'), findsOneWidget);
      // Сокращённый после двух сокращённых подряд недоступен
      expect(find.text('24 ч — сокращённый'), findsOneWidget);
      expect(find.text('недоступен — нужен полный'), findsOneWidget);
      expect(find.text('45 ч — полный'), findsOneWidget);
      expect(find.text('ещё 15:00'), findsOneWidget);
      expect(find.text(at(nextRestStart.add(_h * 45))), findsOneWidget);
      expect(
        find.text('отдыхать до ${at(nextRestStart.add(_h * 87))}'),
        findsOneWidget,
      );
      // Варианты отдыха — когда отдых не идёт
      expect(find.text('СЛЕДУЮЩИЙ ОТДЫХ'), findsNothing);
    });

    testWidgets('два сокращённых подряд — один долг и пояснение', (
      tester,
    ) async {
      await pumpWeekly(tester);
      expect(find.text('Долг по компенсации'), findsOneWidget);
      expect(
        find.text('42:00 до ${formatDayMonth(DateTime.utc(2026, 10, 12))}'),
        findsOneWidget,
      );
      expect(find.textContaining('за отдых'), findsNothing);
      expect(find.text(twoReducedNote), findsOneWidget);
    });

    testWidgets('несколько долгов — всего и каждый со сроком, пара — '
        'одной строкой', (tester) async {
      await pumpDebts(tester);
      expect(find.text('57:00'), findsOneWidget);
      expect(
        find.text('за отдых ${formatDayMonth(DateTime.utc(2026, 9, 5, 20))}'),
        findsOneWidget,
      );
      expect(
        find.text('15:00 до ${formatDayMonth(DateTime.utc(2026, 9, 28))}'),
        findsOneWidget,
      );
      expect(
        find.text(
          'за отдыхи ${formatDayMonth(DateTime.utc(2026, 9, 19, 20))} и '
          '${formatDayMonth(DateTime.utc(2026, 9, 26, 6))}',
        ),
        findsOneWidget,
      );
      expect(
        find.text('42:00 до ${formatDayMonth(DateTime.utc(2026, 10, 12))}'),
        findsOneWidget,
      );
      expect(find.text(twoReducedNote), findsOneWidget);
    });

    testWidgets('один долг — как раньше: долг и срок одной строкой', (
      tester,
    ) async {
      // 30 ч вместо 45: долг 15 ч до пн 12.10
      final periods = consecutive(DateTime.utc(2026, 9, 19, 20), [
        (DriverMode.rest, _h * 30),
        (DriverMode.driving, _h * 4),
      ], open: true);
      await pumpScreen(
        tester,
        const WeeklyRestScreen(),
        viewport: const Size(412, 2400),
        overrides: journalOverrides(
          periods: periods,
          now: DateTime.utc(2026, 9, 21, 6),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('15:00 до ${formatDayMonth(DateTime.utc(2026, 10, 12))}'),
        findsOneWidget,
      );
      expect(find.textContaining('за отдых'), findsNothing);
      expect(find.textContaining('Два сокращённых подряд'), findsNothing);
      expect(find.text('СЛЕДУЮЩИЙ ОТДЫХ'), findsOneWidget);
    });

    // L10N-06 для новых строк: экран с вехами, долгами и пояснением на
    // каждом языке — 360 dp и шрифт ×2, настоящими шрифтами
    setUpAll(loadAppFonts);
    for (final locale in AppLocalizations.supportedLocales) {
      testWidgets('перевод ${locale.languageCode}: 360 dp, шрифт ×2 — без '
          'переполнения', (tester) async {
        await pumpWeekly(
          tester,
          viewport: const Size(360, 3200),
          textScale: 2,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await unmount(tester);
        await pumpDebts(
          tester,
          viewport: const Size(360, 3200),
          textScale: 2,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
