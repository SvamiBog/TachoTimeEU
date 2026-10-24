/// Countries and notes of shifts, which the engine does not need.
library;

import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';

/// Countries and note of a shift. The engine does not need them — only the
/// journal and the report do.
@immutable
class ShiftMeta {
  const new({this.startCountry, this.endCountry, this.note});

  /// Коды тахографа (`TachoCountries`); null — не выбрана.
  final String? startCountry;
  final String? endCountry;
  final String? note;

  static const empty = ShiftMeta();

  /// Страны смены для движка: по ним проверяются два сокращённых отдыха
  /// подряд и считаются рабочие дни.
  ShiftRoute get route => ShiftRoute(from: startCountry, to: endCountry);

  @override
  bool operator ==(Object other) =>
      other is ShiftMeta &&
      other.startCountry == startCountry &&
      other.endCountry == endCountry &&
      other.note == note;

  @override
  int get hashCode => Object.hash(startCountry, endCountry, note);

  @override
  String toString() => 'ShiftMeta($startCountry → $endCountry, $note)';
}

/// A manual shift from the database: totals for the engine plus countries and a
/// note.
@immutable
class ManualShiftRecord {
  const new(this.shift, this.meta);

  final ManualShift shift;
  final ShiftMeta meta;

  @override
  bool operator ==(Object other) =>
      other is ManualShiftRecord &&
      other.meta == meta &&
      other.shift.id == shift.id &&
      other.shift.start == shift.start &&
      other.shift.end == shift.end &&
      other.shift.driving == shift.driving &&
      other.shift.continuousDrivingAtEnd == shift.continuousDrivingAtEnd &&
      other.shift.restKind == shift.restKind &&
      other.shift.splitRest == shift.splitRest;

  @override
  int get hashCode => Object.hash(shift.id, shift.start, shift.end, meta);
}

/// Страны смен для движка по началу смены: из записей режимов
/// ([recorded]) и ручных ([manual]).
Map<DateTime, ShiftRoute> shiftRoutesOf(
  Map<DateTime, ShiftMeta> recorded,
  Iterable<ManualShiftRecord> manual,
) => {
  for (final e in recorded.entries) e.key: e.value.route,
  for (final r in manual) r.shift.start: r.meta.route,
};
