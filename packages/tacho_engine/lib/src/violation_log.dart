/// Infringements over a period of the log — what the driver would have seen on
/// the home screen while the log was being written, plus the working days
/// entered as totals.
///
/// The rules are not repeated: [violationLog] recomputes the
/// [calculateCompliance] snapshot at checkpoints on the log as it was at each
/// of them and finds the first minute of every infringement.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/infringement.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shift_route.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';

/// An infringement found in the log: when it began, its values at the worst
/// moment and when it was over.
@immutable
class LoggedViolation {
  const new({required this.at, required this.infringement, this.until});

  /// Первая минута нарушения: лимит + 1 мин. У рабочего дня, внесённого
  /// итогами, — конец последней смены дня: когда именно лимит превышен,
  /// по итогам не узнать.
  final DateTime at;

  /// Нарушение со значениями на пике: наибольшее превышение, опоздание или
  /// число за всё время, пока оно длилось.
  final Infringement infringement;

  /// Не позже этого момента нарушения уже не было: закончилась запись, день
  /// или неделя. null — оно есть и сейчас.
  final DateTime? until;

  InfringementType get type => infringement.type;

  /// Статья, которую видит инспектор.
  String get article => infringement.article;

  /// Нарушение ещё не устранено.
  bool get active => until == null;

  @override
  bool operator ==(Object other) =>
      other is LoggedViolation &&
      other.at == at &&
      other.infringement == infringement &&
      other.until == until;

  @override
  int get hashCode => Object.hash(at, infringement, until);

  @override
  String toString() =>
      'LoggedViolation($at → ${until ?? 'now'}, $infringement)';
}

/// Сколько журнала до момента расчёта берётся в каждый снимок: срок
/// компенсации — до четырёх недель после сокращённого отдыха, право на
/// сокращённый — по трём недельным отдыхам перед ним. Более старые записи на
/// появление нарушения не влияют, а расчёт по всему журналу за годы был бы
/// в разы дольше.
const violationLookback = Duration(days: 56);

/// Нарушения, которые начались в периоде ([from], [now]], по порядку
/// появления. Предупреждения («скоро») и считывание карты не входят.
/// Нарушение, начатое до [from] и ещё не устранённое к [from], не входит:
/// оно относится к прошлому периоду.
///
/// Смены из записей — как на главной: снимок [calculateCompliance] в
/// контрольных точках (конец каждой записи, конец недели, конец ручной
/// смены, сейчас) по журналу, каким он был в этот момент: более поздних
/// записей нет, идущая — открыта. Чем отдых закончился, уже известно:
/// отдых, который завершил смену (от 9 ч, через паром — тоже), считается
/// концом дня с самого начала, от 24 ч — недельным, а объявленный концом дня
/// и прерванный раньше 9 ч — перерывом. Поэтому нарушения дня заканчиваются
/// с началом суточного отдыха, опоздание с недельным — с его началом, а
/// прерванный через полчаса «конец дня» нарушение надвое не делит.
///
/// Рабочий день, внесённый итогами ([ManualShift]), на главной не виден —
/// его оценивает журнал: больше 10 ч вождения и больше 15 ч (экипаж — 21 ч)
/// от начала первой смены дня до конца последней. День, который продолжают
/// записи режимов, считается по ним, как все остальные.
List<LoggedViolation> violationLog({
  required Iterable<ActivityPeriod> periods,
  required DateTime from,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  ComplianceSettings settings = const ComplianceSettings(),
  Map<DateTime, ShiftRoute> routes = const {},
}) {
  if (!now.isUtc) throw ArgumentError.value(now, 'now', 'должно быть в UTC');
  if (!from.isUtc) throw ArgumentError.value(from, 'from', 'должно быть в UTC');
  if (!from.isBefore(now)) return const [];

  final all = sortedByStart(periods);
  final manual = manualShifts.toList();
  final timeline = analyzeTimeline(all, now);
  final oldest = from.subtract(violationLookback);
  final journal = [
    for (final p in all)
      if (p.end?.isAfter(oldest) ?? true) p,
  ];
  final dayEnds = [
    for (final rest in timeline.rests)
      if (rest.endsShift) rest,
  ];

  ComplianceSnapshot snapshotAt(DateTime t) {
    final cutoff = t.subtract(violationLookback);
    return calculateCompliance(
      periods: _journalAt(journal, dayEnds, t, cutoff),
      now: t,
      manualShifts: [
        for (final m in manual)
          if (_knownAt(m, t, cutoff)) m,
      ],
      settings: settings,
      routes: routes,
    );
  }

  Map<InfringementType, Infringement> violationsAt(DateTime t) => {
    for (final i in snapshotAt(t).infringements)
      if (i.severity == InfringementSeverity.violation &&
          i.category != InfringementCategory.card)
        i.type: i,
  };

  final result = [
    ..._replay(violationsAt, from, _checkpoints(journal, manual, from, now)),
    ..._manualDays(timeline, manual, from: from, now: now, crew: settings.crew),
  ];
  return result..sort((a, b) {
    final byTime = a.at.compareTo(b.at);
    return byTime != 0 ? byTime : a.type.index.compareTo(b.type.index);
  });
}

