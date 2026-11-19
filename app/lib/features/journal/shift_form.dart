/// Shift form logic (screen 11) without Flutter: the form values, what kind of
/// edit they make, the hint above the form, the limits of the driving rows,
/// the choice of rest and what saving writes. The screen turns the results
/// into text and widgets and calls the repository.
library;

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/journal/shift_form_results.dart';

/// Значение «не менять» для полей, которые могут стать null.
const Object _keep = Object();

/// The form values. Times are UTC to the minute, as on screen.
final class ShiftFormValues {
  const new({
    required this.start,
    required this.end,
    required this.restKind,
    required this.split,
    required this.driving,
    required this.continuous,
    required this.startCountry,
    required this.endCountry,
    required this.note,
  });

  final DateTime start;

  /// null — смена идёт, отдых не начат.
  final DateTime? end;
  final RestKind restKind;

  /// Раздельный суточный отдых 3 + 9.
  final bool split;

  /// Вождение за день.
  final Duration driving;

  /// Непрерывное вождение на конец смены.
  final Duration continuous;

  /// Коды тахографа; null — не выбрана.
  final String? startCountry;
  final String? endCountry;
  final String note;

  /// Время, отдых и вождение те же, что в [other]: страны и заметка не в
  /// счёт.
  bool sameTiming(ShiftFormValues other) =>
      start == other.start &&
      end == other.end &&
      restKind == other.restKind &&
      split == other.split &&
      driving == other.driving &&
      continuous == other.continuous;

  bool sameAs(ShiftFormValues other) =>
      sameTiming(other) &&
      startCountry == other.startCountry &&
      endCountry == other.endCountry &&
      note == other.note;

  ShiftMeta get meta =>
      ShiftMeta(startCountry: startCountry, endCountry: endCountry, note: note);

  /// Вождение за день [value]; непрерывное не больше него.
  ShiftFormValues withDriving(Duration value) => _copy(
    driving: value,
    continuous: continuous > value ? value : continuous,
  );

  ShiftFormValues withContinuous(Duration value) => _copy(continuous: value);

  ShiftFormValues withSplit({required bool split}) => _copy(split: split);

  ShiftFormValues withNote(String note) => _copy(note: note);

  /// Начало и конец из шторки «Дата и время»: у идущей смены конца нет.
  ShiftFormValues withTimes(DateTime start, DateTime? end) =>
      _copy(start: start, end: this.end == null ? null : end);

  ShiftFormValues withCountries(String? start, String? end) =>
      _copy(startCountry: start, endCountry: end);

  /// Копия с другими значениями; [end], [startCountry] и [endCountry] могут
  /// стать null, поэтому «не менять» у них — [_keep].
  ShiftFormValues _copy({
    DateTime? start,
    Object? end = _keep,
    RestKind? restKind,
    bool? split,
    Duration? driving,
    Duration? continuous,
    Object? startCountry = _keep,
    Object? endCountry = _keep,
    String? note,
  }) => ShiftFormValues(
    start: start ?? this.start,
    end: identical(end, _keep) ? this.end : end as DateTime?,
    restKind: restKind ?? this.restKind,
    split: split ?? this.split,
    driving: driving ?? this.driving,
    continuous: continuous ?? this.continuous,
    startCountry: identical(startCountry, _keep)
        ? this.startCountry
        : startCountry as String?,
    endCountry: identical(endCountry, _keep)
        ? this.endCountry
        : endCountry as String?,
    note: note ?? this.note,
  );
}

/// The shift form: the journal shift it edits (null — a new manual shift),
/// the values it opened with and the current values. Answers what kind of
/// edit the values make and what saving writes; never changes in place.
final class ShiftForm {
  const new({
    required this.shift,
    required this.initial,
    required this.values,
    this.beforeNone,
  });

