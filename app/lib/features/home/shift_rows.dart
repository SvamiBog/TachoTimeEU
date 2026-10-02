import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';

/// Смены списком на экранах лимитов: день, время, вождение; касание —
/// детали дня. Смен нет — [empty] текстом.
class ShiftRows extends StatelessWidget {
  const new(this.shifts, {required this.empty, super.key});

  final List<JournalShift> shifts;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (shifts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding + 4,
        ),
        child: Text(
          empty,
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