/// Нарушения по снимкам [violationsAt] в контрольных точках [checkpoints]
/// после [from]: нарушение начинается, когда появилось в снимке, — первая
/// минута уточняется между соседними точками — и заканчивается в точке, где
/// его уже нет. То, что было в снимке на [from], началось до периода.
List<LoggedViolation> _replay(
  Map<InfringementType, Infringement> Function(DateTime t) violationsAt,
  DateTime from,
  List<DateTime> checkpoints,
) {
  final result = <LoggedViolation>[];
  final open = <InfringementType, _Episode>{};
  var previousAt = from;
  var previous = violationsAt(from);
  for (final t in checkpoints) {
    final current = violationsAt(t);
    for (final MapEntry(key: type, value: i) in current.entries) {
      final episode = open[type];
      if (episode != null) {
        episode.see(i);
      } else if (!previous.containsKey(type)) {
        open[type] = _Episode(
          _firstMinute(
            previousAt,
            t,
            (probe) => violationsAt(probe).containsKey(type),
          ),
          i,
        );
      }
    }
    open.removeWhere((type, episode) {
      if (current.containsKey(type)) return false;
      result.add(episode.close(t));
      return true;
    });
    previous = current;
    previousAt = t;
  }
  return result
    ..addAll([for (final episode in open.values) episode.close(null)]);
}

const _minute = Duration(minutes: 1);
const _moment = Duration(microseconds: 1);
const int _usPerMinute = Duration.microsecondsPerMinute;
const int _usPerSecond = Duration.microsecondsPerSecond;

/// An infringement that is in the snapshots now: its first minute and the
/// worst values seen so far.
class _Episode {
  new(this.at, this.peak);

  final DateTime at;
  Infringement peak;

  void see(Infringement i) {
    if (_worse(i, peak)) peak = i;
  }

  LoggedViolation close(DateTime? until) => LoggedViolation(
    at: at,
    infringement: _toSeconds(peak),
    until: until == null ? null : _toSecond(until),
  );
}

/// [a] хуже [b]: больше превышение, затем число, затем дни.
bool _worse(Infringement a, Infringement b) {
  final byTime = (a.time ?? Duration.zero).compareTo(b.time ?? Duration.zero);
  if (byTime != 0) return byTime > 0;
  final byCount = (a.count ?? 0).compareTo(b.count ?? 0);
  if (byCount != 0) return byCount > 0;
  return (a.days ?? 0) > (b.days ?? 0);
}

/// Момент — до целой секунды вверх: конец недели — точка за микросекунду до
/// понедельника.
DateTime _toSecond(DateTime t) {
  final rest = t.microsecondsSinceEpoch % _usPerSecond;
  return rest == 0 ? t : t.add(Duration(microseconds: _usPerSecond - rest));
}

/// Превышение — до целой секунды вверх: итог недели берётся за микросекунду
/// до понедельника, и ему не хватает этой микросекунды.
Infringement _toSeconds(Infringement i) {
  final time = i.time;
  if (time == null || time.inMicroseconds % _usPerSecond == 0) return i;
  return Infringement(
    i.type,
    time: Duration(seconds: time.inSeconds + 1),
    limit: i.limit,
    requiredBreak: i.requiredBreak,
    count: i.count,
    days: i.days,
    article: i.article == i.type.article ? null : i.article,
  );
}