  /// Форма смены [shift] журнала [shifts] или новой смены (shift == null) с
  /// видом отдыха [presetRest] («Указать вручную» недельный отдых). Страна
  /// начала — из [meta], иначе [defaultCountry].
  factory open({
    required Iterable<JournalShift> shifts,
    required DateTime now,
    JournalShift? shift,
    ShiftMeta meta = ShiftMeta.empty,
    RestKind? presetRest,
    String? defaultCountry,
  }) {
    final manual = shift?.manual;
    // Новая смена по умолчанию идёт с текущей минуты: водитель открывает
    // её, когда начинает, а отдых отметит, когда закончит (JRN-09). Пока
    // идёт другая смена, новая может быть только прошлой.
    final restKind =
        manual?.restKind ??
        shift?.rest.kind ??
        presetRest ??
        (shifts.any((x) => x.end == null) ? RestKind.daily : RestKind.none);
    final DateTime start;
    final DateTime? end;
    if (shift != null) {
      (start, end) = (shift.start, shift.end);
    } else {
      final slot = newShiftTimes(
        shifts,
        now,
        ongoing: restKind == RestKind.none,
      );
      (start, end) = (slot.start, restKind == RestKind.none ? null : slot.end);
    }
    final startCountry = meta.startCountry ?? defaultCountry;
    final initial = ShiftFormValues(
      start: start,
      end: end,
      restKind: restKind,
      split: manual?.splitRest ?? shift?.rest.split ?? false,
      driving: floorToMinute(shift?.driving ?? Duration.zero),
      continuous: floorToMinute(shift?.continuousDrivingAtEnd ?? Duration.zero),
      startCountry: startCountry,
      // У новой смены конечная страна по умолчанию — начальная
      endCountry: shift != null
          ? meta.endCountry
          : restKind == RestKind.none
          ? null
          : startCountry,
      note: meta.note ?? '',
    );
    return ShiftForm(shift: shift, initial: initial, values: initial);
  }

  /// Смена из журнала; null — новая ручная смена.
  final JournalShift? shift;

  /// Значения, с которыми форма открылась.
  final ShiftFormValues initial;
  final ShiftFormValues values;

  /// Конец и конечная страна до выбора «Не начат» — вернутся, если снова
  /// выбрать отдых.
  final ({DateTime? end, String? country})? beforeNone;

  bool get isNew => shift == null;

  /// Смена «живая»: идёт или после неё идёт отдых — правятся записи режимов.
  bool get live => shift?.live ?? false;

  /// Смена собрана из записей режимов.
  bool get recorded => shift?.recorded != null;

  /// Есть несохранённые изменения.
  bool get dirty => !values.sameAs(initial);

  /// «Живая» смена кончилась, идёт отдых после неё.
  bool get liveEnded => live && initial.end != null;

  /// Отдых после «живой» смены уже идёт или начнётся при сохранении.
  bool get restOngoing => live && values.restKind != RestKind.none;

  /// Смена без записей режимов (новая, ручная или прошлая) идёт сейчас —
  /// станет текущей.
  bool get becomesCurrent => !live && values.restKind == RestKind.none;

  bool get timingChanged => !values.sameTiming(initial);

  /// Смена из записей с другим временем сохранится ручной.
  bool get willConvert => recorded && !live && timingChanged && !becomesCurrent;

  /// Непрерывное вождение считается само: по перерывам записей или, у
  /// смены, которая станет текущей, — всё вождение за день.
  bool get continuousAuto => live || becomesCurrent;

  /// Непрерывное вождение на конец смены, которое сохранится.
  Duration get continuousAtEnd =>
      becomesCurrent ? values.driving : values.continuous;

  /// Начало отдыха после смены, у которого журнал посчитал компенсацию;
  /// null — отдыха нет или время смены меняется и журнал ещё не пересчитан.
  DateTime? get compensationRestStart => timingChanged ? null : shift?.end;

  ShiftForm withValues(ShiftFormValues values) => ShiftForm(
    shift: shift,
    initial: initial,
    values: values,
    beforeNone: beforeNone,
  );

  /// Вождение «живой» смены, которое дают сдвиги записей [periods]
  /// ([drivingAdjustmentBounds]); null — вождения в смене нет.
  ({Duration min, Duration max})? liveDrivingRange(
    List<ActivityPeriod> periods,
    DateTime now,
  ) {
    final shift = this.shift;
    if (!live || shift == null) return null;
    final bounds = drivingAdjustmentBounds(periods, shift.start, now);
    if (bounds == null) return null;
    final driving = initial.driving;
    return (min: driving + bounds.min, max: driving + bounds.max);
  }

