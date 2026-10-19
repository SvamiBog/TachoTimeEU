/// Screen 9 "Weekly rest".
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
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

/// The last weekly rest, in whole minutes.
typedef _Last = ({
  DateTime start,
  DateTime? end,
  int duration,
  RestStatus status,
});

/// Everything the weekly rest screen shows, in whole minutes.
typedef _Weekly = ({
  DateTime? deadline,
  int left,
  int overdue,
  int? onWeekly,
  DateTime? onWeeklyStart,
  bool reducedAvailable,
  _Last? last,

  /// Непогашенные долги по сроку: после двух сокращённых подряд — два.
  ValueList<Compensation> debts,

  /// Долг за два последних недельных отдыха, если оба сокращённые: его
  /// берут перед следующим недельным отдыхом (ст. 8(6)); null — не два
  /// сокращённых подряд или долг за них погашен.
  int? twoReducedDebt,
  bool restCompensation,
});

_Weekly _weekly(ComplianceSnapshot s) {
  final deadline = s.weeklyRestDeadline;
  final rest = s.offDutyRest;
  final onWeekly = rest != null && rest.weekly ? rest : null;
  final last = s.lastWeeklyRest;
  final previous = s.previousWeeklyRest;
  final twoReduced =
      last != null &&
      previous != null &&
      last.status == RestStatus.reduced &&
      previous.status == RestStatus.reduced;
  final twoReducedDebt = !twoReduced
      ? Duration.zero
      : s.unpaidCompensations
            .where(
              (c) => c.restStart == last.start || c.restStart == previous.start,
            )
            .fold(Duration.zero, (sum, c) => sum + c.debt);
  return (
    deadline: deadline,
    left: minutes(s.workWeekRemaining ?? Duration.zero),
    overdue: deadline == null || !s.now.isAfter(deadline)
        ? 0
        : minutes(s.now.difference(deadline)),
    onWeekly: onWeekly == null ? null : minutes(onWeekly.duration),
    onWeeklyStart: onWeekly?.start,
    reducedAvailable: s.reducedWeeklyRestAvailable,
    last: last == null
        ? null
        : (
            start: last.start,
            end: last.end,
            duration: minutes(last.duration),
            status: last.status,
          ),
    debts: ValueList(s.unpaidCompensations),
    twoReducedDebt: twoReducedDebt > Duration.zero
        ? minutes(twoReducedDebt)
        : null,
    restCompensation: s.restCompensation != null,
  );
}

void openWeeklyRestScreen(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const WeeklyRestScreen()));

/// Screen 9 "Weekly rest": the 144 h deadline, regular 45 h and reduced 24 h
/// (during the rest — how long until each), the previous rest, the
/// compensation debts, the Mobility Package.
class WeeklyRestScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _weekly);
    final mobility = ref.watch(
      complianceSettingsProvider.select((a) => a.value?.mobilityPackage),
    );
    return DetailScaffold(
      title: l.rowWeeklyRest,
      bottom: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: l.weeklyAddManually,
              onPressed: () => unawaited(
                openShiftEditor(context, presetRest: RestKind.weekly),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PrimaryButton(
              label: l.weeklyStartRest,
              color: context.colors.rest,
              onPressed: s == null || s.onWeekly != null
                  ? null
                  : () => _startRest(context, ref),
            ),
          ),
        ],
      ),
      children: s == null
          ? const []
          : [
              _Deadline(s),
              // Отдых идёт — сколько ещё до 24 и 45 ч и во сколько
              // наберутся; иначе — какой отдых брать
              if (s.onWeekly != null) ...[
                SectionTitle(l.dailyRestOptions),
                _Milestones(s),
                if (s.restCompensation) ...[
                  const SizedBox(height: AppSpacing.betweenCardsMin),
                  const CardGroup(children: [CompensationRow()]),
                ],
              ] else ...[
                SectionTitle(l.weeklyNext),
                _Options(reducedAvailable: s.reducedAvailable),
              ],
              SectionTitle(l.weeklyHistory),
              _History(s),
              if (s.twoReducedDebt case final debt?)
                InfoNote(
                  l.weeklyTwoReducedNote(
                    formatHm(Duration(minutes: debt)),
                    formatHm(
                      EuLimits.weeklyRestRegular + Duration(minutes: debt),
                    ),
                  ),
                ),
              if (mobility != null) _Info(mobility: mobility),
            ],
    );
  }

  /// Недельный отдых сразу, ещё до 24 ч: смена завершается — как
  /// «Завершить день», водитель вводит вождение за день, — а идущий
  /// суточный отдых становится недельным с его начала.
  static Future<void> _startRest(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    if (await finishDay(context, ref, weekly: true)) navigator.pop();
  }
}

/// Until when the weekly rest must start, or how long it has been going.
class _Deadline extends StatelessWidget {
  const new(this.s);

