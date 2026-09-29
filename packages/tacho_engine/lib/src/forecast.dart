import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/infringement.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/time.dart';

/// Отдых, набранный целиком: водителю можно ехать дальше.
enum RestMilestone {
  /// Перерыв по ст. 7 засчитан: 45 мин или 30 после первой части.
  breakTaken,

  /// Полный суточный отдых 11 ч.
  dailyRestTaken,

  /// Полный недельный отдых 45 ч.
  weeklyRestTaken,

  /// Идущий отдых набрал долг компенсации (ст. 8(7)): долг погашен.
  compensationTaken,
}

/// Событие прогноза: предупреждение или нарушение движка либо набранный
/// отдых.
@immutable
sealed class UpcomingAlert {
  const new(this.at);

  /// Когда событие наступит, если журнал не изменится.
  final DateTime at;

  /// Ключ события: у каждого вида — не больше одного уведомления.
  Enum get kind;
}

/// Предупреждение или нарушение с параметрами на момент [at].
final class LimitAlert extends UpcomingAlert {
  const new(super.at, this.infringement);

  final Infringement infringement;

  @override
  InfringementType get kind => infringement.type;

  @override
  bool operator ==(Object other) =>
      other is LimitAlert &&
      other.at == at &&
      other.infringement == infringement;

  @override
  int get hashCode => Object.hash(at, infringement);

  @override
  String toString() => 'LimitAlert($at, $infringement)';
}

/// Отдых набран: [taken] — сколько отдыха засчитано (45 или 30 мин, 11 ч,
/// 45 ч, погашенный долг компенсации), [drivingUntilBreak] — сколько можно
/// ехать до следующего перерыва.
final class RestAlert extends UpcomingAlert {
  const new(
    super.at,
    this.milestone, {
    required this.taken,
    required this.drivingUntilBreak,
  });

  final RestMilestone milestone;
  final Duration taken;
  final Duration drivingUntilBreak;

  @override
  RestMilestone get kind => milestone;

  @override
  bool operator ==(Object other) =>
      other is RestAlert &&
      other.at == at &&
      other.milestone == milestone &&
      other.taken == taken &&
      other.drivingUntilBreak == drivingUntilBreak;

  @override
  int get hashCode => Object.hash(at, milestone, taken, drivingUntilBreak);

  @override
  String toString() =>
      'RestAlert($at, ${milestone.name}, ${taken.inMinutes} мин)';
}

/// Прогноз уведомлений: когда появятся предупреждения и нарушения и когда
/// отдых будет набран, если текущий режим продолжится, а журнал не
/// изменится. По событию на вид — первое после [now]; то, что уже есть на
/// момент [now], в прогноз не входит: водитель видит это на экране, а
/// повторное уведомление было бы дублем.
///
/// Правила не повторяются: моменты находит сам [calculateCompliance] —
/// прогноз пересчитывает снимок в контрольных точках (порог минус
/// предупреждение, лимит, лимит + 1 мин, границы недели, сроки) и
/// уточняет момент появления с точностью до минуты. Изменился журнал или
/// настройки — прогноз строится заново.
List<UpcomingAlert> forecastAlerts({
  required Iterable<ActivityPeriod> periods,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  ComplianceSettings settings = const ComplianceSettings(),
  DateTime? lastCardDownload,
  Duration horizon = forecastHorizon,
}) {
  if (!now.isUtc) throw ArgumentError.value(now, 'now', 'должно быть в UTC');
  final journal = periods.toList();
  final manual = manualShifts.toList();
  ComplianceSnapshot at(DateTime t) => calculateCompliance(
    periods: journal,
    now: t,
    manualShifts: manual,
    settings: settings,
    lastCardDownload: lastCardDownload,
  );

  final end = now.add(horizon);
  final found = <Enum, UpcomingAlert>{};
  var previous = at(now);
  var previousKinds = alertKinds(previous);
  for (var step = 0; step < _maxSteps; step++) {
    final next = _nextCheckpoint(previous, settings, lastCardDownload);
    if (next == null || next.isAfter(end)) break;
    final snapshot = at(next);
    final kinds = alertKinds(snapshot);
    for (final kind in kinds.difference(previousKinds)) {
      if (found.containsKey(kind)) continue;
      final (moment, s) = _firstMoment(kind, previous.now, next, snapshot, at);
      found[kind] = _alert(kind, moment, s);
    }
    previous = snapshot;
    previousKinds = kinds;
  }
  return found.values.toList()..sort((a, b) => a.at.compareTo(b.at));
}

/// Насколько вперёд строится прогноз: считывание карты — раз в 28 дней.
const forecastHorizon = Duration(days: 30);

/// Защита от бесконечного цикла: за 30 дней непрерывного режима точек
/// заметно меньше.
const _maxSteps = 400;

const _minute = Duration(minutes: 1);
const int _usPerSecond = Duration.microsecondsPerSecond;

/// Виды событий, которые есть в снимке: предупреждения и нарушения и
/// набранный отдых. Уведомление о виде, которого уже нет, устарело.
Set<Enum> alertKinds(ComplianceSnapshot s) => {
  for (final i in s.infringements) i.type,
  ?_restTaken(s),
  if ((s.restCompensation?.taken ?? Duration.zero) > Duration.zero)
    RestMilestone.compensationTaken,
};

