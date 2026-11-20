/// Compensation of reduced weekly rests (Art. 8(6), 8(7)): the debt for each
/// reduced weekly rest, which later rest repaid it, which debts are still open
/// and what the rest in progress repays.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/compliance_log.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

/// Debt for a reduced weekly rest (Art. 8(6)) and the rest it was attached to
/// (Art. 8(7)). Two reduced weekly rests in a row make one debt: it is repaid
/// together, en bloc, after the second of them.
@immutable
class Compensation {
  const new({
    required this.debt,
    required this.dueBy,
    required this.restStart,
    this.secondRestStart,
    this.repaidIn,
  });

  /// Сколько не хватило до 45 ч; два сокращённых подряд — за оба вместе:
  /// после двух по 24 ч — 21 + 21 = 42 ч.
  final Duration debt;

  /// До какого момента долг нужно присоединить к отдыху; два сокращённых
  /// подряд — срок первого.
  final DateTime dueBy;

  /// Начало сокращённого недельного отдыха, за который долг; два подряд —
  /// первого из них.
  final DateTime restStart;

  /// Начало второго из двух сокращённых подряд: долг за оба гасит один
  /// отдых после него (ст. 8(6)); null — сокращённый один.
  final DateTime? secondRestStart;

  /// Начало отдыха, к которому долг присоединён; null — не погашен.
  final DateTime? repaidIn;

  bool get repaid => repaidIn != null;

  /// Недельный отдых, который гасит долг: полные 45 ч и весь долг одним
  /// блоком (ст. 8(6), 8(7)).
  Duration get weeklyRestWithDebt => EuLimits.weeklyRestRegular + debt;

  /// Долг — за недельный отдых, начатый в [start].
  bool isFor(DateTime start) => restStart == start || secondRestStart == start;

  @override
  bool operator ==(Object other) =>
      other is Compensation &&
      other.debt == debt &&
      other.dueBy == dueBy &&
      other.restStart == restStart &&
      other.secondRestStart == secondRestStart &&
      other.repaidIn == repaidIn;

  @override
  int get hashCode =>
      Object.hash(debt, dueBy, restStart, secondRestStart, repaidIn);

  @override
  String toString() =>
      'Compensation(${debt.inMinutes} мин до $dueBy'
      '${secondRestStart == null ? '' : ', два сокращённых подряд'}'
      '${repaidIn == null ? '' : ', погашен $repaidIn'})';
}

/// Compensation inside the rest in progress: how much debt it has already
/// repaid, which debt it repays next and when it repays every debt it can
/// still repay in time. A rest repays a debt when it lasts 9 h + debt (a weekly
/// rest of 24 h or more: 45 h + debt) and reaches that by the due date
/// (Art. 8(7)).
@immutable
class RestCompensation {
  const new({
    required this.taken,
    required this.next,
    required this.until,
    this.planned = const [],
    this.untilAll,
  });

  /// Долг, уже присоединённый к этому отдыху; ноль — пока ни одного.
  final Duration taken;

  /// Долг, который отдых погасит следующим; null — гасить больше нечего.
  final Compensation? next;

  /// Когда отдых погасит [next], если продлится; null — [next] нет.
  final DateTime? until;

  /// Долги, которые отдых ещё погасит, если продлится до [untilAll]: [next]
  /// и за ним остальные, что он успевает погасить к их срокам, не становясь
  /// из суточного недельным. Каждый долг — целиком: после двух сокращённых
  /// по 24 ч долг 42 ч один, недельный отдых гасит его при 45 + 42 = 87 ч.
  /// Пусто — к сроку не успеть ни один.
  final List<Compensation> planned;

  /// Когда отдых погасит все [planned]; null — [planned] пуст.
  final DateTime? untilAll;

  /// Отдых успевает погасить [next] к сроку.
  bool get inTime {
    final (c, at) = (next, until);
    return c != null && at != null && !at.isAfter(c.dueBy);
  }