  /// Вождение «живой» смены сдвигами записей не получить, а после смены
  /// идёт отдых: смена сохранится ручной с этим итогом, как «Завершить
  /// день» на главной.
  bool drivingToManual(List<ActivityPeriod> periods, DateTime now) {
    final driving = values.driving;
    if (!restOngoing || driving == initial.driving) return false;
    final range = liveDrivingRange(periods, now);
    return range == null || driving < range.min || driving > range.max;
  }

  /// Подсказка над формой: как сохранится смена; null — без подсказки.
  ShiftHint? hint(List<ActivityPeriod> periods, DateTime now) {
    if (live) {
      if (drivingToManual(periods, now)) return const LiveToManualHint();
      if (values.restKind == RestKind.none && initial.end != null) {
        return const ResumeHint();
      }
      if (initial.end == null && values.restKind != RestKind.none) {
        return EndNowHint(values.end ?? now);
      }
      return const LiveEditHint();
    }
    if (becomesCurrent) {
      return BecomesCurrentHint(
        start: values.start,
        mode: values.driving > Duration.zero
            ? DriverMode.driving
            : DriverMode.otherWork,
      );
    }
    return willConvert ? const ToManualHint() : null;
  }

  /// Пределы «За день» в шторке длительности. Ручную смену водитель вводит
  /// любую, проверка — при сохранении. У «живой» после неё идёт отдых —
  /// тоже любую, до длины смены: чего не дадут сдвиги записей, сохранится
  /// ручной сменой с итогом. У идущей — только сдвигами записей: главная
  /// считает её по ним.
  DrivingLimits drivingLimits(List<ActivityPeriod> periods, DateTime now) {
    final range = liveDrivingRange(periods, now);
    final (Duration min, Duration? max) = !live
        ? (Duration.zero, null)
        : restOngoing
        ? (
            Duration.zero,
            floorToMinute(durationBetween(values.start, values.end ?? now)),
          )
        : range == null
        ? (initial.driving, initial.driving)
        : (range.min, range.max);
    final low = min < Duration.zero ? Duration.zero : min;
    return (
      min: low,
      max: max != null && max < low ? low : max,
      editable: max == null || max > min,
    );
  }

  /// Вид отдыха после смены [kind]: «Не начат» — смена снова идёт, отдых —
  /// смена кончилась (у идущей — сейчас). «Не начат» нельзя, если после
  /// смены в журнале [shifts] есть другая: форма та же и ошибка.
  ({ShiftForm form, ShiftFormError? error}) withRest(
    RestKind kind, {
    required Iterable<JournalShift> shifts,
    required List<ActivityPeriod> periods,
    required DateTime now,
  }) {
    final current = values.restKind;
    if (kind == current) return (form: this, error: null);
    if (kind == RestKind.none) {
      if (_hasLater(shifts)) {
        return (form: this, error: ShiftFormError.notLast);
      }
      return (form: _resumed(periods, now), error: null);
    }
    if (current != RestKind.none) {
      return (form: withValues(values._copy(restKind: kind)), error: null);
    }
    return (form: _ended(kind, shifts, now), error: null);
  }

  /// Страны смены. Конечная страна у идущей смены — смена кончилась:
  /// сейчас, дальше суточный отдых (отзыв водителя 05.10.2026). На главной
  /// конечную страну по-прежнему выбирают заранее, смена идёт.
  ShiftForm withCountries(
    String? start,
    String? end, {
    required Iterable<JournalShift> shifts,
    required List<ActivityPeriod> periods,
    required DateTime now,
  }) {
    final ended = values.restKind == RestKind.none && end != null;
    final form = withValues(values.withCountries(start, end));
    if (!ended) return form;
    return form
        .withRest(RestKind.daily, shifts: shifts, periods: periods, now: now)
        .form;
  }

