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
import 'package:tachogo/features/home/shift_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';

typedef _WorkWeek = ({
  DateTime? since,
  DateTime? deadline,
  int value,
  int left,
  int overdue,
  bool onWeeklyRest,
  Tone tone,
});

_WorkWeek _workWeek(ComplianceSnapshot s) {
  final deadline = s.weeklyRestDeadline;
  return (
    since: s.workWeekStart,
    deadline: deadline,
    value: minutes(s.workWeekDuration),
    left: minutes(s.workWeekRemaining ?? Duration.zero),
    overdue: deadline == null || !s.now.isAfter(deadline)
        ? 0
        : minutes(s.now.difference(deadline)),
    onWeeklyRest: s.offDutyRest?.weekly ?? false,
    tone: toneOf(
      s,
      violation: InfringementType.weeklyRestOverdue,
      warning: InfringementType.weeklyRestSoon,
    ),
  );
}

void openWorkWeekScreen(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const WorkWeekScreen()));

/// «Рабочая неделя» (отзыв водителя 02.10.2026: строка открывала экран
/// недельного отдыха): время от конца прошлого недельного отдыха из 144 ч,
/// до какого времени начать следующий, переход к экрану 9 и смены этой
/// рабочей недели. Макета нет — из компонентов экранов лимитов.
class WorkWeekScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _workWeek);
    final since = s?.since;
    // Смены от конца недельного отдыха, по возрастанию начала
    final shifts = ref.watch(
      journalProvider.select(
        (a) => ValueList(
          since == null
              ? const <JournalShift>[]
              : ([
                  for (final shift in a.value?.shifts ?? <JournalShift>[])
                    if (!shift.start.isBefore(since)) shift,
                ]..sort((a, b) => a.start.compareTo(b.start))),
        ),
      ),
    );
    return DetailScaffold(
      title: l.rowWorkWeek,
      children: s == null
          ? const []
          : [
              _Summary(s),
              SectionTitle(l.rowWeeklyRest),
              _Milestones(s),
              if (since != null) ...[
                SectionTitle(l.workWeekShifts),
                ShiftRows(shifts.items, empty: l.workWeekNoShifts),
              ],
              InfoNote(l.workWeekRule),
            ],
    );
  }
}

/// «76:30 из 144 ч · с пн 28.09, 06:00» и полоса.
class _Summary extends StatelessWidget {
  const new(this.s);

  final _WorkWeek s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final since = s.since;
    final value = Duration(minutes: s.value);
    final violation = s.tone == Tone.violation;
    final caption = AppTextStyles.body.copyWith(color: colors.textSecondary);
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
                    since == null ? '—' : formatHm(value),
                    spoken: since == null ? '—' : spokenDuration(l, value),
                    style: AppTextStyles.timer.copyWith(
                      color: violation ? colors.errorText : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l.ofLimit(formatLimit(l, EuLimits.maxBetweenWeeklyRests)),
                      style: caption,
                    ),
                  ),
                ],
              ),
              if (since != null && !s.onWeeklyRest)
                Text(
                  l.workWeekSince(
                    formatWeekdayDayClock(since, context.localeTag),
                  ),
                  style: caption,
                ),
              const SizedBox(height: 14),
              LimitBar(
                value: since == null ? Duration.zero : value,
                max: EuLimits.maxBetweenWeeklyRests,
                color: violation ? colors.errorText : colors.text,
              ),
              if (since == null || s.onWeeklyRest) ...[
                const SizedBox(height: 14),
                Text(
                  since == null ? l.weeklyUnknown : l.workWeekOnRest,
                  style: caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Конец прошлого недельного отдыха, 144 ч — начать следующий, переход к
/// экрану недельного отдыха.
class _Milestones extends StatelessWidget {
  const new(this.s);

  final _WorkWeek s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final locale = context.localeTag;
    final since = s.since;
    final deadline = s.deadline;
    final overdue = s.overdue > 0;
    return CardGroup(
      children: [
        if (since != null)
          MilestoneRow(
            dot: MilestoneDot.solid,
            title: l.workWeekRestEnd,
            subtitle: formatWeekdayDay(since, locale),
            value: formatClock(since),
          ),
        if (deadline != null && !s.onWeeklyRest)
          MilestoneRow(
            dot: overdue ? MilestoneDot.solid : MilestoneDot.ring,
            title: l.workWeekDeadline(EuLimits.maxBetweenWeeklyRests.inHours),
            subtitle: overdue
                ? l.weeklyOverdue(formatHm(Duration(minutes: s.overdue)))
                : l.left(formatHm(Duration(minutes: s.left))),
            value: formatWeekdayClock(deadline, locale),
            valueColor: overdue ? colors.errorText : null,
          ),
        NavRow(
          title: l.rowWeeklyRest,
          onTap: () => openWeeklyRestScreen(context),
        ),
      ],
    );
  }
}
