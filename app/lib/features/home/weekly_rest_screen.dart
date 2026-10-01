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
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

typedef _Last = ({
  DateTime start,
  DateTime? end,
  int duration,
  RestStatus status,
});

typedef _Weekly = ({
  DateTime? deadline,
  int left,
  int overdue,
  int? onWeekly,
  bool offDuty,
  bool reducedAvailable,
  _Last? last,
  int? debt,
  DateTime? debtDue,
});

_Weekly _weekly(ComplianceSnapshot s) {
  final deadline = s.weeklyRestDeadline;
  final rest = s.offDutyRest;
  final last = s.lastWeeklyRest;
  final compensation = s.compensation;
  return (
    deadline: deadline,
    left: minutes(s.workWeekRemaining ?? Duration.zero),
    overdue: deadline == null || !s.now.isAfter(deadline)
        ? 0
        : minutes(s.now.difference(deadline)),
    onWeekly: rest != null && rest.weekly ? minutes(rest.duration) : null,
    offDuty: rest != null,
    reducedAvailable: s.reducedWeeklyRestAvailable,
    last: last == null
        ? null
        : (
            start: last.start,
            end: last.end,
            duration: minutes(last.duration),
            status: last.status,
          ),
    debt: compensation == null ? null : minutes(compensation.debt),
    debtDue: compensation?.dueBy,
  );
}

void openWeeklyRestScreen(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const WeeklyRestScreen()));

/// Экран 9 «Недельный отдых»: срок по 144 ч, полный 45 ч и сокращённый
/// 24 ч, прошлый отдых, долг по компенсации, пакет мобильности.
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
              onPressed: s == null || s.offDuty
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
              SectionTitle(l.weeklyNext),
              _Options(reducedAvailable: s.reducedAvailable),
              SectionTitle(l.weeklyHistory),
              _History(s),
              if (mobility != null) _Info(mobility: mobility),
            ],
    );
  }

  /// Отдых, который сразу завершает смену: станет недельным через 24 ч.
  /// Как «Завершить день» — водитель вводит вождение за день.
  static Future<void> _startRest(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    if (await finishDay(context, ref)) navigator.pop();
  }
}

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

class _History extends StatelessWidget {
  const new(this.s);

  final _Weekly s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final last = s.last;
    final debt = s.debt;
    final debtDue = s.debtDue;
    String moment(DateTime t) => '${formatDayMonth(t)} ${formatClock(t)}';
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
                  debt == null || debtDue == null
                      ? l.weeklyCompensationNone
                      : l.weeklyCompensationValue(
                          formatHm(Duration(minutes: debt)),
                          formatDayMonth(debtDue),
                        ),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: debt == null ? colors.restText : colors.drive,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