  /// Отдых после смены, как его посчитает журнал: у «живой» или не
  /// изменённой смены из записей — по записям, иначе — до начала следующей
  /// смены журнала [shifts]. null — отдых не начат.
  RestPreview? restPreview({
    required Iterable<JournalShift> shifts,
    required DateTime now,
    required CrewMode crew,
  }) {
    final shift = this.shift;
    final end = values.end;
    if (values.restKind == RestKind.none || end == null) return null;
    if (shift != null && (live || (recorded && !timingChanged))) {
      return _recordedRest(shift);
    }
    final start = values.start;
    final rest = manualRestAfter(
      ManualShift(
        start: start,
        end: end.isBefore(start) ? start : end,
        driving: Duration.zero,
        restKind: values.restKind,
      ),
      [
        for (final s in shifts)
          if (shift == null || !sameShift(s, shift)) s.start,
      ],
      now,
    );
    if (rest == null) return null;
    // Недельный, выбранный в форме, оценивается как недельный: законченный
    // раньше 24 ч расчёт посчитает суточным (ENG-28), а форма говорит
    // «недостаточный» — недельного отдыха не получилось
    final weekly =
        rest.kind == RestKind.weekly || values.restKind == RestKind.weekly;
    return (
      kind: rest.kind,
      duration: rest.duration,
      end: rest.end,
      ongoing: rest.ongoing,
      status: rest.ongoing
          ? null
          : weekly
          ? weeklyRestStatus(rest.duration)
          : dailyRestStatus(
              restInWindow(durationBetween(start, end), rest.duration, crew),
              split: values.split,
            ),
    );
  }

  /// Что пишет сохранение формы при журнале [shifts] и записях [periods]:
  /// правку записей «живой» смены, страны и заметку без изменения времени,
  /// смену, ставшую текущей, перевод в ручную или ручную смену. Или почему
  /// сохранить нельзя: страна, время или пересечение (`checkManualShift`).
  /// Лимиты сохранению не мешают.
  ShiftSave save({
    required Iterable<JournalShift> shifts,
    required List<ActivityPeriod> periods,
    required DateTime now,
  }) {
    final shift = this.shift;
    if (values.startCountry == null) {
      return const ShiftSaveRefused(ShiftFormError.startCountry);
    }
    if (live && shift != null) return _saveLive(shift, shifts, periods, now);
    if (recorded && !timingChanged && shift != null) {
      return MetaShiftWrite(shift.start, values.meta);
    }
    if (values.restKind != RestKind.none && values.endCountry == null) {
      return const ShiftSaveRefused(ShiftFormError.endCountry);
    }
    return _saveManual(shifts, now);
  }

  bool _hasLater(Iterable<JournalShift> shifts) {
    final shift = this.shift;
    return shifts.any(
      (s) =>
          (shift == null || !sameShift(s, shift)) &&
          s.start.isAfter(values.start),
    );
  }

  /// «Не начат»: смена снова идёт — конечной страны у неё ещё нет, а
  /// вождение «живой» — только то, что дают сдвиги записей.
  ShiftForm _resumed(List<ActivityPeriod> periods, DateTime now) {
    final v = values;
    var driving = v.driving;
    var continuous = v.continuous;
    if (live) {
      final range = liveDrivingRange(periods, now);
      driving = range == null
          ? initial.driving
          : driving < range.min
          ? range.min
          : driving > range.max
          ? range.max
          : driving;
      if (continuous > driving) continuous = driving;
    }
    return ShiftForm(
      shift: shift,
      initial: initial,
      values: v._copy(
        restKind: RestKind.none,
        end: null,
        endCountry: null,
        driving: driving,
        continuous: continuous,
      ),
      beforeNone: (end: v.end, country: v.endCountry),
    );
  }

  /// Отдых [kind] после смены, которая шла: прежний конец, если водитель
  /// уже выбирал отдых, иначе — сейчас.
  ShiftForm _ended(RestKind kind, Iterable<JournalShift> shifts, DateTime now) {
    final v = values;
    final before = beforeNone;
    var start = v.start;
    final DateTime? end;
    if (before == null && isNew) {
      // Новая смена закончилась — сейчас; начало, если водитель его не
      // менял, — по умолчанию для завершённой смены (JRN-09)
      final done = newShiftTimes(shifts, now, ongoing: false);
      end = done.end;
      if (start == initial.start || !start.isBefore(done.end)) {
        start = done.start;
      }
    } else {
      end = before?.end ?? (liveEnded ? initial.end : floorTimeToMinute(now));
    }
    return withValues(
      v._copy(
        restKind: kind,
        start: start,
        end: end,
        endCountry:
            v.endCountry ?? before?.country ?? (isNew ? v.startCountry : null),
      ),
    );
  }

