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
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_history.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

/// Everything the weekly rest screen shows, in whole minutes.
typedef _Weekly = ({
  DateTime? deadline,
  int left,
  int overdue,
  int? onWeekly,
  DateTime? onWeeklyStart,
  bool reducedAvailable,

  /// Сокращённый недоступен из-за страны фирмы: второй подряд — только вне
  /// неё (ст. 8(6)).
  bool reducedAtBase,
  LastWeeklyRest? last,

  /// Непогашенные долги по сроку; за два сокращённых подряд — один на оба.
  ValueList<Compensation> debts,

  /// Долг за два последних недельных отдыха, если оба сокращённые, и
  /// недельный отдых, которым его гасят: долг берут одним блоком после
  /// второго, перед следующим недельным отдыхом (ст. 8(6)); null — не два
  /// сокращённых подряд или долг за них погашен.
  ({int debt, int weeklyRest})? twoReducedDebt,
  bool restCompensation,
});

_Weekly _weekly(ComplianceSnapshot s) {
  final deadline = s.weeklyRestDeadline;
  final rest = s.offDutyRest;
  final onWeekly = rest != null && rest.weekly ? rest : null;
  final last = s.lastWeeklyRest;
  // Долг за пару — у второго из двух последних недельных отдыхов
  final twoReduced = last == null
      ? null
      : s.unpaidCompensations
            .where((c) => c.secondRestStart == last.start)
            .firstOrNull;
  return (
    deadline: deadline,
    left: minutes(s.workWeekRemaining ?? Duration.zero),
    overdue: deadline == null || !s.now.isAfter(deadline)
        ? 0
        : minutes(s.now.difference(deadline)),
    onWeekly: onWeekly == null ? null : minutes(onWeekly.duration),
    onWeeklyStart: onWeekly?.start,
    reducedAvailable: s.reducedWeeklyRestAvailable,
    reducedAtBase: s.reducedWeeklyRestAtBase,
    last: last == null
        ? null
        : (
            start: last.start,
            end: last.end,
            duration: minutes(last.duration),
            status: last.status,
          ),
    debts: ValueList(s.unpaidCompensations),
    twoReducedDebt: twoReduced == null
        ? null
        : (
            debt: minutes(twoReduced.debt),
            weeklyRest: minutes(twoReduced.weeklyRestWithDebt),
          ),
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
      bottom: _Actions(canStart: s != null && s.onWeekly == null),
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
                _Options(
                  reducedAvailable: s.reducedAvailable,
                  reducedAtBase: s.reducedAtBase,
                ),
              ],
              SectionTitle(l.weeklyHistory),
              WeeklyRestHistory(last: s.last, debts: s.debts.items),
              if (s.twoReducedDebt case (:final debt, :final weeklyRest)?)
                InfoNote(
                  l.weeklyTwoReducedNote(
                    formatHm(Duration(minutes: debt)),
                    formatHm(Duration(minutes: weeklyRest)),
                  ),
                ),
              if (mobility != null)
                InfoNote(mobility ? l.weeklyMobilityOn : l.weeklyMobilityOff),
            ],
    );
  }
}

/// "Add manually" and "Start weekly rest" at the bottom of the screen.
class _Actions extends ConsumerWidget {
  const new({required this.canStart});

  /// Недельный отдых ещё не идёт — его можно начать.
  final bool canStart;

  /// Недельный отдых сразу, ещё до 24 ч: смена завершается — как
  /// «Завершить день», водитель вводит вождение за день, — а идущий
  /// суточный отдых становится недельным с его начала.
  static Future<void> _startRest(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    if (await finishDay(context, ref, weekly: true)) navigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: l.weeklyAddManually,
            onPressed: () => unawaited(
              openShiftEditor(context, presetRest: RestKind.weekly),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: PrimaryButton(
            label: l.weeklyStartRest,
            color: context.colors.rest,
            onPressed: canStart ? () => _startRest(context, ref) : null,
          ),
        ),
      ],
    );
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
        const SizedBox(height: AppSpacing.s4),
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
        const SizedBox(height: AppSpacing.s14),
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
        const SizedBox(height: AppSpacing.s4),
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
        const SizedBox(height: AppSpacing.s4),
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
    return HeroCard(children: children);
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
    final rest = RestMilestones.weekly(
      Duration(minutes: onWeekly),
      reducedAvailable: s.reducedAvailable,
    );
    MilestoneRow row(Duration hours, String kind, {bool allowed = true}) {
      final reached = rest.reached(hours);
      return MilestoneRow(
        dot: !allowed
            ? MilestoneDot.muted
            : reached
            ? MilestoneDot.solid
            : MilestoneDot.ring,
        title: l.dailyRestMilestone(hours.inHours, kind),
        subtitle: !allowed
            ? (s.reducedAtBase ? l.weeklyReducedNoBase : l.weeklyReducedNo)
            : reached
            ? l.dailyRestReached
            : l.left(formatHm(rest.left(hours))),
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
  const new({required this.reducedAvailable, required this.reducedAtBase});

  final bool reducedAvailable;

  /// Недоступен из-за страны фирмы — подсказка говорит почему.
  final bool reducedAtBase;

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
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _Option(
                title: l.weeklyReduced,
                hours: EuLimits.weeklyRestReduced.inHours,
                hint: reducedAvailable
                    ? l.weeklyReducedYes
                    : reducedAtBase
                    ? l.weeklyReducedNoBase
                    : l.weeklyReducedNo,
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
            const SizedBox(height: AppSpacing.s6),
            Text(
              l.hoursShort(hours),
              style: AppTextStyles.valueLarge.copyWith(
                color: muted ? colors.textSecondary : null,
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
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
