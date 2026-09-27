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

    test('отрицательный отдых', () {
      expect(
        () => ManualShift(
          start: start,
          end: end,
          driving: Duration.zero,
          restKind: RestKind.daily,
          rest: -minute,
        ),
        throwsArgumentError,
      );
    });

    test('конец отдыха: есть только у завершённой смены с отдыхом', () {
      expect(
        ManualShift(
          start: start,
          end: end,
          driving: hour,
          restKind: RestKind.daily,
          rest: const Duration(hours: 11),
        ).restEnd,
        utc('2026-09-22 03:00'),
      );
      expect(
        ManualShift(start: start, end: end, driving: hour).restEnd,
        isNull,
      );
      expect(
        ManualShift(
          start: start,
          end: null,
          driving: hour,
          restKind: RestKind.daily,
          rest: const Duration(hours: 11),
        ).restEnd,
        isNull,
      );
    });
  });

  group('ENG-06: ручные смены в расчёте', () {
    test('вождение больше 9 ч в ручной смене этой недели тратит продление', () {
      final m = calc(
        recorded(),
        now,
        manual: [
          manualShift(utc('2026-09-21 06:00'), drive: '9:30', rest: '12:00'),
        ],
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
        manual: [manualShift(utc('2026-09-21 06:00'), rest: '9:30')],
      );
      expect(m.reducedRestsUsed, 1);
      expect(m.reducedRestsLeft, 2);
    });

    test('отдых 12 ч после смены 14 ч — в окне 24 ч только 10 ч, '
        'сокращённый', () {
      final m = calc(
        recorded(),
        now,
        manual: [
          manualShift(utc('2026-09-21 06:00'), span: '14:00', rest: '12:00'),
        ],
      );
      expect(m.reducedRestsUsed, 1);
    });

    test('раздельный отдых 3 + 9 — полный, сокращение не тратится', () {
      final m = calc(
        recorded(),
        now,
        manual: [
          manualShift(utc('2026-09-21 06:00'), rest: '9:00', split: true),
        ],
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
