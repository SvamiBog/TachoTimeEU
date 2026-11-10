/// Rest periods after manual shifts, measured from the log around them.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

/// The rest after a manual shift. The driver only marks the kind of rest; its
/// length comes from the log: from the end of the shift to the start of the
/// next one, manual or recorded.
@immutable
class ManualRest {
  const new({
    required this.kind,
    required this.start,
    required this.end,
    required this.duration,
  });

  /// Суточный или недельный, как у отдыха из записей
  /// (`RestPeriod.isWeekly`). Отдых от 24 ч — недельный, даже если водитель
  /// отметил суточный. Отмеченный недельным — недельный, пока идёт;
  /// законченный раньше 24 ч отметку теряет и считается по длительности:
  /// недельным отдых короче 24 ч не бывает.
  final RestKind kind;

  /// Конец смены.
  final DateTime start;

  /// Начало следующей смены; null — следующей смены нет, отдых идёт.
  final DateTime? end;
  final Duration duration;

  bool get ongoing => end == null;

  @override
  String toString() =>
      'ManualRest(${kind.name}, $start → ${end ?? '…'}, '
      '${duration.inMinutes} мин)';
}

/// Отдых после ручной смены [shift]: до ближайшего начала смены из
/// [shiftStarts], не раньше конца [shift]. Если такой смены нет, отдых идёт
/// до [now]. null — смена идёт или отдых после неё не начат.
ManualRest? manualRestAfter(
  ManualShift shift,
  Iterable<DateTime> shiftStarts,
  DateTime now,
) {
  final end = shift.end;
  if (end == null || shift.restKind == RestKind.none) return null;
  DateTime? next;
  for (final s in shiftStarts) {
    // Своё начало не в счёт, даже у смены нулевой длины
    if (!s.isAfter(shift.start) || s.isBefore(end)) continue;
    if (next == null || s.isBefore(next)) next = s;
  }
  final duration = durationBetween(end, next ?? now);
  final declaredWeekly = next == null && shift.restKind == RestKind.weekly;
  return ManualRest(
    kind: declaredWeekly || duration >= EuLimits.weeklyRestReduced
        ? RestKind.weekly
        : RestKind.daily,
    start: end,
    end: next,
    duration: duration,
  );
}

/// Отдых после каждой ручной смены из [manual], в том же порядке: до
/// начала следующей смены — ручной или из [timeline].
List<ManualRest?> manualRests(
  List<ManualShift> manual,
  Timeline timeline,
  DateTime now,
) {
  final starts = [
    for (final m in manual) m.start,
    for (final s in timeline.shifts) s.start,
  ];
  return [for (final m in manual) manualRestAfter(m, starts, now)];
}

/// A manual shift that did not end the working day, with the rest after it:
/// the rest lasted less than a daily rest, so the next shift goes on with the
/// same day.
typedef CarriedShift = ({ManualShift shift, ManualRest rest});

/// Working days that span manual shifts. A rest shorter than 9 h does not end
/// the day — inside a recorded shift it is a break, and so it is after a manual
/// shift: its driving and its time belong to the day of the next shift
/// (Art. 4(k), 8(2)).
class ManualDays {
  /// [rests] — отдых после каждой смены из [manual], в том же порядке
  /// ([manualRests]).
  new(List<ManualShift> manual, List<ManualRest?> rests) {
    for (final (i, m) in manual.indexed) {
      final r = rests[i];
      final next = r?.end;
      if (r == null ||
          next == null ||
          r.duration >= EuLimits.dailyRestReduced ||
          // Смена нулевой длины, начатая в тот же момент, — не «перед»
          !m.start.isBefore(next)) {
        continue;
      }
      // Две смены перед одной (испорченный журнал) — ближайшая к ней
      final other = _before[next];
      if (other == null || other.shift.start.isBefore(m.start)) {
        _before[next] = (shift: m, rest: r);
      }
    }
    for (final part in _before.values) {
      _continuing.add(part.shift);
    }
  }

  /// Начало смены → ручная смена того же дня прямо перед ней.
  final _before = <DateTime, CarriedShift>{};

  /// Смены из [_before]: день продолжает следующая смена.
  final _continuing = Set<ManualShift>.identity();

  /// Ручные смены того же рабочего дня перед сменой, начатой в [shiftStart],
  /// по порядку: отдых после каждой — до начала следующей — короче 9 ч.
  /// Пусто — рабочий день начат самой этой сменой.
  List<CarriedShift> before(DateTime shiftStart) {
    final chain = <CarriedShift>[];
    // Начала строго убывают — цепочка конечна
    for (
      var part = _before[shiftStart];
      part != null;
      part = _before[part.shift.start]
    ) {
      chain.add(part);
    }
    return chain.reversed.toList();
  }

  /// Смена [shift] день не закончила: её продолжает следующая смена.
  bool continues(ManualShift shift) => _continuing.contains(shift);
}
