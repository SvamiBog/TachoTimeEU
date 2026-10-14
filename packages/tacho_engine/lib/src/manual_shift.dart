/// Shifts the driver adds as totals, without activity records.
library;

import 'package:meta/meta.dart';

/// Which rest followed a shift.
enum RestKind { none, daily, weekly }

/// A shift added by hand as totals (for example for the days before the app was
/// installed): no activity records, only sums.
///
/// The driver only picks the kind of rest after the shift; the engine works out
/// its length itself — up to the start of the next shift (`manualRests`).
///
/// Countries and notes are not the engine's business; the app stores them.
@immutable
class ManualShift {
  new({
    required this.start,
    required this.end,
    required this.driving,
    this.id,
    this.continuousDrivingAtEnd = Duration.zero,
    this.restKind = RestKind.none,
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
  }

  /// Идентификатор в хранилище; null — ещё не сохранена.
  final int? id;
  final DateTime start;

  /// null — смена ещё идёт, отдых не начат.
  final DateTime? end;
  final Duration driving;
  final Duration continuousDrivingAtEnd;

  /// Вид отдыха после смены; [RestKind.none] — отдых не начат.
  final RestKind restKind;

  /// Отдых раздельный: в смене была первая часть 3 ч.
  final bool splitRest;
}