  final _Weekly s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final label = AppTextStyles.label.copyWith(
      color: colors.textSecondary,
      letterSpacing: AppTextStyles.label.fontSize! * 0.08,
    );
    final caption = AppTextStyles.body.copyWith(color: colors.textSecondary);
    final deadline = s.deadline;
    final onWeekly = s.onWeekly;
    final List<Widget> children;
    if (onWeekly != null) {
      final d = Duration(minutes: onWeekly);
      final start = s.onWeeklyStart;
      children = [
        Text(l.weeklyOngoing.toUpperCase(), style: label),
        const SizedBox(height: 4),
        DurationText(
          formatHm(d),
          spoken: spokenDuration(l, d),
          style: AppTextStyles.timer.copyWith(color: colors.rest),
        ),
        Text(
          l.ofLimit(formatLimit(l, EuLimits.weeklyRestRegular)),
          style: caption,
        ),
        if (start != null)
          Text(
            l.modeSince(formatWeekdayClock(start, context.localeTag)),
            style: caption,
          ),
        const SizedBox(height: 14),
        LimitBar(
          value: d,
          max: EuLimits.weeklyRestRegular,
          ticks: const [EuLimits.weeklyRestReduced],
          color: colors.rest,
        ),
      ];
    } else if (deadline != null) {
      final overdue = s.overdue > 0;
      children = [
        Text(l.weeklyStartBy.toUpperCase(), style: label),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            formatDeadline(deadline, context.localeTag),
            maxLines: 1,
            style: AppTextStyles.timer.copyWith(
              color: overdue ? colors.errorText : null,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          overdue
              ? l.weeklyOverdue(formatHm(Duration(minutes: s.overdue)))
              : l.weeklyInTime(formatHm(Duration(minutes: s.left))),
          style: caption.copyWith(color: overdue ? colors.errorText : null),
        ),
      ];
    } else {
      children = [Text(l.weeklyUnknown, style: caption)];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.heroCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Milestones of the weekly rest in progress: 24 h — reduced (greyed out when
/// not allowed), 45 h — regular; how long until each and at what time it is
/// reached.
class _Milestones extends StatelessWidget {
  const new(this.s);

  final _Weekly s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final start = s.onWeeklyStart;
    final onWeekly = s.onWeekly;
    if (start == null || onWeekly == null) return const SizedBox.shrink();
    final rest = Duration(minutes: onWeekly);
    MilestoneRow row(Duration hours, String kind, {bool allowed = true}) {
      final reached = rest >= hours;
      return MilestoneRow(
        dot: !allowed
            ? MilestoneDot.muted
            : reached
            ? MilestoneDot.solid
            : MilestoneDot.ring,
        title: l.dailyRestMilestone(hours.inHours, kind),
        subtitle: !allowed
            ? l.weeklyReducedNo
            : reached
            ? l.dailyRestReached
            : l.left(formatHm(hours - rest)),
        value: formatWeekdayClock(start.add(hours), context.localeTag),
        muted: !allowed,
      );
    }

    return CardGroup(
      children: [
        row(EuLimits.weeklyRestReduced, 'reduced', allowed: s.reducedAvailable),
        row(EuLimits.weeklyRestRegular, 'regular'),
      ],
    );
  }
}

/// The two options side by side: regular 45 h and reduced 24 h, the latter
/// greyed out when not allowed.
class _Options extends StatelessWidget {
  const new({required this.reducedAvailable});

  final bool reducedAvailable;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _Option(
                title: l.weeklyFull,
                hours: EuLimits.weeklyRestRegular.inHours,
                hint: l.weeklyFullHint,
                highlighted: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Option(
                title: l.weeklyReduced,
                hours: EuLimits.weeklyRestReduced.inHours,
                hint: reducedAvailable ? l.weeklyReducedYes : l.weeklyReducedNo,
                muted: !reducedAvailable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One weekly rest option: title, hours and hint.
class _Option extends StatelessWidget {
  const new({
    required this.title,
    required this.hours,
    required this.hint,
    this.highlighted = false,
    this.muted = false,
  });

  final String title;
  final int hours;
  final String hint;
  final bool highlighted;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.modeButton),
        border: Border.all(
          color: highlighted ? colors.rest : colors.line,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.rowTitle.copyWith(
                color: highlighted ? colors.restText : colors.chipText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l.hoursShort(hours),
              style: AppTextStyles.valueLarge.copyWith(
                color: muted ? colors.textSecondary : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              style: AppTextStyles.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The previous weekly rests and the compensation debt: the whole debt and,
/// when there are several, each one with its due date.
class _History extends StatelessWidget {
  const new(this.s);

  final _Weekly s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final last = s.last;
    final debts = s.debts.items;
    final debt = debts.fold(Duration.zero, (sum, c) => sum + c.debt);
    String moment(DateTime t) => '${formatDayMonth(t)} ${formatClock(t)}';
    String debtValue(Compensation c) =>
        l.weeklyCompensationValue(formatHm(c.debt), formatDayMonth(c.dueBy));
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    return CardGroup(
      children: [
        if (last == null)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Text(
              l.statusNoData,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(color: colors.rest),
                  child: const ModeIcon(DriverMode.rest, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.weeklyPrevious(last.status.name),
                        style: AppTextStyles.rowTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${moment(last.start)} → '
                        '${last.end == null ? l.weeklyNow : moment(last.end!)}',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                DurationText(
                  formatHm(Duration(minutes: last.duration)),
                  spoken: spokenDuration(l, Duration(minutes: last.duration)),
                  style: AppTextStyles.value,
                ),
              ],
            ),
          ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.listRow),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.weeklyCompensation,
                    style: AppTextStyles.rowTitle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  switch (debts) {
                    [] => l.weeklyCompensationNone,
                    [final c] => debtValue(c),
                    // Несколько долгов — сколько всего, ниже каждый
                    _ => formatHm(debt),
                  },
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: debts.isEmpty ? colors.restText : colors.drive,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (debts.length > 1)
          for (final c in debts)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.weeklyCompensationFor(formatDayMonth(c.restStart)),
                      style: caption,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(debtValue(c), style: AppTextStyles.body),
                ],
              ),
            ),
      ],
    );
  }
}

/// Explanation of the rules, with or without the Mobility Package.
class _Info extends StatelessWidget {
  const new({required this.mobility});

  final bool mobility;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMax,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 20, color: colors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mobility ? l.weeklyMobilityOn : l.weeklyMobilityOff,
                  style: AppTextStyles.body.copyWith(color: colors.chipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
