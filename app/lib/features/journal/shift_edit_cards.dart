/// Cards of the shift form (screen 11) below the times: the hint and the error
/// above the form, driving, the rest after the shift with its compensation,
/// and the note.
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
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/pickers.dart';
import 'package:tachogo/features/journal/shift_form.dart';
import 'package:tachogo/features/journal/shift_form_results.dart';

/// A hint card above the form explaining how this shift is edited.
class ShiftEditHint extends StatelessWidget {
  const new(this.hint, {super.key});

  final ShiftHint hint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMin,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: colors.textSecondary),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Text(
                  _text(context.l10n),
                  style: AppTextStyles.caption.copyWith(color: colors.chipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _text(AppLocalizations l) => switch (hint) {
    LiveToManualHint() => l.shiftLiveConvertHint,
    ResumeHint() => l.shiftResumeHint,
    EndNowHint(:final at) => l.shiftEndNowHint(formatClock(at)),
    LiveEditHint() => l.shiftLiveHint,
    BecomesCurrentHint(:final start, :final mode) => l.shiftOngoingHint(
      formatClock(start),
      l.modeName(mode),
    ),
    ToManualHint() => l.shiftConvertHint,
  };
}

/// Why the form was not saved, under the header; read aloud when it appears.
class ShiftErrorBanner extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screenPadding,
      0,
      AppSpacing.screenPadding,
      AppSpacing.betweenCardsMin,
    ),
    child: Semantics(
      liveRegion: true,
      child: StatusBanner(text, tone: Tone.violation),
    ),
  );
}

/// The "Driving" card: the day's driving and the continuous driving at the end
/// of the shift; a tap opens the duration sheet where the form allows it.
class ShiftDrivingCard extends StatelessWidget {
  const new({
    required this.form,
    required this.limits,
    required this.onDriving,
    required this.onContinuous,
    super.key,
  });

  final ShiftForm form;
  final DrivingLimits limits;
  final ValueChanged<Duration> onDriving;
  final ValueChanged<Duration> onContinuous;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final values = form.values;
    final continuousAuto = form.continuousAuto;
    return CardGroup(
      children: [
        _ValueRow(
          label: l.shiftPerDay,
          caption: limits.editable ? null : l.shiftDrivingAfterRest,
          value: values.driving,
          onTap: limits.editable
              ? () => unawaited(
                  _pickDuration(
                    context,
                    title: l.shiftPerDay,
                    value: values.driving,
                    min: limits.min,
                    max: limits.max,
                    onPicked: onDriving,
                  ),
                )
              : null,
        ),
        _ValueRow(
          label: l.dayContinuousAtEnd,
          caption: continuousAuto ? l.shiftLiveContinuous : null,
          value: form.continuousAtEnd,
          onTap: continuousAuto || values.driving == Duration.zero
              ? null
              : () => unawaited(
                  _pickDuration(
                    context,
                    title: l.dayContinuousAtEnd,
                    value: values.continuous,
                    onPicked: onContinuous,
                  ),
                ),
        ),
      ],
    );
  }
}

/// Шторка длительности; выбранное значение — в [onPicked], если строка ещё
/// на экране.
Future<void> _pickDuration(
  BuildContext context, {
  required String title,
  required Duration value,
  required ValueChanged<Duration> onPicked,
  Duration min = Duration.zero,
  Duration? max,
}) async {
  final picked = await showDurationSheet(
    context,
    title: title,
    initial: value,
    min: min,
    max: max,
  );
  if (picked != null && context.mounted) onPicked(picked);
}

/// The "Rest after the shift" card: the kind of rest, split 3 + 9, how long
/// the rest lasts and the compensation in it, as the journal counts them.
class ShiftRestCard extends ConsumerWidget {
  const new({
    required this.form,
    required this.shifts,
    required this.now,
    required this.onRest,
    required this.onSplit,
    super.key,
  });

  final ShiftForm form;

