// PDF «для инспекции». План тестов: EXP-04 в docs/testing.md.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart' show TtfParser;
import 'package:pdf/widgets.dart' as pw;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/export/pdf_report.dart';
import 'package:tachogo/features/export/report_violations.dart';
import 'package:tachogo/l10n/app_localizations.dart';
import 'package:tachogo/l10n/app_localizations_ru.dart';

import '../support/journal_fixtures.dart';

Journal _journal(
  List<ActivityPeriod> periods,
  DateTime now, {
  CrewMode crew = CrewMode.solo,
  Map<DateTime, ShiftMeta> meta = const {},
}) {
  final timeline = analyzeTimeline(periods, now);
  return Journal(
    now: now,
    periods: periods,
    timeline: timeline,
    weeks: buildJournal(timeline: timeline, now: now, crew: crew),
    recordedMeta: meta,
    manualMeta: const {},
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ReportFonts fonts;
  final l = AppLocalizationsRu();

  setUpAll(() async {
    await initializeDateFormatting('ru');
    fonts = await ReportFonts.load(rootBundle);
  });

  group('EXP-04: PDF для инспекции', () {
    test('кириллица, польские и немецкие буквы есть во встроенных шрифтах', () {
      const text =
          'Отчёт о времени вождения ЁЖЇїІіЄєҐґ ąęłńóśźż ĄĘŁŃÓŚŹŻ '
          'äöüß ÄÖÜ čřšžěů → — … · !';
      for (final font in [fonts.regular, fonts.bold]) {
        final ttf = TtfParser((font as pw.TtfFont).data);
        final missing = [
          for (final rune in text.runes)
            if (rune != 0x20 && !ttf.charToGlyphIndexMap.containsKey(rune))
              String.fromCharCode(rune),
        ];
        expect(missing, isEmpty, reason: ttf.fontName);
      }
      const digits = '0123456789:—.→ идёт';
      final mono = TtfParser((fonts.mono as pw.TtfFont).data);
      for (final rune in digits.runes) {
        if (rune == 0x20) continue;
        expect(
          mono.charToGlyphIndexMap.containsKey(rune),
          isTrue,
          reason: String.fromCharCode(rune),
        );
      }
    });

    test('грузинские буквы — в запасном шрифте, отчёт на грузинском', () async {
      const text = 'ანგარიში მართვისა და დასვენების დროის შესახებ';
      final ttf = TtfParser((fonts.fallback.single as pw.TtfFont).data);
      final missing = [
        for (final rune in text.runes)
          if (rune != 0x20 && !ttf.charToGlyphIndexMap.containsKey(rune))
            String.fromCharCode(rune),
      ];
      expect(missing, isEmpty, reason: ttf.fontName);

      await initializeDateFormatting('ka');
      final j = designJournal();
      final bytes = await buildPdfReport(
        journal: _journal(j.periods, j.now),
        range: reportRange(ReportPeriod.week, j.now),
        includeNotes: true,
        crew: CrewMode.solo,
        l: lookupAppLocalizations(const Locale('ka')),
        locale: 'ka',
        fonts: fonts,
      );
      expect(String.fromCharCodes(bytes), contains('NotoSansGeorgian'));
    });

    test('шрифты встроены в файл, отчёт — PDF', () async {
      final j = designJournal();
      final bytes = await buildPdfReport(
        journal: _journal(j.periods, j.now),
        range: reportRange(ReportPeriod.week, j.now),
        includeNotes: true,
        crew: CrewMode.solo,
        l: l,
        locale: 'ru',
        fonts: fonts,
      );
      final raw = String.fromCharCodes(bytes);
      expect(raw, startsWith('%PDF-'));
      expect(raw, contains('/FontFile2'), reason: 'TrueType встроен в файл');
      for (final name in ['Onest-Regular', 'Onest-Bold', 'JetBrainsMono']) {
        expect(raw, contains(name));
      }
    });

    test('длинный период — на нескольких страницах', () {
      final j = designJournal();
      Future<int> pages(ReportPeriod period) async => buildPdfDocument(
        journal: _journal(j.periods, j.now),
        range: reportRange(period, j.now),
        includeNotes: true,
        crew: CrewMode.solo,
        l: l,
        locale: 'ru',
        fonts: fonts,
      ).document.pdfPageList.pages.length;
      expect(pages(ReportPeriod.week), completion(1));
      expect(pages(ReportPeriod.days28), completion(greaterThan(1)));
    });

    test('нарушения — со статьями регламента', () {
      final start = DateTime.utc(2026, 9, 21, 4);
      final periods = consecutive(start, [
        (DriverMode.rest, const Duration(hours: 11)),
        (DriverMode.driving, const Duration(hours: 4, minutes: 30)),
        (DriverMode.rest, const Duration(minutes: 45)),
        (DriverMode.driving, const Duration(hours: 4, minutes: 30)),
        (DriverMode.rest, const Duration(minutes: 45)),
        (DriverMode.driving, const Duration(hours: 1, minutes: 30)),
        (DriverMode.otherWork, const Duration(hours: 4)),
        (DriverMode.rest, const Duration(hours: 7)),
        (DriverMode.driving, const Duration(hours: 1)),
      ], open: true);
      final now = DateTime.utc(2026, 9, 22, 13);
      final range = reportRange(ReportPeriod.week, now);
      final violations = reportViolations(
        _journal(periods, now),
        range,
        crew: CrewMode.solo,
        l: l,
        locale: 'ru',
      );
      expect(violations.map((v) => v.article), ['6(1)', '8(2)']);
      expect(
        violations.first.text,
        'пн 21.09: суточное вождение 10:30 — '
        'больше 10 ч',
      );
      expect(violations.first.regulation, '561/2006');
      expect(violations[1].text, contains('больше 15 ч'));
    });

    test('экипаж — рабочий день по ст. 8(5), лимит 21 ч', () {
      final periods = consecutive(DateTime.utc(2026, 9, 21, 4), [
        (DriverMode.rest, const Duration(hours: 11)),
        (DriverMode.otherWork, const Duration(hours: 22)),
        (DriverMode.rest, const Duration(hours: 9)),
      ], open: true);
      final now = DateTime.utc(2026, 9, 23);
      final violations = reportViolations(
        _journal(periods, now, crew: CrewMode.team),
        reportRange(ReportPeriod.week, now),
        crew: CrewMode.team,
        l: l,
        locale: 'ru',
      );
      expect(violations.single.article, '8(5)');
      expect(violations.single.text, contains('больше 21 ч'));
    });

    test('недостаточный отдых и 56 ч за неделю', () {
      final periods = [
        for (var day = 14; day <= 19; day++)
          ...consecutive(DateTime.utc(2026, 9, day, 6), [
            (DriverMode.driving, const Duration(hours: 4, minutes: 30)),
            (DriverMode.rest, const Duration(minutes: 45)),
            (DriverMode.driving, const Duration(hours: 5)),
            (DriverMode.rest, const Duration(hours: 13, minutes: 45)),
          ]),
      ];
      final now = DateTime.utc(2026, 9, 20, 12);
      final violations = reportViolations(
        _journal(periods, now),
        reportRange(ReportPeriod.week, now),
        crew: CrewMode.solo,
        l: l,
        locale: 'ru',
      );
      expect(violations.map((v) => v.article), contains('6(2)'));
      expect(
        violations.firstWhere((v) => v.article == '6(2)').text,
        'Неделя 14–20 сентября: вождение 57:00 — больше 56 ч',
      );
    });

    test('без нарушений — пустой список', () {
      final j = designJournal();
      expect(
        reportViolations(
          _journal(j.periods, j.now),
          reportRange(ReportPeriod.days28, j.now),
          crew: CrewMode.solo,
          l: l,
          locale: 'ru',
        ),
        isEmpty,
      );
    });
  });
}
