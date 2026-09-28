// Смены, внесённые итогами (до установки приложения): проверка входных
// данных и участие в расчёте. План тестов: ENG-05, ENG-06 в docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

/// Среда 23.09.2026, неделя с понедельника 21.09.
final DateTime now = utc('2026-09-23 12:00');

/// Записи режимов с полуночи среды: отдых 11 ч и час вождения.
List<ActivityPeriod> recorded() =>
    logUntil(now, [rest('11:00'), drive('1:00')]);

void main() {
  group('ENG-05: ManualShift проверяет данные', () {
    final start = utc('2026-09-21 06:00');
    final end = utc('2026-09-21 16:00');

    test('начало не в UTC', () {
      expect(
        () => ManualShift(
          start: DateTime(2026, 9, 21, 6),
          end: end,
          driving: Duration.zero,
        ),
        throwsArgumentError,
      );
    });

    test('конец не в UTC', () {
      expect(
        () => ManualShift(
          start: start,
          end: DateTime(2026, 9, 21, 16),
          driving: Duration.zero,
        ),
        throwsArgumentError,
      );
    });

    test('конец раньше начала', () {
      expect(
        () => ManualShift(
          start: start,
          end: start.subtract(minute),
          driving: Duration.zero,
        ),
        throwsArgumentError,
      );
    });

    test('отрицательное вождение', () {
      expect(
        () => ManualShift(start: start, end: end, driving: -minute),
        throwsArgumentError,
      );
    });
  });

  group('ENG-05: отдых ручной смены — до начала следующей смены', () {
    final shift = manualShift(utc('2026-09-21 06:00'));

    test('до ближайшей следующей смены: ручной или из записей', () {
      final r = manualRestAfter(shift, [
        utc('2026-09-22 09:00'),
        utc('2026-09-22 05:00'),
        utc('2026-09-23 06:00'),
      ], now);
      expect(r?.start, utc('2026-09-21 16:00'));
      expect(r?.end, utc('2026-09-22 05:00'));
      expect(r?.duration, dur('13:00'));
      expect(r?.kind, RestKind.daily);
      expect(r?.ongoing, isFalse);

      final fromRecords = manualRests(
        [shift],
        analyzeTimeline(recorded(), now),
        now,
      );
      expect(fromRecords.single?.end, utc('2026-09-23 11:00'));
      expect(fromRecords.single?.duration, dur('43:00'));
    });

    test('смены раньше конца и своё начало не в счёт', () {
      final r = manualRestAfter(shift, [
        shift.start,
        utc('2026-09-21 10:00'),
        utc('2026-09-21 16:00'),
      ], now);
      expect(r?.duration, Duration.zero, reason: 'следующая смена встык');
      final empty = ManualShift(
        start: shift.start,
        end: shift.start,
        driving: Duration.zero,
        restKind: RestKind.daily,
      );
      expect(manualRestAfter(empty, [empty.start], now)?.ongoing, isTrue);
    });

    test('следующей смены нет — отдых идёт до сейчас', () {
      final r = manualRestAfter(shift, const [], now);
      expect(r?.ongoing, isTrue);
      expect(r?.end, isNull);
      expect(r?.duration, now.difference(utc('2026-09-21 16:00')));
    });

    test('от 24 ч — недельный, даже если отмечен суточный', () {
      final r = manualRestAfter(shift, [utc('2026-09-22 16:00')], now);
      expect(r?.kind, RestKind.weekly);
      final short = manualRestAfter(
        manualShift(shift.start, restKind: RestKind.weekly),
        [utc('2026-09-22 03:00')],
        now,
      );
      expect(short?.kind, RestKind.weekly, reason: 'отмечен недельный');
      expect(short?.duration, dur('11:00'));
    });

    test('смена идёт или отдых не начат — отдыха нет', () {
      expect(
        manualRestAfter(
          ManualShift(start: shift.start, end: null, driving: hour),
          const [],
          now,
        ),
        isNull,
      );
      expect(
        manualRestAfter(
          manualShift(shift.start, restKind: RestKind.none),
          const [],
          now,
        ),
        isNull,
      );
    });

    test('журнал: длительность, конец и статус отдыха по следующей смене', () {
      final shifts = journalShifts(
        recorded(),
        now,
        manual: manualChain(utc('2026-09-21 06:00'), ['8:30']),
      );
      final first = shifts.first;
      expect(first.rest.duration, dur('8:30'));
      expect(first.restEnd, utc('2026-09-22 00:30'));
      expect(first.rest.status, RestStatus.insufficient);
      expect(first.restLevel, JournalLevel.bad);
    });

    test('журнал: у последней смены отдых идёт, статуса ещё нет', () {
      final shift = journalShifts(
        const [],
        now,
        manual: [manualShift(utc('2026-09-22 06:00'))],
      ).single;
      expect(shift.rest.ongoing, isTrue);
      expect(shift.rest.status, isNull);
      expect(shift.restEnd, isNull);
      expect(shift.rest.duration, dur('20:00'));
    });
  });

  group('ENG-06: ручные смены в расчёте', () {
    test('вождение больше 9 ч в ручной смене этой недели тратит продление', () {
      final m = calc(
        recorded(),
        now,
        manual: [manualShift(utc('2026-09-21 06:00'), drive: '9:30')],
      );
      expect(m.extensionsUsed, 1);
      expect(m.extensionsLeft, 1);
      expect(m.weeklyDriving, dur('10:30'));
    });

    test('ручная смена прошлой недели продление этой недели не тратит', () {
      final m = calc(
        recorded(),
        now,
        manual: [manualShift(utc('2026-09-17 06:00'), drive: '10:00')],
      );
      expect(m.extensionsUsed, 0);
    });

    test('сокращённый суточный отдых ручной смены входит в счёт ст. 8(4)', () {
      final m = calc(
        recorded(),
        now,
        manual: manualChain(utc('2026-09-21 06:00'), ['9:30']),
      );
      expect(m.reducedRestsUsed, 1);
      expect(m.reducedRestsLeft, 2);
    });

    test('отдых 12 ч после смены 14 ч — в окне 24 ч только 10 ч, '
        'сокращённый', () {
      final m = calc(
        recorded(),
        now,
        manual: manualChain(utc('2026-09-21 06:00'), ['12:00'], span: '14:00'),
      );
      expect(m.reducedRestsUsed, 1);
    });

    test('раздельный отдых 3 + 9 — полный, сокращение не тратится', () {
      final m = calc(
        recorded(),
        now,
        manual: manualChain(utc('2026-09-21 06:00'), ['9:00'], split: true),
      );
      expect(m.reducedRestsUsed, 0);
    });

    test('вождение ручной смены — в неделе её начала, даже если смена '
        'закончилась на следующей', () {
      final m = calc(
        recorded(),
        now,
        manual: [manualShift(utc('2026-09-20 20:00'))],
      );
      expect(m.weeklyDriving, hour);
      expect(m.fortnightDriving, dur('10:00'));
    });
  });
}
