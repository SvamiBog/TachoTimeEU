// Правки смен из журнала (экран 11): «живая» смена по записям режимов,
// пересечения ручных смен, вырезка отдыха, удаление смены. Перенесены из
// прототипа (src/domain/shiftEdit.test.ts) и дополнены границами.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

LiveShiftEdit liveEdit(
  DateTime shiftStart, {
  DateTime? restStart,
  DateTime? newStart,
  DateTime? endAt,
  bool resume = false,
  Duration drivingDelta = Duration.zero,
}) => LiveShiftEdit(
  shiftStart: shiftStart,
  restStart: restStart,
  newStart: newStart,
  endAt: endAt,
  resume: resume,
  drivingDelta: drivingDelta,
);

List<ActivityPeriod> edit(List<ActivityPeriod> periods, LiveShiftEdit e) =>
    editLiveShift(periods, e, now).periods;

/// Записи идут встык, без наложений.
void expectNoOverlaps(List<ActivityPeriod> periods) {
  final sorted = sortedByStart(periods);
  for (var i = 1; i < sorted.length; i++) {
    final prevEnd = sorted[i - 1].end;
    expect(
      prevEnd,
      isNotNull,
      reason: 'открыта не последняя: ${sorted[i - 1]}',
    );
    expect(
      prevEnd!.isAfter(sorted[i].start),
      isFalse,
      reason: 'наложение: ${sorted[i - 1]} и ${sorted[i]}',
    );
  }
}

