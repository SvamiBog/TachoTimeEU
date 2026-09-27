// Журнал (экран 2) и детали дня. План тестов: UI-09 в docs/testing.md.
// Данные — журнал с макета «Журнал» (designJournal): суммы недель и
// подсветка совпадают с макетом.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

Future<void> _pumpJournal(
  WidgetTester tester, {
  List<ActivityPeriod>? periods,
  DateTime? now,
  List<ManualShiftRecord> manual = const [],
  Size viewport = const Size(412, 2400),
}) async {
  final j = designJournal();
  await pumpScreen(
    tester,
    const JournalScreen(),
    viewport: viewport,
    overrides: journalOverrides(
      periods: periods ?? j.periods,
      now: now ?? j.now,
      manualShifts: manual,
      shiftMeta: {
        for (final MapEntry(:key, :value) in j.countries.entries)
          key: ShiftMeta(startCountry: value.start, endCountry: value.end),
      },
    ),
  );
}

// Время на экране — местное: ожидания считаются так же, чтобы тест шёл в
// любом часовом поясе (CI-01).
DateTime _u(int day, int hour, int minute) =>
    DateTime.utc(2026, 9, day, hour, minute);

String _span(DateTime a, DateTime? b) =>
    '${formatClock(a)} → ${b == null ? 'идёт' : formatClock(b)}';

/// Ячейка итогов со значением [value].
MetricCell _cell(WidgetTester tester, String value) => tester
    .widgetList<MetricCell>(find.byType(MetricCell))
    .firstWhere((c) => c.value == value);

