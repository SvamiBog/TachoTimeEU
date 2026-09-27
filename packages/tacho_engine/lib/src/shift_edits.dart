import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/journal.dart';
import 'package:tacho_engine/src/journal_edits.dart';
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
}

/// Применяет [edit] к записям режимов. Сдвиги ограничены соседними
/// записями: начало не уходит раньше предыдущей записи (её не удалить
/// правкой начала), конец — не в будущее, смена не короче минуты.
///
/// Возвращает записи и начало смены после правки: по нему приложение
/// переносит страны и заметки.
({List<ActivityPeriod> periods, DateTime shiftStart}) editLiveShift(
  List<ActivityPeriod> periods,
  LiveShiftEdit edit,
  DateTime now,
) {
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
  return (periods: result, shiftStart: shiftStart);
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
/// обрезаются или делятся на две части вокруг смены; отметка «конец дня»
/// остаётся только у части после смены — перед сменой день не кончался.
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
      if (p.start.isBefore(start)) p.withEnd(start).withDayEnd(dayEnd: false),
      if ((p.end ?? now).isAfter(end))
        ActivityPeriod(
          // Часть после смены — новая запись, если первая часть осталась
          id: p.start.isBefore(start) ? null : p.id,
          mode: p.mode,
          start: end,
          end: p.end,
          ferry: p.ferry,
          dayEnd: p.dayEnd,
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

  /// Отдых после смены заходит на другую смену.
  restOverlap,

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
/// с остальными сменами журнала [shifts]. [except] — смена, которую
/// правят. Смена без конца ([end] == null) идёт сейчас и станет текущей:
/// после неё не должно быть других смен.
ShiftEditProblem? checkManualShift({
  required DateTime start,
  required DateTime? end,
  required Iterable<JournalShift> shifts,
  required DateTime now,
  Duration driving = Duration.zero,
  Duration continuousDrivingAtEnd = Duration.zero,
  Duration rest = Duration.zero,
  JournalShift? except,
}) {
  final spanEnd = end ?? now;
  if (!spanEnd.isAfter(start)) {
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
  if (end != null && rest > Duration.zero) {
    final hit = findOverlap(others, (start: end, end: end.add(rest)), now: now);
    if (hit != null) {
      return ShiftEditProblem(ShiftEditError.restOverlap, conflict: hit);
    }
  }
  return null;
}

/// Время новой ручной смены по умолчанию: [span], заканчивающиеся сейчас,
/// или, если это время занято сменой или отдыхом после неё, ближайшее
/// более раннее свободное окно с отдыхом [rest] до следующей смены.
TimeRange freeShiftSlot(
  Iterable<JournalShift> shifts,
  DateTime now, {
  Duration span = const Duration(hours: 10),
  Duration rest = const Duration(hours: 11),
}) {
  final sorted = shifts.toList()..sort((a, b) => b.start.compareTo(a.start));
  DateTime busyUntil(JournalShift s) =>
      s.restEnd ?? (s.end == null || s.rest.ongoing ? now : s.end!);
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