  /// Весь долг этого отдыха, если он продлится до [untilAll]: уже
  /// присоединённый и [planned].
  Duration get total => planned.fold(taken, (sum, c) => sum + c.debt);

  /// Ближайший срок среди [planned]; null — [planned] пуст.
  DateTime? get plannedDueBy => planned.isEmpty
      ? null
      : planned.map((c) => c.dueBy).reduce((a, b) => a.isBefore(b) ? a : b);

  /// Сколько из [total] отдых набрал к моменту снимка [now]: [total] минус
  /// то, что ещё отдыхать до [untilAll]. null — [planned] пуст.
  Duration? totalRepaidAt(DateTime now) {
    final at = untilAll;
    if (planned.isEmpty || at == null) return null;
    return clampToZero(total - clampToZero(at.difference(now)));
  }

  /// Сколько из долга [next] отдых набрал к моменту снимка [now]: долг
  /// минус то, что ещё отдыхать до [until]. null — [next] нет.
  Duration? nextRepaidAt(DateTime now) {
    final (c, at) = (next, until);
    if (c == null || at == null) return null;
    return clampToZero(c.debt - clampToZero(at.difference(now)));
  }

  @override
  bool operator ==(Object other) =>
      other is RestCompensation &&
      other.taken == taken &&
      other.next == next &&
      other.until == until &&
      _sameList(other.planned, planned) &&
      other.untilAll == untilAll;

  @override
  int get hashCode =>
      Object.hash(taken, next, until, Object.hashAll(planned), untilAll);

  @override
  String toString() =>
      'RestCompensation(погашено ${taken.inMinutes} мин'
      '${next == null ? '' : ', дальше ${next!.debt.inMinutes} мин к $until'}'
      '${planned.length < 2 ? '' : ', всё ${total.inMinutes} мин к $untilAll'}'
      ')';
}

/// All compensation debts of the log by the start of the rest, and the unpaid
/// ones by due date.
typedef CompensationDebts = ({
  List<Compensation> all,
  List<Compensation> unpaid,
});

/// Просроченный долг остаётся среди непогашенных ещё четыре недели после
/// срока: водитель видит его и нарушение, пока не пройдёт месяц.
const _overdueDebtShown = Duration(days: 28);

/// Долги за сокращённые недельные отдыхи из законченных недельных
/// [completed] (по началу) и какой отдых журнала [log] погасил каждый.
///
/// Долг берётся одним блоком, присоединённым к другому отдыху не короче
/// 9 ч, до конца третьей недели после недели сокращённого отдыха (ст. 8(6),
/// 8(7)). Недельный отдых (от 24 ч) несёт компенсацию сверх 45 ч — иначе
/// обычный недельный отдых сам гасил бы долг. Долги гасятся по порядку,
/// один длинный отдых может погасить несколько.
CompensationDebts compensationDebts(
  ComplianceLog log,
  List<WeeklyRest> completed,
) {
  final hosts = _Hosts.of(log);
  final all = <Compensation>[];
  final unpaid = <Compensation>[];
  final shownSince = log.now.subtract(_overdueDebtShown);
  for (final group in _reducedGroups(completed)) {
    final end = group.last.end;
    if (end == null) continue;
    final c = _debtOf(group, end, hosts);
    all.add(c);
    if (c.repaidIn == null && !c.dueBy.isBefore(shownSince)) unpaid.add(c);
  }
  unpaid.sort((a, b) => a.dueBy.compareTo(b.dueBy));
  return (all: all, unpaid: unpaid);
}

