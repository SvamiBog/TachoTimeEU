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
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/features/home/corrections.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/end_day.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

typedef _Workday = ({
  DateTime? start,
  DateTime today,
  int value,
  int limit,
  int regular,
  int extended,
  int reducedLeft,
  bool splitFirstPart,
  Tone tone,
});

_Workday _workday(ComplianceSnapshot s) {
  final local = s.now.toLocal();
  return (
    start: s.shift?.start,
    today: DateTime(local.year, local.month, local.day),
    value: minutes(s.shiftDuration),
    limit: minutes(s.shiftLimit),
    regular: minutes(s.shiftRegularLimit),
    extended: minutes(s.shiftExtendedLimit),
    reducedLeft: s.reducedRestsLeft,
    splitFirstPart: s.shift?.splitFirstPart ?? false,
    tone: toneOf(
      s,
      violation: InfringementType.shiftExceeded,
      warning: InfringementType.shiftSoon,
    ),
  );
}

/// Экран 6 «Рабочий день»: 13 / 15 ч (экипаж — 19 / 21 ч) от начала смены
/// и «Завершить день».
class WorkdayScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _workday);
    final start = s?.start;
    return DetailScaffold(
      title: l.rowWorkday,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (start != null) ...[
            Text(
              l.workdayEndDayHint,
              style: AppTextStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l.workdayChangeStart,
                  onPressed: start == null
                      ? null
                      : () => unawaited(openShiftStartCorrection(context, ref)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  label: l.workdayEndDay,
                  color: context.colors.rest,
                  onPressed: start == null ? null : () => _endDay(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
      children: s == null
          ? const []
          : [
              _Summary(s),
              if (start != null) ...[
                SectionTitle(
                  isSameLocalDay(start, s.today)
                      ? l.todayDate(formatWeekdayDay(start, context.localeTag))
                      : formatWeekdayDay(start, context.localeTag),
                ),
                _Milestones(
                  s,
                  start,
                  country: ref.watch(currentCountriesProvider)?.start,
                ),
              ],
              InfoNote(l.workdayRule),
            ],
    );
  }

  /// «Завершить день» — отдых, который сразу завершает смену; водитель
  /// вводит вождение за день.
  static Future<void> _endDay(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    if (await finishDay(context, ref)) navigator.pop();
  }
}

class _Summary extends StatelessWidget {
  const new(this.s);

  final _Workday s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final value = Duration(minutes: s.value);
    final regular = Duration(minutes: s.regular);
    final extended = Duration(minutes: s.extended);
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
                    formatHm(value),
                    spoken: spokenDuration(l, value),
                    style: AppTextStyles.timer.copyWith(
                      color: s.tone == Tone.violation ? colors.errorText : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l.ofLimit(formatHm(Duration(minutes: s.limit))),
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LimitBar(
                value: value,
                max: extended,
                ticks: [if (regular < extended) regular],
                color: s.tone == Tone.violation
                    ? colors.errorText
                    : colors.text,
              ),
              if (s.start == null) ...[
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

class _Milestones extends StatelessWidget {
  const new(this.s, this.start, {this.country});

  final _Workday s;
  final DateTime start;

  /// Страна начала смены, код тахографа.
  final String? country;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final regular = Duration(minutes: s.regular);
    final extended = Duration(minutes: s.extended);
    final left = atLeastZero(regular - Duration(minutes: s.value));
    return CardGroup(
      children: [
        MilestoneRow(
          dot: MilestoneDot.solid,
          title: l.workdayStart,
          subtitle: country,
          value: formatClock(start),
        ),
        MilestoneRow(
          dot: MilestoneDot.ring,
          title: l.workdayRegular(regular.inHours),
          subtitle: l.workdayRegularHint(formatHm(left)),
          value: formatClock(start.add(regular)),
        ),
        if (regular < extended)
          MilestoneRow(
            dot: MilestoneDot.muted,
            title: l.workdayExtended(extended.inHours),
            subtitle: l.workdayExtendedHint(s.reducedLeft),
            value: formatClock(start.add(extended)),
            muted: s.reducedLeft == 0 && !s.splitFirstPart,
          ),
      ],
    );
  }
}