  RestPreview _recordedRest(JournalShift shift) {
    final r = shift.rest;
    return (
      // Идущий отдых короче 24 ч — какой выбран: недельный отмечается у
      // записи отдыха (`declareRest`)
      kind: live && !r.weeklyByLength
          ? values.restKind
          : r.kind == RestKind.none
          ? values.restKind
          : r.kind,
      duration: liveEnded || !live ? r.duration : Duration.zero,
      end: shift.restEnd,
      ongoing: live || r.ongoing,
      status: r.status,
    );
  }

  /// Правка записей «живой» смены: время не в будущем, конец после начала,
  /// без пересечений; вождение итогом — не длиннее смены.
  ShiftSave _saveLive(
    JournalShift shift,
    Iterable<JournalShift> shifts,
    List<ActivityPeriod> periods,
    DateTime now,
  ) {
    final v = values;
    final spanEnd = v.end ?? now;
    if (v.start != initial.start || v.end != initial.end) {
      if (v.start.isAfter(now) || spanEnd.isAfter(now)) {
        return const ShiftSaveRefused(ShiftFormError.future);
      }
      if (!v.start.isBefore(spanEnd)) {
        return const ShiftSaveRefused(ShiftFormError.endBeforeStart);
      }
      final hit = findOverlap(
        shifts,
        (start: v.start, end: spanEnd),
        now: now,
        except: shift,
      );
      if (hit != null) {
        return ShiftSaveRefused(ShiftFormError.overlap, conflict: hit);
      }
    }
    final toManual = drivingToManual(periods, now);
    if (toManual && v.driving > durationBetween(v.start, spanEnd)) {
      return const ShiftSaveRefused(ShiftFormError.drivingTooLong);
    }
    final edit = LiveShiftEdit(
      shiftStart: shift.start,
      restStart: initial.end,
      newStart: v.start != initial.start ? v.start : null,
      endAt: initial.end == null
          ? (v.restKind != RestKind.none ? v.end ?? now : null)
          : (v.end != initial.end ? v.end : null),
      resume: initial.end != null && v.restKind == RestKind.none,
      drivingDelta: toManual ? Duration.zero : v.driving - initial.driving,
      manualDriving: toManual ? v.driving : null,
      restKind: v.restKind,
      splitRest: v.split,
    );
    return LiveShiftWrite(edit, v.meta);
  }

  /// Ручная смена: проверка `checkManualShift`, затем смена, ставшая
  /// текущей, перевод в ручную или ручная смена.
  ShiftSave _saveManual(Iterable<JournalShift> shifts, DateTime now) {
    final v = values;
    final shift = this.shift;
    final ongoing = v.restKind == RestKind.none;
    final end = ongoing ? null : v.end;
    final problem = checkManualShift(
      start: v.start,
      end: end,
      driving: v.driving,
      continuousDrivingAtEnd: continuousAtEnd,
      shifts: shifts,
      now: now,
      except: shift,
    );
    if (problem != null) {
      return ShiftSaveRefused(
        ShiftFormError.of(problem.error),
        conflict: problem.conflict,
      );
    }
    final record = ManualShift(
      id: shift?.manual?.id,
      start: v.start,
      end: end == null || !end.isBefore(v.start) ? end : v.start,
      driving: v.driving,
      continuousDrivingAtEnd: continuousAtEnd,
      restKind: v.restKind,
      splitRest: v.restKind == RestKind.daily && v.split,
    );
    if (becomesCurrent) {
      return OngoingShiftWrite(record, v.meta, replacing: shift);
    }
    if (willConvert && shift != null) {
      return ConvertShiftWrite(shift, record, v.meta);
    }
    return ManualShiftWrite(record, v.meta);
  }
}