void main() {
  setUpAll(loadAppFonts);

  group('UI-09: журнал по неделям', () {
    testWidgets('недели с понедельника, суммы вождения как на макете', (
      tester,
    ) async {
      await _pumpJournal(tester);
      expect(find.text('Сентябрь 2026'), findsOneWidget);
      expect(find.text('21–27 сентября'), findsOneWidget);
      expect(find.text('14–20 сентября'), findsOneWidget);
      expect(find.text('7–13 сентября'), findsOneWidget);
      expect(find.text('текущая'), findsOneWidget);
      for (final sum in ['21:40', '57:14', '35:34', '76:44', '41:10']) {
        expect(find.textContaining(sum, findRichText: true), findsWidgets);
      }
    });

    testWidgets('смены — день, страны, время, итоги', (tester) async {
      await _pumpJournal(tester);
      expect(find.text('PL → …'), findsOneWidget);
      expect(find.text(_span(_u(23, 6, 49), null)), findsOneWidget);
      expect(find.text(_span(_u(22, 6, 30), _u(22, 19, 10))), findsOneWidget);
      expect(find.text('D → PL'), findsOneWidget);
      expect(_cell(tester, '8:55').label, 'Вождение');
      expect(_cell(tester, '12:40').label, 'Смена');
      expect(_cell(tester, '11:39').label, 'Отдых');
      expect(_cell(tester, 'нед.').label, 'Отдых', reason: 'пт 18.09');
      final tuesday = _u(22, 6, 30);
      expect(find.text(formatWeekdayShort(tuesday, 'ru')), findsWidgets);
      expect(find.text('${tuesday.toLocal().day}'), findsWidgets);
    });

    testWidgets('подсветка 10 ч, 13+ ч и сокращённого отдыха — по движку', (
      tester,
    ) async {
      await _pumpJournal(tester);
      // Вт 15.09: 9:40 вождения, 13:50 смены, отдых 9:30
      expect(_cell(tester, '9:40').tone, Tone.warning);
      expect(_cell(tester, '13:50').tone, Tone.warning);
      expect(_cell(tester, '9:30').tone, Tone.warning);
      expect(_cell(tester, '8:55').tone, Tone.neutral);
      expect(_cell(tester, '12:40').tone, Tone.neutral);
      expect(_cell(tester, '11:39').tone, Tone.neutral);
    });

    testWidgets('больше 10 ч и 15 ч — нарушение', (tester) async {
      final start = DateTime.utc(2026, 9, 21, 4);
      final periods = consecutive(start, [
        (DriverMode.rest, const Duration(hours: 11)),
        (DriverMode.driving, const Duration(hours: 4, minutes: 30)),
        (DriverMode.rest, const Duration(minutes: 45)),
        (DriverMode.driving, const Duration(hours: 4, minutes: 30)),
        (DriverMode.rest, const Duration(minutes: 45)),
        (DriverMode.driving, const Duration(hours: 1, minutes: 30)),
        (DriverMode.otherWork, const Duration(hours: 4)),
        (DriverMode.rest, const Duration(hours: 11)),
      ]);
      await _pumpJournal(
        tester,
        periods: periods,
        now: DateTime.utc(2026, 9, 22, 16),
      );
      expect(_cell(tester, '10:30').tone, Tone.violation);
      expect(_cell(tester, '16:00').tone, Tone.violation);
      expect(find.text('текущая'), findsOneWidget);
    });

    testWidgets('идущий отдых после смены — зелёная ячейка', (tester) async {
      final periods = consecutive(DateTime.utc(2026, 9, 23, 6), [
        (DriverMode.driving, const Duration(hours: 4)),
        (DriverMode.rest, const Duration(hours: 10)),
      ], open: true);
      await _pumpJournal(
        tester,
        periods: periods,
        now: DateTime.utc(2026, 9, 23, 20),
      );
      expect(_cell(tester, '10:00').tone, Tone.rest);
    });

    testWidgets('смена в неделе своего начала, граница — пн 00:00 UTC', (
      tester,
    ) async {
      // Вс 20.09 22:00 UTC — прошлая неделя, в любом часовом поясе
      final periods = [
        ...consecutive(DateTime.utc(2026, 9, 20, 22), [
          (DriverMode.driving, const Duration(hours: 3)),
          (DriverMode.rest, const Duration(hours: 11)),
        ]),
        ...consecutive(DateTime.utc(2026, 9, 21, 12), [
          (DriverMode.driving, const Duration(hours: 1)),
        ], open: true),
      ];
      await _pumpJournal(
        tester,
        periods: periods,
        now: DateTime.utc(2026, 9, 21, 13),
      );
      expect(find.text('21–27 сентября'), findsOneWidget);
      expect(find.text('14–20 сентября'), findsOneWidget);
      // Неделя 21.09: 1 ч своей смены и 1 ч вождения после полуночи
      expect(find.textContaining('2:00', findRichText: true), findsWidgets);
    });

    testWidgets('недельный отдых — в неделе, где закончился', (tester) async {
      await _pumpJournal(tester);
      expect(find.text('Недельный отдых · полный'), findsNWidgets(2));
      expect(find.text('66:50'), findsOneWidget);
      expect(
        find.text(
          '${formatDayMonthClock(_u(18, 11, 20))} → '
          '${formatDayMonthClock(_u(21, 6, 10))}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('старые недели свёрнуты, касание раскрывает и сворачивает', (
      tester,
    ) async {
      await _pumpJournal(tester);
      final older = _span(_u(7, 6, 0), _u(7, 17, 0));
      final current = _span(_u(23, 6, 49), null);
      expect(find.text(older), findsNothing, reason: '7–13.09 свёрнута');
      await tester.tap(find.text('7–13 сентября'));
      await tester.pumpAndSettle();
      expect(find.text(older), findsNWidgets(5));

      await tester.tap(find.text('21–27 сентября'));
      await tester.pumpAndSettle();
      expect(find.text(current), findsNothing);
      await tester.tap(find.text('21–27 сентября'));
      await tester.pumpAndSettle();
      expect(find.text(current), findsOneWidget);
    });

    testWidgets('ручная смена отмечена «вручную»', (tester) async {
      final manual = ManualShift(
        id: 1,
        start: DateTime.utc(2026, 9, 1, 6),
        end: DateTime.utc(2026, 9, 1, 16),
        driving: const Duration(hours: 8),
        restKind: RestKind.daily,
        rest: const Duration(hours: 11),
      );
      await _pumpJournal(
        tester,
        manual: [
          ManualShiftRecord(
            manual,
            const ShiftMeta(startCountry: 'CZ', endCountry: 'SK'),
          ),
        ],
      );
      await tester.tap(find.text('31 августа – 6 сентября'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('CZ → SK', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('вручную', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('пустой журнал — подсказка', (tester) async {
      await _pumpJournal(
        tester,
        periods: const [],
        now: DateTime.utc(2026, 9, 23, 12),
      );
      expect(find.textContaining('Смен пока нет'), findsOneWidget);
      expect(find.text('21–27 сентября'), findsOneWidget);
    });

    testWidgets('диктор читает строку смены целиком', (tester) async {
      final handle = tester.ensureSemantics();
      await _pumpJournal(tester);
      final start = _u(22, 6, 30);
      final label =
          '${formatWeekdayFull(start, 'ru')}, PL → PL, '
          '${_span(start, _u(22, 19, 10))}. Вождение 8 часов 55 минут';
      expect(
        find.bySemanticsLabel(RegExp('^${RegExp.escape(label)}')),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('детали дня', () {
    testWidgets('касание смены — записи режимов и итоги', (tester) async {
      await _pumpJournal(tester);
      await tester.tap(find.text(_span(_u(22, 6, 30), _u(22, 19, 10))));
      await tester.pumpAndSettle();
      expect(find.byType(ShiftDayScreen), findsOneWidget);
      expect(find.text(formatWeekdayFull(_u(22, 6, 30), 'ru')), findsOneWidget);
      // Запись — «с–по», через местную полночь — с датой конца
      String block(DateTime a, DateTime b) => isSameLocalDay(a, b)
          ? '${formatClock(a)}–${formatClock(b)}'
          : '${formatClock(a)} – ${formatDayMonthClock(b)}';
      expect(find.text(block(_u(22, 6, 30), _u(22, 6, 45))), findsOneWidget);
      expect(find.text(block(_u(22, 6, 45), _u(22, 11, 15))), findsOneWidget);
      expect(find.text(block(_u(22, 19, 10), _u(23, 6, 49))), findsOneWidget);
      expect(find.text('Изменить смену'), findsOneWidget);
    });

    testWidgets('ручная смена — без записей, с подсказкой', (tester) async {
      final manual = ManualShift(
        id: 7,
        start: DateTime.utc(2026, 9, 1, 6),
        end: DateTime.utc(2026, 9, 1, 16),
        driving: const Duration(hours: 8),
        restKind: RestKind.weekly,
        rest: const Duration(hours: 45),
      );
      final j = designJournal();
      await pumpScreen(
        tester,
        ShiftDayScreen(shiftKey: (manualId: 7, start: DateTime.utc(2026))),
        overrides: journalOverrides(
          periods: j.periods,
          now: j.now,
          manualShifts: [
            ManualShiftRecord(
              manual,
              const ShiftMeta(startCountry: 'PL', note: 'до установки'),
            ),
          ],
        ),
      );
      expect(find.textContaining('внесена вручную'), findsOneWidget);
      expect(find.text('до установки'), findsOneWidget);
      expect(find.textContaining('Недельный'), findsOneWidget);
    });

    testWidgets('смены больше нет — сообщение', (tester) async {
      final j = designJournal();
      await pumpScreen(
        tester,
        ShiftDayScreen(
          shiftKey: (manualId: null, start: DateTime.utc(2026, 9, 2)),
        ),
        overrides: journalOverrides(periods: j.periods, now: j.now),
      );
      expect(find.text('Смены больше нет в журнале.'), findsOneWidget);
    });
  });
}
