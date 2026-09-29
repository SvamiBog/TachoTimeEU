// Компенсация сокращённого недельного отдыха (ст. 8(6), 8(7)) на экранах:
// долг и срок на главной, сколько отдыхать, чтобы погасить его, погашенный
// долг — в отдыхе и в журнале. Правила — в движке (art8_weekly_rest_test).
// План тестов: UI-22 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const _h = Duration(hours: 1);

/// Сокращённый недельный отдых [rest] с сб 19.09 20:00, дальше [after].
List<ActivityPeriod> reducedThen(
  Duration rest,
  List<(DriverMode, Duration)> after,
) => consecutive(DateTime.utc(2026, 9, 19, 20), [
  (DriverMode.rest, rest),
  ...after,
], open: true);

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

/// Строка «Компенсация» на главной: её текст.
Finder inRow(String text) => find.descendant(
  of: find.ancestor(
    of: find.text('Компенсация'),
    matching: find.byType(InkWell),
  ),
  matching: find.text(text),
);

void main() {
  group('UI-22: компенсация на главной', () {
    testWidgets('долг есть, водитель работает — долг и срок', (tester) async {
      // 30 ч вместо 45: долг 15 ч до пн 12.10
      final periods = reducedThen(_h * 30, [(DriverMode.driving, _h * 4)]);
      final now = DateTime.utc(2026, 9, 21, 6);
      await pumpHome(tester, periods, now);

      expect(find.text('Компенсация'), findsOneWidget);
      expect(inRow('15:00'), findsOneWidget);
      expect(inRow('присоединить к отдыху от 9 ч'), findsOneWidget);
      expect(
        inRow('до ${formatDayMonth(DateTime.utc(2026, 10, 12))}'),
        findsOneWidget,
      );
    });

    testWidgets('на суточном отдыхе — до какого времени отдыхать, затем '
        '«погашена»', (tester) async {
      // 40 ч вместо 45: долг 5 ч. Смена 10 ч, с 22:00 отдых — конец дня.
      final log = reducedThen(_h * 40, [
        (DriverMode.otherWork, _h * 10),
        (DriverMode.rest, _h * 4),
      ]);
      final periods = [...log.take(2), log.last.withDayEnd(dayEnd: true)];
      final restStart = DateTime.utc(2026, 9, 21, 22);
      await pumpHome(tester, periods, restStart.add(_h * 4));
      // 9 ч + 5 ч долга
      expect(inRow('5:00'), findsOneWidget);
      expect(
        inRow(
          'отдыхать до '
          '${formatWeekdayClock(restStart.add(_h * 14), 'ru')}',
        ),
        findsOneWidget,
      );
      await unmount(tester);

      await pumpHome(tester, periods, restStart.add(_h * 14));
      expect(inRow('погашена'), findsOneWidget);
      expect(inRow('присоединена к этому отдыху'), findsOneWidget);
    });

    testWidgets('долга нет — строки нет', (tester) async {
      final periods = consecutive(DateTime.utc(2026, 9, 19, 20), [
        (DriverMode.rest, _h * 48),
        (DriverMode.driving, _h * 2),
      ], open: true);
      await pumpHome(tester, periods, DateTime.utc(2026, 9, 21, 22));
      expect(find.text('Компенсация'), findsNothing);
    });
  });

  testWidgets('UI-22: в журнале у сокращённого недельного — долг и срок', (
    tester,
  ) async {
    final periods = reducedThen(_h * 30, [(DriverMode.driving, _h * 4)]);
    await pumpScreen(
      tester,
      const JournalScreen(),
      viewport: const Size(412, 2400),
      overrides: journalOverrides(
        periods: periods,
        now: DateTime.utc(2026, 9, 21, 6),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'долг 15:00 — присоединить до '
        '${formatDayMonth(DateTime.utc(2026, 10, 12))}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('UI-22: форма смены — долг за сокращённый недельный после '
      'неё', (tester) async {
    // Смена 10 ч, после неё недельный 30 ч: долг 15 ч
    final periods = consecutive(DateTime.utc(2026, 9, 19, 10), [
      (DriverMode.otherWork, _h * 10),
      (DriverMode.rest, _h * 30),
      (DriverMode.driving, _h * 4),
    ], open: true);
    final now = DateTime.utc(2026, 9, 21, 6);
    final shift =
        buildJournal(timeline: analyzeTimeline(periods, now), now: now)
            .expand((w) => w.shifts)
            .firstWhere((x) => x.start == DateTime.utc(2026, 9, 19, 10));
    await pumpScreen(
      tester,
      ShiftEditScreen(shift: shift),
      viewport: const Size(412, 2400),
      overrides: journalOverrides(
        periods: periods,
        now: now,
        defaultCountry: 'PL',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Долг по компенсации'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
    expect(
      find.text(
        'присоединить до ${formatDayMonth(DateTime.utc(2026, 10, 12))}',
      ),
      findsOneWidget,
    );
  });
}
