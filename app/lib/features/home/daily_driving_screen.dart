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
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/corrections.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_driving_screen.dart';

typedef _Daily = ({
  DateTime now,
  DateTime? shiftStart,
  int driving,
  int limit,
  int extensionsLeft,
  bool atWheel,
  int weekly,
  Tone tone,
});

_Daily _daily(ComplianceSnapshot s) => (
  now: minuteOf(s.now),
  shiftStart: s.shift?.start,
  driving: minutes(s.dailyDriving),
  limit: minutes(s.dailyDrivingLimit),
  extensionsLeft: s.extensionsLeft,
  atWheel: s.currentMode == DriverMode.driving,
  weekly: minutes(s.weeklyDriving),
  tone: toneOf(
    s,
    violation: InfringementType.dailyDriveExceeded,
    warning: InfringementType.dailyDriveSoon,
  ),
);

void openDailyDrivingScreen(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const DailyDrivingScreen()));

/// «Суточное вождение»: вождение смены из 9 ч (дважды в неделю — 10 ч),
/// сколько осталось и сколько удлинений на неделе, переход к неделе и
/// правка вождения за день (экран 7). Макета нет — из компонентов экранов
/// лимитов.
class DailyDrivingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _daily);
    return DetailScaffold(
      title: l.rowDailyDriving,
      bottom: s?.shiftStart == null
          ? null
          : SecondaryButton(
              label: l.drivingCorrect,
              onPressed: () => unawaited(openDrivingCorrection(context, ref)),
            ),
      children: s == null
          ? const []
          : [
              _Summary(s),
              SectionTitle(l.drivingLimits),
              _Limits(s),
              const SizedBox(height: AppSpacing.betweenCardsMin),
              CardGroup(
                children: [
                  NavRow(
                    title: l.rowWeeklyDriving,
                    value: formatHm(Duration(minutes: s.weekly)),
                    numericValue: true,
                    onTap: () => openWeeklyDrivingScreen(context),
                  ),
                ],
              ),
              InfoNote(l.drivingDailyRule),
            ],
    );
  }
}

class _Summary extends StatelessWidget {
  const new(this.s);

  final _Daily s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final driving = Duration(minutes: s.driving);
    final violation = s.tone == Tone.violation;
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
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 10,
                children: [
                  DurationText(
                    formatHm(driving),
                    spoken: spokenDuration(l, driving),
                    style: AppTextStyles.timer.copyWith(
                      color: violation ? colors.errorText : colors.drive,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l.ofLimit(formatLimit(l, Duration(minutes: s.limit))),
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LimitBar(
                value: driving,
                max: EuLimits.dailyDrivingExtended,
                ticks: const [EuLimits.dailyDriving],
                color: violation ? colors.errorText : colors.drive,
              ),
              if (s.shiftStart == null) ...[
                const SizedBox(height: 14),
                Text(
                  l.workdayNoShift,
                  style: AppTextStyles.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 9 ч и 10 ч: сколько осталось; за рулём — во сколько кончится.
class _Limits extends StatelessWidget {
  const new(this.s);

  final _Daily s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final driving = Duration(minutes: s.driving);
    final extended =
        s.extensionsLeft > 0 ||
        Duration(minutes: s.limit) > EuLimits.dailyDriving;
    MilestoneRow row(
      Duration limit,
      String title, {
      String? hint,
      bool muted = false,
    }) {
      final left = limit - driving;
      final subtitle = left <= Duration.zero
          ? l.drivingUsedUp
          : hint ??
                (s.atWheel
                    ? l.leftUntil(formatHm(left), formatClock(s.now.add(left)))
                    : l.left(formatHm(left)));
      return MilestoneRow(
        dot: left <= Duration.zero
            ? MilestoneDot.solid
            : muted
            ? MilestoneDot.muted
            : MilestoneDot.ring,
        title: title,
        subtitle: subtitle,
        value: formatHm(atLeastZero(left)),
        muted: muted,
      );
    }

    return CardGroup(
      children: [
        row(
          EuLimits.dailyDriving,
          l.workdayRegular(EuLimits.dailyDriving.inHours),
        ),
        row(
          EuLimits.dailyDrivingExtended,
          l.workdayExtended(EuLimits.dailyDrivingExtended.inHours),
          hint: extended
              ? l.drivingExtensionsLeft(s.extensionsLeft)
              : l.drivingNoExtensions,
          muted: !extended,
        ),
      ],
    );
  }
}