/// Журнал [sorted], каким он был в момент [t]: записей, начатых позже, нет,
/// незаконченная к [t] — открыта, законченные до [cutoff] не нужны.
///
/// Внутри отдыха, который завершил смену ([dayEnds]), журнал кончается этим
/// отдыхом — концом дня, а от 24 ч и недельным — с самого его начала, вместе
/// с прерываниями на пароме. В момент начала такого отдыха смена ещё не
/// закончена: в этот момент видно, с чем она пришла к отдыху. Остальные
/// объявления («конец дня», недельный) у идущей в [t] записи не учитываются.
List<ActivityPeriod> _journalAt(
  List<ActivityPeriod> sorted,
  List<RestPeriod> dayEnds,
  DateTime t,
  DateTime cutoff,
) {
  RestPeriod? around;
  for (final rest in dayEnds) {
    if (!rest.start.isBefore(t)) break;
    if (rest.open || rest.end.isAfter(t)) around = rest;
  }
  final result = <ActivityPeriod>[];
  for (final p in sorted) {
    if (around == null ? p.start.isAfter(t) : !p.start.isBefore(around.start)) {
      break;
    }
    final end = p.end;
    if (end != null && !end.isAfter(t)) {
      if (end.isAfter(cutoff)) result.add(p);
    } else {
      result.add(
        ActivityPeriod(id: p.id, mode: p.mode, start: p.start, ferry: p.ferry),
      );
    }
  }
  if (around != null) {
    result.add(
      ActivityPeriod(
        mode: DriverMode.rest,
        start: around.start,
        dayEnd: true,
        weeklyRest: around.isWeekly,
      ),
    );
  }
  return result;
}

/// Итоги ручной смены известны с её конца.
bool _knownAt(ManualShift m, DateTime t, DateTime cutoff) {
  final end = m.end ?? m.start;
  return !end.isAfter(t) && end.isAfter(cutoff);
}

/// Контрольные точки в ([from], [now]] по возрастанию. Между соседними
/// точками журнал не меняется, а нарушение, появившись, не исчезает: конец
/// каждой записи и ручной смены, последний момент каждой недели — после него
/// суммы за неделю обнуляются — и сейчас.
List<DateTime> _checkpoints(
  List<ActivityPeriod> journal,
  List<ManualShift> manual,
  DateTime from,
  DateTime now,
) {
  final points = <DateTime>{now};
  void add(DateTime? t) {
    if (t != null && t.isAfter(from) && t.isBefore(now)) points.add(t);
  }

  for (final p in journal) {
    add(p.end);
  }
  for (final m in manual) {
    add(m.end ?? m.start);
  }
  for (
    var monday = weekStartUtc(from).add(week);
    !monday.isAfter(now);
    monday = monday.add(week)
  ) {
    add(monday.subtract(_moment));
  }
  return points.toList()..sort();
}

/// Первая целая минута, когда нарушение есть: в [from] его нет, в [to] —
/// есть, между ними оно не исчезает. Не позже [to].
DateTime _firstMinute(
  DateTime from,
  DateTime to,
  bool Function(DateTime t) present,
) {
  final base = floorTimeToMinute(from);
  var absent = 0;
  var found = (to.difference(base).inMicroseconds / _usPerMinute).ceil();
  final last = found;
  while (found - absent > 1) {
    final middle = (absent + found) ~/ 2;
    if (present(base.add(_minute * middle))) {
      found = middle;
    } else {
      absent = middle;
    }
  }
  return found == last ? _toSecond(to) : base.add(_minute * found);
}

/// Нарушения рабочих дней из ручных смен, законченных в ([from], [now]].
/// День — смена и ручные смены перед ней, отдых после которых был короче
/// 9 ч ([ManualDays]); день, который продолжила следующая смена, считается
/// у неё.
List<LoggedViolation> _manualDays(
  Timeline timeline,
  List<ManualShift> manual, {
  required DateTime from,
  required DateTime now,
  required CrewMode crew,
}) {
  if (manual.isEmpty) return const [];
  final days = ManualDays(manual, manualRests(manual, timeline, now));
  final spanLimit = workdayWindow(crew) - EuLimits.dailyRestReduced;
  final result = <LoggedViolation>[];
  for (final m in manual) {
    final end = m.end;
    if (end == null ||
        !end.isAfter(from) ||
        end.isAfter(now) ||
        days.continues(m)) {
      continue;
    }
    final before = days.before(m.start);
    final dayStart = before.firstOrNull?.shift.start ?? m.start;
    final driving = before.fold(
      m.driving,
      (sum, part) => sum + part.shift.driving,
    );
    if (driving > EuLimits.dailyDrivingExtended) {
      result.add(
        LoggedViolation(
          at: end,
          until: end,
          infringement: Infringement(
            InfringementType.dailyDriveExceeded,
            time: driving - EuLimits.dailyDrivingExtended,
            limit: EuLimits.dailyDrivingExtended,
          ),
        ),
      );
    }
    final span = durationBetween(dayStart, end);
    if (span > spanLimit) {
      result.add(
        LoggedViolation(
          at: end,
          until: end,
          infringement: Infringement(
            InfringementType.shiftExceeded,
            time: span - spanLimit,
            limit: spanLimit,
            article: crew == CrewMode.team ? '8(5)' : null,
          ),
        ),
      );
    }
  }
  return result;
}
