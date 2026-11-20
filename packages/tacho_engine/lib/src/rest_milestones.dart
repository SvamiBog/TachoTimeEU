/// Milestones of a rest in progress for the screens: which one comes next, how
/// long until each, and from what length the rest can be a weekly one.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/time.dart';

/// The milestones a rest of [rest] reaches: a daily rest — 9 h (reduced), then
/// 11 h (regular) (Art. 8(2)); a weekly rest — 24 h (reduced, when one may be
/// taken), then 45 h (regular) (Art. 8(6)).
///
/// The caller passes the length it shows: the home screen passes whole
/// minutes, so what is left agrees with the time on the screen.
@immutable
class RestMilestones {
  /// Суточный отдых: 9 ч, затем 11 ч.
  const new daily(this.rest)
    : all = const [EuLimits.dailyRestReduced, EuLimits.dailyRestRegular];

  /// Недельный отдых: 24 ч, если сокращённый можно взять
  /// (`ComplianceSnapshot.reducedWeeklyRestAvailable`), затем 45 ч.
  new weekly(this.rest, {required bool reducedAvailable})
    : all = List.unmodifiable([
        if (reducedAvailable) EuLimits.weeklyRestReduced,
        EuLimits.weeklyRestRegular,
      ]);

  /// Сколько отдых уже длится.
  final Duration rest;

  /// Вехи по порядку.
  final List<Duration> all;

  /// Самый короткий отдых этого вида: суточный — 9 ч, недельный — 24 ч,
  /// а если сокращённый нельзя — 45 ч.
  Duration get shortest => all.first;

  /// Ближайшая ненабранная веха; null — набраны все.
  Duration? get next => _ahead.firstOrNull;

  /// Веха после [next]; null — [next] последняя или набраны все.
  Duration? get afterNext => _ahead.skip(1).firstOrNull;

  /// Веха [milestone] набрана.
  bool reached(Duration milestone) => rest >= milestone;

  /// Сколько ещё до вехи [milestone]; ноль — набрана.
  Duration left(Duration milestone) => clampToZero(milestone - rest);

  /// Ненабранные вехи по порядку: вехи растут, поэтому это хвост [all].
  Iterable<Duration> get _ahead => all.where((m) => !reached(m));
}
