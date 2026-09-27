import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/export/report_exporter.dart';
import 'package:tachogo/features/journal/pickers.dart';

/// Шторка «Экспорт отчёта» (экран 16): период, PDF для инспекции или CSV,
/// страны и заметки. Готовый файл уходит в системное «Поделиться».
Future<void> showExportSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const ExportSheet(),
    );

class ExportSheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<ExportSheet> {
  ReportPeriod _period = ReportPeriod.days28;
  ReportFormat _format = ReportFormat.pdf;
  bool _notes = true;
  bool _busy = false;

  /// Свой период: дни по календарю телефона; null — сегодня и неделю назад.
  DateTime? _first;
  DateTime? _last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final journal = ref.watch(journalProvider).value;
    if (journal == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final now = journal.now;
    final today = now.toLocal();
    final first = _first ?? DateTime(today.year, today.month, today.day - 6);
    final last = _last ?? DateTime(today.year, today.month, today.day);
    final range = reportRange(_period, now, first: first, last: last);
    final count = shiftsInRange(journal.shifts, range).length;
    final section = AppTextStyles.section.copyWith(color: colors.textSecondary);
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          0,
          AppSpacing.screenPadding + 4,
          24,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: l.journalExport,
          explicitChildNodes: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(l.journalExport, style: AppTextStyles.header),
              ),
              const SizedBox(height: 16),
              Text(l.exportPeriod.toUpperCase(), style: section),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (p, label) in [
                    (ReportPeriod.week, l.exportWeek),
                    (ReportPeriod.twoWeeks, l.exportTwoWeeks),
                    (ReportPeriod.days28, l.exportDays28),
                    (ReportPeriod.custom, l.exportCustom),
                  ])
                    ChoicePill(
                      label,
                      selected: _period == p,
                      onTap: () => setState(() => _period = p),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (_period == ReportPeriod.custom)
                Row(
                  children: [
                    Expanded(
                      child: _RangeButton(
                        label: '${l.exportFrom} ${utcDay(range.start)}',
                        onTap: () => unawaited(
                          _pickDay(
                            title: l.exportFrom,
                            initial: first,
                            max: now,
                            onPicked: (d) => _first = d,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RangeButton(
                        label: '${l.exportTo} ${utcDay(lastDayOf(range))}',
                        onTap: () => unawaited(
                          _pickDay(
                            title: l.exportTo,
                            initial: last,
                            max: now,
                            onPicked: (d) => _last = d,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                _RangeBox(range),
              const SizedBox(height: 8),
              Text(
                count > 0 ? l.exportCount(count) : l.exportEmpty,
                style: count > 0
                    ? caption
                    : caption.copyWith(color: colors.warningText),
              ),
              const SizedBox(height: 20),
              Text(l.exportFormat.toUpperCase(), style: section),
              const SizedBox(height: 10),
              SegmentedTabs<ReportFormat>(
                options: [
                  (value: ReportFormat.pdf, label: l.exportPdf, detail: null),
                  (value: ReportFormat.csv, label: l.exportCsv, detail: null),
                ],
                value: _format,
                onChanged: (f) => setState(() => _format = f),
              ),
              const SizedBox(height: 8),
              Text(
                _format == ReportFormat.pdf ? l.exportPdfHint : l.exportCsvHint,
                style: caption,
              ),
              const SizedBox(height: 8),
              MergeSemantics(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(l.exportNotes, style: AppTextStyles.rowTitle),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: _notes,
                      onChanged: (v) => setState(() => _notes = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.exportCreate,
                icon: Icons.file_download_outlined,
                onPressed: count == 0 || _busy
                    ? null
                    : () => unawaited(_export(journal, range)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDay({
    required String title,
    required DateTime initial,
    required DateTime max,
    required void Function(DateTime) onPicked,
  }) async {
    final day = await showDaySheet(
      context,
      title: title,
      initial: initial,
      max: max,
    );
    if (day == null || !mounted) return;
    setState(() {
      onPicked(day);
      // «С» не позже «По»
      final (a, b) = (_first, _last);
      if (a != null && b != null && a.isAfter(b)) {
        _first = b;
        _last = a;
      }
    });
  }

  Future<void> _export(Journal journal, TimeRange range) async {
    final l = context.l10n;
    final locale = context.localeTag;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(reportExporterProvider)
          .export(
            journal: journal,
            range: range,
            format: _format,
            includeNotes: _notes,
            crew:
                ref.read(complianceSettingsProvider).value?.crew ??
                CrewMode.solo,
            l: l,
            locale: locale,
          );
      navigator.pop();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.exportFailed)));
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Период: «26.08 — 23.09» с календарём.
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.minTouch),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text('$from — $to', style: AppTextStyles.valueSmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// «С 01.09» / «По 10.09» — выбор дня своего периода.
class _RangeButton extends StatelessWidget {
  const new({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.badge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.minTouch),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(label, style: AppTextStyles.valueSmall),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
