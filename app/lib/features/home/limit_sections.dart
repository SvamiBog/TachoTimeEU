import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/corrections.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';

Duration _m(int minutes) => Duration(minutes: minutes);

DurationValue _duration(
  BuildContext context,
  Duration d, {
  Tone tone = Tone.neutral,
  Color? color,
}) => DurationValue(
  formatHm(d),
  spoken: spokenDuration(context.l10n, d),
  color: tone == Tone.violation ? context.colors.errorText : color,
);

/// Чип строки: при «скоро» и «превышено» — вместо обычного.
StatusChip? _chip(
  BuildContext context,
  Tone tone, {
  required String soon,
  String? normal,
}) => switch (tone) {
  Tone.violation => StatusChip(context.l10n.chipExceeded, tone: Tone.violation),
  Tone.warning => StatusChip(soon, tone: Tone.warning),
  _ => normal == null ? null : StatusChip(normal),
};

Color _barColor(BuildContext context, Tone tone, Color normal) =>
    tone == Tone.violation ? context.colors.errorText : normal;

void _openWorkday(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const WorkdayScreen()));

void _openBreak(BuildContext context) => openBreakScreen(context);

void _openWeeklyRest(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const WeeklyRestScreen()));

// ───────────────────────── Сегодня ─────────────────────────

typedef _Continuous = ({int value, bool driving, DateTime breakAt, Tone tone});

_Continuous _continuous(ComplianceSnapshot s) => (
  value: minutes(s.continuousDriving),
  driving: s.currentMode == DriverMode.driving,
  breakAt: minuteOf(s.now.add(s.drivingUntilBreak)),
  tone: toneOf(
    s,
    violation: InfringementType.continuousExceeded,
    warning: InfringementType.breakSoon,
  ),
);

class ContinuousRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _continuous);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final colors = context.colors;
    final value = _m(s.value);
    final left = EuLimits.continuousDriving - value;
    return LimitRow(
      title: l.rowContinuous,
      onTap: () => _openBreak(context),
      chip: _chip(context, s.tone, soon: l.chipBreakSoon),
      value: _duration(
        context,
        value,
        tone: s.tone,
        color: s.tone == Tone.warning ? colors.drive : null,
      ),
      bar: LimitBar(
        value: value,
        max: EuLimits.continuousDriving,
        color: _barColor(context, s.tone, colors.drive),
      ),
      left: l.limitOf(formatHm(EuLimits.continuousDriving)),
      right: s.driving && left > Duration.zero
          ? l.leftUntil(formatHm(left), formatClock(s.breakAt))
          : null,
    );
  }
}

typedef _Workday = ({
  DateTime? start,
  int value,
  int regular,
  int extended,
  int reducedLeft,
  Tone tone,
});

_Workday _workday(ComplianceSnapshot s) => (
  start: s.shift?.start,
  value: minutes(s.shiftDuration),
  regular: minutes(s.shiftRegularLimit),
  extended: minutes(s.shiftExtendedLimit),
  reducedLeft: s.reducedRestsLeft,
  tone: toneOf(
    s,
    violation: InfringementType.shiftExceeded,
    warning: InfringementType.shiftSoon,
  ),
);

class WorkdayRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _workday);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final value = _m(s.value);
    final regular = _m(s.regular);
    final extended = _m(s.extended);
    final start = s.start;
    return LimitRow(
      title: l.rowWorkday,
      onTap: () => _openWorkday(context),
      chip: _chip(
        context,
        s.tone,
        soon: l.chipShiftSoon,
        normal: l.chipTimes(extended.inHours, s.reducedLeft),
      ),
      value: _duration(context, value, tone: s.tone),
      bar: LimitBar(
        value: value,
        max: extended,
        ticks: [if (regular < extended) regular],
        color: _barColor(context, s.tone, context.colors.text),
      ),
      left: start == null
          ? l.workdayNoShift
          : l.limitLeftUntil(
              regular.inHours,
              formatHm(atLeastZero(regular - value)),
              formatClock(start.add(regular)),
            ),
      right: start == null
          ? null
          : l.limitUntil(extended.inHours, formatClock(start.add(extended))),
    );
  }
}

typedef _Daily = ({int value, int extensionsLeft, Tone tone, bool shift});

