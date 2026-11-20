/// "Daily rest" screen: the rest in progress and its milestones, or when to
/// start the rest while the driver works.
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
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';

/// The rest in progress and the shift, in whole minutes: the one-second tick
/// does not rebuild the screen.
typedef DailyRestState = ({
  DateTime now,

  /// Начало идущего отдыха — после смены или внутри неё; null — водитель
  /// не отдыхает.
  DateTime? restStart,
  int rest,

  /// Смена закончилась: отдых от 9 ч или «Завершить день».
  bool offDuty,
  bool weekly,
  DateTime? shiftStart,
  int regular,
  int extended,
  int reducedLeft,
  bool splitFirstPart,
  bool compensation,
  Tone tone,
});

DailyRestState dailyRestOf(ComplianceSnapshot s) {
  final off = s.offDutyRest;
  final inShift = s.shift != null && s.currentMode == DriverMode.rest
      ? s.currentBreak
      : null;
  return (
    now: minuteOf(s.now),
    restStart: off?.start ?? inShift?.start,
    rest: minutes(off?.duration ?? inShift?.duration ?? Duration.zero),
    offDuty: off != null,
    weekly: off?.weekly ?? false,
    shiftStart: s.shiftStart,
    regular: minutes(s.shiftRegularLimit),
    extended: minutes(s.shiftExtendedLimit),
    reducedLeft: s.reducedRestsLeft,
    splitFirstPart: s.splitFirstPart,
    compensation: s.restCompensation != null,
    tone: toneOf(
      s,
      violation: InfringementType.shiftExceeded,
      warning: InfringementType.shiftSoon,
    ),
  );
}

void openDailyRestScreen(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const DailyRestScreen()));

/// "Daily rest": during a rest — how long until 3, 9 and 11 h and at what time
/// each is reached; while the driver works — until when to start a regular and
/// a reduced rest. There is no mockup: built from the components of the
/// "Workday" and "Weekly rest" screens.
class DailyRestScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, dailyRestOf);
    final Widget? bottom = s == null
        ? null
        : s.weekly
        ? SecondaryButton(
            label: l.rowWeeklyRest,
            onPressed: () => openWeeklyRestScreen(context),
          )
        : s.shiftStart != null
        ? PrimaryButton(
            label: l.workdayEndDay,
            color: context.colors.rest,
            onPressed: () => _endDay(context, ref),
          )
        : null;
    return DetailScaffold(
      title: l.rowDailyRest,
      bottom: bottom,
      children: s == null
          ? const []
          : [
              _Summary(s),
              if (!s.weekly) ...[
                SectionTitle(l.dailyRestOptions),
                _Milestones(s),
                if (s.compensation && s.restStart != null) ...[
                  const SizedBox(height: AppSpacing.betweenCardsMin),
                  const CardGroup(children: [CompensationRow()]),
                ],
              ],
              if (s.restStart != null && !s.offDuty)
                InfoNote(l.dailyRestInShift)
              else if (s.offDuty)
                InfoNote(l.heroOffDutyHint),
              InfoNote(l.dailyRestRule),
            ],
    );
  }

  /// «Завершить день»: отдых начинается сейчас (или уже идущий становится
  /// суточным) и завершает смену; водитель вводит вождение за день.
  static Future<void> _endDay(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    if (await finishDay(context, ref)) navigator.pop();
  }
}

/// The summary card: the rest so far, until when to start the rest, or that
/// there is no shift.
class _Summary extends StatelessWidget {
  const new(this.s);

  final DailyRestState s;

  @override
  Widget build(BuildContext context) {
    final restStart = s.restStart;
    final shiftStart = s.shiftStart;
    return HeroCard(
      children: [
        if (restStart != null)
          _RestSoFar(s, restStart: restStart)
        else if (shiftStart != null)
          _StartRestBy(s, shiftStart: shiftStart)
        else
          Text(
            context.l10n.workdayNoShift,
            style: AppTextStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
      ],
    );
  }
}

/// The caption over the big value of the summary card: "DAILY REST".
class _SummaryLabel extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: AppTextStyles.label.copyWith(
      color: context.colors.textSecondary,
      letterSpacing: AppTextStyles.label.fontSize! * 0.08,
    ),
  );
}

