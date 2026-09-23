import 'package:meta/meta.dart';
import 'package:tacho_engine/src/driver_mode.dart';

/// Непрерывный отрезок времени в одном режиме.
///
/// Время хранится в UTC. Открытый период (текущий режим) имеет [end] == null.
@immutable
class ActivityPeriod {
  new({required this.mode, required this.start, this.end})
    : assert(start.isUtc, 'start должен быть в UTC'),
      assert(end == null || end.isUtc, 'end должен быть в UTC'),
      assert(end == null || !end.isBefore(start), 'end раньше start');

  final DriverMode mode;
  final DateTime start;
  final DateTime? end;

  bool get isOpen => end == null;

  /// Длительность периода; для открытого периода — до момента [now].
  Duration durationAt(DateTime now) => (end ?? now).difference(start);

  ActivityPeriod close(DateTime at) =>
      ActivityPeriod(mode: mode, start: start, end: at);

  @override
  bool operator ==(Object other) =>
      other is ActivityPeriod &&
      other.mode == mode &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(mode, start, end);

  @override
  String toString() => 'ActivityPeriod($mode, $start → ${end ?? 'now'})';
}
