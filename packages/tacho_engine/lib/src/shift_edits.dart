import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/journal.dart';
import 'package:tacho_engine/src/journal_edits.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';

// Правки смен из журнала (экран 11). Как и в journal_edits.dart, функции
// чистые: новые записи создаются с id == null, удалённые пропадают из
// списка — хранилище сохраняет разницу.

const _minute = Duration(minutes: 1);

/// Смена, внесённая вручную, не длиннее 30 ч: дольше — почти наверняка
/// ошибка в дате.
const maxManualShiftSpan = Duration(hours: 30);

/// Правка «живой» смены: той, что идёт сейчас, или после которой идёт
/// отдых. Такая смена считается по записям режимов, поэтому правка сдвигает
/// сами записи, и таймеры главной дальше считаются по ним.
@immutable
class LiveShiftEdit {
  const new({
    required this.shiftStart,
    this.restStart,
    this.newStart,
    this.endAt,
    this.resume = false,
    this.drivingDelta = Duration.zero,
    this.manualDriving,
    this.restKind,
    this.splitRest = false,
  });

  /// Начало смены до правки.
  final DateTime shiftStart;

  /// Начало отдыха после смены; null — смена идёт.
  final DateTime? restStart;

  /// Новое начало смены.
  final DateTime? newStart;

  /// Идущая смена: завершить её в этот момент. Завершённая: перенести
  /// начало отдыха после неё.
  final DateTime? endAt;

  /// Отменить завершение: отдых после смены удаляется, смена продолжается.
  final bool resume;

  /// Поправка суточного вождения ([adjustDriving]).
  final Duration drivingDelta;

  /// Вождение за день итогом, которое ввёл водитель, когда сдвигом записей
  /// его не получить (в смене одна «Работа»): смена, после которой идёт
  /// отдых, становится ручной с этим итогом, как в [endDayWithDriving].
  /// Идущую смену так не правят — у неё таймеры главной по записям.
  final Duration? manualDriving;

  /// Отдых после смены: суточный или недельный, разделённый суточный; null
  /// — вид не меняется (корректировки с экранов лимитов). У смены по
  /// записям недельный отмечается у записи идущего отдыха
  /// ([ActivityPeriod.weeklyRest]); у смены, ставшей ручной
  /// ([manualDriving]), — у ручной смены.
  final RestKind? restKind;
  final bool splitRest;
}

/// Применяет [edit] к записям режимов. Сдвиги ограничены соседними
/// записями: начало не уходит раньше предыдущей записи (её не удалить
/// правкой начала), конец — не в будущее, смена не короче минуты.
///
/// Возвращает записи и начало смены после правки: по нему приложение
/// переносит страны и заметки. `manual` — смена стала ручной
/// ([LiveShiftEdit.manualDriving]): записей смены больше нет.
({List<ActivityPeriod> periods, DateTime shiftStart, ManualShift? manual})
editLiveShift(List<ActivityPeriod> periods, LiveShiftEdit edit, DateTime now) {
  var result = periods;
  var shiftStart = edit.shiftStart;

  final newStart = edit.newStart;
  if (newStart != null && newStart != shiftStart) {
    final sorted = sortedByStart(result);
    final idx = sorted.indexWhere(
      (p) => !p.start.isBefore(shiftStart) && !p.mode.isRest,
    );
    if (idx >= 0) {
      final first = sorted[idx];
      final max = (first.end ?? now).subtract(_minute);
      var target = newStart;
      if (idx > 0) target = later(target, sorted[idx - 1].start.add(_minute));
      target = earlier(target, max);
      result = moveStart(result, first, target, now);
      shiftStart = target;
    }
  }

  final restStart = edit.restStart;
  final endAt = edit.endAt;
  if (edit.resume && restStart != null) {
    result = resumeShift(result, restStart);
  } else if (endAt != null) {
    result = restStart == null
        ? endShiftAt(
            result,
            earlier(now, later(endAt, shiftStart.add(_minute))),
            now,
          )
        : _moveRestStart(result, shiftStart, restStart, endAt, now);
  }

  if (edit.drivingDelta != Duration.zero) {
    result = adjustDriving(result, shiftStart, edit.drivingDelta, now).periods;
  }

  final manualDriving = edit.manualDriving;
  final shift = manualDriving == null
      ? null
      : analyzeTimeline(result, now).shifts.lastOrNull;
  if (manualDriving != null && shift != null && shift.start == shiftStart) {
    final converted = _toManual(
      result,
      shift,
      manualDriving,
      restKind: edit.restKind,
      splitRest: edit.splitRest,
    );
    if (converted != null) {
      return (
        periods: converted.periods,
        shiftStart: shiftStart,
        manual: converted.manual,
      );
    }
  }
  final restKind = edit.restKind;
  return (
    periods: restKind == null
        ? result
        : declareRest(
            result,
            shiftStart,
            weekly: restKind == RestKind.weekly,
            now: now,
          ),
    shiftStart: shiftStart,
    manual: null,
  );
}

