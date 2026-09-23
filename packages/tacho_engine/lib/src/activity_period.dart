import 'package:meta/meta.dart';
import 'package:tacho_engine/src/driver_mode.dart';

/// Непрерывный отрезок времени в одном режиме.
///
/// Время хранится в UTC. Открытый период (текущий режим) имеет [end] == null.
/// Инварианты проверяются всегда, а не через assert: в release-сборке
/// Flutter assert вырезаются, а ошибка во времени ломает все лимиты.
@immutable
class ActivityPeriod {
  new({required this.mode, required this.start, this.end}) {
    if (!start.isUtc) {
      throw ArgumentError.value(start, 'start', 'должно быть в UTC');
    }
    final end = this.end;
    if (end != null) {
      if (!end.isUtc) {
        throw ArgumentError.value(end, 'end', 'должно быть в UTC');
      }
      if (end.isBefore(start)) {
        throw ArgumentError.value(end, 'end', 'раньше start ($start)');
      }
    }
  }

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
