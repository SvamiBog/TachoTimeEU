// ENG-20 (docs/testing.md): обезличенные журналы с настоящих тахографов —
// нарушения движка совпадают с отчётом программы анализа данных тахографа.
// Фикстуры — test/fixtures/real/*.json, как их собрать — README.md рядом.
// Синтетическая фикстура (`"synthetic": true`) проверяет саму обвязку.

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/fixture.dart';
import '../tool/src/violations.dart';

List<RealJournalFixture> fixtures() {
  final dir = Directory('test/fixtures/real');
  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  return [
    for (final f in files)
      RealJournalFixture.fromJson(
        (jsonDecode(f.readAsStringSync()) as Map).cast<String, Object?>(),
      ),
  ];
}

void main() {
  final all = fixtures();

  test('фикстуры читаются, хотя бы одна — синтетическая проверка обвязки', () {
    expect(all.where((f) => f.synthetic), isNotEmpty);
    for (final f in all) {
      expect(f.periods, isNotEmpty, reason: f.name);
      expect(f.name, isNot(contains(' ')), reason: 'имя — как у файла');
    }
  });

  for (final fixture in all) {
    final kind = fixture.synthetic ? 'синтетика' : 'тахограф';
    test('ENG-20 [$kind] ${fixture.name}: нарушения движка — как в отчёте '
        'программы анализа', () {
      final found = [
        for (final v in journalViolations(
          fixture.periods,
          settings: fixture.settings,
        ))
          (type: v.type, date: DateTime.utc(v.at.year, v.at.month, v.at.day)),
      ];
      final accepted = [...fixture.expected, ...fixture.knownDifferences];
      final missing = [
        for (final e in fixture.expected)
          if (!found.any((f) => sameViolation(f.type, f.date, e)))
            '${e.type.name} ${isoDate(e.date)} ${e.note}',
      ];
      final extra = [
        for (final f in found)
          if (!accepted.any((e) => sameViolation(f.type, f.date, e)))
            '${f.type.name} ${isoDate(f.date)}',
      ];
      // Ошибка движка — исправить с тестом по статье; толкование
      // регламента или ошибка программы — в knownDifferences с причиной.
      expect(missing, isEmpty, reason: 'в отчёте программы есть, движок нет');
      expect(extra, isEmpty, reason: 'движок нашёл, в отчёте программы нет');
    });
  }
}
