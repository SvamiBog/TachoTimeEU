/// The "Rest" section of the home screen: daily and weekly rest, compensation
/// and the ferry / train mark. Rows select only their part of the engine
/// snapshot, in whole minutes, so the clock tick rebuilds only what changed.
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
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/daily_rest_screen.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';

Duration _m(int minutes) => Duration(minutes: minutes);

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

/// «Не начат» или «идёт 2:15».
StatusValue _status(AppLocalizations l, int? minutes) => StatusValue(
  minutes == null
      ? l.statusNotStarted
      : l.statusInProgress(formatHm(_m(minutes))),
);

/// "Rest": daily rest with the reduced rests left, weekly rest, compensation
/// and the ferry / train mark.
class RestSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _rest);
    if (s == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(context.l10n.sectionRest),
        CardGroup(
          children: [
            _DailyRestRow(s),
            _WeeklyRestRow(s),
            // Долг за сокращённый недельный отдых — только когда он есть
            if (s.compensation) const CompensationRow(),
            const FerryRow(),
          ],
        ),
      ],
    );
  }
}

/// "Daily rest": the rest in progress and when it reaches 9 and 11 h, the
/// reduced rests left; opens the daily rest screen.
class _DailyRestRow extends StatelessWidget {
  const new(this.s);

  final _Rest s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final daily = s.daily;
    final dailyStart = s.dailyStart;
    final (left, right) = daily != null && dailyStart != null
        ? _dailyRestCaptions(
            l,
            daily,
            dailyStart,
            reducedWeekly: s.reducedWeekly,
            locale: context.localeTag,
          )
        : (l.dailyRestCaption, l.dailyRestSplit);
    return LimitRow(
      title: l.rowDailyRest,
      onTap: () => openDailyRestScreen(context),
      chip: StatusChip(
        l.chipTimes(EuLimits.dailyRestReduced.inHours, s.reducedLeft),
      ),
      value: _status(l, s.daily),
      bar: LimitBar(
        value: _m(s.daily ?? 0),
        max: EuLimits.dailyRestRegular,
        ticks: const [EuLimits.dailyRestSplitFirst, EuLimits.dailyRestReduced],
        color: context.colors.rest,
      ),
      left: left,
      right: right,
    );
  }
}

/// "Weekly rest": the rest in progress and when it reaches 24 and 45 h, or
/// until when to start it; opens the weekly rest screen.
class _WeeklyRestRow extends StatelessWidget {
  const new(this.s);

  final _Rest s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = context.localeTag;
    final weekly = s.weekly;
    final weeklyStart = s.weeklyStart;
    final deadline = s.deadline;
    final (left, right) = weekly != null && weeklyStart != null
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
    return LimitRow(
      title: l.rowWeeklyRest,
      chip: StatusChip(
        s.reducedWeekly ? l.chipReducedAvailable : l.chipReducedUnavailable,
      ),
      value: _status(l, s.weekly),
      bar: LimitBar(
        value: _m(s.weekly ?? 0),
        max: EuLimits.weeklyRestRegular,
        ticks: const [EuLimits.weeklyRestReduced],
        color: context.colors.rest,
      ),
      left: left,
      right: right,
      onTap: () => openWeeklyRestScreen(context),
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
          AppSpacing.s12,
          AppSpacing.rowTrailing,
          AppSpacing.s12,
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
            const SizedBox(width: AppSpacing.s12),
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