/// Сокращённые отдыхи из [completed] по долгам. Два сокращённых подряд
/// (пакет мобильности) — один долг за оба: следующему недельному отдыху
/// предшествует отдых в компенсацию за оба (ст. 8(6)). Его берут вместе,
/// одним блоком, после второго из них и до срока первого; отдых между ними
/// долг не гасит, по частям — тоже.
List<List<WeeklyRest>> _reducedGroups(List<WeeklyRest> completed) {
  final groups = <List<WeeklyRest>>[];
  for (final (i, r) in completed.indexed) {
    if (r.status != RestStatus.reduced) continue;
    final group = groups.lastOrNull;
    if (group != null &&
        group.length == 1 &&
        identical(group.single, completed[i - 1])) {
      group.add(r);
    } else {
      groups.add([r]);
    }
  }
  return groups;
}

/// Долг за сокращённые отдыхи [group], последний из которых кончился в
/// [end], и отдых из [hosts], который его погасил.
Compensation _debtOf(List<WeeklyRest> group, DateTime end, _Hosts hosts) {
  final debt = group.fold(
    Duration.zero,
    (sum, r) => sum + EuLimits.weeklyRestRegular - r.duration,
  );
  final dueBy = weekStartUtc(group.first.start)
      .add(week * (EuLimits.compensationWeeks + 1));
  return Compensation(
    debt: debt,
    dueBy: dueBy,
    restStart: group.first.start,
    secondRestStart: group.length > 1 ? group.last.start : null,
    repaidIn: hosts.repay(debt, after: end, dueBy: dueBy),
  );
}

/// The rests of the log that can carry compensation, with the debt each one
/// has taken so far.
final class _Hosts {
  new(this._rests) : _used = List.filled(_rests.length, Duration.zero);

  /// Отдыхи из записей и ручных смен. Отдых ручной смены, который уже есть
  /// в записях (после «Завершить день» с вождением), — один раз: он не
  /// может погасить долг дважды.
  factory of(ComplianceLog log) {
    final timeline = log.timeline;
    return _Hosts([
      for (final p in timeline.rests) (start: p.start, rest: p.rest),
      for (final r in log.manualRest)
        if (!timeline.rests.any((p) => overlapsRecordedRest(p, r, log.now)))
          (start: r.start, rest: r.duration),
    ]);
  }

  final List<({DateTime start, Duration rest})> _rests;

  /// Сколько долга уже присоединено к каждому отдыху.
  final List<Duration> _used;

  /// Начало первого отдыха после [after] и до срока [dueBy], который
  /// вмещает долг [debt] сверх своей основы, и отдых его запоминает; null —
  /// такого нет. Засчитывается только отдых, набранный к сроку.
  DateTime? repay(
    Duration debt, {
    required DateTime after,
    required DateTime dueBy,
  }) {
    for (final (i, host) in _rests.indexed) {
      if (host.start.isBefore(after) || !host.start.isBefore(dueBy)) continue;
      final base = _compensationBase(host.rest, Duration.zero);
      final byDue = shorter(host.rest, dueBy.difference(host.start));
      if (byDue - base - _used[i] >= debt) {
        _used[i] += debt;
        return host.start;
      }
    }
    return null;
  }
}

/// Компенсация в идущем отдыхе [rest]: сколько долга из [debts] он уже
/// погасил, какой погасит следующим и когда; null — гасить нечего.
///
/// Долги гасятся по очереди, и отдых гасит первым тот, что влезет раньше, —
/// обычно меньший. Суточный отдых несёт долг сверх 9 ч, недельный — сверх
/// 45 ч; отдых, который с долгом выйдет за 24 ч, станет недельным. Чистый
/// отдых растёт вместе со временем: момент — от [now], прерывания на
/// пароме в прошлом не мешают.
RestCompensation? restCompensationOf(
  OffDutyRest rest,
  CompensationDebts debts,
  DateTime now,
) {
  final taken = [
    for (final c in debts.all)
      if (c.repaidIn == rest.start) c.debt,
  ].fold(Duration.zero, (sum, d) => sum + d);
  final next = _nextDebt(rest, taken, debts.unpaid, now);
  if (taken <= Duration.zero && next == null) return null;
  final (:planned, :untilAll) = _plan(rest, taken, next, debts.unpaid, now);
  return RestCompensation(
    taken: taken,
    next: next?.c,
    until: next?.until,
    planned: List.unmodifiable(planned),
    untilAll: untilAll,
  );
}