/// Вид идущего отдыха после смены [shiftStart] по записям: [weekly] —
/// недельный, иначе — по длительности. Отметка ставится у записей отдыха
/// ([ActivityPeriod.weeklyRest]); завершённый отдых не меняется — он
/// считается по длительности. Без изменений возвращается тот же список.
List<ActivityPeriod> declareRest(
  List<ActivityPeriod> periods,
  DateTime shiftStart, {
  required bool weekly,
  required DateTime now,
}) {
  final rest = analyzeTimeline(
    periods,
    now,
  ).shifts.where((s) => s.start == shiftStart).firstOrNull?.restAfter;
  if (rest == null || !rest.open) return periods;
  bool target(ActivityPeriod p) =>
      p.mode.isRest && !p.start.isBefore(rest.start) && p.weeklyRest != weekly;
  if (!periods.any(target)) return periods;
  return [
    for (final p in periods)
      if (target(p)) p.withWeeklyRest(weeklyRest: weekly) else p,
  ];
}

/// «Начать недельный отдых», когда смены нет: идущий отдых становится
/// недельным с его начала, а если отдыха нет — он начинается сейчас. Отдых
/// после ручной смены — недельный у неё ([ManualShift.restKind]), иначе —
/// отметка у записи отдыха. `manual` — изменённая ручная смена, null — не
/// менялась.
({List<ActivityPeriod> periods, ManualShift? manual}) declareWeeklyRest(
  List<ActivityPeriod> periods,
  List<ManualShift> manualShifts,
  DateTime now,
) {
  final timeline = analyzeTimeline(periods, now);
  final rests = manualRests(manualShifts, timeline, now);
  ManualShift? after;
  for (final (i, r) in rests.indexed) {
    final m = manualShifts[i];
    if (r != null && r.ongoing && (after?.start.isBefore(m.start) ?? true)) {
      after = m;
    }
  }
  final recorded = timeline.shifts.lastOrNull;
  if (after != null &&
      (recorded == null || recorded.start.isBefore(after.start))) {
    return (
      periods: periods,
      manual: after.restKind == RestKind.weekly
          ? null
          : ManualShift(
              id: after.id,
              start: after.start,
              end: after.end,
              driving: after.driving,
              continuousDrivingAtEnd: after.continuousDrivingAtEnd,
              restKind: RestKind.weekly,
            ),
    );
  }
  return (
    periods: changeMode(periods, DriverMode.rest, now, weeklyRest: true),
    manual: null,
  );
}