/// The rest in progress: how long, out of what, since when and the bar with
/// the 3 and 9 h marks.
class _RestSoFar extends StatelessWidget {
  const new(this.s, {required this.restStart});

  final DailyRestState s;
  final DateTime restStart;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = AppTextStyles.body.copyWith(color: colors.textSecondary);
    final rest = Duration(minutes: s.rest);
    final target = s.weekly
        ? EuLimits.weeklyRestRegular
        : EuLimits.dailyRestRegular;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryLabel(s.weekly ? l.weeklyOngoing : l.dailyRestOngoing),
        const SizedBox(height: AppSpacing.s4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: AppSpacing.s10,
          children: [
            DurationText(
              formatHm(rest),
              spoken: spokenDuration(l, rest),
              style: AppTextStyles.timer.copyWith(color: colors.rest),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s10),
              child: Text(l.ofLimit(formatLimit(l, target)), style: caption),
            ),
          ],
        ),
        Text(l.modeSince(formatClock(restStart)), style: caption),
        const SizedBox(height: AppSpacing.s14),
        LimitBar(
          value: rest,
          max: target,
          ticks: s.weekly
              ? const [EuLimits.weeklyRestReduced]
              : [
                  if (!s.offDuty) EuLimits.dailyRestSplitFirst,
                  EuLimits.dailyRestReduced,
                ],
          color: colors.rest,
        ),
      ],
    );
  }
}

/// While the driver works: until when to start a regular rest, and a reduced
/// one if any are left; past it — how late.
class _StartRestBy extends StatelessWidget {
  const new(this.s, {required this.shiftStart});

  final DailyRestState s;
  final DateTime shiftStart;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = AppTextStyles.body.copyWith(color: colors.textSecondary);
    final regular = shiftStart.add(Duration(minutes: s.regular));
    final extended = shiftStart.add(Duration(minutes: s.extended));
    final late = s.now.isAfter(regular);
    final overdue = s.tone == Tone.violation;
    final reduced = s.reducedLeft > 0 || s.splitFirstPart;
    final latest = reduced ? extended : regular;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryLabel(l.dailyRestStartBy),
        const SizedBox(height: AppSpacing.s4),
        Text(
          formatClock(late ? latest : regular),
          style: AppTextStyles.timer.copyWith(
            color: overdue
                ? colors.errorText
                : late
                ? colors.drive
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          overdue
              ? l.weeklyOverdue(formatHm(s.now.difference(latest)))
              : late
              ? l.dailyRestMilestone(
                  EuLimits.dailyRestReduced.inHours,
                  'reduced',
                )
              : reduced
              ? l.dailyRestReducedBy(
                  EuLimits.dailyRestReduced.inHours,
                  formatClock(extended),
                )
              : l.dailyRestNoReduced,
          style: caption.copyWith(color: overdue ? colors.errorText : null),
        ),
      ],
    );
  }
}

/// Rest milestones: 3 h — the first part of a split rest (while the shift is
/// on), 9 h — reduced, 11 h — regular. During a rest — when each is reached;
/// before it — until when to start.
class _Milestones extends StatelessWidget {
  const new(this.s);

  final DailyRestState s;

  @override
  Widget build(BuildContext context) {
    final restStart = s.restStart;
    final shiftStart = s.shiftStart;
    if (restStart != null) return _RestMilestones(s, restStart: restStart);
    if (shiftStart != null) return _ShiftMilestones(s, shiftStart: shiftStart);
    return _RuleMilestones(s);
  }
}

/// Milestones of the rest in progress: when each is reached and how long is
/// left.
class _RestMilestones extends StatelessWidget {
  const new(this.s, {required this.restStart});

