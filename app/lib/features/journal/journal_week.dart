/// A week of the journal: the card with its header, shifts and weekly rests,
/// and the collapsed past week.
library;

import 'package:flutter/material.dart';
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
import 'package:tachogo/features/journal/journal_rows.dart';

/// An item of a week: a shift or a weekly rest, newest first.
sealed class _Item {
  const new(this.at);

  final DateTime at;
}

/// A shift in the week's list.
class _ShiftItem extends _Item {
  new(this.shift) : super(shift.start);

  final JournalShift shift;
}

/// A weekly rest in the week's list, placed by its end.
class _RestItem extends _Item {
  new(this.rest, DateTime now) : super(rest.end ?? now);

  final WeeklyRest rest;
}

List<_Item> _items(JournalWeek week, DateTime now) =>
    <_Item>[
      for (final s in week.shifts) _ShiftItem(s),
      for (final r in week.weeklyRests) _RestItem(r, now),
    ]..sort((a, b) {
      final byTime = b.at.compareTo(a.at);
      if (byTime != 0) return byTime;
      // Отдых, закончившийся в начале смены, — под ней
      return a is _ShiftItem ? -1 : 1;
    });

/// A week card: header with totals and its shifts and weekly rests.
class JournalWeekCard extends StatelessWidget {
  const new({
    required this.journal,
    required this.week,
    required this.onToggle,
    super.key,
  });

  final Journal journal;
  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WeekHeader(week: week, onToggle: onToggle),
          for (final item in _items(week, journal.now)) ...[
            Divider(height: 1, thickness: 1, color: colors.surface2),
            switch (item) {
              _ShiftItem(:final shift) => JournalShiftRow(journal, shift),
              _RestItem(:final rest) => JournalWeeklyRestRow(rest),
            },
          ],
        ],
      ),
    );
  }
}

final int _weekHours = EuLimits.weeklyDriving.inHours;
final int _fortnightHours = EuLimits.fortnightDriving.inHours;

/// Week header: dates, driving of the week and the collapse toggle.
class _WeekHeader extends StatelessWidget {
  const new({required this.week, required this.onToggle});

  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final range = formatWeekRange(week.start, context.localeTag);
    final weekOver = week.driving > EuLimits.weeklyDriving;
    return Semantics(
      button: true,
      expanded: true,
      label: l.journalWeekSpoken(
        range,
        spokenDuration(l, week.driving),
        spokenDuration(l, week.fortnightDriving),
      ),
      excludeSemantics: true,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _WeekRange(range)),
                  const SizedBox(width: AppSpacing.s8),
                  if (week.isCurrent)
                    StatusChip(l.journalCurrent, tone: Tone.warning)
                  else
                    Icon(
                      Icons.keyboard_arrow_up,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.s10),
              LimitBar(
                value: week.driving,
                max: EuLimits.weeklyDriving,
                color: weekOver ? colors.errorText : colors.drive,
              ),
              const SizedBox(height: AppSpacing.s10),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: AppSpacing.s12,
                runSpacing: 2,
                children: [
                  _Total(
                    label: l.journalDriving,
                    value: week.driving,
                    of: l.journalOf(_weekHours),
                    over: weekOver,
                  ),
                  _Total(
                    label: l.journalFortnight,
                    value: week.fortnightDriving,
                    of: l.journalOf(_fortnightHours),
                    over: week.fortnightDriving > EuLimits.fortnightDriving,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dates of a week in bold: "21–27 September".
class _WeekRange extends StatelessWidget {
  const new(this.range);

  final String range;

  @override
  Widget build(BuildContext context) => Text(
    range,
    style: AppTextStyles.rowTitle.copyWith(fontWeight: FontWeight.w700),
  );
}

/// A driving total of the header: "Driving 35:34 of 56"; over the limit — the
/// value in the error colour.
class _Total extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.of,
    required this.over,
  });

  final String label;
  final Duration value;

  /// «из 56»: предел.
  final String of;
  final bool over;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text.rich(
      TextSpan(
        style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: formatHm(value),
            style: AppTextStyles.numericCaption.copyWith(
              fontWeight: FontWeight.w700,
              color: over ? colors.errorText : colors.text,
            ),
          ),
          TextSpan(text: ' $of'),
        ],
      ),
    );
  }
}

/// A collapsed past week: dates and driving, a tap expands it.
class JournalCollapsedWeek extends StatelessWidget {
  const new({required this.week, required this.onToggle, super.key});

  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final range = formatWeekRange(week.start, context.localeTag);
    return Semantics(
      button: true,
      expanded: false,
      label: l.journalWeekSpoken(
        range,
        spokenDuration(l, week.driving),
        spokenDuration(l, week.fortnightDriving),
      ),
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.modeButton),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onToggle,
          child: CardRow(
            vertical: AppSpacing.s8,
            child: Row(
              children: [
                Expanded(child: _WeekRange(range)),
                const SizedBox(width: AppSpacing.s8),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: '${l.journalCollapsedDriving} '),
                      TextSpan(
                        text: formatHm(week.driving),
                        style: AppTextStyles.numericCaption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