/// «Завершить день» с вождением за день, которое ввёл водитель. Журнал
/// режимов по времени ему не нужен — только итог (отзыв водителей,
/// 28.09.2026).
///
/// Смена завершается, как [endDay]. Вождение совпало с записями — они
/// остаются. Иначе записи смены заменяются ручной сменой с итогом
/// [driving] (не длиннее смены), а отдых после неё остаётся записью с
/// отметкой «конец дня»: главная показывает его, как после обычного
/// завершения. Смены нет — только [endDay].
({List<ActivityPeriod> periods, ManualShift? manual}) endDayWithDriving(
  List<ActivityPeriod> periods,
  Duration driving,
  DateTime now, {
  bool weekly = false,
}) {
  final ended = endDay(periods, now, weekly: weekly);
  final shift = analyzeTimeline(ended, now).shifts.lastOrNull;
  final converted = shift != null && (shift.restAfter?.dayEnd ?? false)
      ? _toManual(
          ended,
          shift,
          driving,
          restKind: weekly ? RestKind.weekly : null,
        )
      : null;
  return converted ?? (periods: ended, manual: null);
}

/// Записи завершённой смены [shift], после которой идёт отдых, заменяет
/// ручная смена с вождением [driving] (не длиннее смены); отдых остаётся
/// записью. Вид отдыха теперь у ручной смены ([restKind]; null — какой
/// был), отметка «недельный» с записей отдыха снимается — иначе её не
/// изменить правкой смены. null — отдых после смены не идёт или вождение
/// совпало с записями.
({List<ActivityPeriod> periods, ManualShift manual})? _toManual(
  List<ActivityPeriod> periods,
  Shift shift,
  Duration driving, {
  RestKind? restKind,
  bool splitRest = false,
}) {
  final rest = shift.restAfter;
  if (rest == null || !rest.open) return null;
  final end = rest.start;
  final span = floorToMinute(durationBetween(shift.start, end));
  final entered = shorter(floorToMinute(clampToZero(driving)), span);
  if (entered == floorToMinute(shift.driving)) return null;
  final kind = restKind == null || restKind == RestKind.none
      ? (rest.isWeekly ? RestKind.weekly : RestKind.daily)
      : restKind;
  return (
    periods: [
      for (final p in deleteShiftPeriods(periods, shift.start, end))
        if (p.weeklyRest && !p.start.isBefore(end))
          p.withWeeklyRest(weeklyRest: false)
        else
          p,
    ],
    manual: ManualShift(
      start: shift.start,
      end: end,
      driving: entered,
      continuousDrivingAtEnd: shorter(shift.continuousDrivingAtEnd, entered),
      restKind: kind,
      splitRest: kind == RestKind.daily && splitRest,
    ),
  );
}

/// Переносит начало отдыха после завершённой смены (конец смены): не
/// раньше минуты после начала последней работы смены и не в будущее.
List<ActivityPeriod> _moveRestStart(
  List<ActivityPeriod> periods,
  DateTime shiftStart,
  DateTime restStart,
  DateTime newEnd,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = sorted.indexWhere((p) => p.mode.isRest && p.start == restStart);
  if (idx < 0) return periods;
  var lastWork = shiftStart;
  for (var j = idx - 1; j >= 0; j--) {
    final p = sorted[j];
    if (p.start.isBefore(shiftStart)) break;
    if (!p.mode.isRest) {
      lastWork = p.start;
      break;
    }
  }
  final target = earlier(now, later(newEnd, lastWork.add(_minute)));
  return moveStart(periods, sorted[idx], target, now);
}

/// Удаляет записи смены: всё, что началось с [start] и до [end]. Отдых
/// после завершённой смены остаётся, на месте смены — разрыв в данных:
/// соседние смены не меняются.
///
/// Идущая смена ([end] == null) удаляется до конца журнала, а отдых перед
/// ней снова идёт — как будто смену не начинали.
List<ActivityPeriod> deleteShiftPeriods(
  List<ActivityPeriod> periods,
  DateTime start,
  DateTime? end,
) {
  final kept = [
    for (final p in sortedByStart(periods))
      if (p.start.isBefore(start) || (end != null && !p.start.isBefore(end))) p,
  ];
  if (end == null && kept.isNotEmpty && kept.last.mode.isRest) {
    kept.last = kept.last.withEnd(null);
  }
  return kept;
}

