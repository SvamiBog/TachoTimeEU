import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';

typedef _Week = ({
  DateTime weekStart,
  int weekly,
  int fortnight,
  int remaining,
  bool fortnightLimiting,
  Tone weeklyTone,
  Tone fortnightTone,
});

_Week _week(ComplianceSnapshot s) => (
  weekStart: s.weekStart,
  weekly: minutes(s.weeklyDriving),
  fortnight: minutes(s.fortnightDriving),
  remaining: minutes(s.weeklyDrivingRemaining),
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

void openWeeklyDrivingScreen(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const WeeklyDrivingScreen()));

/// «Недельное вождение»: вождение недели из 56 ч и двух недель из 90 ч,
/// что ограничивает раньше, и смены недели — касание открывает детали дня.
/// Макета нет — из компонентов экранов лимитов.
class WeeklyDrivingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _week);
    final shifts = ref.watch(
      journalProvider.select(
        (a) => ValueList(
          [
            for (final s in a.value?.weeks ?? const <JournalWeek>[])
              if (s.isCurrent) ...s.shifts,
          ]..sort((a, b) => a.start.compareTo(b.start)),
        ),
      ),
    );
    return DetailScaffold(
      title: l.rowWeeklyDriving,
      children: s == null
          ? const []
          : [
              _Summary(s),
              SectionTitle(l.drivingLimits),
              _Limits(s),
              if (s.fortnightLimiting)
                InfoNote(
                  l.drivingFortnightLimits(
                    formatHm(Duration(minutes: s.remaining)),
                  ),
                ),
              SectionTitle(l.drivingWeekShifts),
              _Shifts(shifts.items),
              InfoNote(l.drivingWeekRule),
            ],
    );
  }
}

class _Summary extends StatelessWidget {
  const new(this.s);

  final _Week s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final weekly = Duration(minutes: s.weekly);
    final violation = s.weeklyTone == Tone.violation;
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
                    formatHm(weekly),
                    spoken: spokenDuration(l, weekly),
                    style: AppTextStyles.timer.copyWith(
                      color: violation ? colors.errorText : colors.drive,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l.ofLimit(formatLimit(l, EuLimits.weeklyDriving)),
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                l.drivingWeekSince(
                  formatWeekdayDayClock(s.weekStart, context.localeTag),
                ),
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 14),
              LimitBar(
                value: weekly,
                max: EuLimits.weeklyDriving,
                color: violation ? colors.errorText : colors.drive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 56 ч за неделю и 90 ч за две: сколько осталось.
class _Limits extends StatelessWidget {
  const new(this.s);

  final _Week s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final weekly = Duration(minutes: s.weekly);
    final fortnight = Duration(minutes: s.fortnight);
    final weekLeft = EuLimits.weeklyDriving - weekly;
    final fortnightLeft = EuLimits.fortnightDriving - fortnight;
    return CardGroup(
      children: [
        MilestoneRow(
          dot: weekLeft <= Duration.zero
              ? MilestoneDot.solid
              : MilestoneDot.ring,
          title: l.drivingWeekLimit(EuLimits.weeklyDriving.inHours),
          subtitle: weekLeft <= Duration.zero
              ? l.drivingUsedUp
              : l.left(formatHm(weekLeft)),
          value: formatHm(atLeastZero(weekLeft)),
          valueColor: s.weeklyTone == Tone.violation ? colors.errorText : null,
        ),
        MilestoneRow(
          dot: fortnightLeft <= Duration.zero
              ? MilestoneDot.solid
              : MilestoneDot.ring,
          title: l.drivingFortnightLimit(EuLimits.fortnightDriving.inHours),
          subtitle: l.drivingFortnightHint(
            formatHm(fortnight - weekly),
            formatHm(atLeastZero(fortnightLeft)),
          ),
          value: formatHm(atLeastZero(fortnightLeft)),
          valueColor: s.fortnightTone == Tone.violation
              ? colors.errorText
              : null,
        ),
      ],
    );
  }
}

/// Смены текущей недели: день, время, вождение; касание — детали дня.
class _Shifts extends StatelessWidget {
  const new(this.shifts);

  final List<JournalShift> shifts;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (shifts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding + 4,
        ),
        child: Text(
          l.drivingNoShifts,
          style: AppTextStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      );
    }
    final locale = context.localeTag;
    return CardGroup(
      children: [
        for (final s in shifts)
          NavRow(
            title: formatWeekdayDay(s.start, locale),
            subtitle:
                '${formatClock(s.start)} → '
                '${s.end == null ? l.journalOngoing : formatClock(s.end!)}',
            value: formatHm(s.driving),
            numericValue: true,
            onTap: () => openShiftDay(context, keyOf(s)),
          ),
      ],
    );
  }
}
