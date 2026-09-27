import 'dart:typed_data';

import 'package:flutter/services.dart' show AssetBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/l10n/app_localizations.dart';

// PDF «для инспекции» (экран 16): водитель, период, смены с режимами,
// нарушения со статьями, страны. Шрифты Onest и JetBrains Mono встроены —
// кириллица, польские и немецкие буквы видны на любом компьютере. Это не
// официальная запись, отчёт так и говорит (PRD, вопрос 8).

/// Кегль отчёта, пункты на листе A4. Это бумага, а не экран: токены
/// дизайна (`AppTextStyles`) здесь не действуют.
abstract final class _Pt {
  static const body = 8.5;
  static const heading = 10.0;
  static const title = 16.0;
}

/// Шрифты отчёта из ресурсов приложения.
class ReportFonts {
  const new({required this.regular, required this.bold, required this.mono});

  final pw.Font regular;
  final pw.Font bold;

  /// Время и цифры.
  final pw.Font mono;

  static Future<ReportFonts> load(AssetBundle bundle) async {
    Future<pw.Font> font(String name) async =>
        pw.Font.ttf(await bundle.load('assets/fonts/$name.ttf'));
    return ReportFonts(
      regular: await font('Onest-Regular'),
      bold: await font('Onest-Bold'),
      mono: await font('JetBrainsMono-Medium'),
    );
  }
}

/// Нарушение за период со статьёй регламента.
typedef ReportViolation = ({String text, String regulation, String article});

/// Нарушения по оценке журнала: больше 10 ч вождения, больше 15 ч (экипаж —
/// 21 ч) рабочего дня, недостаточный отдых, больше 56 ч за неделю и 90 ч за
/// две. Правила не повторяются — берутся оценки `buildJournal`.
List<ReportViolation> reportViolations(
  Journal journal,
  TimeRange range, {
  required CrewMode crew,
  required AppLocalizations l,
  required String locale,
}) {
  String date(DateTime t) => formatWeekdayDay(t, locale);
  ReportViolation v(String text, InfringementType type, [String? article]) => (
    text: text,
    regulation: type.regulation,
    article: article ?? type.article,
  );
  final spanLimit = workdayWindow(crew) - EuLimits.dailyRestReduced;
  final result = <ReportViolation>[];
  for (final s in shiftsInRange(journal.shifts, range)) {
    if (s.driveLevel == JournalLevel.bad) {
      result.add(
        v(
          l.reportViolationDrive(date(s.start), formatHm(s.driving)),
          InfringementType.dailyDriveExceeded,
        ),
      );
    }
    if (s.spanLevel == JournalLevel.bad) {
      result.add(
        v(
          l.reportViolationSpan(
            date(s.start),
            formatHm(s.span),
            spanLimit.inHours,
          ),
          InfringementType.shiftExceeded,
          crew == CrewMode.team ? '8(5)' : null,
        ),
      );
    }
    if (s.restLevel == JournalLevel.bad) {
      // Отдыху отдельного вида нарушения в движке нет — статья по виду отдыха
      result.add((
        text: l.reportViolationRest(date(s.start), formatHm(s.rest.duration)),
        regulation: '561/2006',
        article: s.rest.kind == RestKind.weekly ? '8(6)' : '8(2)',
      ));
    }
  }
  for (final w in journal.weeks.reversed) {
    final weekEnd = w.start.add(week);
    if (!weekEnd.isAfter(range.start) || !w.start.isBefore(range.end)) {
      continue;
    }
    final label = formatWeekRange(w.start, locale);
    if (w.driving > EuLimits.weeklyDriving) {
      result.add(
        v(
          l.reportViolationWeek(label, formatHm(w.driving)),
          InfringementType.weeklyDriveExceeded,
        ),
      );
    }
    if (w.fortnightDriving > EuLimits.fortnightDriving) {
      result.add(
        v(
          l.reportViolationFortnight(label, formatHm(w.fortnightDriving)),
          InfringementType.fortnightDriveExceeded,
        ),
      );
    }
  }
  return result;
}