/// Вырезает время ручной смены [start]–[end] из записанного отдыха: водитель
/// забыл переключить режим, и работа числится отдыхом. Записи отдыха
/// обрезаются или делятся на две части вокруг смены; отметки «конец дня» и
/// «недельный» остаются только у части после смены — перед сменой день не
/// кончался.
List<ActivityPeriod> carveRest(
  List<ActivityPeriod> periods,
  DateTime start,
  DateTime end,
  DateTime now,
) => [
  for (final p in periods)
    if (!p.mode.isRest ||
        !(p.end ?? now).isAfter(start) ||
        !p.start.isBefore(end))
      p
    else ...[
      if (p.start.isBefore(start))
        p
            .withEnd(start)
            .withDayEnd(dayEnd: false)
            .withWeeklyRest(weeklyRest: false),
      if ((p.end ?? now).isAfter(end))
        ActivityPeriod(
          // Часть после смены — новая запись, если первая часть осталась
          id: p.start.isBefore(start) ? null : p.id,
          mode: p.mode,
          start: end,
          end: p.end,
          ferry: p.ferry,
          dayEnd: p.dayEnd,
          weeklyRest: p.weeklyRest,
        ),
    ],
];

/// Одна и та же смена в двух расчётах журнала: у ручной — тот же id, у
/// записанной — то же начало.
bool sameShift(JournalShift a, JournalShift b) {
  final (ma, mb) = (a.manual, b.manual);
  if ((ma == null) != (mb == null)) return false;
  if (ma != null && mb != null && ma.id != null) return ma.id == mb.id;
  return a.start == b.start;
}

/// Отрезок времени [start, end).
typedef TimeRange = ({DateTime start, DateTime end});

/// Смена журнала, с которой пересекается [range]; null — пересечений
/// нет. [except] — сама правимая смена.
///
/// Считается только время смен, их отдых — нет: ручная смена может лечь на
/// записанный отдых — его вырежет [carveRest].
JournalShift? findOverlap(
  Iterable<JournalShift> shifts,
  TimeRange range, {
  required DateTime now,
  JournalShift? except,
}) {
  for (final s in shifts) {
    if (except != null && sameShift(s, except)) continue;
    final end = s.end ?? now;
    if (range.start.isBefore(end) && s.start.isBefore(range.end)) return s;
  }
  return null;
}

/// Почему ручную смену нельзя сохранить.
enum ShiftEditError {
  /// Конец смены не позже начала.
  endBeforeStart,

  /// Конец смены в будущем.
  future,

  /// Смена длиннее [maxManualShiftSpan].
  tooLong,

  /// Вождения больше, чем длится смена.
  drivingTooLong,

  /// Непрерывного вождения на конец смены больше, чем вождения за день.
  continuousTooLong,

  /// Смена пересекается с другой ([ShiftEditProblem.conflict]).
  overlap,

  /// Смена не последняя в журнале, а идти может только последняя.
  notLast,
}

/// Ошибка ручной смены и смена, с которой она конфликтует.
@immutable
class ShiftEditProblem {
  const new(this.error, {this.conflict});

  final ShiftEditError error;
  final JournalShift? conflict;
}

