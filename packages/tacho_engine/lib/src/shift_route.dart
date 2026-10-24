/// Countries where a shift started and ended — the engine needs them only to
/// tell whether a rest is taken in the company country.
library;

import 'package:meta/meta.dart';

/// Start and end countries of a shift: tachograph country codes as the driver
/// entered them (Mobility Package). The engine only compares them with the
/// company country (`ComplianceSettings.baseCountry`).
@immutable
class ShiftRoute {
  const new({this.from, this.to});

  /// Страна начала смены; null — не выбрана.
  final String? from;

  /// Страна конца смены; null — ещё не выбрана.
  final String? to;

  /// Где водитель после смены — и на отдыхе после неё: страна конца, а
  /// пока её нет — страна начала.
  String? get last => to ?? from;

  @override
  bool operator ==(Object other) =>
      other is ShiftRoute && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'ShiftRoute(${from ?? '—'} → ${to ?? '—'})';
}
