/// Compensation for a reduced weekly rest (Art. 8(6), 8(7)): the debt, the due
/// date and how long to rest to repay it. The rules are in the engine: any rest
/// of 9 h or more repays the debt when it lasts 9 h + debt (a weekly rest — 45
/// h + debt).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';

/// Что отдых начала [restStart] сделал с долгами: сколько долга к нему
/// присоединено и долг за него самого, если это сокращённый недельный. Два
/// сокращённых подряд — долг на оба, у каждого из них.
({Duration taken, Compensation? debt}) compensationOfRest(
  List<Compensation> all,
  DateTime restStart,
) => (
  taken: [
    for (final c in all)
      if (c.repaidIn == restStart) c.debt,
  ].fold(Duration.zero, (sum, d) => sum + d),
  debt: all.where((c) => c.isFor(restStart)).firstOrNull,
);

/// Второй отдых пары, когда долг [c] — за два сокращённых подряд: у отдыха
/// [restStart] — начало другого; null — сокращённый один.
DateTime? pairedRest(Compensation c, DateTime restStart) {
  final second = c.secondRestStart;
  if (second == null) return null;
  return restStart == second ? c.restStart : second;
}

/// Debt state in whole minutes: the one-second tick does not rebuild the row.
typedef _Compensation = ({
  int debt,
  int progress,
  DateTime? dueBy,

  /// Ближайший по сроку долг, когда долгов несколько: «21:00 до 12.10»;
  /// null — долг один или водитель на отдыхе.
  int? first,
  DateTime? until,
  bool resting,
  bool inTime,
  bool done,
  Tone tone,
});

_Compensation? _compensation(ComplianceSnapshot s) {
  final rest = s.restCompensation;
  final next = rest?.next;
  final until = rest?.until;
  final untilAll = rest?.untilAll;
  final tone = toneOf(
    s,
    violation: InfringementType.compensationOverdue,
    warning: InfringementType.compensationSoon,
  );
  // Отдых успевает погасить долги: весь долг этого отдыха — уже
  // присоединённый и тот, что он ещё погасит, — и до какого времени
  // отдыхать. После двух сокращённых по 24 ч — 42:00 до 45 + 42 ч.
  if (rest != null && rest.planned.isNotEmpty && untilAll != null) {
    final total = rest.total;
    final done = total - atLeastZero(untilAll.difference(s.now));
    return (
      debt: minutes(total),
      progress: minutes(atLeastZero(done)),
      dueBy: rest.planned
          .map((c) => c.dueBy)
          .reduce((a, b) => a.isBefore(b) ? a : b),
      first: null,
      until: minuteOf(untilAll),
      resting: true,
      inTime: true,
      done: false,
      tone: tone,
    );
  }
  if (rest != null && next != null && until != null) {
    final left = until.difference(s.now);
    final done = next.debt - (left.isNegative ? Duration.zero : left);
    return (
      debt: minutes(next.debt),
      progress: minutes(done.isNegative ? Duration.zero : done),
      dueBy: next.dueBy,
      first: null,
      until: minuteOf(until),
      resting: true,
      inTime: rest.inTime,
      done: false,
      tone: rest.inTime ? tone : Tone.warning,
    );
  }
  if (rest != null && rest.taken > Duration.zero) {
    return (
      debt: minutes(rest.taken),
      progress: minutes(rest.taken),
      dueBy: null,
      first: null,
      until: null,
      resting: true,
      inTime: true,
      done: true,
      tone: Tone.rest,
    );
  }
  final c = s.compensation;
  if (c == null) return null;
  // Сколько всего компенсации нужно взять: все долги, после двух
  // сокращённых подряд — один на оба
  return (
    debt: minutes(s.compensationDebt),
    progress: 0,
    dueBy: c.dueBy,
    first: s.unpaidCompensations.length > 1 ? minutes(c.debt) : null,
    until: null,
    resting: false,
    inTime: true,
    done: false,
    tone: tone,
  );
}

/// "Compensation" in the "Rest" section of the home screen: only when there is
/// a debt or the rest in progress has repaid one. The value is the whole debt
/// (after two reduced rests in a row — one debt for both, repaid only in
/// full); during a rest — until when to rest to repay it.
class CompensationRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _compensation);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final colors = context.colors;
    final debt = Duration(minutes: s.debt);
    final (dueBy, until, first) = (s.dueBy, s.until, s.first);
    final chip = s.done
        ? StatusChip(l.chipCompensationDone, tone: Tone.rest)
        : switch (s.tone) {
            Tone.violation => StatusChip(
              l.chipCompensationOverdue,
              tone: Tone.violation,
            ),
            Tone.warning when s.inTime => StatusChip(
              l.chipCompensationSoon,
              tone: Tone.warning,
            ),
            _ => null,
          };
    final String left;
    if (s.done) {
      left = l.compensationTakenHere;
    } else if (!s.resting) {
      left = l.compensationAttach;
    } else if (!s.inTime) {
      left = l.compensationTooLate;
    } else {
      left = l.compensationRestUntil(
        until == null ? '' : formatWeekdayClock(until, context.localeTag),
      );
    }
    return LimitRow(
      title: l.rowCompensation,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const WeeklyRestScreen())),
      chip: chip,
      value: DurationValue(
        formatHm(debt),
        spoken: spokenDuration(l, debt),
        color: s.done
            ? colors.restText
            : s.tone == Tone.violation
            ? colors.errorText
            : null,
      ),
      bar: LimitBar(
        value: Duration(minutes: s.progress),
        max: debt,
        color: s.tone == Tone.violation ? colors.errorText : colors.rest,
      ),
      left: left,
      // Срок — через недели: дата, а не день недели. Долгов несколько —
      // ближайший и его срок.
      right: dueBy == null
          ? null
          : first == null
          ? l.statusBy(formatDayMonth(dueBy))
          : l.weeklyCompensationValue(
              formatHm(Duration(minutes: first)),
              formatDayMonth(dueBy),
            ),
    );
  }
}