/// Долг [c] может погасить отдых [rest]: отдых начат после сокращённого
/// (второго из двух подряд) и до срока.
bool _canRepay(Compensation c, OffDutyRest rest) =>
    (c.secondRestStart ?? c.restStart).isBefore(rest.start) &&
    c.dueBy.isAfter(rest.start);

/// Когда отдых [rest], уже погасивший [taken], погасит ещё и [debt]: сейчас
/// [now] плюс то, чего ему не хватает до основы (9 или 45 ч) и долга.
DateTime _repaidAt(
  OffDutyRest rest,
  Duration taken,
  Duration debt,
  DateTime now,
) {
  final load = taken + debt;
  final need = _compensationBase(rest.duration, load) + load;
  return now.add(need - rest.duration);
}

/// Долг из [unpaid], который отдых [rest] погасит следующим, и когда: из
/// тех, что успевает к сроку, — раньше всех, а если не успевает ни один —
/// с самым ранним сроком. null — гасить нечего.
({Compensation c, DateTime until})? _nextDebt(
  OffDutyRest rest,
  Duration taken,
  List<Compensation> unpaid,
  DateTime now,
) {
  ({Compensation c, DateTime until})? next;
  for (final c in unpaid) {
    if (!_canRepay(c, rest)) continue;
    final until = _repaidAt(rest, taken, c.debt, now);
    final inTime = !until.isAfter(c.dueBy);
    final best = next;
    final bestInTime = best != null && !best.until.isAfter(best.c.dueBy);
    final better =
        best == null ||
        (inTime != bestInTime
            ? inTime
            : inTime
            ? until.isBefore(best.until)
            : c.dueBy.isBefore(best.c.dueBy));
    if (better) next = (c: c, until: until);
  }
  return next;
}

/// Вслед за [next] — остальные долги из [unpaid] по сроку: отдых гасит и их,
/// если успевает к сроку каждого и не становится из суточного недельным
/// (тогда вместо 9 ч + долг понадобилось бы 45 ч + долг). Пусто — [next]
/// к сроку не успеть.
({List<Compensation> planned, DateTime? untilAll}) _plan(
  OffDutyRest rest,
  Duration taken,
  ({Compensation c, DateTime until})? next,
  List<Compensation> unpaid,
  DateTime now,
) {
  final planned = <Compensation>[];
  DateTime? untilAll;
  if (next case (:final c, :final until) when !until.isAfter(c.dueBy)) {
    var load = taken + c.debt;
    final base = _compensationBase(rest.duration, load);
    planned.add(c);
    untilAll = until;
    for (final other in unpaid) {
      if (identical(other, c) || !_canRepay(other, rest)) continue;
      final more = load + other.debt;
      if (_compensationBase(rest.duration, more) != base) continue;
      final at = now.add(base + more - rest.duration);
      if (at.isAfter(other.dueBy)) continue;
      load = more;
      planned.add(other);
      untilAll = at;
    }
  }
  return (planned: planned, untilAll: untilAll);
}

/// Сколько отдыха нужно без долга, чтобы сверх этого шла компенсация:
/// недельный отдых (от 24 ч) — 45 ч, остальной — 9 ч (ст. 8(7)). [rest] —
/// сколько отдых длится, [debt] — сколько к нему присоединить: отдых,
/// который вместе с долгом дойдёт до 24 ч, будет недельным.
Duration _compensationBase(Duration rest, Duration debt) =>
    rest >= EuLimits.weeklyRestReduced ||
        EuLimits.compensationAttachedRest + debt >= EuLimits.weeklyRestReduced
    ? EuLimits.weeklyRestRegular
    : EuLimits.compensationAttachedRest;

bool _sameList<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