  /// Смены журнала: отдых ручной смены длится до начала следующей.
  final Iterable<JournalShift> shifts;
  final DateTime now;
  final ValueChanged<RestKind> onRest;
  final ValueChanged<bool> onSplit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final values = form.values;
    final crew = ref.watch(
      complianceSettingsProvider.select((a) => a.value?.crew),
    );
    final rest = form.restPreview(
      shifts: shifts,
      now: now,
      crew: crew ?? CrewMode.solo,
    );
    // Снимок смотрим, только пока отдых есть: строки компенсации — под ним
    final compensation = rest == null
        ? null
        : _compensationOf(ref, form.compensationRestStart);
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: SegmentedTabs<RestKind>(
            options: [
              (value: RestKind.none, label: l.shiftRestNone, detail: null),
              (value: RestKind.daily, label: l.shiftRestDaily, detail: null),
              (value: RestKind.weekly, label: l.shiftRestWeekly, detail: null),
            ],
            value: values.restKind,
            onChanged: onRest,
          ),
        ),
        if (values.restKind == RestKind.daily && !form.restOngoing)
          _SplitRow(split: values.split, onChanged: onSplit),
        if (rest != null) _RestDurationRow(rest, chosen: values.restKind),
        if (compensation != null) ...[
          if (compensation.debt case final debt?)
            _CompensationDebtRow(
              debt: debt,
              restStart: compensation.restStart,
              now: now,
            ),
          if (compensation.taken > Duration.zero)
            _ValueRow(
              label: l.rowCompensation,
              caption: l.compensationTakenHere,
              value: compensation.taken,
              chip: StatusChip(l.chipCompensationDone, tone: Tone.rest),
            ),
          if ((compensation.next, compensation.until) case (
            final next?,
            final until?,
          ))
            _CompensationNextRow(
              debt: next.debt,
              until: until,
              inTime: compensation.inTime,
            ),
        ],
      ],
    );
  }
}

/// Compensation debts from the snapshot, for the rest rows of the form.
typedef _CompensationView = ({
  ValueList<Compensation> all,
  DateTime? restStart,
  Compensation? next,
  DateTime? until,
  bool inTime,
});

_CompensationView _compensationView(ComplianceSnapshot s) {
  final plan = s.restCompensation;
  final until = plan?.until;
  return (
    all: ValueList(s.compensations),
    restStart: s.offDutyRest?.start,
    next: plan?.next,
    until: until == null ? null : minuteOf(until),
    inTime: plan?.inTime ?? false,
  );
}

/// Compensation in the rest after the shift, as the journal counted it: the
/// debt for this rest, the debt attached to it and the debt to attach to the
/// rest in progress.
typedef _RestCompensation = ({
  DateTime restStart,
  Compensation? debt,
  Duration taken,
  Compensation? next,
  DateTime? until,
  bool inTime,
});

/// Компенсация в отдыхе с начала [restStart], как её посчитал журнал: долг,
/// присоединённый к этому отдыху, долг за сам отдых, если он сокращённый
/// недельный, и сколько ещё отдыхать, если отдых идёт. null — отдыха нет
/// или время смены меняется и журнал ещё не пересчитан.
_RestCompensation? _compensationOf(WidgetRef ref, DateTime? restStart) {
  final view = watchSnapshot(ref, _compensationView);
  if (view == null || restStart == null) return null;
  final (:taken, :debt) = compensationOfRest(view.all.items, restStart);
  return (
    restStart: restStart,
    debt: debt,
    taken: taken,
    next: restStart == view.restStart ? view.next : null,
    until: view.until,
    inTime: view.inTime,
  );
}

/// "Split rest 3 + 9" with a switch, for a daily rest.
class _SplitRow extends StatelessWidget {
  const new({required this.split, required this.onChanged});

