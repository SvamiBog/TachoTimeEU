/// Parts of the "Export report" sheet: the period with its dates, the format
/// with the PDF language, the notes switch and the fields they are built of.
library;

import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/l10n/languages.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/export/report_exporter.dart';

/// "PERIOD": the period pills, the dates of the period (two day buttons for a
/// custom one) and how many shifts it holds.
class ExportPeriodSection extends StatelessWidget {
  const new({
    required this.period,
    required this.range,
    required this.count,
    required this.onPeriod,
    required this.onFrom,
    required this.onTo,
    super.key,
  });

  final ReportPeriod period;
  final TimeRange range;

  /// Смен в периоде.
  final int count;
  final ValueChanged<ReportPeriod> onPeriod;
  final VoidCallback onFrom;
  final VoidCallback onTo;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.exportPeriod.toUpperCase(),
          style: AppTextStyles.section.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s10),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final (p, label) in [
              (ReportPeriod.week, l.exportWeek),
              (ReportPeriod.twoWeeks, l.exportTwoWeeks),
              (ReportPeriod.days28, l.exportDays28),
              (ReportPeriod.days56, l.exportDays56),
              (ReportPeriod.custom, l.exportCustom),
            ])
              ChoicePill(
                label,
                selected: period == p,
                onTap: () => onPeriod(p),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        if (period == ReportPeriod.custom)
          Row(
            children: [
              Expanded(
                child: _RangeButton(
                  label: l.exportFromDay(utcDay(range.start)),
                  onTap: onFrom,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _RangeButton(
                  label: l.exportToDay(utcDay(lastDayOf(range))),
                  onTap: onTo,
                ),
              ),
            ],
          )
        else
          _RangeBox(range),
        const SizedBox(height: AppSpacing.s8),
        Text(
          count > 0 ? l.exportCount(count) : l.exportEmpty,
          style: count > 0
              ? caption
              : caption.copyWith(color: colors.warningText),
        ),
      ],
    );
  }
}

/// "FORMAT": PDF or CSV with a hint, and the language of the PDF.
class ExportFormatSection extends StatelessWidget {
  const new({
    required this.format,
    required this.language,
    required this.onFormat,
    required this.onLanguage,
    super.key,
  });

  final ReportFormat format;

  /// Язык PDF: код языка.
  final String language;
  final ValueChanged<ReportFormat> onFormat;
  final VoidCallback onLanguage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.exportFormat.toUpperCase(),
          style: AppTextStyles.section.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s10),
        SegmentedTabs<ReportFormat>(
          options: [
            (value: ReportFormat.pdf, label: l.exportPdf, detail: null),
            (value: ReportFormat.csv, label: l.exportCsv, detail: null),
          ],
          value: format,
          onChanged: onFormat,
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          format == ReportFormat.pdf ? l.exportPdfHint : l.exportCsvHint,
          style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        ),
        if (format == ReportFormat.pdf) ...[
          const SizedBox(height: AppSpacing.s8),
          _LanguageButton(language: language, onTap: onLanguage),
        ],
      ],
    );
  }
}

/// "Countries and notes" with its switch; the screen reader reads them as one.
class ExportNotesSwitch extends StatelessWidget {
  const new({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Row(
      children: [
        Expanded(
          child: Text(context.l10n.exportNotes, style: AppTextStyles.rowTitle),
        ),
        const SizedBox(width: AppSpacing.s12),
        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}

/// The period "26.08 — 23.09" with a calendar icon.
class _RangeBox extends StatelessWidget {
  const new(this.range);

  final TimeRange range;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final from = utcDay(range.start);
    final to = utcDay(lastDayOf(range));
    return Semantics(
      container: true,
      label: context.l10n.exportRangeSpoken(from, to),
      excludeSemantics: true,
      child: _Field(
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.s10),
            Flexible(
              child: Text('$from — $to', style: AppTextStyles.valueSmall),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Report language      Deutsch ›".
class _LanguageButton extends StatelessWidget {
  const new({required this.language, required this.onTap});

  final String language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = languageName(Locale(language));
    return Semantics(
      button: true,
      label: '${context.l10n.exportLanguage}: $name',
      excludeSemantics: true,
      child: _Field(
        onTap: onTap,
        child: Row(
          children: [
            Icon(Icons.translate, size: 18, color: colors.textSecondary),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Text(
                context.l10n.exportLanguage,
                style: AppTextStyles.rowTitle,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(
              name,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.s4),
            Icon(Icons.chevron_right, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// "From 01.09" / "To 10.09" — picks a day of the custom period.
class _RangeButton extends StatelessWidget {
  const new({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Field(
    onTap: onTap,
    horizontal: AppSpacing.s12,
    child: Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: context.colors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.s8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(label, style: AppTextStyles.valueSmall),
          ),
        ),
      ],
    ),
  );
}

/// A field of the sheet: a rounded surface at least 44 dp tall; with [onTap]
/// it is pressed like a button.
class _Field extends StatelessWidget {
  const new({
    required this.child,
    this.onTap,
    this.horizontal = AppSpacing.s14,
  });

  final VoidCallback? onTap;

  /// Поля по бокам: у кнопок «С» и «По» в один ряд — уже.
  final double horizontal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onTap = this.onTap;
    final body = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.minTouch),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: AppSpacing.s10,
        ),
        child: child,
      ),
    );
    if (onTap == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: body,
      );
    }
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.badge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: body),
    );
  }
}
