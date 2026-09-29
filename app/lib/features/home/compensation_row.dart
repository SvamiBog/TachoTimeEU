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

// Компенсация сокращённого недельного отдыха (ст. 8(6), 8(7)): долг, срок
// и сколько отдыхать, чтобы его погасить. Правила — в движке: гасит долг
// любой отдыхом от 9 ч, если длится 9 ч + долг (недельный — 45 ч + долг).

/// Что отдых начала [restStart] сделал с долгами: сколько долга к нему
/// присоединено и долг за него самого, если это сокращённый недельный.
({Duration taken, Compensation? debt}) compensationOfRest(
  List<Compensation> all,
  DateTime restStart,
) => (
  taken: [
    for (final c in all)
      if (c.repaidIn == restStart) c.debt,
  ].fold(Duration.zero, (sum, d) => sum + d),
  debt: all.where((c) => c.restStart == restStart).firstOrNull,
);

/// Состояние долга по минутам: секундный тик строку не перестраивает.
typedef _Compensation = ({
  int debt,
  int progress,
  DateTime? dueBy,
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
  final tone = toneOf(
    s,
    violation: InfringementType.compensationOverdue,
    warning: InfringementType.compensationSoon,
  );
  if (rest != null && next != null && until != null) {
    final left = until.difference(s.now);
    final done = next.debt - (left.isNegative ? Duration.zero : left);
    return (
      debt: minutes(next.debt),
      progress: minutes(done.isNegative ? Duration.zero : done),
      dueBy: next.dueBy,
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
      until: null,
      resting: true,
      inTime: true,
      done: true,
      tone: Tone.rest,
    );
  }
  final c = s.compensation;
  if (c == null) return null;
  return (
    debt: minutes(c.debt),
    progress: 0,
    dueBy: c.dueBy,
    until: null,
    resting: false,
    inTime: true,
    done: false,
    tone: tone,
  );
}

/// «Компенсация» в разделе «Отдых» главной: только когда есть долг или
/// идущий отдых его погасил. На отдыхе — до какого времени отдыхать.
class CompensationRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _compensation);
    if (s == null) return const SizedBox.shrink();
    final l = context.l10n;
    final colors = context.colors;
    final debt = Duration(minutes: s.debt);
    final (dueBy, until) = (s.dueBy, s.until);
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
      // Срок — через недели: дата, а не день недели
      right: dueBy == null ? null : l.statusBy(formatDayMonth(dueBy)),
    );
  }
}
