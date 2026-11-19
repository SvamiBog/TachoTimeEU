/// History of the "Weekly rest" screen: the previous weekly rest and the
/// compensation debts with their due dates.
library;

import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';

/// The last weekly rest, in whole minutes.
typedef LastWeeklyRest = ({
  DateTime start,
  DateTime? end,
  int duration,
  RestStatus status,
});

/// The previous weekly rests and the compensation debt: the whole debt and,
/// when there are several, each one with its due date.
class WeeklyRestHistory extends StatelessWidget {
  const new({required this.last, required this.debts, super.key});

  final LastWeeklyRest? last;

  /// Непогашенные долги по сроку; за два сокращённых подряд — один на оба.
  final List<Compensation> debts;

  @override
  Widget build(BuildContext context) {
    final last = this.last;
    return CardGroup(
      children: [
        if (last == null) const _NoHistory() else _LastRest(last),
        _CompensationTotal(debts),
        if (debts.length > 1)
          for (final c in debts) _DebtRow(c),
      ],
    );
  }
}

/// «15:00 до 12.10» — долг и срок.
String _debtValue(AppLocalizations l, Compensation c) =>
    l.weeklyCompensationValue(formatHm(c.debt), formatDayMonth(c.dueBy));

/// No weekly rest in the journal yet.
class _NoHistory extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.cardPadding),
    child: Text(
      context.l10n.statusNoData,
      style: AppTextStyles.body.copyWith(color: context.colors.textSecondary),
    ),
  );
}

/// The previous weekly rest: its kind, from and to, how long.
class _LastRest extends StatelessWidget {
  const new(this.last);

  final LastWeeklyRest last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final end = last.end;
    final duration = Duration(minutes: last.duration);
    String moment(DateTime t) => '${formatDayMonth(t)} ${formatClock(t)}';
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          ModeIcon(DriverMode.rest, size: 24, color: colors.rest),
          const SizedBox(width: AppSpacing.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.weeklyPrevious(last.status.name),
                  style: AppTextStyles.rowTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  '${moment(last.start)} → '
                  '${end == null ? l.weeklyNow : moment(end)}',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          DurationText(
            formatHm(duration),
            spoken: spokenDuration(l, duration),
            style: AppTextStyles.value,
          ),
        ],
      ),
    );
  }
}

/// "Compensation": none, the one debt with its due date, or the sum of
/// several.
class _CompensationTotal extends StatelessWidget {
  const new(this.debts);

  final List<Compensation> debts;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final debt = debts.fold(Duration.zero, (sum, c) => sum + c.debt);
    return CardRow(
      vertical: AppSpacing.s12,
      child: Row(
        children: [
          Expanded(
            child: Text(l.weeklyCompensation, style: AppTextStyles.rowTitle),
          ),
          const SizedBox(width: AppSpacing.s8),
          // «15:00 antes del 12.10» на крупном шрифте переносится, а не
          // выталкивает название
          Flexible(
            child: Text(
              switch (debts) {
                [] => l.weeklyCompensationNone,
                [final c] => _debtValue(l, c),
                // Несколько долгов — сколько всего, ниже каждый
                _ => formatHm(debt),
              },
              textAlign: TextAlign.end,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: debts.isEmpty ? colors.restText : colors.drive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One of several debts: for which rest (or pair of rests), how much and by
/// when.
class _DebtRow extends StatelessWidget {
  const new(this.c);

  final Compensation c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              switch (c.secondRestStart) {
                final second? => l.weeklyCompensationForTwo(
                  formatDayMonth(c.restStart),
                  formatDayMonth(second),
                ),
                null => l.weeklyCompensationFor(formatDayMonth(c.restStart)),
              },
              style: AppTextStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Flexible(
            child: Text(
              _debtValue(l, c),
              textAlign: TextAlign.end,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
