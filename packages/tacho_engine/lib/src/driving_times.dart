/// Driving times and what is left of each driving limit, for the screens.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/eu_limits.dart';

/// Driving times and what is left of each driving limit: 4:30 without a break
/// (Art. 7), 9 h a day, 10 h with an extension (Art. 6(1)), 56 h a week
/// (Art. 6(2)) and 90 h in two weeks (Art. 6(3)).
///
/// What is left is signed: a negative value is how far the limit is exceeded.
/// The caller passes the times it shows: the home screen passes whole minutes,
/// so what is left agrees with the time on the screen.
@immutable
class DrivingTimes {
  const new({
    this.continuous = Duration.zero,
    this.daily = Duration.zero,
    this.dailyLimit = EuLimits.dailyDriving,
    this.weekly = Duration.zero,
    this.fortnight = Duration.zero,
  });

  /// Непрерывное вождение с прошлого перерыва.
  final Duration continuous;

  /// Вождение за рабочий день.
  final Duration daily;

  /// Лимит дня: 9 ч, а пока на неделе есть продления — 10 ч
  /// (`ComplianceSnapshot.dailyDrivingLimit`).
  final Duration dailyLimit;

  /// Вождение с понедельника.
  final Duration weekly;

  /// Вождение за эту неделю и прошлую.
  final Duration fortnight;

  /// До 4:30 непрерывного вождения.
  Duration get untilBreak => EuLimits.continuousDriving - continuous;

  /// До лимита дня [dailyLimit].
  Duration get untilDailyLimit => dailyLimit - daily;

  /// До 9 ч за день.
  Duration get untilRegularDay => EuLimits.dailyDriving - daily;

  /// До 10 ч за день — с продлением.
  Duration get untilExtendedDay => EuLimits.dailyDrivingExtended - daily;

  /// До 56 ч за неделю.
  Duration get untilWeeklyLimit => EuLimits.weeklyDriving - weekly;

  /// До 90 ч за две недели.
  Duration get untilFortnightLimit => EuLimits.fortnightDriving - fortnight;

  /// Вождение прошлой недели: две недели без этой.
  Duration get previousWeek => fortnight - weekly;
}
