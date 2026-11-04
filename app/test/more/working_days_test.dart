// «Рабочие дни» (Premium): рабочие дни, выходные за границей и в стране фирмы
// за месяц и календарь. Правило — в движке (working_days_test). План тестов:
// UI-29 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/more/working_days_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const DriverMode _drive = DriverMode.driving;
const DriverMode _work = DriverMode.otherWork;
const DriverMode _rest = DriverMode.rest;

Duration _h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

/// Местное время телефона: дни считаются по нему.
DateTime _local(int day, int hour) => DateTime(2026, 10, day, hour).toUtc();

/// Фирма в Польше. Чт 08.10 — смена в Германии; пт — из Германии домой к
/// 22:00; сб–вс — дома; пн — выезд 06:00, в Германию; вт — назад; ср — рейс
/// по Польше 05:00–15:00; чт 15.10 — дома: 5 рабочих дней, 3 выходных дома.
final List<ActivityPeriod> trip = consecutive(_local(8, 18), [
  (_drive, _h(4)),
  (_rest, _h(9)),
  (_drive, _h(4, 30)),
  (_rest, _h(0, 45)),
  (_drive, _h(4, 30)),
  (_work, _h(5, 15)),
  (_rest, _h(56)),
  (_drive, _h(4)),
  (_rest, _h(0, 45)),
  (_drive, _h(4)),
  (_rest, _h(15, 15)),
  (_drive, _h(8)),
  (_rest, _h(15)),
  (_drive, _h(4, 30)),
  (_rest, _h(0, 45)),
  (_work, _h(4, 45)),
  (_rest, _h(21)),
], open: true);

final DateTime now = _local(15, 12);

final Map<DateTime, ShiftMeta> tripCountries = {
  _local(8, 18): const ShiftMeta(startCountry: 'D', endCountry: 'D'),
  _local(9, 7): const ShiftMeta(startCountry: 'D', endCountry: 'PL'),
  _local(12, 6): const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
  _local(13, 6): const ShiftMeta(startCountry: 'D', endCountry: 'PL'),
  _local(14, 5): const ShiftMeta(startCountry: 'PL', endCountry: 'PL'),
};

Future<void> pumpDays(
  WidgetTester tester, {
  String? base = 'PL',
  Size viewport = const Size(412, 2400),
  double textScale = 1,
  Locale locale = const Locale('ru'),
}) => pumpScreen(
  tester,
  const WorkingDaysScreen(),
  viewport: viewport,
  textScale: textScale,
  locale: locale,
  overrides: journalOverrides(
    periods: trip,
    now: now,
    shiftMeta: tripCountries,
    settings: ComplianceSettings(baseCountry: base),
  ),
);

/// Значение строки итога с названием [title].
Finder valueOf(String title, String value) => find.descendant(
  of: find.ancestor(of: find.text(title), matching: find.byType(Row)).first,
  matching: find.text(value),
);

