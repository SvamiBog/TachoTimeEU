/// Limit sections of the home screen — "Today", "Rest" and "Week" — and their
/// rows. Each row selects only its part of the engine snapshot, in whole
/// minutes, so the clock tick rebuilds only what changed.
library;

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
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/daily_rest_screen.dart';
import 'package:tachogo/features/home/driving_screen.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/work_week_screen.dart';
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

void _openWorkday(BuildContext context) => openWorkdayScreen(context);

void _openBreak(BuildContext context) => openBreakScreen(context);

void _openWeeklyRest(BuildContext context) => openWeeklyRestScreen(context);

// ───────────────────────── Сегодня ─────────────────────────

/// Continuous driving for its row, in whole minutes.
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

/// "Continuous driving": driving since the last break out of 4:30, and when the
/// break is due. Opens the driving screen.
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
      onTap: () => openDrivingScreen(context),
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

/// The workday for its row, in whole minutes.
typedef _Workday = ({
  DateTime? start,
  int value,
  int regular,
  int extended,
  int limit,
  int reducedLeft,
  Tone tone,
});

_Workday _workday(ComplianceSnapshot s) => (
  start: s.shift?.start,
  value: minutes(s.shiftDuration),
  regular: minutes(s.shiftRegularLimit),
  extended: minutes(s.shiftExtendedLimit),
  limit: minutes(s.shiftLimit),
  reducedLeft: s.reducedRestsLeft,
  tone: toneOf(
    s,
    violation: InfringementType.shiftExceeded,
    warning: InfringementType.shiftSoon,
  ),
);

/// Workday: large — what is left until 13 and 15 h and at what time they come;
/// the time worked — small. Drivers plan the day by what is left, not by what
/// they have worked (driver feedback 12.10.2026).
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
      value: StatusValue(
        start == null ? l.workdayNoShift : l.workdayElapsed(formatHm(value)),
      ),
      bar: LimitBar(
        value: value,
        max: extended,
        ticks: [if (regular < extended) regular],
        color: _barColor(context, s.tone, context.colors.text),
      ),
      footer: start == null
          ? null
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, limit) in [regular, extended].indexed) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _WorkdayLeft(
                      limit: limit,
                      elapsed: value,
                      start: start,
                      // Предупреждение движка — о лимите смены: 15 ч,
                      // пока можно сократить отдых, иначе 13 ч
                      tone: limit == _m(s.limit) ? s.tone : Tone.neutral,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

/// What is left of the workday until [limit]: "left until 13 h", "10:40 →
/// 21:00". Past it — "0:00" in grey; the shift limit is in the warning colour.
class _WorkdayLeft extends StatelessWidget {
  const new({
    required this.limit,
    required this.elapsed,
    required this.start,
    required this.tone,
  });

  final Duration limit;
  final Duration elapsed;
  final DateTime start;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    final left = atLeastZero(limit - elapsed);
    final color = switch (tone) {
      Tone.violation => colors.errorText,
      Tone.warning => colors.drive,
      _ => left == Duration.zero ? colors.textSecondary : null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.workdayLeftTo(limit.inHours), style: caption),
        const SizedBox(height: 2),
        Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DurationText(
              formatHm(left),
              spoken: spokenDuration(l, left),
              style: AppTextStyles.value.copyWith(color: color),
            ),
            Text('→ ${formatClock(start.add(limit))}', style: caption),
          ],
        ),
      ],
    );
  }
}

/// Daily driving for its row, in whole minutes.
typedef _Daily = ({int value, int extensionsLeft, Tone tone});

_Daily _daily(ComplianceSnapshot s) => (
  value: minutes(s.dailyDriving),
  extensionsLeft: s.extensionsLeft,
  tone: toneOf(
    s,
    violation: InfringementType.dailyDriveExceeded,
    warning: InfringementType.dailyDriveSoon,
  ),
);

/// "Daily driving": 9 h, 10 h with an extension; opens the driving screen.
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
      // Детали и оттуда — правка вождения за день (экран 7)
      onTap: () => openDrivingScreen(context, DrivingSection.daily),
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

/// The break for its row, in whole minutes.
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

/// "Break": what is taken of 45 min or 15 + 30; opens the break screen.
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

/// "Today": continuous driving, workday, daily driving, break and the "End day"
/// button.
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

/// Daily and weekly rest for the "Rest" section, in whole minutes.
typedef _Rest = ({
  int? daily,
  DateTime? dailyStart,
  int? weekly,
  DateTime? weeklyStart,
  int reducedLeft,
  bool reducedWeekly,
  DateTime? deadline,
  bool compensation,
});

