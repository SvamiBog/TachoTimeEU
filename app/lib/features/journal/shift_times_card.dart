/// The "Shift" card of the shift form (screen 11): start and end with country,
/// date and time, and the duration of the shift.
library;

import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/core/widgets/value_row_layout.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/journal/shift_form.dart';

/// The "Shift" card: start and end (country, date, time), duration.
class ShiftTimesCard extends StatelessWidget {
  const new({
    required this.values,
    required this.now,
    required this.onCountry,
    required this.onDate,
    required this.onEndNow,
    super.key,
  });

  final ShiftFormValues values;
  final DateTime now;
  final void Function(CountryTarget target) onCountry;
  final void Function({required bool editEnd}) onDate;

  /// «Сейчас (идёт)» у конца идущей смены: смена кончается сейчас.
  final VoidCallback onEndNow;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final end = values.end;
    return CardGroup(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Side(
                  title: l.shiftStart,
                  country: values.startCountry,
                  at: values.start,
                  onCountry: () => onCountry(CountryTarget.start),
                  onDate: () => onDate(editEnd: false),
                ),
              ),
              VerticalDivider(width: 1, thickness: 1, color: colors.surface2),
              Expanded(
                child: _Side(
                  title: l.shiftEnd,
                  country: values.endCountry,
                  at: end,
                  onRoad: values.restKind == RestKind.none,
                  onCountry: () => onCountry(CountryTarget.end),
                  onDate: () => onDate(editEnd: true),
                  onEndNow: onEndNow,
                ),
              ),
            ],
          ),
        ),
        _SpanRow(start: values.start, end: end, now: now),
      ],
    );
  }
}

/// "Duration" of the shift: to the end or, for an ongoing shift, to now;
/// longer than a manual shift may be — in red. When the value does not fit
/// beside the label, it moves under it.
class _SpanRow extends StatelessWidget {
  const new({required this.start, required this.end, required this.now});

  final DateTime start;

  /// null — смена идёт.
  final DateTime? end;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final span = durationBetween(start, end ?? now);
    // «сейчас» — при длительности: на узком экране уходит под название
    // вместе с ней
    return MergeSemantics(
      child: CardRow(
        child: ValueRowLayout(
          text: Text(l.shiftDuration, style: AppTextStyles.rowTitle),
          value: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (end == null) ...[
                Text(
                  l.shiftNowSuffix,
                  style: AppTextStyles.label.copyWith(color: colors.drive),
                ),
                const SizedBox(width: AppSpacing.s8),
              ],
              DurationText(
                formatHm(span),
                spoken: spokenDuration(l, span),
                style: AppTextStyles.value.copyWith(
                  color: span > maxManualShiftSpan
                      ? colors.errorText
                      : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One side of the shift — start or end: country, date and time, "now" for an
/// ongoing shift.
class _Side extends StatelessWidget {
  const new({
    required this.title,
    required this.country,
    required this.at,
    required this.onCountry,
    required this.onDate,
    this.onRoad = false,
    this.onEndNow,
  });

  final String title;
  final String? country;

  /// null — смена идёт.
  final DateTime? at;
  final bool onRoad;
  final VoidCallback onCountry;
  final VoidCallback onDate;
  final VoidCallback? onEndNow;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final at = this.at;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              if (onRoad) StatusChip(l.shiftOnRoad, tone: Tone.warning),
            ],
          ),
          const SizedBox(height: AppSpacing.s10),
          _CountryButton(title: title, country: country, onTap: onCountry),
          const SizedBox(height: AppSpacing.s10),
          if (at == null)
            _FieldButton(
              icon: Icons.schedule,
              text: l.shiftNowOngoing,
              spoken: l.shiftNowOngoing,
              color: colors.drive,
              onTap: onEndNow ?? onDate,
            )
          else
            _DateTimeButtons(title: title, at: at, onTap: onDate),
        ],
      ),
    );
  }
}

/// The date and time buttons of a side: both open the "Date and time" sheet.
class _DateTimeButtons extends StatelessWidget {
  const new({required this.title, required this.at, required this.onTap});

  /// «Начало» или «Конец» — для чтения вслух.
  final String title;
  final DateTime at;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = context.localeTag;
    final spoken = context.l10n.shiftDateSpoken(
      title,
      formatWeekdayFull(at, locale),
      formatClock(at),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: Icons.calendar_today_outlined,
          text: '${formatWeekdayShort(at, locale)}, ${formatDayMonth(at)}',
          spoken: spoken,
          onTap: onTap,
        ),
        const SizedBox(height: AppSpacing.s6),
        _FieldButton(
          icon: Icons.schedule,
          text: formatClock(at),
          numeric: true,
          spoken: spoken,
          onTap: onTap,
        ),
      ],
    );
  }
}

/// The country button of a side: the tachograph code in a pill, "—" when not
/// chosen.
class _CountryButton extends StatelessWidget {
  const new({required this.title, required this.country, required this.onTap});

  /// «Начало» или «Конец» — для чтения вслух.
  final String title;
  final String? country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final country = this.country;
    return Semantics(
      button: true,
      label: l.shiftCountrySpoken(title, country ?? l.shiftChoose),
      excludeSemantics: true,
      child: Material(
        color: colors.background,
        shape: StadiumBorder(side: BorderSide(color: colors.switchOff)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSize.minTouch,
              minWidth: AppSize.minTouch,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    country ?? '—',
                    style: AppTextStyles.valueSmall.copyWith(
                      color: country == null
                          ? colors.textSecondary
                          : colors.text,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s6),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A date or time field button: icon and value on a dark pad.
class _FieldButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.text,
    required this.spoken,
    required this.onTap,
    this.numeric = false,
    this.color,
  });

  final IconData icon;
  final String text;
  final String spoken;
  final VoidCallback onTap;
  final bool numeric;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = numeric
        ? AppTextStyles.value
        : AppTextStyles.body.copyWith(fontWeight: FontWeight.w600);
    return Semantics(
      button: true,
      label: spoken,
      excludeSemantics: true,
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.icon),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSize.minTouch,
              minWidth: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s8,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: color ?? colors.textSecondary),
                  const SizedBox(width: AppSpacing.s8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        text,
                        maxLines: 1,
                        style: style.copyWith(color: color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
