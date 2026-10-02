// Шторка «Экспорт отчёта» (экран 16): период, формат, файл уходит в
// «Поделиться». Отправка подменена. План тестов: EXP-01…04.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/export/report_exporter.dart';
import 'package:tachogo/features/journal/journal_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

class _FakeSharer implements ReportSharer {
  final shared = <({String fileName, Uint8List bytes, String mimeType})>[];
  bool fail = false;

  @override
  Future<void> share({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    if (fail) throw StateError('share');
    shared.add((fileName: fileName, bytes: bytes, mimeType: mimeType));
  }
}

void main() {
  setUpAll(loadAppFonts);

  Future<_FakeSharer> open(WidgetTester tester) async {
    final sharer = _FakeSharer();
    final j = designJournal();
    await pumpScreen(
      tester,
      const JournalScreen(),
      overrides: [
        ...journalOverrides(
          periods: j.periods,
          now: j.now,
          shiftMeta: {
            for (final MapEntry(:key, :value) in j.countries.entries)
              key: ShiftMeta(startCountry: value.start, endCountry: value.end),
          },
        ),
        reportSharerProvider.overrideWithValue(sharer),
      ],
    );
    await tester.tap(find.byTooltip('Экспорт отчёта'));
    await tester.pumpAndSettle();
    expect(find.byType(ExportSheet), findsOneWidget);
    return sharer;
  }

  Future<void> create(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Создать отчёт'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Создать отчёт'));
    // PDF собирается и шрифты грузятся по-настоящему
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('по умолчанию 28 дней, PDF, страны и заметки', (tester) async {
    await open(tester);
    expect(find.text('27.08 — 23.09'), findsOneWidget);
    expect(find.text('13 смен в отчёте'), findsOneWidget);
    expect(find.textContaining('Не официальная запись'), findsOneWidget);
    final notes = tester.widget<Switch>(
      find.descendant(
        of: find.byType(ExportSheet),
        matching: find.byType(Switch),
      ),
    );
    expect(notes.value, isTrue);
  });

  testWidgets('EXP-03: «Эта неделя» и «2 недели» — с понедельника', (
    tester,
  ) async {
    await open(tester);
    await tester.tap(find.text('Эта неделя'));
    await tester.pump();
    expect(find.text('21.09 — 23.09'), findsOneWidget);
    expect(find.text('3 смены в отчёте'), findsOneWidget);
    await tester.tap(find.text('2 недели'));
    await tester.pump();
    expect(find.text('14.09 — 23.09'), findsOneWidget);
    expect(find.text('8 смен в отчёте'), findsOneWidget);
  });

  testWidgets('EXP-03: «56 дней» — 56 суток вместе с сегодняшними; формат — '
      'просто PDF', (tester) async {
    await open(tester);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.textContaining('инспекц'), findsNothing);
    await tester.tap(find.text('56 дней'));
    await tester.pump();
    expect(find.text('30.07 — 23.09'), findsOneWidget);
    expect(find.text('13 смен в отчёте'), findsOneWidget);
  });

  testWidgets('CSV за неделю уходит в «Поделиться»', (tester) async {
    final sharer = await open(tester);
    await tester.tap(find.text('Эта неделя'));
    await tester.tap(find.text('CSV · таблица'));
    await tester.pump();
    expect(find.textContaining('время в UTC'), findsOneWidget);
    await create(tester);
    final file = sharer.shared.single;
    expect(file.fileName, 'tachogo_2026-09-21_2026-09-23.csv');
    expect(file.mimeType, 'text/csv');
    final csv = utf8.decode(file.bytes.skip(3).toList());
    expect(csv, startsWith('"activity"'));
    expect(csv, contains('"DRIVING","2026-09-23T07:04:00Z"'));
    expect(csv, contains('"PL","PL"'));
    expect(find.byType(ExportSheet), findsNothing);
  });

  testWidgets('PDF без стран и заметок', (tester) async {
    final sharer = await open(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(ExportSheet),
        matching: find.byType(Switch),
      ),
    );
    await tester.pump();
    await create(tester);
    final file = sharer.shared.single;
    expect(file.fileName, 'tachogo_2026-08-27_2026-09-23.pdf');
    expect(file.mimeType, 'application/pdf');
    expect(String.fromCharCodes(file.bytes.take(5)), '%PDF-');
  });

  testWidgets('свой период: дни из календаря, пустой — кнопка неактивна', (
    tester,
  ) async {
    await open(tester);
    await tester.tap(find.text('Свой период'));
    await tester.pump();
    expect(find.text('С 17.09'), findsOneWidget);
    expect(find.text('По 23.09'), findsOneWidget);
    expect(find.text('5 смен в отчёте'), findsOneWidget);

    await tester.tap(find.text('По 23.09'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('19'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();
    expect(find.text('По 19.09'), findsOneWidget);
    expect(find.text('2 смены в отчёте'), findsOneWidget);

    await tester.tap(find.text('С 17.09'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('19'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();
    expect(find.text('За выбранный период смен нет.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Создать отчёт'),
        matching: find.byWidgetPredicate((w) => w is FilledButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('ошибка отправки — сообщение, шторка остаётся', (tester) async {
    final sharer = (await open(tester))..fail = true;
    await tester.tap(find.text('CSV · таблица'));
    await tester.pump();
    await create(tester);
    expect(sharer.shared, isEmpty);
    expect(
      find.text('Не удалось создать отчёт. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    expect(find.byType(ExportSheet), findsOneWidget);
  });
}