  final bool split;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
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
                  Text(l.shiftSplit, style: AppTextStyles.rowTitle),
                  Text(
                    l.shiftSplitHint,
                    style: AppTextStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Switch(value: split, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// How long the rest after the shift lasts and its rating. The duration is
/// not entered: the rest lasts until the next shift starts.
class _RestDurationRow extends StatelessWidget {
  const new(this.rest, {required this.chosen});

  final RestPreview rest;

  /// Вид отдыха, выбранный в форме.
  final RestKind chosen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final restEnd = rest.end;
    final status = rest.status;
    return _ValueRow(
      label: l.shiftDuration,
      caption: rest.kind == RestKind.weekly && chosen == RestKind.daily
          ? l.shiftRestCountsWeekly
          : restEnd != null
          ? l.shiftRestUntilNext(
              '${formatWeekdayDay(restEnd, context.localeTag)} '
              '${formatClock(restEnd)}',
            )
          : l.shiftRestAutoHint,
      value: floorToMinute(rest.duration),
      chip: rest.ongoing
          ? StatusChip(l.journalOngoing, tone: Tone.rest)
          : status == null
          ? null
          : StatusChip(
              l.restStatus(status.name),
              tone: switch (status) {
                RestStatus.full => Tone.rest,
                RestStatus.reduced => Tone.warning,
                RestStatus.insufficient => Tone.violation,
              },
            ),
    );
  }
}

/// The compensation debt for this rest when it is a reduced weekly one: when
/// it was repaid or by when to attach it.
class _CompensationDebtRow extends StatelessWidget {
  const new({required this.debt, required this.restStart, required this.now});

  final Compensation debt;
  final DateTime restStart;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final repaidIn = debt.repaidIn;
    // Два сокращённых подряд — один долг на оба
    final paired = pairedRest(debt, restStart);
    return _ValueRow(
      label: l.weeklyCompensation,
      caption: [
        if (repaidIn != null)
          l.compensationRepaidOn(formatDayMonth(repaidIn))
        else
          l.compensationAttachBy(formatDayMonth(debt.dueBy)),
        if (paired != null) l.compensationTogetherWith(formatDayMonth(paired)),
      ].join(' · '),
      value: debt.debt,
      chip: repaidIn != null
          ? StatusChip(l.chipCompensationDone, tone: Tone.rest)
          : debt.dueBy.isBefore(now)
          ? StatusChip(l.chipCompensationOverdue, tone: Tone.violation)
          : null,
    );
  }
}

/// The debt to attach to the rest in progress: until when to rest, or that
/// this rest is too late for it.
class _CompensationNextRow extends StatelessWidget {
  const new({required this.debt, required this.until, required this.inTime});

  final Duration debt;
  final DateTime until;
  final bool inTime;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _ValueRow(
      label: l.rowCompensation,
      caption: inTime
          ? l.compensationRestUntil(
              formatWeekdayClock(until, context.localeTag),
            )
          : l.compensationTooLate,
      value: debt,
    );
  }
}

/// The "Notes" field of the form.
class ShiftNoteField extends StatelessWidget {
  const new({required this.controller, required this.onChanged, super.key});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        minLines: 3,
        maxLines: 6,
        style: AppTextStyles.body,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: context.l10n.shiftNotesHint,
          hintStyle: AppTextStyles.body.copyWith(color: colors.textSecondary),
          filled: true,
          fillColor: colors.surface,
          contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.modeButton),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// A "label — value ›" row: a tap opens the duration sheet.
class _ValueRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.caption,
    this.chip,
    this.onTap,
  });

  final String label;
  final String? caption;
  final Duration value;
  final StatusChip? chip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = this.caption;
    final chip = this.chip;
    final body = CardRow(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.rowTitle),
                if (caption != null)
                  Text(
                    caption,
                    style: AppTextStyles.small.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (chip != null) ...[const SizedBox(width: AppSpacing.s8), chip],
          const SizedBox(width: AppSpacing.s8),
          DurationText(
            formatHm(value),
            spoken: spokenDuration(l, value),
            style: AppTextStyles.value,
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.s4),
            Icon(Icons.chevron_right, color: colors.textSecondary),
          ],
        ],
      ),
    );
    return MergeSemantics(
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
  }
}
