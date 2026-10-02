import 'package:meta/meta.dart';
import 'package:tacho_engine/src/bans/ban_rule.dart';
import 'package:tacho_engine/src/bans/vehicle_mass.dart';

/// Запрет движения во времени, UTC. Соседние и пересекающиеся запреты
/// одной силы склеены: «с 22:00 субботы до 22:00 воскресенья» у
/// праздника в понедельник продолжается до 22:00 понедельника.
@immutable
class BanWindow {
  const new({
    required this.start,
    required this.end,
    required this.kinds,
    required this.scope,
    this.provisional = false,
  });

  final DateTime start;
  final DateTime end;

  /// Откуда запрет: выходные, праздник, ночь...
  final Set<BanKind> kinds;

  /// Где: у склеенного запрета — самая широкая из областей.
  final BanScope scope;

  /// Позже известного годового календаря страны: только постоянные
  /// правила, в календаре могут появиться дни.
  final bool provisional;

  bool contains(DateTime at) => !at.isBefore(start) && at.isBefore(end);

  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) =>
      other is BanWindow &&
      other.start == start &&
      other.end == end &&
      other.scope == scope &&
      other.provisional == provisional &&
      other.kinds.length == kinds.length &&
      other.kinds.containsAll(kinds);

  @override
  int get hashCode => Object.hash(
    start,
    end,
    scope,
    provisional,
    Object.hashAllUnordered(kinds),
  );

  @override
  String toString() =>
      'BanWindow($start → $end, ${scope.name}, '
      '${kinds.map((k) => k.name).join('+')}'
      '${provisional ? ', предварительно' : ''})';
}

/// Запреты страны [country] для машины [mass], которые пересекают
/// [from, to): время по местным правилам страны, переведённое в UTC.
/// Запреты по всей сети ([BanScope.definite]) склеиваются друг с другом,
/// остальные — с запретами той же области; частичный запрет внутри
/// полного не показывается.
List<BanWindow> banWindows(
  CountryBans country,
  VehicleMass mass,
  DateTime from,
  DateTime to,
) {
  final rules = [
    for (final r in country.rules)
      if (mass.heavierThan(r.overTonnes)) r,
  ];
  if (rules.isEmpty || !to.isAfter(from)) return const [];
  final zone = country.zone;
  final firstDay = _dateOf(zone.toLocal(from)).subtract(_days2);
  final lastDay = _dateOf(zone.toLocal(to)).add(_days2);
  final until = country.calendarUntil?.date;

  final raw = <_Raw>[];
  for (
    var day = firstDay;
    !day.isAfter(lastDay);
    day = DateTime.utc(day.year, day.month, day.day + 1)
  ) {
    for (final r in rules) {
      if (!r.appliesOn(day)) continue;
      final start = zone.toUtc(r.from.on(day));
      final end = zone.toUtc(r.to.on(day));
      if (!end.isAfter(start) || !end.isAfter(from) || !start.isBefore(to)) {
        continue;
      }
      raw.add(
        _Raw(
          start,
          end,
          r.kind,
          r.scope,
          provisional: until != null && day.isAfter(until),
        ),
      );
    }
  }

  final definite = _merge([
    for (final w in raw)
      if (w.scope.definite) w,
  ]);
  final partial = <BanWindow>[];
  for (final scope in BanScope.values.where((s) => !s.definite)) {
    for (final w in _merge([
      for (final r in raw)
        if (r.scope == scope) r,
    ])) {
      final covered = definite.any(
        (d) => !d.start.isAfter(w.start) && !d.end.isBefore(w.end),
      );
      if (!covered) partial.add(w);
    }
  }
  return [...definite, ...partial]..sort((a, b) {
    final byStart = a.start.compareTo(b.start);
    return byStart != 0 ? byStart : a.scope.index.compareTo(b.scope.index);
  });
}

/// Что с запретом сейчас.
enum BanLevel {
  /// Запрет по всей сети дорог идёт.
  active,

