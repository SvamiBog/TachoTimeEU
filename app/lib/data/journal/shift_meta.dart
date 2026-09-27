import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';

/// Страны и заметка смены. Движку они не нужны — только журналу и отчёту.
@immutable
class ShiftMeta {
  const new({this.startCountry, this.endCountry, this.note});

  /// Коды тахографа (`TachoCountries`); null — не выбрана.
  final String? startCountry;
  final String? endCountry;
  final String? note;

  static const empty = ShiftMeta();

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

/// Ручная смена из БД: итоги для движка и страны с заметкой.
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
      other.shift.rest == shift.rest &&
      other.shift.splitRest == shift.splitRest;

  @override
  int get hashCode => Object.hash(shift.id, shift.start, shift.end, meta);
}