  final DailyRestState s;
  final DateTime restStart;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rest = RestMilestones.daily(Duration(minutes: s.rest));
    final reduced = s.reducedLeft > 0 || s.splitFirstPart;
    final reducedLeft = rest.left(EuLimits.dailyRestReduced);
    return CardGroup(
      children: [
        // Первая часть раздельного — только пока смена идёт: она сама её не
        // завершает, а если первая часть уже взята, этот отдых — вторая
        if (!s.offDuty && !s.splitFirstPart)
          _Reached(
            EuLimits.dailyRestSplitFirst,
            'split',
            rest: rest,
            restStart: restStart,
          ),
        if (reduced || rest.reached(EuLimits.dailyRestReduced))
          _Reached(
            EuLimits.dailyRestReduced,
            'reduced',
            rest: rest,
            restStart: restStart,
            pending: s.splitFirstPart
                ? null
                : l.dailyRestLeftCount(formatHm(reducedLeft), s.reducedLeft),
          )
        else
          MilestoneRow(
            dot: MilestoneDot.muted,
            title: l.dailyRestMilestone(
              EuLimits.dailyRestReduced.inHours,
              'reduced',
            ),
            subtitle: l.dailyRestNoReduced,
            value: formatClock(restStart.add(EuLimits.dailyRestReduced)),
            muted: true,
          ),
        _Reached(
          EuLimits.dailyRestRegular,
          'regular',
          rest: rest,
          restStart: restStart,
        ),
      ],
    );
  }
}

/// A milestone of the rest in progress: reached — a solid dot, not yet — how
/// long is left ([pending] instead, when given); the time it is reached.
class _Reached extends StatelessWidget {
  const new(
    this.hours,
    this.kind, {
    required this.rest,
    required this.restStart,
    this.pending,
  });

  final Duration hours;

  /// Вид отдыха для подписи: split, reduced, regular.
  final String kind;

  /// Идущий отдых и его вехи — из движка.
  final RestMilestones rest;
  final DateTime restStart;
  final String? pending;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reached = rest.reached(hours);
    return MilestoneRow(
      dot: reached ? MilestoneDot.solid : MilestoneDot.ring,
      title: l.dailyRestMilestone(hours.inHours, kind),
      subtitle: reached
          ? (kind == 'split' ? l.dailyRestSplitHint : l.dailyRestReached)
          : pending ?? l.left(formatHm(rest.left(hours))),
      value: formatClock(restStart.add(hours)),
    );
  }
}

/// While the driver works: the latest start of a regular and of a reduced
/// rest.
class _ShiftMilestones extends StatelessWidget {
  const new(this.s, {required this.shiftStart});

  final DailyRestState s;
  final DateTime shiftStart;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reduced = s.reducedLeft > 0 || s.splitFirstPart;
    final regular = shiftStart.add(Duration(minutes: s.regular));
    return CardGroup(
      children: [
        MilestoneRow(
          dot: MilestoneDot.ring,
          title: l.dailyRestMilestone(
            EuLimits.dailyRestRegular.inHours,
            'regular',
          ),
          subtitle: l.dailyRestStartLatest,
          value: formatClock(regular),
          muted: s.now.isAfter(regular),
        ),
        MilestoneRow(
          dot: reduced ? MilestoneDot.ring : MilestoneDot.muted,
          title: l.dailyRestMilestone(
            EuLimits.dailyRestReduced.inHours,
            'reduced',
          ),
          subtitle: s.splitFirstPart
              ? l.dailyRestStartLatest
              : reduced
              ? l.dailyRestStartLatestCount(s.reducedLeft)
              : l.dailyRestNoReduced,
          value: formatClock(shiftStart.add(Duration(minutes: s.extended))),
          muted: !reduced,
        ),
      ],
    );
  }
}

/// No shift and no rest: the regular and the reduced rest and how many reduced
/// rests are left.
class _RuleMilestones extends StatelessWidget {
  const new(this.s);

  final DailyRestState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reduced = s.reducedLeft > 0 || s.splitFirstPart;
    return CardGroup(
      children: [
        MilestoneRow(
          dot: MilestoneDot.ring,
          title: l.dailyRestMilestone(
            EuLimits.dailyRestRegular.inHours,
            'regular',
          ),
          value: formatHm(EuLimits.dailyRestRegular),
        ),
        MilestoneRow(
          dot: reduced ? MilestoneDot.ring : MilestoneDot.muted,
          title: l.dailyRestMilestone(
            EuLimits.dailyRestReduced.inHours,
            'reduced',
          ),
          subtitle: reduced
              ? l.chipTimes(EuLimits.dailyRestReduced.inHours, s.reducedLeft)
              : l.dailyRestNoReduced,
          value: formatHm(EuLimits.dailyRestReduced),
          muted: !reduced,
        ),
      ],
    );
  }
}
