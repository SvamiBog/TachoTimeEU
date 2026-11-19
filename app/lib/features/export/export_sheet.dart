/// The "Export report" sheet (screen 16).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/sheet_body.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/features/export/export_sections.dart';
import 'package:tachogo/features/export/report_exporter.dart';
import 'package:tachogo/features/journal/date_time_sheet.dart';
import 'package:tachogo/features/settings/language_sheet.dart';

/// Шторка «Экспорт отчёта» (экран 16): период, PDF или CSV, язык PDF,
/// страны и заметки. Готовый файл уходит в системное «Поделиться».
Future<void> showExportSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const ExportSheet(),
    );

/// "Export report" (screen 16): period, PDF or CSV, PDF language, countries and
/// notes. The finished file goes to the system "Share" menu.
class ExportSheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

/// Keeps the chosen period, format, language and the custom days.
class _ExportSheetState extends ConsumerState<ExportSheet> {
  ReportPeriod _period = ReportPeriod.days28;
  ReportFormat _format = ReportFormat.pdf;
  bool _notes = true;
  bool _busy = false;

  /// Язык PDF, выбранный в этой шторке; null — из настроек.
  String? _language;

  /// Язык PDF: выбранный, последний из настроек или язык интерфейса.
  /// CSV — для программ, его заголовки не переводятся.
  String _reportLanguage(BuildContext context) {
    bool supported(String? code) => AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == code,
    );
    final saved = ref.watch(preferencesProvider).value?.reportLanguage;
    return _language ??
        (supported(saved)
            ? saved!
            : Localizations.localeOf(context).languageCode);
  }

  /// Свой период: дни по календарю телефона; null — сегодня и неделю назад.
  DateTime? _first;
  DateTime? _last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
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
    final language = _reportLanguage(context);

    return SheetBody(
      label: l.journalExport,
      children: [
        Semantics(
          header: true,
          child: Text(l.journalExport, style: AppTextStyles.header),
        ),
        const SizedBox(height: AppSpacing.s16),
        ExportPeriodSection(
          period: _period,
          range: range,
          count: count,
          onPeriod: (p) => setState(() => _period = p),
          onFrom: () => unawaited(
            _pickDay(
              title: l.exportFrom,
              initial: first,
              max: now,
              onPicked: (d) => _first = d,
            ),
          ),
          onTo: () => unawaited(
            _pickDay(
              title: l.exportTo,
              initial: last,
              max: now,
              onPicked: (d) => _last = d,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s20),
        ExportFormatSection(
          format: _format,
          language: language,
          onFormat: (f) => setState(() => _format = f),
          onLanguage: () => unawaited(_pickLanguage(language)),
        ),
        const SizedBox(height: AppSpacing.s8),
        ExportNotesSwitch(
          value: _notes,
          onChanged: (v) => setState(() => _notes = v),
        ),
        const SizedBox(height: AppSpacing.s16),
        PrimaryButton(
          label: l.exportCreate,
          icon: Icons.file_download_outlined,
          onPressed: count == 0 || _busy
              ? null
              : () => unawaited(_export(journal, range, language)),
        ),
      ],
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

  Future<void> _pickLanguage(String selected) async {
    final picked = await showReportLanguageSheet(context, selected: selected);
    if (picked == null || !mounted) return;
    setState(() => _language = picked);
    // В следующий раз — тот же язык: водитель ездит через одни страны
    unawaited(ref.read(settingsRepositoryProvider).setReportLanguage(picked));
  }

  Future<void> _export(
    Journal journal,
    TimeRange range,
    String language,
  ) async {
    final l = context.l10n;
    // Отчёт — на выбранном языке, сообщение об ошибке — на языке интерфейса
    final report = lookupAppLocalizations(Locale(language));
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
            l: report,
            locale: Locale(language).toLanguageTag(),
          );
      navigator.pop();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.exportFailed)));
      if (mounted) setState(() => _busy = false);
    }
  }
}