RestMilestone? _restTaken(ComplianceSnapshot s) {
  if (s.weeklyRestRemaining == Duration.zero) {
    return RestMilestone.weeklyRestTaken;
  }
  if (s.dailyRestRemaining == Duration.zero) {
    return RestMilestone.dailyRestTaken;
  }
  final b = s.currentBreak;
  if (s.status == DriverStatus.onBreak &&
      b != null &&
      b.duration >= b.required) {
    return RestMilestone.breakTaken;
  }
  return null;
}

UpcomingAlert _alert(Enum kind, DateTime at, ComplianceSnapshot s) {
  if (kind is! RestMilestone) {
    return LimitAlert(at, s.infringement(kind as InfringementType)!);
  }
  return RestAlert(
    at,
    kind,
    taken: switch (kind) {
      RestMilestone.breakTaken => s.currentBreak!.required,
      RestMilestone.dailyRestTaken => EuLimits.dailyRestRegular,
      RestMilestone.weeklyRestTaken => EuLimits.weeklyRestRegular,
      RestMilestone.compensationTaken => s.restCompensation!.taken,
    },
    drivingUntilBreak: s.drivingUntilBreak,
  );
}

/// Первый момент в (from, to], когда в снимке есть [kind]; в [to] он есть.
/// Обычно контрольная точка и есть этот момент — тогда минутой раньше его
/// ещё нет. Иначе (например, отдых склеился через паром) — деление пополам
/// до секунды. Точность — до минуты: превышение наступает сразу после
/// лимита, а уведомление приходит на минуту позже, как в тестах на
/// границе (ровно лимит — норма, лимит + 1 мин — нарушение).
(DateTime, ComplianceSnapshot) _firstMoment(
  Enum kind,
  DateTime from,
  DateTime to,
  ComplianceSnapshot atTo,
  ComplianceSnapshot Function(DateTime) at,
) {
  bool has(ComplianceSnapshot s) => alertKinds(s).contains(kind);
  // Минутой раньше — предыдущая точка или ещё раньше: там вида не было.
  final probe = to.subtract(_minute);
  if (!probe.isAfter(from)) return (to, atTo);
  var result = at(probe);
  if (!has(result)) return (to, atTo);
  // Целые секунды от from: вида нет в lo, есть в hi.
  var moment = probe;
  var lo = 0;
  var hi = (probe.difference(from).inMicroseconds / _usPerSecond).ceil();
  while (hi - lo > 1) {
    final mid = (lo + hi) ~/ 2;
    final t = from.add(Duration(seconds: mid));
    final s = at(t);
    if (has(s)) {
      hi = mid;
      moment = t;
      result = s;
    } else {
      lo = mid;
    }
  }
  return (moment, result);
}

/// Ближайшая контрольная точка после снимка [s]: моменты, когда значение,
/// которое растёт, пока режим не меняется, доходит до порога
/// предупреждения, до лимита и превышает его на минуту, и сроки из
/// календаря.
DateTime? _nextCheckpoint(
  ComplianceSnapshot s,
  ComplianceSettings settings,
  DateTime? lastCardDownload,
) {
  final now = s.now;
  final points = <DateTime>[];
  void add(DateTime t) {
    if (t.isAfter(now)) points.add(t);
  }

  // Остаток до лимита убывает вместе со временем.
  void limit(Duration left, {Duration? warning}) {
    add(now.add(left - (warning ?? settings.warningLead)));
    add(now.add(left));
    add(now.add(left + _minute));
  }

  final mode = s.currentMode;
  if (mode == DriverMode.driving) {
    limit(EuLimits.continuousDriving - s.continuousDriving);
    limit(EuLimits.dailyDriving - s.dailyDriving);
    limit(s.dailyDrivingLimit - s.dailyDriving);
    limit(EuLimits.weeklyDriving - s.weeklyDriving);
    limit(EuLimits.fortnightDriving - s.fortnightDriving);
  }
  if (s.shift != null) limit(s.shiftLimit - s.shiftDuration);

  // Отдых растёт: перерыв засчитан, смена закрыта, отдых суточный,
  // недельный, полный.
  if (s.currentBreak case final b?) {
    add(now.add(b.required - b.duration));
    add(now.add(EuLimits.breakSplitFirst - b.duration));
  }
  final rests = s.timeline.rests;
  // Отдых после ручной смены растёт и без записи режима
  final rest = mode == DriverMode.rest && rests.isNotEmpty
      ? (rests.last.open ? rests.last.rest : null)
      : mode == null
      ? s.offDutyRest?.duration
      : null;
  if (rest != null) {
    for (final threshold in const [
      EuLimits.dailyRestSplitFirst,
      EuLimits.dailyRestReduced,
      EuLimits.dailyRestRegular,
      EuLimits.weeklyRestReduced,
      EuLimits.weeklyRestRegular,
    ]) {
      add(now.add(threshold - rest));
    }
  }

  // Календарь: неделя с понедельника, 144 ч, компенсация, карта.
  add(s.weekStart.add(week));
  if (s.weeklyRestDeadline case final deadline?) {
    add(deadline.subtract(EuLimits.weeklyRestWarning));
    add(deadline);
    add(deadline.add(_minute));
  }
  if (s.compensation case final c?) {
    add(c.dueBy.subtract(EuLimits.compensationWarning));
    add(c.dueBy.add(_minute));
  }
  if (s.restCompensation case final c? when c.inTime) add(c.until!);
  if (lastCardDownload != null) {
    final days = EuLimits.cardDownloadInterval.inDays;
    add(lastCardDownload.add(Duration(days: days - settings.cardAlertDays)));
    add(lastCardDownload.add(Duration(days: days + 1)));
  }
  return points.isEmpty ? null : points.reduce(earlier);
}
