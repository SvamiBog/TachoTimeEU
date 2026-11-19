/// What the shift form logic (screen 11) answers: the hint above the form,
/// the save decision with the write or the reason it is refused, the rest
/// preview and the limits of the day's driving. Pure Dart, like `ShiftForm`.
library;

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/shift_meta.dart';

/// The rest after the shift as the journal will count it.
typedef RestPreview = ({
  RestKind kind,
  Duration duration,
  DateTime? end,
  bool ongoing,
  RestStatus? status,
});

/// Limits of the day's driving in the duration sheet, and whether the row
/// opens the sheet at all.
typedef DrivingLimits = ({Duration min, Duration? max, bool editable});

/// Why the form cannot be saved or the rest cannot be chosen.
enum ShiftFormError {
  /// Страна начала не выбрана.
  startCountry,

  /// Отдых после смены выбран, а страна конца — нет.
  endCountry,

  /// Конец смены не позже начала.
  endBeforeStart,

  /// Время смены в будущем.
  future,

  /// Смена длиннее [maxManualShiftSpan].
  tooLong,

  /// Вождения больше, чем длится смена.
  drivingTooLong,

  /// Непрерывного вождения больше, чем вождения за день.
  continuousTooLong,

  /// Смена пересекается с другой ([ShiftSaveRefused.conflict]).
  overlap,

  /// После смены есть другая, а идти может только последняя.
  notLast;

  /// Ошибка проверки движка `checkManualShift`.
  static ShiftFormError of(ShiftEditError error) => switch (error) {
    ShiftEditError.endBeforeStart => endBeforeStart,
    ShiftEditError.future => future,
    ShiftEditError.tooLong => tooLong,
    ShiftEditError.drivingTooLong => drivingTooLong,
    ShiftEditError.continuousTooLong => continuousTooLong,
    ShiftEditError.overlap => overlap,
    ShiftEditError.notLast => notLast,
  };
}

/// The hint above the form: how this shift is edited and saved.
sealed class ShiftHint {
  const new();
}

/// A shift from the activity records: edits move the records.
final class LiveEditHint extends ShiftHint {
  const new();
}

/// The rest after the shift is cancelled: the shift goes on.
final class ResumeHint extends ShiftHint {
  const new();
}

/// The ongoing shift ends at [at], then the rest starts.
final class EndNowHint extends ShiftHint {
  const new(this.at);

  final DateTime at;
}

/// Moving the records cannot give this driving: the shift is saved as a
/// manual one with the total, like "End the day" on the home screen.
final class LiveToManualHint extends ShiftHint {
  const new();
}

/// A shift without records goes on now: it becomes the current one from
/// [start], in [mode].
final class BecomesCurrentHint extends ShiftHint {
  const new({required this.start, required this.mode});

  final DateTime start;
  final DriverMode mode;
}

/// A shift from the records with changed times is saved as a manual one.
final class ToManualHint extends ShiftHint {
  const new();
}

/// What saving the form does: refuses with a reason or writes the shift.
sealed class ShiftSave {
  const new();
}

/// The form cannot be saved: [error], and for an overlap or a later shift —
/// the [conflict].
final class ShiftSaveRefused extends ShiftSave {
  const new(this.error, {this.conflict});

  final ShiftFormError error;
  final JournalShift? conflict;
}

/// A write to the journal with the countries and note of the shift.
sealed class ShiftWrite extends ShiftSave {
  const new(this.meta);

  final ShiftMeta meta;
}

/// An edit of the activity records of the "live" shift.
final class LiveShiftWrite extends ShiftWrite {
  const new(this.edit, super.meta);

  final LiveShiftEdit edit;
}

/// Countries and note only: the times of a recorded shift stay.
final class MetaShiftWrite extends ShiftWrite {
  const new(this.shiftStart, super.meta);

  final DateTime shiftStart;
}

/// A shift without records goes on now and becomes the current one,
/// [replacing] the edited shift.
final class OngoingShiftWrite extends ShiftWrite {
  const new(this.shift, super.meta, {this.replacing});

  final ManualShift shift;
  final JournalShift? replacing;
}

/// A recorded shift [from] with changed times becomes the manual [shift].
final class ConvertShiftWrite extends ShiftWrite {
  const new(this.from, this.shift, super.meta);

  final JournalShift from;
  final ManualShift shift;
}

/// A new or changed manual shift.
final class ManualShiftWrite extends ShiftWrite {
  const new(this.shift, super.meta);

  final ManualShift shift;
}
