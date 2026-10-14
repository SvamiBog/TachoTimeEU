/// TachoGo regulatory engine: EU Regulation 561/2006 and AETR driving and rest
/// time rules in pure Dart, without Flutter.
///
/// Feed it the driver's activity log (`ActivityPeriod`s in UTC) and it returns
/// what is left of every limit, the infringements and the warnings
/// (`ComplianceSnapshot`), the journal by weeks and shifts (`Journal`), the
/// forecast of when limits run out (`forecastAlerts`), automatic driving
/// detection from GPS speed (`MotionDetector`) and the edits a driver may make
/// to the log. Rules and sources: `docs/domain/eu-561-rules.md`.
library;

export 'src/activity_period.dart';
export 'src/auto_switch.dart';
export 'src/compliance.dart';
export 'src/driver_mode.dart';
export 'src/eu_limits.dart';
export 'src/forecast.dart';
export 'src/infringement.dart';
export 'src/journal.dart';
export 'src/journal_edits.dart';
export 'src/manual_rest.dart';
export 'src/manual_shift.dart';
export 'src/scope.dart';
export 'src/shift_edits.dart';
export 'src/shifts.dart';
export 'src/time.dart'
    show durationBetween, floorTimeToMinute, floorToMinute, week, weekStartUtc;
export 'src/timeline.dart';
