// Логика формы смены (экран 11) без Flutter: значения по умолчанию, вид
// правки, подсказка, пределы вождения, выбор отдыха и что пишет сохранение.
// Экран целиком — shift_edit_test.dart. План тестов: JRN-15 в
// docs/testing.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/journal/shift_form.dart';
import 'package:tachogo/features/journal/shift_form_results.dart';

import '../support/journal_fixtures.dart';

Duration h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

DateTime u(int day, int hour, [int minute = 0]) =>
    DateTime.utc(2026, 9, day, hour, minute);

/// Сейчас — ср 23.09 12:00 UTC.
final DateTime now = u(23, 12);

List<JournalShift> shiftsOf(
  List<ActivityPeriod> periods, {
  List<ManualShift> manual = const [],
}) => [
  for (final w in buildJournal(
    timeline: analyzeTimeline(periods, now),
    now: now,
    manualShifts: manual,
  ))
    ...w.shifts,
];

/// Идущая смена с 06:00: отдых до неё, дальше вождение до сейчас.
final List<ActivityPeriod> ongoingLog = consecutive(u(22, 19), [
  (DriverMode.rest, h(11)),
  (DriverMode.driving, h(6)),
], open: true);

/// Смена 06:00–10:00 с [mode], после неё идёт отдых «конец дня».
List<ActivityPeriod> restLog(DriverMode mode) {
  final log = consecutive(u(22, 19), [
    (DriverMode.rest, h(11)),
    (mode, h(4)),
    (DriverMode.rest, h(2)),
  ], open: true);
  return [...log.take(2), log.last.withDayEnd(dayEnd: true)];
}

/// Прошлая смена вт 06:00–14:00 (8 ч вождения), отдых 16 ч, с 06:00 идёт
/// следующая.
final List<ActivityPeriod> pastLog = consecutive(u(21, 19), [
  (DriverMode.rest, h(11)),
  (DriverMode.driving, h(8)),
  (DriverMode.rest, h(16)),
  (DriverMode.driving, h(2)),
], open: true);

const pl = ShiftMeta(startCountry: 'PL', endCountry: 'PL');

/// Страны [pl] в форме: заметка — пустая строка, а не null.
const plNote = ShiftMeta(startCountry: 'PL', endCountry: 'PL', note: '');

/// Форма смены журнала, начатой в [start].
({ShiftForm form, List<JournalShift> shifts}) openShift(
  List<ActivityPeriod> periods,
  DateTime start, {
  List<ManualShift> manual = const [],
  ShiftMeta meta = const ShiftMeta(startCountry: 'PL'),
}) {
  final shifts = shiftsOf(periods, manual: manual);
  final shift = shifts.firstWhere((s) => s.start == start);
  return (
    form: ShiftForm.open(shift: shift, meta: meta, shifts: shifts, now: now),
    shifts: shifts,
  );
}

/// Новая смена при журнале [shifts].
ShiftForm openNew(
  List<JournalShift> shifts, {
  String? country = 'PL',
  RestKind? presetRest,
}) => ShiftForm.open(
  shifts: shifts,
  now: now,
  defaultCountry: country,
  presetRest: presetRest,
);

extension on ShiftForm {
  ShiftForm edit(ShiftFormValues Function(ShiftFormValues v) change) =>
      withValues(change(values));

  ShiftForm rest(
    RestKind kind, {
    List<JournalShift> shifts = const [],
    List<ActivityPeriod> periods = const [],
  }) {
    final result = withRest(kind, shifts: shifts, periods: periods, now: now);
    expect(result.error, isNull);
    return result.form;
  }

  ShiftSave saveIn(
    List<JournalShift> shifts, [
    List<ActivityPeriod> periods = const [],
  ]) => save(shifts: shifts, periods: periods, now: now);
}

Matcher refused(ShiftFormError error, {JournalShift? conflict}) =>
    isA<ShiftSaveRefused>()
        .having((r) => r.error, 'error', error)
        .having((r) => r.conflict?.start, 'conflict', conflict?.start);

