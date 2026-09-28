import 'package:meta/meta.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

/// Отдых после ручной смены. Водитель отмечает только вид отдыха, а
/// длительность считается по журналу: отдых длится от конца смены до начала
/// следующей смены — ручной или из записей режимов.
@immutable
class ManualRest {
  const new({
    required this.kind,
    required this.start,
    required this.end,
    required this.duration,
  });

  /// Суточный или недельный. Отдых от 24 ч — недельный, даже если водитель
  /// отметил суточный: так же считается отдых из записей
  /// (`RestPeriod.isWeekly`).
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
  return ManualRest(
    kind:
        shift.restKind == RestKind.weekly ||
            duration >= EuLimits.weeklyRestReduced
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
