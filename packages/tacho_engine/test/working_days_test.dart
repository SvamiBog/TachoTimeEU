// Рабочие дни для зарплаты: день считается, если водитель хоть часть дня был
// вне страны фирмы или работал в ней. План тестов: ENG-26 в docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

/// Сутки UTC с [first] по [last] включительно.
List<CalendarDay> utcDays(String first, String last) {
  final days = <CalendarDay>[];
  for (
    var d = utc('$first 00:00');
    !d.isAfter(utc('$last 00:00'));
    d = d.add(day)
  ) {
    days.add((start: d, end: d.add(day)));
  }
  return days;
}

List<WorkingDayKind> kinds(
  List<ActivityPeriod> periods,
  DateTime now,
  List<String?> countries,
  List<CalendarDay> days, {
  List<ManualShift> manual = const [],
  Map<DateTime, ShiftRoute>? routes,
}) {
  final shifts = journalShifts(periods, now, manual: manual);
  return workingDayKinds(
    shifts: shifts,
    routes:
        routes ??
        {
          for (final (i, s) in shifts.indexed)
            if (countries[i] case final c?)
              s.start: ShiftRoute(
                from: c.split('-').first,
                to: c.split('-').last,
              ),
        },
    baseCountry: 'PL',
    days: days,
    now: now,
  );
}

const WorkingDayKind abroad = WorkingDayKind.abroad;
const WorkingDayKind home = WorkingDayKind.home;
const WorkingDayKind off = WorkingDayKind.off;

void main() {
  group('ENG-26: рабочие дни — за границей или работа', () {
    // Фирма в Польше. Чт — смена в Германии; пт — из Германии домой к
    // 22:00; сб–вс — дома; пн — выезд 06:00, в Германию; вт — назад; ср —
    // рейс только по Польше 05:00–15:00; чт — дома.
    final log = logFrom(utc('2026-10-08 18:00'), [
      drive('4:00'),
      rest('9:00'),
      ...drivingDay('9:00'),
      work('5:15'),
      rest('56:00'),
      ...drivingDay('8:00'),
      rest('15:15'),
      drive('8:00'),
      rest('15:00'),
      drive('4:30'),
      rest('0:45'),
      work('4:45'),
      rest('21:00'),
    ]);
    const route = ['D-D', 'D-PL', 'PL-D', 'D-PL', 'PL-PL'];

    test(
      'пример водителя: выходные дома не считаются, рейс по стране — да',
      () {
        expect(log.now, utc('2026-10-15 12:00'));
        expect(
          kinds(
            log.periods,
            log.now,
            route,
            utcDays('2026-10-07', '2026-10-15'),
          ),
          [off, abroad, abroad, off, off, abroad, abroad, home, off],
        );
      },
    );

    test('выходные за границей — рабочие дни', () {
      final away = logFrom(utc('2026-10-09 07:00'), [
        ...drivingDay('9:00'),
        rest('56:00'),
        ...drivingDay('9:00'),
      ]);
      expect(
        kinds(
          away.periods,
          away.now,
          ['PL-D', 'D-D'],
          [...utcDays('2026-10-09', '2026-10-12')],
        ),
        [abroad, abroad, abroad, abroad],
      );
    });

    test('страна конца не выбрана — отдых в стране начала', () {
      final away = logFrom(utc('2026-10-09 07:00'), [
        ...drivingDay('9:00'),
        rest('30:00'),
      ]);
      expect(
        kinds(away.periods, away.now, [
          'D',
        ], utcDays('2026-10-09', '2026-10-10')),
        [abroad, abroad],
      );
      expect(
        kinds(away.periods, away.now, [
          'PL',
        ], utcDays('2026-10-09', '2026-10-10')),
        [home, off],
      );
    });

    test('страны не выбраны — дни работы считаются, отдых нет', () {
      expect(
        kinds(
          log.periods,
          log.now,
          List.filled(5, null),
          utcDays('2026-10-08', '2026-10-15'),
        ),
        [home, home, off, off, home, home, home, off],
      );
    });

    test('только готовность в стране фирмы — день не рабочий', () {
      // Смена 20:00–22:00 вождения, после полуночи — готовность до 01:00
      final night = logFrom(utc('2026-10-09 20:00'), [
        drive('2:00'),
        poa('3:00'),
        rest('20:00'),
      ]);
      expect(
        kinds(night.periods, night.now, [
          'PL-PL',
        ], utcDays('2026-10-09', '2026-10-10')),
        [home, off],
      );
    });

    test('дни — по местному времени, их границы задаёт приложение', () {
      // Рейс по Польше 14:00–22:30 UTC — в Варшаве (UTC+2) до 00:30
      final late = logFrom(utc('2026-10-09 14:00'), [
        ...drivingDay('8:30'),
        rest('11:00'),
      ]);
      final warsaw = [
        for (final d in utcDays('2026-10-09', '2026-10-10'))
          (
            start: d.start.subtract(const Duration(hours: 2)),
            end: d.end.subtract(const Duration(hours: 2)),
          ),
      ];
      expect(late.periods[1].end, isNotNull);
      expect(kinds(late.periods, late.now, ['PL-PL'], warsaw), [home, home]);
      expect(
        kinds(late.periods, late.now, [
          'PL-PL',
        ], utcDays('2026-10-09', '2026-10-10')),
        [home, off],
      );
    });

    test('ручная смена — работа вся смена, страна из её маршрута', () {
      final manual = [
        ManualShift(
          start: utc('2026-10-05 06:00'),
          end: utc('2026-10-05 16:00'),
          driving: const Duration(hours: 8),
          restKind: RestKind.weekly,
        ),
      ];
      final now = utc('2026-10-07 12:00');
      final days = utcDays('2026-10-05', '2026-10-07');
      expect(
        kinds(
          const [],
          now,
          const [],
          days,
          manual: manual,
          routes: {manual.first.start: const ShiftRoute(from: 'PL', to: 'PL')},
        ),
        [home, off, off],
      );
      expect(
        kinds(
          const [],
          now,
          const [],
          days,
          manual: manual,
          routes: {manual.first.start: const ShiftRoute(from: 'PL', to: 'D')},
        ),
        [abroad, abroad, abroad],
      );
    });

    test('идущая смена за границей — сегодня рабочий день', () {
      final now = utc('2026-10-12 08:00');
      final periods = logUntil(now, [rest('60:00'), drive('2:00')]);
      expect(kinds(periods, now, ['D'], utcDays('2026-10-11', '2026-10-12')), [
        off,
        abroad,
      ]);
    });
  });
}