/// PDF за период [range]. [includeNotes] — колонки стран и заметок.
Future<Uint8List> buildPdfReport({
  required Journal journal,
  required TimeRange range,
  required bool includeNotes,
  required CrewMode crew,
  required AppLocalizations l,
  required String locale,
  required ReportFonts fonts,
}) => buildPdfDocument(
  journal: journal,
  range: range,
  includeNotes: includeNotes,
  crew: crew,
  l: l,
  locale: locale,
  fonts: fonts,
).save();

/// Документ отчёта до сохранения: страницы уже разложены.
pw.Document buildPdfDocument({
  required Journal journal,
  required TimeRange range,
  required bool includeNotes,
  required CrewMode crew,
  required AppLocalizations l,
  required String locale,
  required ReportFonts fonts,
}) {
  // copyWith(font:) не меняет уже заданный шрифт — стили задаём целиком
  final base = pw.TextStyle(
    fontNormal: fonts.regular,
    fontBold: fonts.bold,
    fontSize: _Pt.body,
  );
  final bold = base.copyWith(fontWeight: pw.FontWeight.bold);
  final mono = pw.TextStyle(
    fontNormal: fonts.mono,
    fontBold: fonts.mono,
    fontSize: _Pt.body,
  );
  final muted = base.copyWith(color: PdfColors.grey700);
  final shifts = shiftsInRange(journal.shifts, range);
  final byWeek = <DateTime, List<JournalShift>>{};
  for (final s in shifts) {
    (byWeek[weekStartUtc(s.start)] ??= []).add(s);
  }
  final violations = reportViolations(
    journal,
    range,
    crew: crew,
    l: l,
    locale: locale,
  );
  final now = journal.now;
  final offset = now.toLocal().timeZoneOffset;
  final zone =
      '${now.toLocal().timeZoneName}, UTC'
      '${offset.isNegative ? '−' : '+'}${formatHm(offset.abs())}';

  String mark(JournalLevel level) => switch (level) {
    JournalLevel.ok => '',
    JournalLevel.warn => ' !',
    JournalLevel.bad => ' !!',
  };
  String rest(JournalShift s) {
    if (s.rest.kind == RestKind.none) return '—';
    if (s.rest.ongoing) return l.journalOngoing;
    final status = s.rest.status;
    return [
          formatHm(s.rest.duration),
          if (s.rest.kind == RestKind.weekly) l.journalRestWeekly,
          if (status != null) l.restStatus(status.name),
        ].join(' ') +
        mark(s.restLevel);
  }

  String end(JournalShift s) {
    final e = s.end;
    if (e == null) return l.journalOngoing;
    return isSameLocalDay(s.start, e) ? formatClock(e) : formatDayMonthClock(e);
  }

  final headers = [
    l.reportDate,
    l.reportStart,
    l.reportEnd,
    if (includeNotes) l.reportCountries,
    l.reportDriving,
    l.reportWork,
    l.reportAvailability,
    l.reportBreaks,
    l.reportSpan,
    l.reportRestAfter,
    if (includeNotes) l.reportNotes,
  ];
  // Колонки цифр — моноширинным шрифтом: начало, конец, вождение, работа,
  // готовность, перерывы, смена
  final first = includeNotes ? 4 : 3;
  final numeric = {1, 2, for (var i = first; i < first + 5; i++) i};
  pw.Widget cell(String text, int column, {bool header = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
    child: pw.Text(
      text,
      style: header ? bold : (numeric.contains(column) ? mono : base),
    ),
  );
  List<String> row(JournalShift s) {
    final meta = journal.metaOf(s);
    final recorded = s.recorded != null;
    return [
      '${formatWeekdayDay(s.start, locale)}${s.manual != null ? ' *' : ''}',
      formatClock(s.start),
      end(s),
      if (includeNotes) routeText(meta),
      formatHm(s.driving) + mark(s.driveLevel),
      if (recorded) formatHm(s.otherWork) else '—',
      if (recorded) formatHm(s.availability) else '—',
      if (recorded) formatHm(s.breaks) else '—',
      formatHm(s.span) + mark(s.spanLevel),
      rest(s),
      if (includeNotes) meta.note ?? '',
    ];
  }

  pw.Widget weekTable(DateTime start, List<JournalShift> list) {
    JournalWeek? summary;
    for (final w in journal.weeks) {
      if (w.start == start) summary = w;
    }
    // Неделя — целиком на одной странице, заголовок не отрывается
    return pw.Inseparable(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 10),
          pw.Text(
            l.reportWeek(formatWeekRange(start, locale)),
            style: bold.copyWith(fontSize: _Pt.heading),
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
            columnWidths: {
              for (final (i, width) in [
                1.1, // дата
                0.8, // начало
                1.0, // конец
                if (includeNotes) 0.9, // страны
                0.8, // вождение
                0.8, // работа
                0.8, // готовность
                0.9, // перерывы
                0.8, // смена
                1.7, // отдых после
                if (includeNotes) 2.4, // заметки
              ].indexed)
                i: pw.FlexColumnWidth(width),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  for (final (i, h) in headers.indexed)
                    cell(h, i, header: true),
                ],
              ),
              for (final s in list)
                pw.TableRow(
                  children: [
                    for (final (i, text) in row(s).indexed) cell(text, i),
                  ],
                ),
            ],
          ),
          if (summary != null) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              l.reportWeekTotal(
                formatHm(summary.driving),
                formatHm(summary.fortnightDriving),
              ),
              style: bold,
            ),
          ],
        ],
      ),
    );
  }

  final doc = pw.Document(
    title: l.reportTitle,
    author: 'TachoGo',
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
  );
  final blank = '_' * 28;
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(28),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          l.reportPage(context.pageNumber, context.pagesCount),
          style: muted,
        ),
      ),
      build: (context) => [
        pw.Text(l.reportTitle, style: bold.copyWith(fontSize: _Pt.title)),
        pw.Text(l.reportSubtitle, style: muted.copyWith(fontSize: _Pt.heading)),
        pw.SizedBox(height: 10),
        pw.Table(
          tableWidth: pw.TableWidth.min,
          columnWidths: const {
            0: pw.IntrinsicColumnWidth(),
            1: pw.IntrinsicColumnWidth(),
          },
          children: [
            for (final (label, value) in [
              (l.reportDriver, blank),
              (l.reportCard, blank),
              (l.reportVehicle, blank),
              (l.reportCompany, blank),
              (
                l.reportPeriod,
                '${utcDay(range.start, year: true)} — '
                    '${utcDay(lastDayOf(range), year: true)}',
              ),
              (
                l.reportGenerated,
                '${formatDayMonthYear(now)} ${formatClock(now)}',
              ),
            ])
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 12, bottom: 3),
                    child: pw.Text(label, style: bold),
                  ),
                  pw.Text(value, style: base),
                ],
              ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Text(l.reportTimezone(zone), style: muted),
        for (final MapEntry(key: start, value: list) in byWeek.entries)
          weekTable(start, list),
        pw.SizedBox(height: 12),
        pw.Text(
          l.reportViolations,
          style: bold.copyWith(fontSize: _Pt.heading),
        ),
        pw.SizedBox(height: 4),
        if (violations.isEmpty)
          pw.Text(l.reportNoViolations, style: base)
        else
          for (final v in violations)
            pw.Bullet(
              text: '${v.text} — ${l.infrArticle(v.regulation, v.article)}',
              style: base,
            ),
        pw.SizedBox(height: 10),
        pw.Text(l.reportMarks, style: bold),
        pw.Text(l.reportMarkWarn, style: base),
        pw.Text(l.reportMarkBad, style: base),
        pw.Text(l.reportMarkManual, style: base),
        pw.SizedBox(height: 10),
        pw.Text(l.reportDisclaimer, style: base),
        pw.SizedBox(height: 24),
        pw.Text('${l.reportSignature}: $blank', style: base),
      ],
    ),
  );
  return doc;
}
