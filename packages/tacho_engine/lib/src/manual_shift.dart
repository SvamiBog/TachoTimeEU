import 'package:meta/meta.dart';

/// Какой отдых был после смены.
enum RestKind { none, daily, weekly }

/// Смена, добавленная вручную итогами (например, за дни до установки
/// приложения): без записей режимов, только суммы.
///
/// Страны и заметки движку не нужны — они хранятся в приложении.
@immutable
class ManualShift {
  new({
    required this.start,
    required this.end,
    required this.driving,
    this.id,
    this.continuousDrivingAtEnd = Duration.zero,
    this.restKind = RestKind.none,
    this.rest = Duration.zero,
    this.splitRest = false,
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
    if (driving.isNegative) {
      throw ArgumentError.value(driving, 'driving', 'отрицательное');
    }
    if (rest.isNegative) {
      throw ArgumentError.value(rest, 'rest', 'отрицательный');
    }
  }

  /// Идентификатор в хранилище; null — ещё не сохранена.
  final int? id;
  final DateTime start;

  /// null — смена ещё идёт, отдых не начат.
  final DateTime? end;
  final Duration driving;
  final Duration continuousDrivingAtEnd;
  final RestKind restKind;

  /// Длительность отдыха после смены.
  final Duration rest;

  /// Отдых раздельный: в смене была первая часть 3 ч.
  final bool splitRest;

  /// Конец отдыха после смены, если он записан.
  DateTime? get restEnd {
    final end = this.end;
    return end == null || restKind == RestKind.none ? null : end.add(rest);
  }
}
