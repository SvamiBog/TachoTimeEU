/// The PDF "for the roadside check" (screen 16): driver, period, shifts with
/// activities, infringements with articles, countries. Onest and JetBrains Mono
/// are embedded, so Cyrillic, Polish and German letters show on any computer.
/// It is not an official record, and the report says so (PRD, question 8).
library;

import 'dart:typed_data';

import 'package:flutter/services.dart' show AssetBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/export/report_violations.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Font sizes of the report, in points on an A4 sheet. This is paper, not a
/// screen: the design tokens (`AppTextStyles`) do not apply here.
abstract final class _Pt {
  static const body = 8.5;
  static const heading = 10.0;
  static const title = 16.0;
}

/// Report fonts from the app assets.
class ReportFonts {
  const new({
    required this.regular,
    required this.bold,
    required this.mono,
    this.fallback = const [],
  });

  final pw.Font regular;
  final pw.Font bold;

  /// Время и цифры.
  final pw.Font mono;

  /// Письменности, которых нет в Onest: грузинская. На экране их берёт
  /// система, в PDF шрифт встраивается. Пакет `pdf` берёт первый шрифт
  /// с нужной буквой, поэтому начертание одно — обычное.
  final List<pw.Font> fallback;

  static Future<ReportFonts> load(AssetBundle bundle) async {
    Future<pw.Font> font(String name) async =>
        pw.Font.ttf(await bundle.load('assets/fonts/$name.ttf'));
    return ReportFonts(
      regular: await font('Onest-Regular'),
      bold: await font('Onest-Bold'),
      mono: await font('JetBrainsMono-Medium'),
      fallback: [await font('NotoSansGeorgian-Regular')],
    );
  }
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
  final layout = _ReportLayout.of(
    journal: journal,
    includeNotes: includeNotes,
    l: l,
    locale: locale,
    fonts: fonts,
  );
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
  return pw.Document(
    title: l.reportTitle,
    author: 'TachoGo',
    theme: pw.ThemeData.withFont(
      base: fonts.regular,
      bold: fonts.bold,
      fontFallback: fonts.fallback,
    ),
  )..addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(28),
      footer: layout.pageNumber,
      build: (context) => [
        ...layout.header(range),
        for (final MapEntry(key: start, value: list) in byWeek.entries)
          layout.weekTable(start, list),
        ...layout.violations(violations),
        ...layout.closing(),
      ],
    ),
  );
}

/// The parts of the report page: the header with the fields the driver fills
/// in by hand, a table for each week, the infringements and the closing notes.
/// Holds the report's text styles and what every part needs.
final class _ReportLayout {
  const new({
    required this.journal,
    required this.includeNotes,
    required this.l,
    required this.locale,
    required this.base,
    required this.bold,
    required this.mono,
    required this.muted,
  });

  factory of({
    required Journal journal,
    required bool includeNotes,
    required AppLocalizations l,
    required String locale,
    required ReportFonts fonts,
  }) {
    // copyWith(font:) не меняет уже заданный шрифт — стили задаём целиком
    final base = pw.TextStyle(
      fontNormal: fonts.regular,
      fontBold: fonts.bold,
      fontFallback: fonts.fallback,
      fontSize: _Pt.body,
    );
    return _ReportLayout(
      journal: journal,
      includeNotes: includeNotes,
      l: l,
      locale: locale,
      base: base,
      bold: base.copyWith(fontWeight: pw.FontWeight.bold),
      mono: pw.TextStyle(
        fontNormal: fonts.mono,
        fontBold: fonts.mono,
        fontSize: _Pt.body,
      ),
      muted: base.copyWith(color: PdfColors.grey700),
    );
  }

  final Journal journal;

  /// Колонки стран и заметок.
  final bool includeNotes;
  final AppLocalizations l;
  final String locale;
  final pw.TextStyle base;
  final pw.TextStyle bold;

  /// Время и цифры.
  final pw.TextStyle mono;
  final pw.TextStyle muted;

  /// Пустое поле, которое водитель заполнит от руки.
  static final String _blank = '_' * 28;

