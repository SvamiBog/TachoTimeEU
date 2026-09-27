import 'dart:typed_data';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/export/pdf_report.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Отдаёт файл водителю: системное меню «Поделиться» — почта, мессенджер,
/// сохранение в файлы. В тестах подменяется.
abstract interface class ReportSharer {
  Future<void> share({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  });
}

class SystemReportSharer implements ReportSharer {
  const new();

  @override
  Future<void> share({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: mimeType, name: fileName)],
        fileNameOverrides: [fileName],
      ),
    );
  }
}

final reportSharerProvider = Provider<ReportSharer>(
  (ref) => const SystemReportSharer(),
);

/// Формат отчёта.
enum ReportFormat { pdf, csv }

/// Выгрузка отчёта — Premium-операция (docs/premium.md, закрытие — Фаза 5):
/// здесь будет вторая проверка `EntitlementService`, кроме замка на экране.
class ReportExporter {
  new(this._sharer, {AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final ReportSharer _sharer;
  final AssetBundle _bundle;

  /// Собирает отчёт за [range] и отдаёт файл. Возвращает имя файла.
  Future<String> export({
    required Journal journal,
    required TimeRange range,
    required ReportFormat format,
    required bool includeNotes,
    required CrewMode crew,
    required AppLocalizations l,
    required String locale,
  }) async {
    final Uint8List bytes;
    switch (format) {
      case ReportFormat.pdf:
        bytes = await buildPdfReport(
          journal: journal,
          range: range,
          includeNotes: includeNotes,
          crew: crew,
          l: l,
          locale: locale,
          fonts: await ReportFonts.load(_bundle),
        );
      case ReportFormat.csv:
        bytes = Uint8List.fromList(
          csvBytes(buildCsv(journal, range, includeNotes: includeNotes)),
        );
    }
    final name = reportFileName(range, format.name);
    await _sharer.share(
      fileName: name,
      bytes: bytes,
      mimeType: format == ReportFormat.pdf ? 'application/pdf' : 'text/csv',
    );
    return name;
  }
}

final reportExporterProvider = Provider<ReportExporter>(
  (ref) => ReportExporter(ref.watch(reportSharerProvider)),
);
