// ENG-29 (docs/testing.md): рабочий день после ручной смены. Отдых короче
// 9 ч день не заканчивает — так считается отдых внутри смены из записей, и
// так же после смены, внесённой итогами: «Завершить день» с вождением,
// которое разошлось с записями, а через три часа водитель снова едет.
// Раньше суточное вождение и рабочий день начинались с нуля.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  /// Среда, неделя с понедельника 21.09.
  final start = utc('2026-09-23 06:00');

  /// Смена с 06:00 до 15:15: 8 ч вождения с перерывом 45 мин.
  final log = logFrom(start, [
    work('0:30'),
    drive('4:30'),
    rest('0:45'),
    drive('3:30'),
  ]);
  final end = log.now;

  /// «Завершить день» с вождением [driving], через [pause] — снова вождение.
  ({List<ActivityPeriod> periods, List<ManualShift> manual, DateTime back})
  resumed(Object driving, {Object pause = '3:00'}) {
    final ended = endDayWithDriving(log.periods, dur(driving), end);
    final back = end.add(dur(pause));
    return (
      periods: changeMode(ended.periods, DriverMode.driving, back),
      manual: [?ended.manual],
      back: back,
    );
  }

  /// Ручная смена с 06:00 и непрерывным вождением [continuous] на её конец.
  ManualShift driven(Object span, Object driving, {Object continuous = 0}) =>
      ManualShift(
        start: start,
        end: start.add(dur(span)),
        driving: dur(driving),
        continuousDrivingAtEnd: dur(continuous),
        restKind: RestKind.daily,
      );

  group('ENG-29: «Завершить день» с итогом, затем снова в путь', () {
    test('через 3 ч — тот же рабочий день: вождение и время смены '
        'продолжаются', () {
      final r = resumed('8:10');
      expect(r.manual, hasLength(1), reason: 'итог разошёлся с записями');

      final m = calc(r.periods, r.back.add(hour), manual: r.manual);
      expect(m.status, DriverStatus.driving);
      expect(m.dailyDriving, dur('9:10'));
      expect(m.shiftStart, start);
      expect(m.shiftDuration, dur('13:15'));
      expect(m.dailyRestDeadline, start.add(day));
      // Записи режимов — с возвращения: правки работают с ними
      expect(m.shift?.start, r.back);
      expect(keys(m), contains(InfringementType.extensionInUse));
    });

    test('итог совпал с записями — те же день и начало смены', () {
      final byTotal = resumed('8:10');
      final byRecords = resumed('8:00');
      expect(byRecords.manual, isEmpty);

      final now = byTotal.back.add(hour);
      final a = calc(byTotal.periods, now, manual: byTotal.manual);
      final b = calc(byRecords.periods, now);
      expect(b.dailyDriving, dur('9:00'));
      expect(a.shiftStart, b.shiftStart);
      expect(a.shiftDuration, b.shiftDuration);
      expect(a.dailyRestDeadline, b.dailyRestDeadline);
      expect(a.continuousDriving, b.continuousDriving);
    });

    test('3 ч отдыха — перерыв и первая часть раздельного отдыха 3 + 9', () {
      final r = resumed('8:10');
      final m = calc(r.periods, r.back.add(hour), manual: r.manual);
      expect(m.continuousDriving, hour);
      expect(m.splitFirstPart, isTrue);
      expect(m.shiftLimit, m.shiftExtendedLimit);
    });

    test('вождения за день больше 10 ч — нарушение', () {
      final r = resumed('8:10');
      final m = calc(r.periods, r.back.add(hour * 2), manual: r.manual);
      expect(m.dailyDriving, dur('10:10'));
      final i = m.infringement(InfringementType.dailyDriveExceeded);
      expect(i?.time, minutes(10));
    });

    test('пока отдых после смены идёт — водитель на суточном отдыхе', () {
      final ended = endDayWithDriving(log.periods, dur('8:10'), end);
      final m = calc(ended.periods, end.add(hour * 2), manual: [ended.manual!]);
      expect(m.status, DriverStatus.dailyRest);
      expect(m.offDutyRest?.duration, hour * 2);
      expect(m.shiftStart, isNull);
      expect(m.dailyDriving, Duration.zero);
    });

    test('отдых 9 ч и больше — новый рабочий день', () {
      final r = resumed('8:10', pause: '9:00');
      final m = calc(r.periods, r.back.add(hour), manual: r.manual);
      expect(m.dailyDriving, hour);
      expect(m.shiftStart, r.back);
      expect(m.shiftDuration, hour);
      expect(m.splitFirstPart, isFalse);
    });
  });

  group('ENG-29: ручная смена и смена по записям — один рабочий день', () {
    test('рабочий день считается от начала ручной смены', () {
      // Ручная смена 06:00–18:00, через 2 ч — работа по записям
      final now = utc('2026-09-23 22:00');
      final m = calc(
        logUntil(now, [work('2:00')]),
        now,
        manual: [driven('12:00', '4:00')],
      );
      expect(m.shiftStart, start);
      expect(m.shiftDuration, dur('16:00'));
      final i = m.infringement(InfringementType.shiftExceeded);
      expect(i?.time, hour);
    });

    test('несколько ручных смен подряд — весь день', () {
      final first = ManualShift(
        start: start,
        end: utc('2026-09-23 10:00'),
        driving: dur('3:00'),
        restKind: RestKind.daily,
      );
      final second = ManualShift(
        start: utc('2026-09-23 12:00'),
        end: utc('2026-09-23 15:00'),
        driving: dur('2:00'),
        restKind: RestKind.daily,
      );
      final now = utc('2026-09-23 17:00');
      final m = calc(
        logUntil(now, [drive('1:00')]),
        now,
        manual: [second, first],
      );
      expect(m.dailyDriving, dur('6:00'));
      expect(m.shiftStart, start);
      expect(m.shiftDuration, dur('11:00'));
    });

    test('короткая пауза перерывом не считается: непрерывное вождение '
        'продолжается', () {
      final manual = driven('5:00', '4:00', continuous: '3:00');
      // 10 мин после смены, затем 1:40 вождения
      final next = logFrom(manual.end!.add(minutes(10)), [drive('1:40')]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.continuousDriving, dur('4:40'));
      expect(keys(m), contains(InfringementType.continuousExceeded));
    });

    test('пауза 20 мин — первая часть перерыва 15 + 30', () {
      final manual = driven('5:00', '4:00', continuous: '3:00');
      final next = logFrom(manual.end!.add(minutes(20)), [drive('1:00')]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.continuousDriving, dur('4:00'));
      expect(m.breakFirstPart?.start, manual.end);
      expect(m.breakFirstPart?.duration, minutes(20));
      expect(m.breakRequired, EuLimits.breakSplitSecond);
    });

    test('пауза 45 мин — перерыв: непрерывное вождение с нуля', () {
      final manual = driven('5:00', '4:00', continuous: '3:00');
      final next = logFrom(manual.end!.add(minutes(45)), [drive('1:40')]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.continuousDriving, dur('1:40'));
      expect(m.breakFirstPart, isNull);
      expect(m.dailyDriving, dur('5:40'));
    });

    test('две ручные смены внахлёст перед одной (испорченный журнал) — в '
        'день входит ближайшая, расчёт не падает', () {
      final early = ManualShift(
        start: start,
        end: utc('2026-09-23 10:00'),
        driving: dur('3:00'),
        restKind: RestKind.daily,
      );
      final late = ManualShift(
        start: utc('2026-09-23 07:00'),
        end: utc('2026-09-23 11:00'),
        driving: dur('2:00'),
        restKind: RestKind.daily,
      );
      final now = utc('2026-09-23 13:00');
      for (final manual in [
        [early, late],
        [late, early],
      ]) {
        final m = calc(logUntil(now, [drive('1:00')]), now, manual: manual);
        expect(m.shiftStart, late.start);
        expect(m.dailyDriving, dur('3:00'));
      }
    });

    test('раздельный отдых ручной смены даёт рабочий день 15 ч', () {
      final split = ManualShift(
        start: start,
        end: utc('2026-09-23 12:00'),
        driving: dur('3:00'),
        restKind: RestKind.daily,
        splitRest: true,
      );
      final now = utc('2026-09-23 14:00');
      final m = calc(logUntil(now, [work('1:00')]), now, manual: [split]);
      expect(m.splitFirstPart, isTrue);
    });
  });

  group('ENG-29: продление до 10 ч — один раз на рабочий день', () {
    test('ручная смена идущего дня продление ещё не потратила', () {
      // 9:30 вождения итогом, через час — ещё 20 мин по записям
      final manual = driven('11:00', '9:30');
      final next = logFrom(manual.end!.add(hour), [drive('0:20')]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.dailyDriving, dur('9:50'));
      expect(m.extensionsUsed, 0);
      expect(m.dailyDrivingLimit, EuLimits.dailyDrivingExtended);
      expect(m.infringement(InfringementType.extensionInUse)?.count, 1);
    });

    test('законченный день из двух смен — 10 ч, одно продление', () {
      // 5 ч итогом и 5 ч по записям, отдых 11 ч, утром новая смена
      final manual = driven('6:00', '5:00');
      final next = logFrom(manual.end!.add(hour), [
        drive('4:30'),
        rest('0:45'),
        drive('0:30'),
        rest('11:00'),
        drive('1:00'),
      ]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.dailyDriving, hour);
      expect(m.extensionsUsed, 1);
      expect(m.extensionsLeft, 1);
    });

    test('две ручные смены одного дня — тоже одно продление', () {
      final first = driven('6:00', '5:00');
      final second = ManualShift(
        start: first.end!.add(hour),
        end: first.end!.add(hour * 7),
        driving: dur('4:30'),
        restKind: RestKind.daily,
      );
      final now = utc('2026-09-24 12:00');
      final m = calc(
        logUntil(now, [drive('1:00')]),
        now,
        manual: [first, second],
      );
      expect(m.extensionsUsed, 1);
    });
  });

  group('ENG-29: уведомления считают тот же рабочий день', () {
    test('«скоро конец суточного вождения» — с вождением ручной смены', () {
      // 8 ч итогом, час отдыха, с 15:00 снова вождение
      final manual = driven('8:00', '8:00');
      final back = utc('2026-09-23 15:00');
      final periods = [ActivityPeriod(mode: DriverMode.driving, start: back)];
      final alerts = forecastAlerts(
        periods: periods,
        now: back.add(minute),
        manualShifts: [manual],
      );
      final soon = alerts.whereType<LimitAlert>().firstWhere(
        (a) => a.kind == InfringementType.dailyDriveSoon,
      );
      expect(soon.at, utc('2026-09-23 16:30'));
    });
  });
}
