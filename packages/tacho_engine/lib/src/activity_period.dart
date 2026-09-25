import 'package:meta/meta.dart';
import 'package:tacho_engine/src/driver_mode.dart';

/// Непрерывный отрезок времени в одном режиме — запись журнала.
///
/// Время хранится в UTC. Открытый период (текущий режим) имеет [end] == null.
/// Инварианты проверяются всегда, а не через assert: в release-сборке
/// Flutter assert вырезаются, а ошибка во времени ломает все лимиты.
@immutable
class ActivityPeriod {
  new({
    required this.mode,
    required this.start,
    this.end,
    this.id,
    this.ferry = false,
    this.dayEnd = false,
  }) {
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

  /// Идентификатор записи в хранилище; null — запись ещё не сохранена.
  final int? id;
  final DriverMode mode;
  final DateTime start;
  final DateTime? end;

  /// Отрезок записан в режиме «паром / поезд» (ст. 9 Регламента 561/2006).
  final bool ferry;

  /// Отдых начат как конец рабочего дня: пока он идёт, смена считается
  /// завершённой. Если отдых прервали раньше 9 ч, он снова считается
  /// перерывом.
  final bool dayEnd;

  bool get isOpen => end == null;

  /// Длительность периода; для открытого периода — до момента [now].
  Duration durationAt(DateTime now) => (end ?? now).difference(start);

  ActivityPeriod close(DateTime at) => withEnd(at);

  /// Копия с другим концом; null — период снова открыт.
  ActivityPeriod withEnd(DateTime? end) => ActivityPeriod(
    id: id,
    mode: mode,
    start: start,
    end: end,
    ferry: ferry,
    dayEnd: dayEnd,
  );

  ActivityPeriod withStart(DateTime start) => ActivityPeriod(
    id: id,
    mode: mode,
    start: start,
    end: end,
    ferry: ferry,
    dayEnd: dayEnd,
  );

  ActivityPeriod withDayEnd({required bool dayEnd}) => ActivityPeriod(
    id: id,
    mode: mode,
    start: start,
    end: end,
    ferry: ferry,
    dayEnd: dayEnd,
  );

  @override
  bool operator ==(Object other) =>
      other is ActivityPeriod &&
      other.id == id &&
      other.mode == mode &&
      other.start == start &&
      other.end == end &&
      other.ferry == ferry &&
      other.dayEnd == dayEnd;

  @override
  int get hashCode => Object.hash(id, mode, start, end, ferry, dayEnd);

  @override
  String toString() =>
      'ActivityPeriod(${id ?? 'new'}, $mode, '
      '$start → ${end ?? 'now'}'
      '${ferry ? ', паром' : ''}${dayEnd ? ', конец дня' : ''})';
}