  /// Номер страницы внизу справа.
  pw.Widget pageNumber(pw.Context context) => pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Text(
      l.reportPage(context.pageNumber, context.pagesCount),
      style: muted,
    ),
  );

  /// Название, поля водителя, период, время создания и часовой пояс.
  List<pw.Widget> header(TimeRange range) => [
    pw.Text(l.reportTitle, style: bold.copyWith(fontSize: _Pt.title)),
    pw.Text(l.reportSubtitle, style: muted.copyWith(fontSize: _Pt.heading)),
    pw.SizedBox(height: 10),
    _fields(range),
    pw.SizedBox(height: 6),
    pw.Text(l.reportTimezone(_zone(journal.now)), style: muted),
  ];

  /// Водитель, карта, машина и фирма — от руки; период и время создания.
  pw.Widget _fields(TimeRange range) {
    final now = journal.now;
    return pw.Table(
      tableWidth: pw.TableWidth.min,
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(),
        1: pw.IntrinsicColumnWidth(),
      },
      children: [
        for (final (label, value) in [
          (l.reportDriver, _blank),
          (l.reportCard, _blank),
          (l.reportVehicle, _blank),
          (l.reportCompany, _blank),
          (
            l.reportPeriod,
            '${utcDay(range.start, year: true)} — '
                '${utcDay(lastDayOf(range), year: true)}',
          ),
          (l.reportGenerated, '${formatDayMonthYear(now)} ${formatClock(now)}'),
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
    );
  }

  /// Пояс телефона, в котором показано время: «CEST, UTC+2:00».
  static String _zone(DateTime now) {
    final offset = now.toLocal().timeZoneOffset;
    return '${now.toLocal().timeZoneName}, UTC'
        '${offset.isNegative ? '−' : '+'}${formatHm(offset.abs())}';
  }

  /// Неделя [start]: заголовок, смены [list] и итог вождения. Неделя —
  /// целиком на одной странице, заголовок не отрывается.
  pw.Widget weekTable(DateTime start, List<JournalShift> list) {
    JournalWeek? summary;
    for (final w in journal.weeks) {
      if (w.start == start) summary = w;
    }
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
          _shiftTable(list),
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

  /// Таблица смен недели: строка заголовков и по строке на смену.
  pw.Widget _shiftTable(List<JournalShift> list) => pw.Table(
    border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
    columnWidths: _columnWidths,
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          for (final (i, h) in _headers.indexed) _cell(h, i, header: true),
        ],
      ),
      for (final s in list)
        pw.TableRow(
          children: [for (final (i, text) in _row(s).indexed) _cell(text, i)],
        ),
    ],
  );

  Map<int, pw.TableColumnWidth> get _columnWidths => {
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
  };

  List<String> get _headers => [
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

  /// Колонки цифр — моноширинным шрифтом: начало, конец, вождение, работа,
  /// готовность, перерывы, смена.
  bool _isNumeric(int column) {
    final first = includeNotes ? 4 : 3;
    return column == 1 ||
        column == 2 ||
        (column >= first && column < first + 5);
  }

  pw.Widget _cell(String text, int column, {bool header = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
    child: pw.Text(
      text,
      style: header ? bold : (_isNumeric(column) ? mono : base),
    ),
  );

  /// Ячейки смены в порядке колонок [_headers].
  List<String> _row(JournalShift s) {
    final meta = journal.metaOf(s);
    final recorded = s.recorded != null;
    return [
      '${formatWeekdayDay(s.start, locale)}${s.manual != null ? ' *' : ''}',
      formatClock(s.start),
      _end(s),
      if (includeNotes) routeText(meta),
      formatHm(s.driving) + _mark(s.driveLevel),
      if (recorded) formatHm(s.otherWork) else '—',
      if (recorded) formatHm(s.availability) else '—',
      if (recorded) formatHm(s.breaks) else '—',
      formatHm(s.span) + _mark(s.spanLevel),
      _rest(s),
      if (includeNotes) meta.note ?? '',
    ];
  }

  /// Пометка оценки журнала: « !» — предупреждение, « !!» — нарушение.
  static String _mark(JournalLevel level) => switch (level) {
    JournalLevel.ok => '',
    JournalLevel.warn => ' !',
    JournalLevel.bad => ' !!',
  };

  String _end(JournalShift s) {
    final e = s.end;
    if (e == null) return l.journalOngoing;
    return isSameLocalDay(s.start, e) ? formatClock(e) : formatDayMonthClock(e);
  }

  /// Отдых после смены: длительность, вид и оценка.
  String _rest(JournalShift s) {
    if (s.rest.kind == RestKind.none) return '—';
    if (s.rest.ongoing) return l.journalOngoing;
    final status = s.rest.status;
    return [
          formatHm(s.rest.duration),
          if (s.rest.kind == RestKind.weekly) l.journalRestWeekly,
          if (status != null) l.restStatus(status.name),
        ].join(' ') +
        _mark(s.restLevel);
  }

  /// Нарушения периода со статьями регламента.
  List<pw.Widget> violations(List<ReportViolation> list) => [
    pw.SizedBox(height: 12),
    pw.Text(l.reportViolations, style: bold.copyWith(fontSize: _Pt.heading)),
    pw.SizedBox(height: 4),
    if (list.isEmpty)
      pw.Text(l.reportNoViolations, style: base)
    else
      for (final v in list)
        pw.Bullet(
          text: '${v.text} — ${l.infrArticle(v.regulation, v.article)}',
          style: base,
        ),
  ];

  /// Что значат пометки, оговорка о неофициальном отчёте и подпись.
  List<pw.Widget> closing() => [
    pw.SizedBox(height: 10),
    pw.Text(l.reportMarks, style: bold),
    pw.Text(l.reportMarkWarn, style: base),
    pw.Text(l.reportMarkBad, style: base),
    pw.Text(l.reportMarkManual, style: base),
    pw.SizedBox(height: 10),
    pw.Text(l.reportDisclaimer, style: base),
    pw.SizedBox(height: 24),
    pw.Text('${l.reportSignature}: $_blank', style: base),
  ];
}