void main() {
  group('JRN-01: правка идущей смены', () {
    test('начало переносится раньше за счёт предыдущего отдыха', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final shiftStart = periods[1].start;
      final r = editLiveShift(
        periods,
        liveEdit(shiftStart, newStart: shiftStart.subtract(minutes(30))),
        now,
      );
      expect(r.shiftStart, shiftStart.subtract(minutes(30)));
      final m = calc(r.periods, now);
      expect(m.shift?.start, shiftStart.subtract(minutes(30)));
      expect(m.dailyDriving, dur('2:30'));
      expect(r.periods[0].end, r.shiftStart);
      expectNoOverlaps(r.periods);
    });

    test('начало не уходит дальше предыдущей записи', () {
      final periods = logUntil(now, [drive(60), rest('11:00'), drive('2:00')]);
      final shiftStart = periods[2].start;
      final r = editLiveShift(
        periods,
        liveEdit(shiftStart, newStart: shiftStart.subtract(day)),
        now,
      );
      expect(r.periods.map((p) => p.id), containsAll([0, 1]));
      expect(r.shiftStart, periods[1].start.add(minute));
      expectNoOverlaps(r.periods);
    });

    test('начало позже — отдых перед сменой продлевается', () {
      final periods = logUntil(now, [rest('11:00'), work(30), drive('2:00')]);
      final shiftStart = periods[1].start;
      final r = editLiveShift(
        periods,
        liveEdit(shiftStart, newStart: shiftStart.add(minutes(20))),
        now,
      );
      expect(r.shiftStart, shiftStart.add(minutes(20)));
      expect(r.periods[0].end, r.shiftStart);
      expect(r.periods[1].durationAt(now), minutes(10));
    });

    test('начало не позже минуты до конца первой записи смены', () {
      final periods = logUntil(now, [rest('11:00'), work(30), drive('2:00')]);
      final shiftStart = periods[1].start;
      final r = editLiveShift(
        periods,
        liveEdit(shiftStart, newStart: shiftStart.add(hour)),
        now,
      );
      expect(r.shiftStart, periods[1].end!.subtract(minute));
    });

    test('без работы после начала смены начало не меняется', () {
      final periods = logUntil(now, [drive('2:00'), rest('11:00')]);
      final start = now.subtract(hour);
      final r = editLiveShift(
        periods,
        liveEdit(start, newStart: start.subtract(hour)),
        now,
      );
      expect(r.periods, same(periods));
      expect(r.shiftStart, start);
    });

    test('завершение задним числом — дальше идёт суточный отдых', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00'), work(60)]);
      final shiftStart = periods[1].start;
      final updated = edit(
        periods,
        liveEdit(shiftStart, endAt: now.subtract(minutes(30))),
      );
      final m = calc(updated, now);
      expect(m.currentMode, DriverMode.rest);
      expect(m.shift, isNull);
      expect(m.offDutyRest?.duration, minutes(30));
      expect(m.timeline.shifts.last.otherWork, minutes(30));
      expect(updated.last.dayEnd, isTrue);
    });

    test('завершение не в будущем и не раньше минуты после начала', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final shiftStart = periods[1].start;
      final future = edit(periods, liveEdit(shiftStart, endAt: now.add(hour)));
      expect(future.last.start, now);
      final early = edit(
        periods,
        liveEdit(shiftStart, endAt: shiftStart.subtract(hour)),
      );
      expect(early.last.start, shiftStart.add(minute));
      expect(calc(early, now).timeline.shifts.last.driving, minute);
    });

    test('смена короче минуты — отдых продолжается, ничего в будущем', () {
      final periods = logUntil(now, [rest('11:00'), drive(0)]);
      final updated = edit(periods, liveEdit(now, endAt: now));
      expect(updated.single.mode, DriverMode.rest);
      expect(updated.single.isOpen, isTrue);
      expect(updated.single.dayEnd, isTrue);
    });

    test('завершение можно отменить', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('10:00'),
      ]);
      final updated = edit(
        periods,
        liveEdit(periods[1].start, restStart: periods[2].start, resume: true),
      );
      final m = calc(updated, now);
      expect(m.currentMode, DriverMode.driving);
      expect(m.shift?.driving, dur('12:00'));
    });

    test('конец завершённой смены переносится вместе с началом отдыха', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('10:00'),
      ]);
      final restStart = periods[2].start;
      final updated = edit(
        periods,
        liveEdit(
          periods[1].start,
          restStart: restStart,
          endAt: restStart.subtract(minutes(20)),
        ),
      );
      final m = calc(updated, now);
      expect(m.offDutyRest?.duration, dur('10:20'));
      expect(m.timeline.shifts.last.driving, dur('1:40'));
      expectNoOverlaps(updated);
    });

    test(
      'конец завершённой смены — не раньше минуты после последней работы',
      () {
        final periods = logUntil(now, [
          rest('11:00'),
          drive('2:00'),
          rest(20),
          work(30),
          rest('10:00'),
        ]);
        final updated = edit(
          periods,
          liveEdit(
            periods[1].start,
            restStart: periods[4].start,
            endAt: periods[1].start,
          ),
        );
        final m = calc(updated, now);
        expect(m.timeline.shifts.last.otherWork, minute);
        expect(m.timeline.shifts.last.driving, dur('2:00'));
      },
    );

    test('конец завершённой смены — не в будущем', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('10:00'),
      ]);
      final updated = edit(
        periods,
        liveEdit(
          periods[1].start,
          restStart: periods[2].start,
          endAt: now.add(hour),
        ),
      );
      expect(updated.last.start, now);
      expect(updated.last.isOpen, isTrue);
    });

    test('неизвестное начало отдыха — записи без изменений', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('10:00'),
      ]);
      final updated = edit(
        periods,
        liveEdit(
          periods[1].start,
          restStart: periods[2].start.add(minute),
          endAt: periods[2].start.subtract(hour),
        ),
      );
      expect(updated, same(periods));
    });

    test('поправка вождения — вместе с новым началом', () {
      final periods = logUntil(now, [rest('11:00'), work(60), drive('2:00')]);
      final shiftStart = periods[1].start;
      final updated = edit(
        periods,
        liveEdit(
          shiftStart,
          newStart: shiftStart.subtract(minutes(30)),
          drivingDelta: minutes(15),
        ),
      );
      final m = calc(updated, now);
      expect(m.shift?.start, shiftStart.subtract(minutes(30)));
      expect(m.dailyDriving, dur('2:15'));
      expect(m.shift?.otherWork, minutes(75));
    });

    test('правки без изменений возвращают тот же журнал', () {
      final periods = logUntil(now, [rest('11:00'), drive('2:00')]);
      final shiftStart = periods[1].start;
      expect(edit(periods, liveEdit(shiftStart)), same(periods));
      expect(
        edit(periods, liveEdit(shiftStart, newStart: shiftStart)),
        same(periods),
      );
      expect(
        edit(periods, liveEdit(shiftStart, resume: true)),
        same(periods),
        reason: 'отменять нечего: смена идёт',
      );
    });

    test('случайные правки: без наложений, времени не больше, чем было', () {
      final rng = Rng(561);
      for (var run = 0; run < 300; run++) {
        final segs = [
          rest('11:00'),
          for (var i = 0; i < rng.nextInt(1, 6); i++)
            Seg(rng.pick(DriverMode.values), minutes(rng.nextInt(1, 180))),
          if (rng.next() < 0.5) rest(rng.nextInt(540, 700)),
        ];
        final periods = logUntil(now, segs);
        final m = calc(periods, now);
        final shift = m.timeline.shifts.lastOrNull;
        if (shift == null) continue;
        final e = liveEdit(
          shift.start,
          restStart: shift.end,
          newStart: rng.next() < 0.5
              ? shift.start.add(minutes(rng.nextInt(-300, 300)))
              : null,
          endAt: rng.next() < 0.5
              ? now.subtract(minutes(rng.nextInt(-60, 600)))
              : null,
          resume: rng.next() < 0.2,
          drivingDelta: minutes(rng.nextInt(-60, 60)),
        );
        final updated = edit(periods, e);
        expectNoOverlaps(updated);
        for (final p in updated) {
          expect(p.end?.isAfter(now) ?? false, isFalse, reason: '$p');
          expect(p.start.isAfter(now), isFalse, reason: '$p');
        }
        expect(updated.where((p) => p.isOpen), hasLength(lessThanOrEqualTo(1)));
      }
    });
  });

  group('JRN-08: вождение за день итогом в форме смены', () {
    // now 12:00: смена 06:00–11:00 — весь день «Работа», с 11:00 отдых
    final periods = logUntil(now, [
      rest('11:00'),
      work('5:00'),
      rest('1:00', dayEnd: true),
    ]);
    final shiftStart = utc('2026-09-23 06:00');
    final restStart = utc('2026-09-23 11:00');

    test('завершённая смена становится ручной с итогом, отдых — запись', () {
      final r = editLiveShift(
        periods,
        LiveShiftEdit(
          shiftStart: shiftStart,
          restStart: restStart,
          manualDriving: dur('3:30'),
        ),
        now,
      );
      final manual = r.manual!;
      expect((manual.start, manual.end), (shiftStart, restStart));
      expect(manual.driving, dur('3:30'));
      expect(manual.continuousDrivingAtEnd, Duration.zero);
      expect(manual.restKind, RestKind.daily);
      expect(manual.splitRest, isFalse);
      expect(r.periods.map((p) => (p.mode, p.start, p.isOpen, p.dayEnd)), [
        (DriverMode.rest, utc('2026-09-22 19:00'), false, false),
        (DriverMode.rest, restStart, true, true),
      ]);

      final m = calc(r.periods, now, manual: [manual]);
      expect(m.status, DriverStatus.dailyRest);
      expect(m.weeklyDriving, dur('3:30'));
      final shifts = journalShifts(r.periods, now, manual: [manual]);
      expect(shifts.last.manual, isNotNull);
      expect(shifts.last.rest.ongoing, isTrue);
    });

    test('вместе с новыми началом и концом — ручная смена по ним', () {
      final r = editLiveShift(
        periods,
        LiveShiftEdit(
          shiftStart: shiftStart,
          restStart: restStart,
          newStart: utc('2026-09-23 05:30'),
          endAt: utc('2026-09-23 11:30'),
          manualDriving: dur('9:00'),
          restKind: RestKind.weekly,
          splitRest: true,
        ),
        now,
      );
      final manual = r.manual!;
      expect(r.shiftStart, utc('2026-09-23 05:30'));
      expect(manual.start, utc('2026-09-23 05:30'));
      expect(manual.end, utc('2026-09-23 11:30'));
      expect(manual.driving, dur('6:00'), reason: 'не длиннее смены');
      expect(manual.restKind, RestKind.weekly);
      expect(manual.splitRest, isFalse, reason: 'разделяется только суточный');
      expect(r.periods.last.start, utc('2026-09-23 11:30'));
      expect(r.periods.last.isOpen, isTrue);
    });

    test(
      'идущая смена, которую завершают, — ручная до конца, отдых с него',
      () {
        final ongoing = logUntil(now, [rest('11:00'), work('6:00')]);
        final r = editLiveShift(
          ongoing,
          LiveShiftEdit(
            shiftStart: shiftStart,
            endAt: now,
            manualDriving: dur('4:45'),
          ),
          now,
        );
        expect((r.manual!.start, r.manual!.end), (shiftStart, now));
        expect(r.manual!.driving, dur('4:45'));
        expect(
          (r.periods.last.mode, r.periods.last.start, r.periods.last.dayEnd),
          (DriverMode.rest, now, true),
        );
      },
    );

    test('идущую смену итогом не правят, итог как в записях — записи на '
        'месте', () {
      final ongoing = logUntil(now, [rest('11:00'), work('6:00')]);
      final r = editLiveShift(
        ongoing,
        LiveShiftEdit(shiftStart: shiftStart, manualDriving: dur('4:45')),
        now,
      );
      expect(r.manual, isNull);
      expect(r.periods, same(ongoing));

      final same0 = editLiveShift(
        periods,
        LiveShiftEdit(
          shiftStart: shiftStart,
          restStart: restStart,
          manualDriving: Duration.zero,
        ),
        now,
      );
      expect(same0.manual, isNull);
      expect(same0.periods, same(periods));
    });
  });

  group('JRN-02: пересечение смен', () {
    final periods = logUntil(now, [
      rest('11:00'),
      drive('5:00'),
      rest('11:40'),
      drive(60),
    ]);
    final shifts = journalShifts(periods, now);
    final first = shifts.firstWhere((s) => s.driving == dur('5:00'));
    final current = shifts.last;

    test('ручная смена поверх записанной — пересечение', () {
      final range = (
        start: first.start.add(hour),
        end: first.start.add(hour * 2),
      );
      expect(findOverlap(shifts, range, now: now), same(first));
      expect(findOverlap(shifts, range, now: now, except: first), isNull);
    });

    test('граница: смена встык — не пересечение', () {
      expect(
        findOverlap(shifts, (
          start: first.start.subtract(hour),
          end: first.start,
        ), now: now),
        isNull,
      );
      expect(
        findOverlap(shifts, (
          start: first.start.subtract(hour),
          end: first.start.add(minute),
        ), now: now),
        same(first),
      );
    });

    test('записанный отдых другой смены — не пересечение', () {
      final inRest = (
        start: first.end!.add(hour),
        end: first.end!.add(hour * 3),
      );
      expect(findOverlap(shifts, inRest, now: now), isNull);
    });

    test('идущая смена занимает время до сейчас', () {
      expect(
        findOverlap(shifts, (
          start: now.subtract(minutes(10)),
          end: now,
        ), now: now),
        same(current),
      );
    });

    test('смена при правке не пересекается сама с собой', () {
      final problem = checkManualShift(
        start: first.start,
        end: first.end,
        driving: first.driving,
        shifts: shifts,
        now: now,
        except: first,
      );
      expect(problem, isNull);
      expect(
        checkManualShift(
          start: first.start,
          end: first.end,
          driving: first.driving,
          shifts: shifts,
          now: now,
        )?.error,
        ShiftEditError.overlap,
      );
    });

    test('ручные смены различаются по id, записанные — по началу', () {
      final a = manualShift(utc('2026-09-01 06:00'), id: 1);
      final b = manualShift(utc('2026-09-01 06:00'), id: 2);
      final manual = journalShifts(const [], now, manual: [a, b]);
      expect(sameShift(manual[0], manual[0]), isTrue);
      expect(sameShift(manual[0], manual[1]), isFalse);
      expect(sameShift(first, first), isTrue);
      expect(sameShift(first, current), isFalse);
      expect(sameShift(first, manual[0]), isFalse);
      final unsaved = journalShifts(
        const [],
        now,
        manual: [manualShift(first.start)],
      ).single;
      expect(sameShift(unsaved, unsaved), isTrue);
    });
  });

  group('проверка ручной смены', () {
    final start = utc('2026-09-20 06:00');

    ShiftEditError? check({
      DateTime? from,
      DateTime? end,
      bool ongoing = false,
      Object drive = '8:00',
      Object continuous = '2:00',
      List<JournalShift> shifts = const [],
    }) => checkManualShift(
      start: from ?? start,
      end: ongoing ? null : end ?? start.add(hour * 10),
      driving: dur(drive),
      continuousDrivingAtEnd: dur(continuous),
      shifts: shifts,
      now: now,
    )?.error;

    test('правильная смена сохраняется', () => expect(check(), isNull));

    test('конец не позже начала', () {
      expect(check(end: start), ShiftEditError.endBeforeStart);
      expect(check(end: start.subtract(hour)), ShiftEditError.endBeforeStart);
    });

    test('конец в будущем', () {
      expect(check(end: now.add(minute)), ShiftEditError.future);
      expect(
        check(from: now.subtract(hour), end: now, drive: 30, continuous: 30),
        isNull,
      );
    });

    test('не длиннее 30 ч', () {
      expect(check(end: start.add(maxManualShiftSpan)), isNull);
      expect(
        check(end: start.add(maxManualShiftSpan + minute)),
        ShiftEditError.tooLong,
      );
    });

    test('вождения не больше длительности смены', () {
      expect(check(drive: '10:00', continuous: 0), isNull);
      expect(
        check(drive: '10:01', continuous: 0),
        ShiftEditError.drivingTooLong,
      );
    });

    test('непрерывного не больше суточного', () {
      expect(check(drive: '2:00'), isNull);
      expect(
        check(drive: '2:00', continuous: '2:01'),
        ShiftEditError.continuousTooLong,
      );
    });

    test('идущая смена — только последняя', () {
      final from = now.subtract(hour * 3);
      final later = journalShifts(
        const [],
        now,
        manual: [manualShift(from.add(hour), span: 30, id: 7)],
      );
      expect(check(from: from, ongoing: true, drive: 60), isNull);
      expect(
        check(from: from, ongoing: true, drive: 60, shifts: later),
        ShiftEditError.notLast,
      );
    });

    test('идущая смена может начаться в эту же минуту', () {
      expect(check(from: now, ongoing: true, drive: 0), isNull);
      expect(
        check(from: now.add(minute), ongoing: true, drive: 0),
        ShiftEditError.endBeforeStart,
      );
    });

    test('отдых до следующей смены сохранению не мешает', () {
      final next = journalShifts(
        const [],
        now,
        manual: [manualShift(start.add(hour * 11), id: 3)],
      );
      expect(check(shifts: next), isNull);
    });
  });

  group('JRN-03: ручная смена внутри записанного отдыха', () {
    test('отдых делится на две части вокруг смены', () {
      final periods = logUntil(now, [drive('5:00'), rest('33:20'), drive(60)]);
      final restStart = periods[1].start;
      final carved = carveRest(
        periods,
        restStart.add(hour * 10),
        restStart.add(hour * 20),
        now,
      );
      final rests = sortedByStart(carved.where((p) => p.mode.isRest).toList());
      expect(rests, hasLength(2));
      expect(rests[0].id, periods[1].id);
      expect(rests[0].end, restStart.add(hour * 10));
      expect(rests[1].id, isNull, reason: 'вторая часть — новая запись');
      expect(rests[1].start, restStart.add(hour * 20));
      expect(rests[1].end, periods[1].end);
    });

    test('«конец дня» остаётся только у части после смены', () {
      final periods = logUntil(now, [
        drive('5:00'),
        rest('20:00', dayEnd: true),
      ]);
      final restStart = periods[1].start;
      final carved = carveRest(
        periods,
        restStart.add(hour * 2),
        restStart.add(hour * 8),
        now,
      );
      final rests = sortedByStart(carved.where((p) => p.mode.isRest).toList());
      expect(rests[0].dayEnd, isFalse);
      expect(rests[1].dayEnd, isTrue);
      expect(rests[1].isOpen, isTrue, reason: 'отдых идёт и после смены');
    });

    test('смена с начала отдыха обрезает его, id остаётся', () {
      final periods = logUntil(now, [drive('5:00'), rest('20:00')]);
      final restStart = periods[1].start;
      final carved = carveRest(periods, restStart, restStart.add(hour), now);
      expect(carved, hasLength(2));
      expect(carved[1].id, periods[1].id);
      expect(carved[1].start, restStart.add(hour));
    });

    test('смена, накрывшая отдых целиком, его удаляет', () {
      final periods = logUntil(now, [drive('5:00'), rest('2:00'), work(60)]);
      final carved = carveRest(
        periods,
        periods[1].start.subtract(minute),
        periods[1].end!.add(minute),
        now,
      );
      expect(carved.map((p) => p.mode), [
        DriverMode.driving,
        DriverMode.otherWork,
      ]);
    });

    test('работа и отдых вне смены не меняются', () {
      final periods = logUntil(now, [rest('11:00'), drive('5:00'), rest(60)]);
      final carved = carveRest(
        periods,
        periods[1].start.add(hour),
        periods[1].start.add(hour * 2),
        now,
      );
      expect(carved, periods);
    });

    test('после вырезки смена и отдых считаются по отдельности', () {
      final periods = logUntil(now, [drive('5:00'), rest('40:00')]);
      final restStart = periods[1].start;
      final m = manualShift(
        restStart.add(hour * 12),
        span: '8:00',
        drive: '6:00',
      );
      final carved = carveRest(periods, m.start, m.end!, now);
      final shifts = journalShifts(carved, now, manual: [m]);
      // Отдых после ручной смены — не смена: работы в нём нет
      expect(shifts.map((s) => s.manual != null), [false, true]);
      expect(shifts[0].rest.duration, hour * 12);
    });
  });

  group('JRN-05: удаление смены', () {
    final periods = logUntil(now, [
      rest('11:00'),
      ...drivingDay('8:00'),
      rest('11:00'),
      ...drivingDay('9:00'),
      rest('11:00'),
      ...drivingDay('7:00'),
      rest('11:00'),
      drive(30),
    ]);

    test('смена пропадает из журнала и из сумм недели', () {
      final before = journalShifts(periods, now);
      final target = before[1];
      final updated = deleteShiftPeriods(periods, target.start, target.end);
      final after = journalShifts(updated, now);
      expect(after, hasLength(before.length - 1));
      expect(after.map((s) => s.start), isNot(contains(target.start)));
      final weekBefore = calc(periods, now).weeklyDriving;
      expect(calc(updated, now).weeklyDriving, weekBefore - dur('9:00'));
      expect(calc(updated, now).fortnightDriving, weekBefore - dur('9:00'));
    });

    test('соседние смены не меняются', () {
      final before = journalShifts(periods, now);
      final target = before[1];
      final after = journalShifts(
        deleteShiftPeriods(periods, target.start, target.end),
        now,
      );
      for (final s in [before[0], before[2]]) {
        final same = after.firstWhere((a) => a.start == s.start);
        expect(same.driving, s.driving);
        expect(same.end, s.end);
        expect(same.rest.duration, s.rest.duration);
        expect(same.rest.status, s.rest.status);
      }
    });

    test('идущая смена удаляется, отдых перед ней снова идёт', () {
      final before = journalShifts(periods, now);
      final current = before.last;
      final updated = deleteShiftPeriods(periods, current.start, current.end);
      final m = calc(updated, now);
      expect(m.currentMode, DriverMode.rest);
      expect(m.shift, isNull);
      expect(updated.last.isOpen, isTrue);
      expect(updated.last.start, before[2].end);
      expect(journalShifts(updated, now), hasLength(before.length - 1));
    });

    test('первая смена без отдыха перед ней — журнал пуст', () {
      final only = logUntil(now, [drive(30)]);
      expect(deleteShiftPeriods(only, only.first.start, null), isEmpty);
    });

    test('завершённая смена: отдых после неё остаётся', () {
      final ended = logUntil(now, [
        rest('11:00'),
        drive('2:00'),
        rest('10:00'),
      ]);
      final shift = journalShifts(ended, now).single;
      final updated = deleteShiftPeriods(ended, shift.start, shift.end);
      expect(updated.map((p) => p.id), [0, 2]);
      expect(updated.last.isOpen, isTrue);
    });
  });

  group('время новой смены по умолчанию', () {
    test('пустой журнал — 10 ч до сейчас', () {
      final slot = freeShiftSlot(const [], now);
      expect(slot.end, now);
      expect(slot.start, now.subtract(hour * 10));
    });

    test('округляется до минуты', () {
      final slot = freeShiftSlot(
        const [],
        now.add(const Duration(seconds: 42)),
      );
      expect(slot.end, now);
    });

    test('занятое время — ближайшее раньше, с отдыхом 11 ч до смены', () {
      final periods = logUntil(now, [rest('11:00'), drive('3:00')]);
      final shifts = journalShifts(periods, now);
      final slot = freeShiftSlot(shifts, now);
      expect(slot.end, shifts.single.start.subtract(hour * 11));
      expect(slot.start, slot.end.subtract(hour * 10));
      expect(
        checkManualShift(
          start: slot.start,
          end: slot.end,
          shifts: shifts,
          now: now,
        ),
        isNull,
      );
    });

    test('отдых после смены тоже занят', () {
      final periods = logUntil(now, [rest('11:00'), drive('3:00'), rest(120)]);
      final shifts = journalShifts(periods, now);
      final slot = freeShiftSlot(shifts, now);
      expect(slot.end, shifts.single.start.subtract(hour * 11));
    });

    test('после завершённой смены с отдыхом окно свободно', () {
      final start = now.subtract(day * 3);
      final m = manualShift(start, id: 1);
      final shifts = journalShifts(const [], now, manual: [m]);
      final slot = freeShiftSlot(shifts, now);
      expect(slot.end, now);
    });

    test('плотный журнал — не больше 60 попыток', () {
      final manual = [
        for (var i = 0; i < 70; i++)
          manualShift(now.subtract(hour * (21 * (i + 1))), id: i),
      ];
      final shifts = journalShifts(const [], now, manual: manual);
      final slot = freeShiftSlot(shifts, now);
      expect(slot.end.difference(slot.start), hour * 10);
      expect(slot.end.isBefore(now), isTrue);
    });
  });

  group('JRN-09: новая смена — от текущего момента', () {
    test('идущая — с текущей минуты, сохранить можно сразу', () {
      final at = now.add(const Duration(seconds: 42));
      final t = newShiftTimes(const [], at, ongoing: true);
      expect(t, (start: now, end: now));
      expect(
        checkManualShift(start: t.start, end: null, shifts: const [], now: at),
        isNull,
      );
    });

    test('завершённая — 10 ч до текущей минуты', () {
      expect(newShiftTimes(const [], now, ongoing: false), (
        start: now.subtract(hour * 10),
        end: now,
      ));
    });

    test('после ручной смены, пока идёт её отдых, — тоже сейчас', () {
      // Смена закончилась 3 ч назад: завершённая новая начинается не
      // раньше её конца
      final m = manualShift(now.subtract(hour * 13), id: 1);
      final shifts = journalShifts(const [], now, manual: [m]);
      expect(newShiftTimes(shifts, now, ongoing: true).start, now);
      final done = newShiftTimes(shifts, now, ongoing: false);
      expect(done, (start: m.end!, end: now));
      expect(
        checkManualShift(
          start: done.start,
          end: done.end,
          shifts: shifts,
          now: now,
        ),
        isNull,
      );
    });

    test('записанная смена, суточный отдых после неё идёт, — тоже сейчас', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('3:00'),
        rest('9:00'),
      ]);
      final shifts = journalShifts(periods, now);
      expect(newShiftTimes(shifts, now, ongoing: true).start, now);
      expect(newShiftTimes(shifts, now, ongoing: false), (
        start: now.subtract(hour * 9),
        end: now,
      ));
    });

    test('перерыв 2 ч — смена ещё идёт, новая — в окне раньше', () {
      final periods = logUntil(now, [rest('11:00'), drive('3:00'), rest(120)]);
      final shifts = journalShifts(periods, now);
      expect(
        newShiftTimes(shifts, now, ongoing: true),
        freeShiftSlot(shifts, now),
      );
    });

    test('сейчас идёт другая смена — ближайшее свободное окно раньше', () {
      final periods = logUntil(now, [rest('11:00'), drive('3:00')]);
      final shifts = journalShifts(periods, now);
      final slot = freeShiftSlot(shifts, now);
      expect(slot.end.isBefore(shifts.single.start), isTrue);
      expect(newShiftTimes(shifts, now, ongoing: true), slot);
      expect(newShiftTimes(shifts, now, ongoing: false), slot);
    });

    test('прошлая смена закончилась в эту минуту — завершённой места нет', () {
      final m = manualShift(now.subtract(hour * 10), id: 1);
      final shifts = journalShifts(const [], now, manual: [m]);
      expect(newShiftTimes(shifts, now, ongoing: true).start, now);
      expect(
        newShiftTimes(shifts, now, ongoing: false),
        freeShiftSlot(shifts, now),
      );
    });
  });
}
