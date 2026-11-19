/// Rows of a journal week: a shift and a weekly rest.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';

/// A shift row: day, countries, time, totals. A tap opens the day details.
class JournalShiftRow extends StatelessWidget {
  const new(this.journal, this.shift, {super.key});

  final Journal journal;
  final JournalShift shift;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = shift;
    final route = routeOf(journal.metaOf(s));
    final time = shiftTimeOf(l, s);
    return Semantics(
      button: true,
      label: l.journalShiftSpoken(
        formatWeekdayFull(s.start, context.localeTag),
        route,
        time,
        spokenDuration(l, s.driving),
        spokenDuration(l, s.span),
        restSpokenOf(l, s),
      ),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => openShiftDay(context, keyOf(s)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: AppSpacing.s14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShiftDay(s.start),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ShiftRoute(
                      route: route,
                      manual: s.manual != null,
                      time: time,
                      live: s.end == null,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    ShiftMetrics(s),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The day column of a shift row: the short weekday over the day of the month.
class _ShiftDay extends StatelessWidget {
  const new(this.start);

  final DateTime start;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 44,
    child: Column(
      children: [
        Text(
          formatWeekdayShort(start, context.localeTag),
          style: AppTextStyles.small.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text('${start.toLocal().day}', style: AppTextStyles.modeTimer),
      ],
    ),
  );
}

/// "PL → D  manual" and the shift's time; the time of a shift in progress is
/// in the driving colour.
class _ShiftRoute extends StatelessWidget {
  const new({
    required this.route,
    required this.manual,
    required this.time,
    required this.live,
  });

  final String route;

  /// Смена внесена итогами — подпись «вручную».
  final bool manual;
  final String time;

  /// Смена идёт.
  final bool live;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s8,
      runSpacing: 2,
      children: [
        Text.rich(
          TextSpan(
            text: route,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            children: [
              if (manual)
                TextSpan(
                  text: '  ${context.l10n.journalManual}',
                  style: AppTextStyles.small.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Text(
          time,
          style: AppTextStyles.numericCaption.copyWith(
            color: live ? colors.drive : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Долг за сокращённый отдых и чем он погашен, с каким отдыхом он общий и
/// долг, погашенный этим отдыхом: «Долг 21:00 — погашен 05.10 · …».
/// Пусто — у отдыха нет компенсации.
String _compensationText(
  AppLocalizations l,
  ({Duration taken, Compensation? debt}) of,
  DateTime restStart,
) {
  final (:taken, :debt) = of;
  final repaidIn = debt?.repaidIn;
  final debtState = debt == null
      ? null
      : repaidIn != null
      ? l.compensationRepaidOn(formatDayMonth(repaidIn))
      : l.compensationAttachBy(formatDayMonth(debt.dueBy));
  // Два сокращённых подряд — один долг на оба: у каждого — с каким
  final paired = debt == null ? null : pairedRest(debt, restStart);
  return [
    if (debt != null && debtState != null)
      '${l.compensationDebt(formatHm(debt.debt))} — $debtState',
    if (paired != null) l.compensationTogetherWith(formatDayMonth(paired)),
    if (taken > Duration.zero) l.compensationTakenValue(formatHm(taken)),
  ].join(' · ');
}

/// A weekly rest row with its status and the compensation debt it created or
/// repaid.
class JournalWeeklyRestRow extends ConsumerWidget {
  const new(this.rest, {super.key});

  final WeeklyRest rest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    final end = rest.end;
    final title = l.journalWeeklyRest(l.restStatus(rest.status.name));
    final when =
        '${formatDayMonthClock(rest.start)} → '
        '${end == null ? l.weeklyNow : formatDayMonthClock(end)}';
    // Долг за сокращённый отдых и чем он погашен; долг, погашенный им
    final all = watchSnapshot(ref, (s) => ValueList(s.compensations));
    final of = compensationOfRest(all?.items ?? const [], rest.start);
    final compensation = _compensationText(l, of, rest.start);
    final debt = of.debt;
    return Semantics(
      container: true,
      label:
          '$title. $when. ${spokenDuration(l, rest.duration)}'
          '${compensation.isEmpty ? '' : '. $compensation'}',
      excludeSemantics: true,
      child: ColoredBox(
        color: colors.restBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: AppSpacing.s14,
          ),
          child: Row(
            children: [
              ModeIcon(DriverMode.rest, size: 22, color: colors.rest),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _RestTexts(
                  title: title,
                  when: when,
                  compensation: compensation,
                  owed: debt != null && debt.repaidIn == null,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                formatHm(rest.duration),
                style: AppTextStyles.value.copyWith(color: colors.restText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The texts of a weekly rest row: its kind, from and to, the compensation.
class _RestTexts extends StatelessWidget {
  const new({
    required this.title,
    required this.when,
    required this.compensation,
    required this.owed,
  });

  final String title;
  final String when;

  /// Компенсация; пусто — строки нет.
  final String compensation;

  /// Долг ещё не погашен — цвет предупреждения.
  final bool owed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.restText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          when,
          style: AppTextStyles.numericCaption.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (compensation.isNotEmpty)
          Text(
            compensation,
            style: AppTextStyles.caption.copyWith(
              color: owed ? colors.warningText : colors.restText,
            ),
          ),
      ],
    );
  }
}