/// Проверяет ручную смену перед сохранением: время, суммы и пересечения
/// с остальными сменами журнала [shifts]. [except] — смена, которую правят.
/// Смена без конца ([end] == null) идёт сейчас и станет текущей: после неё
/// не должно быть других смен.
///
/// Нарушения лимитов сохранению не мешают — их покажет журнал после
/// сохранения. Здесь только данные, которых не может быть.
ShiftEditProblem? checkManualShift({
  required DateTime start,
  required DateTime? end,
  required Iterable<JournalShift> shifts,
  required DateTime now,
  Duration driving = Duration.zero,
  Duration continuousDrivingAtEnd = Duration.zero,
  JournalShift? except,
}) {
  final spanEnd = end ?? now;
  // Идущая смена может начаться в эту же минуту: водитель открывает её,
  // когда начинает
  if (end == null ? spanEnd.isBefore(start) : !spanEnd.isAfter(start)) {
    return const ShiftEditProblem(ShiftEditError.endBeforeStart);
  }
  if (spanEnd.isAfter(now)) {
    return const ShiftEditProblem(ShiftEditError.future);
  }
  final span = spanEnd.difference(start);
  if (span > maxManualShiftSpan) {
    return const ShiftEditProblem(ShiftEditError.tooLong);
  }
  if (driving > span) {
    return const ShiftEditProblem(ShiftEditError.drivingTooLong);
  }
  if (end != null && continuousDrivingAtEnd > driving) {
    return const ShiftEditProblem(ShiftEditError.continuousTooLong);
  }
  final others = [
    for (final s in shifts)
      if (except == null || !sameShift(s, except)) s,
  ];
  if (end == null) {
    for (final s in others) {
      if (s.start.isAfter(start)) {
        return ShiftEditProblem(ShiftEditError.notLast, conflict: s);
      }
    }
  }
  final work = findOverlap(others, (start: start, end: spanEnd), now: now);
  if (work != null) {
    return ShiftEditProblem(ShiftEditError.overlap, conflict: work);
  }
  return null;
}

/// Время новой ручной смены по умолчанию: [span], заканчивающиеся сейчас,
/// или, если это время занято сменой или отдыхом после неё, ближайшее
/// более раннее свободное окно с отдыхом [rest] до следующей смены.
///
/// Идущий отдых после ручной смены длится до начала следующей смены, поэтому
/// новая смена может начаться после него — но не раньше, чем через [rest].
TimeRange freeShiftSlot(
  Iterable<JournalShift> shifts,
  DateTime now, {
  Duration span = const Duration(hours: 10),
  Duration rest = const Duration(hours: 11),
}) {
  final sorted = shifts.toList()..sort((a, b) => b.start.compareTo(a.start));
  DateTime busyUntil(JournalShift s) {
    final end = s.end;
    if (s.restEnd case final restEnd?) return restEnd;
    if (end == null) return now;
    if (s.manual != null) return end.add(rest);
    return s.rest.ongoing ? now : end;
  }

  var end = floorTimeToMinute(now);
  // Не больше 60 попыток: на плотном журнале окно ищется глубже в прошлом
  for (var i = 0; i < 60; i++) {
    final start = end.subtract(span);
    JournalShift? hit;
    for (final s in sorted) {
      if (start.isBefore(busyUntil(s)) && s.start.isBefore(end.add(rest))) {
        hit = s;
        break;
      }
    }
    if (hit == null) return (start: start, end: end);
    end = floorTimeToMinute(hit.start.subtract(rest));
  }
  return (start: end.subtract(span), end: end);
}

/// Время новой смены в форме по умолчанию (JRN-09): водитель вносит смену,
/// когда начинает или заканчивает её. Идущая ([ongoing]) начинается в
/// текущую минуту (`end` — тоже она), завершённая заканчивается в текущую
/// минуту и длится [span], но начинается не раньше конца прошлой смены.
///
/// Если сейчас идёт другая смена (её отдых не начат), новая может быть
/// только прошлой — ближайшее свободное окно, [freeShiftSlot].
TimeRange newShiftTimes(
  Iterable<JournalShift> shifts,
  DateTime now, {
  required bool ongoing,
  Duration span = const Duration(hours: 10),
}) {
  final minute = floorTimeToMinute(now);
  if (shifts.any((s) => s.end == null)) {
    return freeShiftSlot(shifts, now, span: span);
  }
  if (ongoing) return (start: minute, end: minute);
  var start = minute.subtract(span);
  for (final s in shifts) {
    final end = s.end!;
    if (end.isAfter(start)) start = end;
  }
  // Прошлая смена закончилась в эту минуту — до сейчас места нет
  if (!start.isBefore(minute)) return freeShiftSlot(shifts, now, span: span);
  return (start: start, end: minute);
}