void main() {
  group('UI-29: рабочие дни', () {
    testWidgets('месяц: рабочие дни, выходные за границей и дома, календарь', (
      tester,
    ) async {
      await pumpDays(tester);
      expect(find.text('Октябрь 2026'), findsWidgets);
      expect(valueOf('рабочих дней', '5'), findsOneWidget);
      expect(valueOf('Выходные за границей', '0'), findsOneWidget);
      expect(valueOf('Выходные в стране фирмы', '3'), findsOneWidget);
      // Ставки и суммы нет: экран только считает дни
      expect(find.textContaining('Ставка'), findsNothing);
      // Календарь: до журнала — нет данных, рабочий день — один вид и за
      // границей (пятница), и в стране (среда), суббота — выходной дома, после
      // сегодняшнего — ещё не наступили
      expect(
        find.bySemanticsLabel('Четверг, 1 октября: Нет данных'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Пятница, 9 октября: Рабочий день'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Суббота, 10 октября: Выходной в стране фирмы'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Среда, 14 октября: Рабочий день'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Пятница, 16 октября: Нет данных'),
        findsOneWidget,
      );
      expect(find.textContaining('Рабочий день — день с вождением'), findsOne);
      expect(
        find.textContaining('кольцом — выходные в стране фирмы'),
        findsOne,
      );
    });

    testWidgets('выходные за границей — отдельной строкой и в календаре', (
      tester,
    ) async {
      // Пт 09.10 — в Германию к 16:45, сб–вс — отдых там, пн — работа
      final monday = DateTime(2026, 10, 12, 0, 45).toUtc();
      await pumpScreen(
        tester,
        const WorkingDaysScreen(),
        viewport: const Size(412, 2400),
        overrides: journalOverrides(
          periods: consecutive(_local(9, 7), [
            (_drive, _h(4, 30)),
            (_rest, _h(0, 45)),
            (_drive, _h(4, 30)),
            (_rest, _h(56)),
            (_drive, _h(3)),
          ], open: true),
          now: _local(12, 4),
          shiftMeta: {
            _local(9, 7): const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
            monday: const ShiftMeta(startCountry: 'D'),
          },
        ),
      );
      // Выходные за границей — не рабочие дни
      expect(valueOf('рабочих дня', '2'), findsOneWidget);
      expect(valueOf('Выходные за границей', '2'), findsOneWidget);
      expect(valueOf('Выходные в стране фирмы', '0'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Пятница, 9 октября: Рабочий день'),
        findsOneWidget,
      );
      for (final day in ['Суббота, 10 октября', 'Воскресенье, 11 октября']) {
        expect(
          find.bySemanticsLabel('$day: Выходной за границей'),
          findsOneWidget,
        );
      }
      expect(
        find.bySemanticsLabel('Понедельник, 12 октября: Рабочий день'),
        findsOneWidget,
      );
    });

    testWidgets('прошлый месяц — по своим дням, следующий — только до '
        'текущего', (tester) async {
      await pumpDays(tester);
      final next = find.ancestor(
        of: find.byTooltip('Следующий месяц'),
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(next).onPressed, isNull);
      await tester.tap(find.byTooltip('Предыдущий месяц'));
      await tester.pumpAndSettle();
      expect(find.text('Сентябрь 2026'), findsWidgets);
      expect(valueOf('рабочих дней', '0'), findsOneWidget);
      // До журнала — нет данных, а не выходные дома
      expect(valueOf('Выходные в стране фирмы', '0'), findsOneWidget);
      expect(tester.widget<IconButton>(next).onPressed, isNotNull);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(valueOf('рабочих дней', '5'), findsOneWidget);
    });

    testWidgets('без страны фирмы — сначала она', (tester) async {
      await pumpDays(tester, base: null);
      expect(
        find.text(
          'Укажите страну фирмы: рабочие дни считаются относительно неё.',
        ),
        findsOneWidget,
      );
      expect(find.text('Страна фирмы'), findsOneWidget);
      expect(find.text('Не выбрана'), findsOneWidget);
      expect(find.text('Выходные за границей'), findsNothing);
    });

    testWidgets('в «Ещё» — строка, открывает экран', (tester) async {
      await pumpScreen(
        tester,
        const MoreScreen(),
        overrides: journalOverrides(
          periods: trip,
          now: now,
          shiftMeta: tripCountries,
        ),
      );
      expect(
        find.text('Рабочие дни и выходные — в стране фирмы и за границей'),
        findsOneWidget,
      );
      await tester.tap(find.text('Рабочие дни'));
      await tester.pumpAndSettle();
      expect(find.byType(WorkingDaysScreen), findsOneWidget);
    });

    group('на каждом языке — 360 dp и шрифт ×2 без переполнения', () {
      setUpAll(loadAppFonts);
      for (final locale in AppLocalizations.supportedLocales) {
        testWidgets(locale.languageCode, (tester) async {
          await pumpDays(
            tester,
            viewport: const Size(360, 3200),
            textScale: 2,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          expect(find.byType(WorkingDaysScreen), findsOneWidget);
        });
      }
    });
  });

  group('дни месяца', () {
    test('дни месяца — местные сутки подряд, не позже сегодняшних', () {
      final days = monthDays(DateTime(2026, 10), now);
      expect(days, hasLength(15));
      expect(days.first.start, DateTime(2026, 10).toUtc());
      for (var i = 1; i < days.length; i++) {
        expect(days[i].start, days[i - 1].end);
      }
      expect(monthDays(DateTime(2026, 9), now), hasLength(30));
      expect(monthDays(DateTime(2026, 11), now), isEmpty);
    });
  });
}
