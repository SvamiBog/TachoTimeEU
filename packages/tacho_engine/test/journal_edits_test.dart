// Переключение режима и ручные корректировки задним числом: правка берёт
// время у соседней записи, поэтому записи не накладываются, не появляются
// дыры, общее время сохраняется.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

/// Записи идут встык, открыта только последняя.
void expectContiguous(List<ActivityPeriod> periods, [String label = '']) {
  final sorted = sortedByStart(periods);
  for (final (i, p) in sorted.indexed) {
    if (i == sorted.length - 1) break;
    expect(p.end, isNotNull, reason: '$label: запись $p открыта не последней');
    expect(
      p.end,
      sorted[i + 1].start,
      reason: '$label: разрыв или наложение после $p',
    );
  }
  expect(sorted.last.end, isNull, reason: label);
}

Duration totalTime(List<ActivityPeriod> periods, DateTime now) =>
    periods.fold(Duration.zero, (sum, p) => sum + p.durationAt(now));

void main() {
  group('переключение режима', () {
    test('закрывает текущую запись и открывает новую', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final updated = changeMode(periods, DriverMode.rest, now);
      expect(updated, hasLength(3));
      expect(updated[1].end, now);
      expect(updated.last.mode, DriverMode.rest);
      expect(updated.last.id, isNull);
      expectContiguous(updated);
    });

    test('повторное переключение в тот же режим ничего не меняет', () {
      final periods = logUntil(now, [rest('11:00'), rest('0:20')]);
      expect(
        identical(changeMode(periods, DriverMode.rest, now), periods),
        isTrue,
      );
    });

    test('разрешены переходы между любыми режимами', () {
      var periods = <ActivityPeriod>[];
      var t = now;
      for (final from in DriverMode.values) {
        for (final to in DriverMode.values) {
          if (from == to) continue;
          periods = changeMode(periods, from, t);
          t = t.add(minute);
          periods = changeMode(periods, to, t);
          expect(periods.last.mode, to);
          t = t.add(minute);
        }
      }
      expectContiguous(periods);
    });

    test('«Завершить день» во время перерыва не дробит отдых', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('0:20'),
      ]);
      final updated = endDay(periods, now);
      expect(updated, hasLength(3));
      expect(updated.last.dayEnd, isTrue);
      final m = calc(updated, now);
      expect(m.shift, isNull);
      expect(m.status, DriverStatus.dailyRest);
    });

    test('паром: новая запись отмечена', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final updated = changeMode(
        periods,
        DriverMode.otherWork,
        now,
        ferry: true,
      );
      expect(updated.last.ferry, isTrue);
    });
  });

  group('корректировка суточного вождения', () {
    test('+N мин нельзя больше длины предыдущего отрезка', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('1:40'),
        work('0:20'),
        drive('1:00'),
      ]);
      final shiftStart = periods[1].start;
      expect(drivingAdjustmentBounds(periods, shiftStart, now), (
        min: -minutes(60),
        max: minutes(20),
      ));

      final r = adjustDriving(periods, shiftStart, minutes(30), now);
      expect(r.applied, minutes(20));
      expectContiguous(r.periods);
      final m = calc(r.periods, now);
      expect(m.dailyDriving, minutes(180));
      expect(m.shift?.otherWork, Duration.zero);
    });

    test('−N мин отдаются предыдущему отрезку', () {
      final periods = logUntil(now, [
        rest('11:00'),
        work('0:20'),
        drive('1:40'),
      ]);
      final r = adjustDriving(periods, periods[1].start, -minutes(10), now);
      expect(r.applied, -minutes(10));
      expectContiguous(r.periods);
      final m = calc(r.periods, now);
      expect(m.dailyDriving, minutes(90));
      expect(m.shift?.otherWork, minutes(30));
    });

    test('+10 мин вождения берутся из предыдущего отрезка, без наложений', () {
      final periods = logUntil(now, [
        rest(660),
        drive(100),
        work(20),
        drive(60),
      ]);
      final r = adjustDriving(periods, periods[1].start, minutes(10), now);
      expect(r.applied, minutes(10));
      final m = calc(r.periods, now);
      expect(m.dailyDriving, minutes(170));
      expect(m.shift?.otherWork, minutes(10));
    });

    test('нельзя убрать больше вождения, чем есть в последнем отрезке', () {
      final periods = logUntil(now, [
        rest('11:00'),
        work('0:20'),
        drive('1:40'),
      ]);
      final r = adjustDriving(periods, periods[1].start, -minutes(200), now);
      expect(r.applied, -minutes(100));
      expect(calc(r.periods, now).dailyDriving, Duration.zero);
    });

    test('без вождения в смене править нечего', () {
      final periods = logUntil(now, [rest('11:00'), work('2:00')]);
      expect(drivingAdjustmentBounds(periods, periods[1].start, now), isNull);
      final r = adjustDriving(periods, periods[1].start, minutes(10), now);
      expect(identical(r.periods, periods), isTrue);
      expect(r.applied, Duration.zero);
    });

    test('нулевая поправка не меняет записи', () {
      final periods = logUntil(now, [rest('11:00'), drive('1:00')]);
      final r = adjustDriving(periods, periods[1].start, Duration.zero, now);
      expect(identical(r.periods, periods), isTrue);
    });
  });

  group('корректировка последнего перерыва', () {
    test('завершённый перерыв 20 → 45 мин: время берётся у следующего '
        'вождения, перерыв засчитан', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('0:20'),
        drive('1:00'),
      ]);
      final shiftStart = periods[1].start;
      expect(lastBreakInfo(periods, shiftStart, now), (
        duration: minutes(20),
        max: minutes(80),
        open: false,
      ));

      final updated = setLastBreakDuration(
        periods,
        shiftStart,
        minutes(45),
        now,
      );
      expectContiguous(updated);
      final m = calc(updated, now);
      expect(m.continuousDriving, minutes(35));
      expect(m.dailyDriving, minutes(155));
    });

    test('завершённый перерыв 20 → 10 мин: следующее вождение начинается '
        'раньше', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('0:20'),
        drive('1:00'),
      ]);
      final updated = setLastBreakDuration(
        periods,
        periods[1].start,
        minutes(10),
        now,
      );
      expectContiguous(updated);
      final m = calc(updated, now);
      expect(m.continuousDriving, minutes(190));
      expect(m.shift?.breaks, minutes(10));
    });

    test('текущий перерыв можно удлинить только за счёт отрезка смены перед '
        'ним', () {
      final periods = logUntil(now, [
        rest('11:00'),
        work('0:30'),
        drive('2:00'),
        rest('0:10'),
      ]);
      expect(lastBreakInfo(periods, periods[1].start, now), (
        duration: minutes(10),
        max: minutes(130),
        open: true,
      ));
    });

    test('длительность текущего перерыва задаётся сдвигом его начала', () {
      final periods = logUntil(now, [rest(660), drive(200), rest(10)]);
      final updated = setLastBreakDuration(
        periods,
        periods[1].start,
        minutes(45),
        now,
      );
      final m = calc(updated, now);
      expect(m.continuousDriving, Duration.zero);
      expect(m.dailyDriving, minutes(165));
    });
  });

  group('завершение и начало смены задним числом', () {
    test('смену завершили во время перерыва — перерыв становится суточным '
        'отдыхом', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('0:20'),
      ]);
      final updated = endShiftAt(periods, now.subtract(minutes(5)), now);
      expectContiguous(updated);
      final m = calc(updated, now);
      expect(m.shift, isNull);
      expect(m.offDutyRest?.duration, minutes(20));
      expect(m.timeline.shifts.last.driving, minutes(120));
    });

    test('смену завершили во время вождения — остаток вождения удаляется', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final updated = endShiftAt(periods, now.subtract(minutes(30)), now);
      expectContiguous(updated);
      final m = calc(updated, now);
      expect(m.shift, isNull);
      expect(m.timeline.shifts.last.driving, minutes(90));
      expect(m.offDutyRest?.duration, minutes(30));
    });

    test('отмена завершения: отдых удаляется, смена продолжается', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('0:20'),
      ]);
      final ended = endShiftAt(periods, now.subtract(minutes(20)), now);
      final resumed = resumeShift(ended, now.subtract(minutes(20)));
      expectContiguous(resumed);
      final m = calc(resumed, now);
      expect(m.shift, isNotNull);
      expect(m.currentMode, DriverMode.driving);
      expect(m.dailyDriving, minutes(140));
    });

    test('смена, внесённая как идущая, начинается ровно с целой минуты '
        'вождения', () {
      final t = now.add(const Duration(seconds: 30)); // 12:00:30
      final periods = logUntil(now.subtract(const Duration(hours: 5)), [
        drive('5:00'),
        rest('15:00'),
      ]);
      final updated = startShiftAt(
        periods,
        now.subtract(const Duration(hours: 3)),
        minutes(60),
        t,
      );
      expectContiguous(updated);
      final m = calc(updated, t);
      expect(m.dailyDriving, greaterThanOrEqualTo(minutes(60)));
      expect(m.dailyDriving, lessThan(minutes(61)));
      expect(m.shift?.otherWork, greaterThan(Duration.zero));
    });

    test('идущая смена без вождения — только работа', () {
      final periods = logUntil(now, [rest('11:00')]);
      final updated = startShiftAt(
        periods,
        now.subtract(const Duration(hours: 2)),
        Duration.zero,
        now,
      );
      expect(updated.last.mode, DriverMode.otherWork);
      expect(calc(updated, now).shiftDuration, const Duration(hours: 2));
    });
  });

  group('случайные правки не ломают журнал', () {
    const modes = DriverMode.values;

    // Журнал в приложении начинается с отдыха («смена не начата»)
    test('переключение режимов, переносы начала и конца записей, '
        'корректировки сохраняют время', () {
      for (var seed = 1; seed <= 300; seed++) {
        final r = Rng(seed);
        final segs = [
          for (var i = r.nextInt(1, 25); i > 0; i--)
            Seg(r.pick(modes), minutes(r.nextInt(1, 12) * 15)),
        ];
        final log = logFrom(
          utc('2026-09-21 00:00').add(minutes(r.nextInt(0, 3000))),
          [rest('11:00'), ...segs],
        );
        final periods = log.periods;
        final now = log.now;
        final firstStart = periods.first.start;
        final pick = periods[r.nextInt(1, periods.length - 1)];
        final shiftStart = periods[r.nextInt(0, periods.length - 1)].start;
        final delta = minutes(r.nextInt(-180, 180));
        final pickStart = pick.start.add(delta);
        final edits = <String, List<ActivityPeriod>>{
          'changeMode': changeMode(periods, r.pick(modes), now),
          'moveStart': moveStart(
            periods,
            pick,
            pickStart.isBefore(firstStart) ? firstStart : pickStart,
            now,
          ),
          'moveEnd': moveEnd(periods, pick, (pick.end ?? now).add(delta), now),
        };

        // Корректировки — в пределах, которые показывает экран правки
        final bounds = drivingAdjustmentBounds(periods, shiftStart, now);
        if (bounds != null) {
          final wanted = minutes(
            r.nextInt(bounds.min.inMinutes, bounds.max.inMinutes),
          );
          final adjusted = adjustDriving(periods, shiftStart, wanted, now);
          expect(adjusted.applied, wanted, reason: 'seed $seed');
          edits['adjustDriving'] = adjusted.periods;
        }
        // 0 мин удаляет перерыв целиком — тогда последним становится другой
        final info = lastBreakInfo(periods, shiftStart, now);
        if (info != null && info.max > Duration.zero) {
          final wanted = minutes(r.nextInt(1, info.max.inMinutes));
          final updated = setLastBreakDuration(
            periods,
            shiftStart,
            wanted,
            now,
          );
          expect(
            lastBreakInfo(updated, shiftStart, now)?.duration,
            wanted,
            reason: 'seed $seed',
          );
          edits['setLastBreakDuration'] = updated;
        }

        for (final MapEntry(key: name, value: updated) in edits.entries) {
          final label = 'seed $seed, $name';
          final nonEmpty = [
            for (final p in updated)
              if (p.isOpen || p.end!.isAfter(p.start)) p,
          ];
          expectContiguous(nonEmpty, label);
          expect(sortedByStart(updated).first.start, firstStart, reason: label);
          expect(
            totalTime(updated, now),
            now.difference(firstStart),
            reason: label,
          );
          expect(() => calc(updated, now), returnsNormally, reason: label);
        }
      }
    });
  });
}
