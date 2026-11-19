/// The "Week" section of the home screen: weekly and two-week driving and the
/// work week. Each row selects only its part of the engine snapshot, in whole
/// minutes, so the clock tick rebuilds only what changed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/driving_screen.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/work_week_screen.dart';

Duration _m(int minutes) => Duration(minutes: minutes);

/// Weekly and fortnightly driving for their rows, in whole minutes.
typedef _Week = ({
  int weekly,
  int fortnight,
  bool fortnightLimiting,
  Tone weeklyTone,
  Tone fortnightTone,
});

_Week _week(ComplianceSnapshot s) => (
  weekly: minutes(s.weeklyDriving),
  fortnight: minutes(s.fortnightDriving),
  fortnightLimiting: s.fortnightLimiting,
  weeklyTone: toneOf(
    s,
    violation: InfringementType.weeklyDriveExceeded,
    warning: InfringementType.weeklyDriveSoon,
  ),
  fortnightTone: toneOf(
    s,
    violation: InfringementType.fortnightDriveExceeded,
    warning: InfringementType.fortnightDriveSoon,
  ),
);

/// The work week (144 h) for its row, in whole minutes.
typedef _WorkWeek = ({
  DateTime? since,
  DateTime? deadline,
  int value,
  int left,
  Tone tone,
});

_WorkWeek _workWeek(ComplianceSnapshot s) => (
  since: s.workWeekStart,
  deadline: s.weeklyRestDeadline,
  value: minutes(s.workWeekDuration),
  left: minutes(s.workWeekRemaining ?? Duration.zero),
  tone: toneOf(
    s,
    violation: InfringementType.weeklyRestOverdue,
    warning: InfringementType.weeklyRestSoon,
  ),
);

/// "Week": weekly driving, two-week driving and the work week.
class WeekSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.sectionWeek),
        const CardGroup(
          children: [WeeklyDrivingRow(), FortnightRow(), WorkWeekRow()],
        ),
      ],
    );
  }
}

/// "Weekly driving" out of 56 h; opens the driving screen.
class WeeklyDrivingRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _week);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final value = _m(s.weekly);
    const limit = EuLimits.weeklyDriving;
    return LimitRow(
      title: l.rowWeeklyDriving,
      onTap: () => openDrivingScreen(context, DrivingSection.week),
      chip: limitChip(context, s.weeklyTone, soon: l.chipLimitSoon),
      value: limitDuration(context, value, tone: s.weeklyTone),
      bar: LimitBar(
        value: value,
        max: limit,
        color: limitBarColor(context, s.weeklyTone, context.colors.drive),
      ),
      left: l.limitOf(formatHm(limit)),
      right: l.left(formatHm(atLeastZero(limit - value))),
    );
  }
}

/// "Two-week driving" out of 90 h; opens the driving screen.
class FortnightRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _week);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final value = _m(s.fortnight);
    const limit = EuLimits.fortnightDriving;
    final tone = s.fortnightTone;
    return LimitRow(
      title: l.rowFortnightDriving,
      onTap: () => openDrivingScreen(context, DrivingSection.week),
      chip: tone == Tone.neutral && s.fortnightLimiting
          ? StatusChip(l.chipLimiting, tone: Tone.warning)
          : limitChip(context, tone, soon: l.chipLimitSoon),
      value: limitDuration(context, value, tone: tone),
      bar: LimitBar(
        value: value,
        max: limit,
        color: limitBarColor(context, tone, context.colors.drive),
      ),
      left: l.limitOf(formatHm(limit)),
      right: l.left(formatHm(atLeastZero(limit - value))),
    );
  }
}

/// "Work week": time since the end of the last weekly rest out of 144 h; opens
/// the work week screen.
class WorkWeekRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _workWeek);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final locale = context.localeTag;
    const limit = EuLimits.maxBetweenWeeklyRests;
    final since = s.since;
    final deadline = s.deadline;
    final value = _m(s.value);
    return LimitRow(
      title: l.rowWorkWeek,
      onTap: () => openWorkWeekScreen(context),
      chip: limitChip(
        context,
        s.tone,
        soon: l.chipRestSoon,
        normal: l.hoursShort(limit.inHours),
      ),
      value: since == null
          ? const StatusValue('—')
          : limitDuration(context, value, tone: s.tone),
      bar: LimitBar(
        value: since == null ? Duration.zero : value,
        max: limit,
        color: limitBarColor(context, s.tone, context.colors.text),
      ),
      left: since == null
          ? l.workWeekUnknown
          : l.workWeekSince(formatWeekdayDayClock(since, locale)),
      right: since == null || deadline == null
          ? null
          : l.leftUntil(
              formatHm(_m(s.left)),
              formatWeekdayClock(deadline, locale),
            ),
    );
  }
}