  /// Начнётся скоро ([banStatus], `soon`).
  soon,

  /// Идёт запрет на части дорог, в части регионов или не для всех машин.
  partial,

  /// Сейчас и в ближайшее время запрета нет.
  clear,

  /// Запреты только на отдельных дорогах — время не считается.
  someRoads,

  /// Для этой машины запретов нет.
  none,
}

/// Состояние запретов страны в момент расчёта ([banStatus]).
@immutable
class BanStatus {
  const new({required this.level, this.current, this.partial, this.next});

  final BanLevel level;

  /// Идущий запрет по всей сети.
  final BanWindow? current;

  /// Идущий частичный запрет.
  final BanWindow? partial;

  /// Ближайший запрет по всей сети впереди (в пределах недели).
  final BanWindow? next;
}

/// Сейчас — [BanLevel.active], [BanLevel.soon] (полный запрет начнётся в
/// пределах [soon]), [BanLevel.partial] или [BanLevel.clear]. Ближайший
/// запрет ищется на 8 дней вперёд.
BanStatus banStatus(
  CountryBans country,
  VehicleMass mass,
  DateTime now, {
  Duration soon = const Duration(hours: 3),
}) {
  switch (country.coverage) {
    case BanCoverage.none:
      return const BanStatus(level: BanLevel.none);
    case BanCoverage.someRoads:
      return const BanStatus(level: BanLevel.someRoads);
    case BanCoverage.rules:
      break;
  }
  if (!country.rules.any((r) => mass.heavierThan(r.overTonnes))) {
    return const BanStatus(level: BanLevel.none);
  }
  final windows = banWindows(
    country,
    mass,
    now.subtract(const Duration(days: 1)),
    now.add(const Duration(days: 8)),
  );
  BanWindow? current;
  BanWindow? partial;
  BanWindow? next;
  for (final w in windows) {
    if (w.scope.definite) {
      if (w.contains(now)) {
        current = w;
      } else if (w.start.isAfter(now)) {
        next ??= w;
      }
    } else if (w.contains(now)) {
      partial ??= w;
    }
  }
  final level = current != null
      ? BanLevel.active
      : next != null && !next.start.isAfter(now.add(soon))
      ? BanLevel.soon
      : partial != null
      ? BanLevel.partial
      : BanLevel.clear;
  return BanStatus(
    level: level,
    current: current,
    partial: partial,
    next: next,
  );
}

const _days2 = Duration(days: 2);

DateTime _dateOf(DateTime local) =>
    DateTime.utc(local.year, local.month, local.day);

class _Raw {
  new(this.start, this.end, this.kind, this.scope, {required this.provisional});

  final DateTime start;
  final DateTime end;
  final BanKind kind;
  final BanScope scope;
  final bool provisional;
}

/// Склеивает пересекающиеся и соседние отрезки.
List<BanWindow> _merge(List<_Raw> windows) {
  if (windows.isEmpty) return const [];
  windows.sort((a, b) => a.start.compareTo(b.start));
  final result = <BanWindow>[];
  var start = windows.first.start;
  var end = windows.first.end;
  var kinds = <BanKind>{windows.first.kind};
  var scope = windows.first.scope;
  var provisional = windows.first.provisional;
  void flush() => result.add(
    BanWindow(
      start: start,
      end: end,
      kinds: kinds,
      scope: scope,
      provisional: provisional,
    ),
  );
  for (final w in windows.skip(1)) {
    if (w.start.isAfter(end)) {
      flush();
      start = w.start;
      end = w.end;
      kinds = {w.kind};
      scope = w.scope;
      provisional = w.provisional;
      continue;
    }
    if (w.end.isAfter(end)) end = w.end;
    kinds.add(w.kind);
    if (w.scope.index < scope.index) scope = w.scope;
    provisional = provisional || w.provisional;
  }
  flush();
  return result;
}