_Daily _daily(ComplianceSnapshot s) => (
  shift: s.shift != null,
  value: minutes(s.dailyDriving),
  extensionsLeft: s.extensionsLeft,
  tone: toneOf(
    s,
    violation: InfringementType.dailyDriveExceeded,
    warning: InfringementType.dailyDriveSoon,
  ),
);

class DailyDrivingRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _daily);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final value = _m(s.value);
    const regular = EuLimits.dailyDriving;
    const extended = EuLimits.dailyDrivingExtended;
    return LimitRow(
      title: l.rowDailyDriving,
      // Корректировка — правка журнала (экран 7)
      onTap: s.shift
          ? () => unawaited(openDrivingCorrection(context, ref))
          : null,
      chip: _chip(
        context,
        s.tone,
        soon: l.chipLimitSoon,
        normal: l.chipTimes(extended.inHours, s.extensionsLeft),
      ),
      value: _duration(context, value, tone: s.tone),
      bar: LimitBar(
        value: value,
        max: extended,
        ticks: const [regular],
        color: _barColor(context, s.tone, context.colors.drive),
      ),
      left: l.limitLeft(
        regular.inHours,
        formatHm(atLeastZero(regular - value)),
      ),
      right: s.extensionsLeft > 0
          ? l.limitLeft(
              extended.inHours,
              formatHm(atLeastZero(extended - value)),
            )
          : null,
    );
  }
}

typedef _Break = ({
  int taken,
  bool split,
  bool counted,
  int? current,
  int? required,
  int? firstPart,
  DateTime? firstAt,
});

_Break _break(ComplianceSnapshot s) {
  final first = s.breakFirstPart;
  final current = s.currentBreak;
  final secondPart = current?.required == EuLimits.breakSplitSecond;
  final taken = current == null
      ? first?.duration ?? Duration.zero
      : (secondPart ? first?.duration ?? Duration.zero : Duration.zero) +
            current.duration;
  return (
    taken: minutes(taken),
    split: first != null || secondPart,
    counted:
        s.shift != null &&
        current != null &&
        s.continuousDriving == Duration.zero,
    current: current == null ? null : minutes(current.duration),
    required: current == null ? null : minutes(current.required),
    firstPart: first == null ? null : minutes(first.duration),
    firstAt: first?.start,
  );
}

class BreakRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _break);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final colors = context.colors;
    final taken = _m(s.taken);
    final (current, required) = (s.current, s.required);
    final (first, firstAt) = (s.firstPart, s.firstAt);
    final (String left, String? right) = current != null && required != null
        ? (l.breakResting(formatHm(_m(current)), required), null)
        : first != null && firstAt != null
        ? (
            l.breakTaken(first, formatClock(firstAt)),
            l.breakStillNeeded(EuLimits.breakSplitSecond.inMinutes),
          )
        : (l.breakNotTaken, null);
    return LimitRow(
      title: l.rowBreak,
      onTap: () => _openBreak(context),
      chip: s.split ? const StatusChip('15 + 30') : null,
      value: _duration(context, taken, color: s.counted ? colors.rest : null),
      bar: LimitBar(
        value: taken,
        max: EuLimits.breakFull,
        ticks: const [EuLimits.breakSplitFirst],
        color: colors.rest,
      ),
      left: left,
      right: right,
    );
  }
}

class TodaySection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionTitle(context.l10n.sectionToday),
      const CardGroup(
        children: [
          ContinuousRow(),
          WorkdayRow(),
          DailyDrivingRow(),
          BreakRow(),
        ],
      ),
      // В конце дня — вождение за день итогом
      const EndDayButton(),
    ],
  );
}

// ───────────────────────── Отдых ─────────────────────────

typedef _Rest = ({
  int? daily,
  int? weekly,
  int reducedLeft,
  bool reducedWeekly,
  DateTime? deadline,
});

_Rest _rest(ComplianceSnapshot s) {
  final rest = s.offDutyRest;
  return (
    daily: rest != null && !rest.weekly ? minutes(rest.duration) : null,
    weekly: rest != null && rest.weekly ? minutes(rest.duration) : null,
    reducedLeft: s.reducedRestsLeft,
    reducedWeekly: s.reducedWeeklyRestAvailable,
    deadline: s.weeklyRestDeadline,
  );
}

class RestSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _rest);
    if (s == null) return const SizedBox.shrink();
    final deadline = s.deadline;
    final l = context.l10n;
    final colors = context.colors;
    StatusValue status(int? minutes) => StatusValue(
      minutes == null
          ? l.statusNotStarted
          : l.statusInProgress(formatHm(_m(minutes))),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.sectionRest),
        CardGroup(
          children: [
            LimitRow(
              title: l.rowDailyRest,
              onTap: () => _openWorkday(context),
              chip: StatusChip(
                l.chipTimes(EuLimits.dailyRestReduced.inHours, s.reducedLeft),
              ),
              value: status(s.daily),
              bar: LimitBar(
                value: _m(s.daily ?? 0),
                max: EuLimits.dailyRestRegular,
                ticks: const [
                  EuLimits.dailyRestSplitFirst,
                  EuLimits.dailyRestReduced,
                ],
                color: colors.rest,
              ),
              left: l.dailyRestCaption,
              right: l.dailyRestSplit,
            ),
            LimitRow(
              title: l.rowWeeklyRest,
              chip: StatusChip(
                s.reducedWeekly
                    ? l.chipReducedAvailable
                    : l.chipReducedUnavailable,
              ),
              value: status(s.weekly),
              bar: LimitBar(
                value: _m(s.weekly ?? 0),
                max: EuLimits.weeklyRestRegular,
                ticks: const [EuLimits.weeklyRestReduced],
                color: colors.rest,
              ),
              left: l.weeklyRestCaption,
              right: s.weekly != null
                  ? null
                  : deadline == null
                  ? l.statusNoData
                  : l.statusBy(formatWeekdayClock(deadline, context.localeTag)),
              onTap: () => _openWeeklyRest(context),
            ),
            const FerryRow(),
          ],
        ),
      ],
    );
  }
}

typedef _Ferry = ({bool on, bool canToggle});

_Ferry _ferry(ComplianceSnapshot s) {
  final last = s.timeline.blocks.lastOrNull;
  return (
    on: last != null && last.open && last.ferry,
    canToggle: s.currentMode != null,
  );
}

/// «Паром / поезд» (ст. 9): отметка текущей записи и следующих, пока
/// водитель не выключит.
class FerryRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _ferry);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.cardPadding,
          12,
          AppSpacing.cardPadding - 4,
          12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.ferryTitle, style: AppTextStyles.rowTitle),
                  const SizedBox(height: 2),
                  Text(
                    l.ferryHint,
                    style: AppTextStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: s.on,
              onChanged: s.canToggle
                  ? (on) => unawaited(
                      ref.read(activityRepositoryProvider).setFerryMode(on: on),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Неделя ─────────────────────────

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
      chip: _chip(context, s.weeklyTone, soon: l.chipLimitSoon),
      value: _duration(context, value, tone: s.weeklyTone),
      bar: LimitBar(
        value: value,
        max: limit,
        color: _barColor(context, s.weeklyTone, context.colors.drive),
      ),
      left: l.limitOf(formatHm(limit)),
      right: l.left(formatHm(atLeastZero(limit - value))),
    );
  }
}

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
      chip: tone == Tone.neutral && s.fortnightLimiting
          ? StatusChip(l.chipLimiting, tone: Tone.warning)
          : _chip(context, tone, soon: l.chipLimitSoon),
      value: _duration(context, value, tone: tone),
      bar: LimitBar(
        value: value,
        max: limit,
        color: _barColor(context, tone, context.colors.drive),
      ),
      left: l.limitOf(formatHm(limit)),
      right: l.left(formatHm(atLeastZero(limit - value))),
    );
  }
}

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
      onTap: () => _openWeeklyRest(context),
      chip: _chip(
        context,
        s.tone,
        soon: l.chipRestSoon,
        normal: l.hoursShort(limit.inHours),
      ),
      value: since == null
          ? const StatusValue('—')
          : _duration(context, value, tone: s.tone),
      bar: LimitBar(
        value: since == null ? Duration.zero : value,
        max: limit,
        color: _barColor(context, s.tone, context.colors.text),
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