_Rest _rest(ComplianceSnapshot s) {
  // Суточный — и отдых после смены, и отдых внутри неё: пока он короче
  // 9 ч, это перерыв, но водитель видит, сколько ещё до 9 и 11 ч
  final daily = dailyRestOf(s);
  final dailyResting = daily.restStart != null && !daily.weekly;
  return (
    daily: dailyResting ? daily.rest : null,
    dailyStart: dailyResting ? daily.restStart : null,
    weekly: daily.weekly ? daily.rest : null,
    weeklyStart: daily.weekly ? daily.restStart : null,
    reducedLeft: s.reducedRestsLeft,
    reducedWeekly: s.reducedWeeklyRestAvailable,
    deadline: s.weeklyRestDeadline,
    compensation: s.compensation != null || s.restCompensation != null,
  );
}

/// Подписи строки идущего суточного отдыха: ближайшая веха — 9 ч, затем
/// 11 ч. Набрал 11 ч — когда отдых станет недельным: 24 ч (45 ч, если
/// сокращённый недельный недоступен).
(String, String?) _dailyRestCaptions(
  AppLocalizations l,
  int minutes,
  DateTime start, {
  required bool reducedWeekly,
  required String locale,
}) {
  final rest = _m(minutes);
  String until(Duration hours) => l.limitLeftUntil(
    hours.inHours,
    formatHm(atLeastZero(hours - rest)),
    formatClock(start.add(hours)),
  );
  if (rest < EuLimits.dailyRestReduced) {
    return (
      until(EuLimits.dailyRestReduced),
      l.limitUntil(
        EuLimits.dailyRestRegular.inHours,
        formatClock(start.add(EuLimits.dailyRestRegular)),
      ),
    );
  }
  if (rest < EuLimits.dailyRestRegular) {
    return (until(EuLimits.dailyRestRegular), null);
  }
  final weekly = reducedWeekly
      ? EuLimits.weeklyRestReduced
      : EuLimits.weeklyRestRegular;
  return (
    l.dailyRestCaption,
    l.limitUntil(weekly.inHours, formatWeekdayClock(start.add(weekly), locale)),
  );
}

/// Подписи строки идущего недельного отдыха: сколько ещё до 24 ч и 45 ч и
/// когда они наберутся. Отдых длится сутками — время с днём недели.
/// Сокращённый недоступен — сразу 45 ч.
(String, String?) _weeklyRestCaptions(
  AppLocalizations l,
  int minutes,
  DateTime start, {
  required bool reducedWeekly,
  required String locale,
}) {
  final rest = _m(minutes);
  String at(Duration hours) => formatWeekdayClock(start.add(hours), locale);
  String until(Duration hours) => l.limitLeftUntil(
    hours.inHours,
    formatHm(atLeastZero(hours - rest)),
    at(hours),
  );
  const regular = EuLimits.weeklyRestRegular;
  if (reducedWeekly && rest < EuLimits.weeklyRestReduced) {
    return (
      until(EuLimits.weeklyRestReduced),
      l.limitUntil(regular.inHours, at(regular)),
    );
  }
  if (rest < regular) return (until(regular), null);
  return (l.weeklyRestCaption, null);
}

/// "Rest": daily rest with the reduced rests left, weekly rest, compensation
/// and the ferry / train mark.
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
    final locale = context.localeTag;
    final daily = s.daily;
    final dailyStart = s.dailyStart;
    final (dailyLeft, dailyRight) = daily != null && dailyStart != null
        ? _dailyRestCaptions(
            l,
            daily,
            dailyStart,
            reducedWeekly: s.reducedWeekly,
            locale: locale,
          )
        : (l.dailyRestCaption, l.dailyRestSplit);
    final weekly = s.weekly;
    final weeklyStart = s.weeklyStart;
    final (weeklyLeft, weeklyRight) = weekly != null && weeklyStart != null
        ? _weeklyRestCaptions(
            l,
            weekly,
            weeklyStart,
            reducedWeekly: s.reducedWeekly,
            locale: locale,
          )
        : (
            l.weeklyRestCaption,
            deadline == null
                ? l.statusNoData
                : l.statusBy(formatWeekdayClock(deadline, locale)),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.sectionRest),
        CardGroup(
          children: [
            LimitRow(
              title: l.rowDailyRest,
              onTap: () => openDailyRestScreen(context),
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
              left: dailyLeft,
              right: dailyRight,
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
              left: weeklyLeft,
              right: weeklyRight,
              onTap: () => _openWeeklyRest(context),
            ),
            // Долг за сокращённый недельный отдых — только когда он есть
            if (s.compensation) const CompensationRow(),
            const FerryRow(),
          ],
        ),
      ],
    );
  }
}

/// Whether the ferry / train mark is on and can be toggled.
typedef _Ferry = ({bool on, bool canToggle});

_Ferry _ferry(ComplianceSnapshot s) {
  final last = s.timeline.blocks.lastOrNull;
  return (
    on: last != null && last.open && last.ferry,
    canToggle: s.currentMode != null,
  );
}

/// "Ferry / train" (Art. 9): marks the current record and the next ones until
/// the driver turns it off.
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
