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

/// Отдых, который идёт сейчас, и смена — по минутам: секундный тик экран
/// не перестраивает.
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
    shiftStart: s.shift?.start,
    regular: minutes(s.shiftRegularLimit),
    extended: minutes(s.shiftExtendedLimit),
    reducedLeft: s.reducedRestsLeft,
    splitFirstPart: s.shift?.splitFirstPart ?? false,
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

/// «Суточный отдых»: идущий отдых — сколько отдыхать до 3, 9 и 11 ч и в
/// котором часу они наберутся; пока водитель работает — до какого времени
/// начать полный и сокращённый отдых. Макета нет: собран из компонентов
/// экранов «Рабочий день» и «Недельный отдых».
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

class _Summary extends StatelessWidget {
  const new(this.s);

  final DailyRestState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final label = AppTextStyles.label.copyWith(
      color: colors.textSecondary,
      letterSpacing: AppTextStyles.label.fontSize! * 0.08,
    );
    final caption = AppTextStyles.body.copyWith(color: colors.textSecondary);
    final restStart = s.restStart;
    final shiftStart = s.shiftStart;
    final List<Widget> children;
    if (restStart != null) {
      final rest = Duration(minutes: s.rest);
      final target = s.weekly
          ? EuLimits.weeklyRestRegular
          : EuLimits.dailyRestRegular;
      children = [
        Text(
          (s.weekly ? l.weeklyOngoing : l.dailyRestOngoing).toUpperCase(),
          style: label,
        ),
        const SizedBox(height: 4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 10,
          children: [
            DurationText(
              formatHm(rest),
              spoken: spokenDuration(l, rest),
              style: AppTextStyles.timer.copyWith(color: colors.rest),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(l.ofLimit(formatLimit(l, target)), style: caption),
            ),
          ],
        ),
        Text(l.modeSince(formatClock(restStart)), style: caption),
        const SizedBox(height: 14),
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
      ];
    } else if (shiftStart != null) {
      final regular = shiftStart.add(Duration(minutes: s.regular));
      final extended = shiftStart.add(Duration(minutes: s.extended));
      final late = s.now.isAfter(regular);
      final overdue = s.tone == Tone.violation;
      final latest = s.reducedLeft > 0 || s.splitFirstPart ? extended : regular;
      children = [
        Text(l.dailyRestStartBy.toUpperCase(), style: label),
        const SizedBox(height: 4),
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
        const SizedBox(height: 4),
        Text(
          overdue
              ? l.weeklyOverdue(formatHm(s.now.difference(latest)))
              : late
              ? l.dailyRestMilestone(
                  EuLimits.dailyRestReduced.inHours,
                  'reduced',
                )
              : s.reducedLeft > 0 || s.splitFirstPart
              ? l.dailyRestReducedBy(
                  EuLimits.dailyRestReduced.inHours,
                  formatClock(extended),
                )
              : l.dailyRestNoReduced,
          style: caption.copyWith(color: overdue ? colors.errorText : null),
        ),
      ];
    } else {
      children = [Text(l.workdayNoShift, style: caption)];
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

/// Вехи отдыха: 3 ч — первая часть раздельного (пока смена идёт), 9 ч —
/// сокращённый, 11 ч — полный. Отдых идёт — когда наберётся каждая; не
/// начат — до какого времени начать.
class _Milestones extends StatelessWidget {
  const new(this.s);

  final DailyRestState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final restStart = s.restStart;
    final shiftStart = s.shiftStart;
    final rest = Duration(minutes: s.rest);
    final reduced = s.reducedLeft > 0 || s.splitFirstPart;
    final rows = <Widget>[];

    if (restStart != null) {
      MilestoneRow row(Duration hours, String kind, {String? pending}) {
        final reached = rest >= hours;
        final left = hours - rest;
        return MilestoneRow(
          dot: reached ? MilestoneDot.solid : MilestoneDot.ring,
          title: l.dailyRestMilestone(hours.inHours, kind),
          subtitle: reached
              ? (kind == 'split' ? l.dailyRestSplitHint : l.dailyRestReached)
              : pending ?? l.left(formatHm(left)),
          value: formatClock(restStart.add(hours)),
        );
      }

      // Первая часть раздельного — только пока смена идёт: она сама её не
      // завершает, а если первая часть уже взята, этот отдых — вторая
      if (!s.offDuty && !s.splitFirstPart) {
        rows.add(row(EuLimits.dailyRestSplitFirst, 'split'));
      }
      final reducedLeft = EuLimits.dailyRestReduced - rest;
      rows
        ..add(
          reduced || rest >= EuLimits.dailyRestReduced
              ? row(
                  EuLimits.dailyRestReduced,
                  'reduced',
                  pending: s.splitFirstPart
                      ? null
                      : l.dailyRestLeftCount(
                          formatHm(reducedLeft),
                          s.reducedLeft,
                        ),
                )
              : MilestoneRow(
                  dot: MilestoneDot.muted,
                  title: l.dailyRestMilestone(
                    EuLimits.dailyRestReduced.inHours,
                    'reduced',
                  ),
                  subtitle: l.dailyRestNoReduced,
                  value: formatClock(restStart.add(EuLimits.dailyRestReduced)),
                  muted: true,
                ),
        )
        ..add(row(EuLimits.dailyRestRegular, 'regular'));
    } else if (shiftStart != null) {
      final late = s.now.isAfter(shiftStart.add(Duration(minutes: s.regular)));
      rows
        ..add(
          MilestoneRow(
            dot: MilestoneDot.ring,
            title: l.dailyRestMilestone(
              EuLimits.dailyRestRegular.inHours,
              'regular',
            ),
            subtitle: l.dailyRestStartLatest,
            value: formatClock(shiftStart.add(Duration(minutes: s.regular))),
            muted: late,
          ),
        )
        ..add(
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
        );
    } else {
      rows
        ..add(
          MilestoneRow(
            dot: MilestoneDot.ring,
            title: l.dailyRestMilestone(
              EuLimits.dailyRestRegular.inHours,
              'regular',
            ),
            value: formatHm(EuLimits.dailyRestRegular),
          ),
        )
        ..add(
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
        );
    }
    return CardGroup(children: rows);
  }
}