void main() {
  group('JRN-15: форма открывается', () {
    test('новая смена — идёт с текущей минуты, страна по умолчанию', () {
      final form = ShiftForm.open(
        shifts: const [],
        now: now.add(const Duration(seconds: 40)),
        defaultCountry: 'PL',
      );
      final v = form.values;
      expect((v.start, v.end, v.restKind), (now, null, RestKind.none));
      expect((v.startCountry, v.endCountry, v.note), ('PL', null, ''));
      expect(
        (v.driving, v.continuous, v.split),
        (Duration.zero, Duration.zero, false),
      );
      expect(form.isNew, isTrue);
      expect(form.becomesCurrent, isTrue);
      expect(form.dirty, isFalse);
    });

    test('пока идёт другая смена — прошлая с суточным отдыхом, конечная '
        'страна — начальная', () {
      final shifts = shiftsOf(ongoingLog);
      final form = openNew(shifts);
      final slot = freeShiftSlot(shifts, now);
      expect(form.values.restKind, RestKind.daily);
      expect((form.values.start, form.values.end), (slot.start, slot.end));
      expect(form.values.endCountry, 'PL');
      expect(form.becomesCurrent, isFalse);
    });

    test('вид отдыха задан — с ним («Указать вручную» недельный)', () {
      final form = openNew(const [], presetRest: RestKind.weekly);
      expect(form.values.restKind, RestKind.weekly);
      expect(form.values.end, now);
      expect(form.values.start, now.subtract(h(10)));
    });

    test('смена журнала — её время, вождение до минуты, страны и заметка', () {
      final shifts = shiftsOf(pastLog);
      final shift = shifts.firstWhere((s) => s.start == u(22, 6));
      final form = ShiftForm.open(
        shift: shift,
        meta: const ShiftMeta(startCountry: 'D', endCountry: 'PL', note: 'x'),
        shifts: shifts,
        now: now,
        defaultCountry: 'LT',
      );
      final v = form.values;
      expect(
        (v.start, v.end, v.restKind),
        (u(22, 6), u(22, 14), RestKind.daily),
      );
      expect((v.driving, v.continuous), (h(8), h(8)));
      expect((v.startCountry, v.endCountry, v.note), ('D', 'PL', 'x'));
      expect(form.recorded, isTrue);
      expect(form.live, isFalse);
      expect(
        v.meta,
        const ShiftMeta(startCountry: 'D', endCountry: 'PL', note: 'x'),
      );
    });

    test('смена без страны начала — страна по умолчанию', () {
      final (:form, shifts: _) = openShift(
        ongoingLog,
        u(23, 6),
        meta: ShiftMeta.empty,
      );
      expect(form.values.startCountry, isNull);
      final withDefault = ShiftForm.open(
        shift: form.shift,
        shifts: const [],
        now: now,
        defaultCountry: 'PL',
      );
      expect(withDefault.values.startCountry, 'PL');
    });
  });

  group('JRN-15: сохранение', () {
    test('без страны начала — отказ, остальное не проверяется', () {
      expect(
        openNew(const [], country: null).saveIn(const []),
        refused(ShiftFormError.startCountry),
      );
      final (:form, :shifts) = openShift(
        ongoingLog,
        u(23, 6),
        meta: ShiftMeta.empty,
      );
      expect(form.saveIn(shifts, ongoingLog), refused(.startCountry));
    });

    test('идущая смена без правок — правка записей без изменений', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      final save = form.saveIn(shifts, ongoingLog);
      expect(save, isA<LiveShiftWrite>());
      final edit = (save as LiveShiftWrite).edit;
      expect((edit.shiftStart, edit.restStart), (u(23, 6), null));
      expect((edit.newStart, edit.endAt, edit.resume), (null, null, false));
      expect((edit.drivingDelta, edit.manualDriving), (Duration.zero, null));
      expect((edit.restKind, edit.splitRest), (RestKind.none, false));
      expect(save.meta, const ShiftMeta(startCountry: 'PL', note: ''));
    });

    test('идущая смена, «Суточный» — завершается сейчас', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      final daily = form.rest(.daily, shifts: shifts, periods: ongoingLog);
      final edit = (daily.saveIn(shifts, ongoingLog) as LiveShiftWrite).edit;
      expect(
        (edit.endAt, edit.restKind, edit.resume),
        (now, RestKind.daily, false),
      );
    });

    test('идущая смена, начало раньше — новое начало', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      final earlier = form.edit((v) => v.withTimes(u(23, 5), u(23, 5)));
      expect(earlier.values.end, isNull, reason: 'у идущей смены конца нет');
      final edit = (earlier.saveIn(shifts, ongoingLog) as LiveShiftWrite).edit;
      expect((edit.newStart, edit.endAt), (u(23, 5), null));
    });

    test('идущая смена: начало в будущем — отказ', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      final future = form.edit((v) => v.withTimes(u(23, 12, 30), now));
      expect(future.saveIn(shifts, ongoingLog), refused(.future));
    });

    test('идущая смена: начало внутри прошлой смены — пересечение с ней', () {
      final (:form, :shifts) = openShift(pastLog, u(23, 6));
      final past = shifts.firstWhere((s) => s.start == u(22, 6));
      final overlap = form.edit((v) => v.withTimes(u(22, 13), now));
      expect(
        overlap.saveIn(shifts, pastLog),
        refused(.overlap, conflict: past),
      );
    });

    test('смена с идущим отдыхом: начало после конца — отказ', () {
      final log = restLog(DriverMode.driving);
      final (:form, :shifts) = openShift(log, u(23, 6));
      expect(form.values.end, u(23, 10));
      final late = form.edit((v) => v.withTimes(u(23, 11), u(23, 10)));
      expect(late.saveIn(shifts, log), refused(.endBeforeStart));
    });

    test('смена с идущим отдыхом: вождение в пределах сдвига записей — '
        'поправка', () {
      final log = restLog(DriverMode.driving);
      final (:form, :shifts) = openShift(log, u(23, 6));
      final less = form.edit((v) => v.withDriving(h(3)));
      final edit = (less.saveIn(shifts, log) as LiveShiftWrite).edit;
      expect((edit.drivingDelta, edit.manualDriving), (-h(1), null));
      expect(edit.restStart, u(23, 10));
    });

    test('смена с идущим отдыхом без вождения: вождение итогом — ручная', () {
      final log = restLog(DriverMode.otherWork);
      final (:form, :shifts) = openShift(log, u(23, 6));
      final driven = form.edit((v) => v.withDriving(h(3, 30)));
      final edit = (driven.saveIn(shifts, log) as LiveShiftWrite).edit;
      expect(
        (edit.drivingDelta, edit.manualDriving),
        (Duration.zero, h(3, 30)),
      );
    });

    test('вождение итогом длиннее смены — отказ', () {
      final log = restLog(DriverMode.otherWork);
      final (:form, :shifts) = openShift(log, u(23, 6));
      final driven = form.edit((v) => v.withDriving(h(4, 1)));
      expect(driven.saveIn(shifts, log), refused(.drivingTooLong));
    });

    test('смена с идущим отдыхом, «Не начат» — отмена завершения', () {
      final log = restLog(DriverMode.driving);
      final (:form, :shifts) = openShift(log, u(23, 6));
      final resumed = form.rest(.none, shifts: shifts, periods: log);
      final edit = (resumed.saveIn(shifts, log) as LiveShiftWrite).edit;
      expect(
        (edit.resume, edit.endAt, edit.restKind),
        (true, null, RestKind.none),
      );
    });

    test('прошлая смена: только страны и заметка — без правки времени', () {
      final (:form, :shifts) = openShift(pastLog, u(22, 6));
      final edited = form.edit(
        (v) => v.withCountries('D', 'LT').withNote('паром'),
      );
      final save = edited.saveIn(shifts, pastLog);
      expect(save, isA<MetaShiftWrite>());
      save as MetaShiftWrite;
      expect(save.shiftStart, u(22, 6));
      expect(
        save.meta,
        const ShiftMeta(startCountry: 'D', endCountry: 'LT', note: 'паром'),
      );
    });

    test('прошлая смена с другим вождением — перевод в ручную', () {
      final (:form, :shifts) = openShift(pastLog, u(22, 6), meta: pl);
      final edited = form.edit((v) => v.withDriving(h(7)));
      expect(edited.willConvert, isTrue);
      final save = edited.saveIn(shifts, pastLog);
      expect(save, isA<ConvertShiftWrite>());
      save as ConvertShiftWrite;
      expect(save.from.start, u(22, 6));
      final s = save.shift;
      expect((s.id, s.start, s.end), (null, u(22, 6), u(22, 14)));
      expect((s.driving, s.continuousDrivingAtEnd), (h(7), h(7)));
      expect((s.restKind, s.splitRest), (RestKind.daily, false));
      expect(save.meta, plNote);
    });

    test('новая смена с отдыхом без конечной страны — отказ', () {
      final form = openNew(const [])
          .rest(.daily)
          .edit((v) => v.withCountries('PL', null));
      expect(form.saveIn(const []), refused(.endCountry));
    });

    test('новая идущая смена — станет текущей', () {
      expect(openNew(const []).saveIn(const []), isA<OngoingShiftWrite>());
      final form = openNew(const [])
          .edit((v) => v.withTimes(u(23, 10), u(23, 10)).withDriving(h(1)));
      final save = form.saveIn(const []);
      expect(save, isA<OngoingShiftWrite>());
      save as OngoingShiftWrite;
      final s = save.shift;
      expect((s.start, s.end, s.restKind), (u(23, 10), null, RestKind.none));
      expect((s.driving, s.continuousDrivingAtEnd), (h(1), h(1)));
      expect(save.replacing, isNull);
      expect(save.meta, const ShiftMeta(startCountry: 'PL', note: ''));
    });

    test('новая смена с суточным раздельным отдыхом — ручная', () {
      final form = openNew(const [])
          .rest(.daily)
          .edit((v) => v.withSplit(split: true).withDriving(h(2)));
      final save = form.saveIn(const []);
      expect(save, isA<ManualShiftWrite>());
      final s = (save as ManualShiftWrite).shift;
      expect((s.id, s.start, s.end), (null, u(23, 2), now));
      expect(
        (s.restKind, s.splitRest, s.driving),
        (RestKind.daily, true, h(2)),
      );
      expect(save.meta, plNote);
    });

    test('раздельный отдых только у суточного', () {
      final form = openNew(const [])
          .rest(.weekly)
          .edit((v) => v.withSplit(split: true));
      final s = (form.saveIn(const []) as ManualShiftWrite).shift;
      expect(s.splitRest, isFalse);
    });

    test('ручная смена журнала — ручная с тем же id', () {
      final manual = ManualShift(
        id: 5,
        start: u(22, 6),
        end: u(22, 16),
        driving: h(8),
        restKind: RestKind.daily,
      );
      final (:form, :shifts) = openShift(
        const [],
        u(22, 6),
        manual: [manual],
        meta: pl,
      );
      final save = form.edit((v) => v.withDriving(h(7))).saveIn(shifts);
      expect(save, isA<ManualShiftWrite>());
      final s = (save as ManualShiftWrite).shift;
      expect((s.id, s.driving, s.end), (5, h(7), u(22, 16)));
    });

    test('последняя ручная смена, «Не начат» — снова идёт, заменяет '
        'прежнюю', () {
      final manual = ManualShift(
        id: 5,
        start: u(23, 6),
        end: u(23, 10),
        driving: h(3),
        restKind: RestKind.daily,
      );
      final (:form, :shifts) = openShift(
        const [],
        u(23, 6),
        manual: [manual],
        meta: pl,
      );
      final resumed = form.rest(.none, shifts: shifts);
      expect(resumed.values.endCountry, isNull);
      final save = resumed.saveIn(shifts);
      expect(save, isA<OngoingShiftWrite>());
      save as OngoingShiftWrite;
      expect(save.replacing?.manual?.id, 5);
      final s = save.shift;
      expect((s.id, s.end, s.continuousDrivingAtEnd), (5, null, h(3)));
    });

    group('проверка ручной смены движком', () {
      ShiftForm daily() => openNew(const []).rest(.daily);
      final other = ManualShift(
        id: 9,
        start: u(23, 8),
        end: u(23, 10),
        driving: h(1),
        restKind: RestKind.daily,
      );
      final withOther = shiftsOf(const [], manual: [other]);

      test('конец не позже начала', () {
        final f = daily().edit((v) => v.withTimes(u(23, 10), u(23, 10)));
        expect(f.saveIn(const []), refused(.endBeforeStart));
      });

      test('конец в будущем', () {
        final f = daily().edit((v) => v.withTimes(u(23, 10), u(23, 13)));
        expect(f.saveIn(const []), refused(.future));
      });

      test('длиннее 30 ч', () {
        final f = daily().edit((v) => v.withTimes(u(21, 12), now));
        expect(f.saveIn(const []), refused(.tooLong));
      });

      test('вождения больше смены', () {
        final f = daily().edit((v) => v.withDriving(h(10, 1)));
        expect(f.saveIn(const []), refused(.drivingTooLong));
      });

      test('непрерывного больше вождения за день', () {
        final f = daily().edit((v) => v.withDriving(h(2)).withContinuous(h(3)));
        expect(f.saveIn(const []), refused(.continuousTooLong));
      });

      test('пересекается с другой сменой — с ней', () {
        final f = daily().edit((v) => v.withTimes(u(23, 7), u(23, 9)));
        expect(
          f.saveIn(withOther),
          refused(.overlap, conflict: withOther.single),
        );
      });

      test('идущая, а после неё есть смена — не последняя', () {
        final f = openNew(withOther)
            .edit((v) => v.withTimes(u(23, 7), u(23, 7)));
        expect(f.becomesCurrent, isTrue);
        expect(
          f.saveIn(withOther),
          refused(.notLast, conflict: withOther.single),
        );
      });
    });
  });

  group('JRN-15: подсказка над формой', () {
    test('идущая смена — правка записей; «Суточный» — конец сейчас', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      expect(form.hint(ongoingLog, now), isA<LiveEditHint>());
      final daily = form.rest(.daily, shifts: shifts, periods: ongoingLog);
      expect(
        daily.hint(ongoingLog, now),
        isA<EndNowHint>().having((x) => x.at, 'at', now),
      );
    });

    test('отдых после смены отменён — смена продолжится', () {
      final log = restLog(DriverMode.driving);
      final (:form, :shifts) = openShift(log, u(23, 6));
      expect(form.hint(log, now), isA<LiveEditHint>());
      final resumed = form.rest(.none, shifts: shifts, periods: log);
      expect(resumed.hint(log, now), isA<ResumeHint>());
    });

    test('вождения сдвигом записей не получить — сохранится ручной', () {
      final log = restLog(DriverMode.otherWork);
      final (:form, shifts: _) = openShift(log, u(23, 6));
      final driven = form.edit((v) => v.withDriving(h(2)));
      expect(driven.drivingToManual(log, now), isTrue);
      expect(driven.hint(log, now), isA<LiveToManualHint>());
    });

    test('новая идущая — станет текущей: работа, с вождением — вождение', () {
      final form = openNew(const []);
      expect(
        form.hint(const [], now),
        isA<BecomesCurrentHint>()
            .having((x) => x.start, 'start', now)
            .having((x) => x.mode, 'mode', DriverMode.otherWork),
      );
      expect(
        form.edit((v) => v.withDriving(h(1))).hint(const [], now),
        isA<BecomesCurrentHint>().having(
          (x) => x.mode,
          'mode',
          DriverMode.driving,
        ),
      );
    });

    test('прошлая смена: без правки времени — нет, с правкой — станет '
        'ручной', () {
      final (:form, shifts: _) = openShift(pastLog, u(22, 6));
      expect(form.hint(pastLog, now), isNull);
      final edited = form.edit((v) => v.withDriving(h(7)));
      expect(edited.hint(pastLog, now), isA<ToManualHint>());
    });

    test('новая смена с отдыхом — без подсказки', () {
      expect(openNew(const []).rest(.daily).hint(const [], now), isNull);
    });
  });

  group('JRN-15: вождение за день', () {
    test('ручная смена — любое', () {
      final limits = openNew(const [])
          .rest(.daily)
          .drivingLimits(const [], now);
      expect(limits, (min: Duration.zero, max: null, editable: true));
    });

    test('идущая смена — только сдвигом записей вождения', () {
      final (:form, shifts: _) = openShift(ongoingLog, u(23, 6));
      final bounds = drivingAdjustmentBounds(ongoingLog, u(23, 6), now)!;
      expect(form.liveDrivingRange(ongoingLog, now), (
        min: h(6) + bounds.min,
        max: h(6) + bounds.max,
      ));
      expect(form.drivingLimits(ongoingLog, now), (
        min: Duration.zero,
        max: h(6) + bounds.max,
        editable: true,
      ));
      expect(form.continuousAuto, isTrue);
      // Журнал не посчитан — экран передаёт пустые записи: сдвигов нет
      expect(form.liveDrivingRange(const [], now), isNull);
      expect(form.drivingLimits(const [], now), (
        min: h(6),
        max: h(6),
        editable: false,
      ));
    });

    test('идущая смена без вождения — не меняется, пока не выбран отдых', () {
      final log = consecutive(u(22, 19), [
        (DriverMode.rest, h(11)),
        (DriverMode.otherWork, h(6)),
      ], open: true);
      final (:form, :shifts) = openShift(log, u(23, 6));
      expect(form.drivingLimits(log, now), (
        min: Duration.zero,
        max: Duration.zero,
        editable: false,
      ));
      final daily = form.rest(.daily, shifts: shifts, periods: log);
      expect(daily.drivingLimits(log, now), (
        min: Duration.zero,
        max: h(6),
        editable: true,
      ));
    });

    test('непрерывное на конец: у идущей ручной — равно вождению', () {
      final form = openNew(const [])
          .edit((v) => v.withDriving(h(2)).withContinuous(h(1)));
      expect(form.continuousAtEnd, h(2));
      expect(form.rest(.daily).continuousAtEnd, h(1));
    });

    test('вождение меньше непрерывного — непрерывное уменьшается', () {
      final v = openNew(const []).values
          .withDriving(h(3))
          .withContinuous(h(3))
          .withDriving(h(2));
      expect((v.driving, v.continuous), (h(2), h(2)));
    });
  });

  group('JRN-15: отдых после смены', () {
    test('новая: отдых — конец сейчас, «Не начат» и снова отдых — тот же '
        'конец и страна', () {
      final form = openNew(const []);
      final daily = form.rest(.daily);
      expect((daily.values.start, daily.values.end), (u(23, 2), now));
      expect(daily.values.endCountry, 'PL');
      final changed = daily.edit((v) => v.withCountries('PL', 'D'));
      final none = changed.rest(.none);
      expect((none.values.end, none.values.endCountry), (null, null));
      final again = none.rest(.weekly);
      expect((again.values.end, again.values.endCountry), (now, 'D'));
    });

    test('новая: начало, которое водитель поменял, остаётся', () {
      final form = openNew(const [])
          .edit((v) => v.withTimes(u(23, 5), u(23, 5)))
          .rest(.daily);
      expect((form.values.start, form.values.end), (u(23, 5), now));
    });

    test('после смены есть другая — «Не начат» нельзя', () {
      final (:form, :shifts) = openShift(pastLog, u(22, 6));
      final result = form.withRest(
        RestKind.none,
        shifts: shifts,
        periods: pastLog,
        now: now,
      );
      expect(result.error, ShiftFormError.notLast);
      expect(result.form, same(form));
    });

    test('тот же вид отдыха — без изменений', () {
      final form = openNew(const []);
      expect(form.rest(.none), same(form));
    });

    test('отмена завершения: вождение — в пределах сдвига записей', () {
      final log = restLog(DriverMode.driving);
      final (:form, :shifts) = openShift(log, u(23, 6));
      final range = form.liveDrivingRange(log, now)!;
      final more = form.edit(
        (v) => v.withDriving(range.max + h(1)).withContinuous(range.max + h(1)),
      );
      final resumed = more.rest(.none, shifts: shifts, periods: log);
      expect(resumed.values.driving, range.max);
      expect(resumed.values.continuous, range.max);
    });

    test('у идущей смены выбрана конечная страна — смена кончилась '
        'сейчас, суточный отдых', () {
      final (:form, :shifts) = openShift(ongoingLog, u(23, 6));
      final ended = form.withCountries(
        'PL',
        'D',
        shifts: shifts,
        periods: ongoingLog,
        now: now,
      );
      expect(ended.values.restKind, RestKind.daily);
      expect((ended.values.end, ended.values.endCountry), (now, 'D'));
      final kept = form.withCountries(
        'PL',
        null,
        shifts: shifts,
        periods: ongoingLog,
        now: now,
      );
      expect(kept.values.restKind, RestKind.none);
    });

    test('предпросмотр: не начат — нет; новая — идёт до следующей смены', () {
      final form = openNew(const []);
      expect(form.restPreview(shifts: const [], now: now, crew: .solo), isNull);
      final rest = form
          .rest(.daily)
          .restPreview(shifts: const [], now: now, crew: .solo);
      expect(rest?.ongoing, isTrue);
      expect(rest?.status, isNull);
      expect(rest?.kind, RestKind.daily);
    });

    test('предпросмотр прошлой смены без правки — как в журнале', () {
      final (:form, :shifts) = openShift(pastLog, u(22, 6));
      final shift = form.shift!;
      final rest = form.restPreview(shifts: shifts, now: now, crew: .solo);
      expect(rest?.duration, shift.rest.duration);
      expect(rest?.end, shift.restEnd);
      expect(rest?.status, shift.rest.status);
      expect(form.compensationRestStart, u(22, 14));
      final edited = form.edit((v) => v.withDriving(h(7)));
      expect(edited.compensationRestStart, isNull);
    });

    test('предпросмотр: недельный короче 24 ч — недостаточный', () {
      final form = openNew(const [])
          .rest(.weekly)
          .edit((v) => v.withTimes(u(22, 20), u(23, 6)));
      final next = ManualShift(
        start: u(23, 7),
        end: u(23, 9),
        driving: h(1),
        restKind: RestKind.daily,
      );
      final rest = form.restPreview(
        shifts: shiftsOf(const [], manual: [next]),
        now: now,
        crew: .solo,
      );
      expect(rest?.duration, h(1));
      expect(rest?.status, RestStatus.insufficient);
    });
  });
}
