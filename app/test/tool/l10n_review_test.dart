// Инструмент вычитки переводов (tool/l10n_review.dart): таблица для
// носителей языка и загрузка их исправлений обратно в ARB без поломки
// подстановок и плюралей. docs/beta/translation-review.md.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/l10n_review.dart';

Map<String, Object?> arb(String lang) => readArb(arbFile(lang));

/// Таблица выгрузки с исправлениями: id → (исправление, комментарий).
List<List<String>> edited(String lang, Map<String, (String, String)> changes) {
  final rows = parseCsv(exportCsv(lang));
  final fix = rows.first.indexOf('correction');
  final comment = rows.first.indexOf('comment');
  return [
    rows.first,
    for (final row in rows.skip(1))
      if (changes[row.first] case (final f, final c))
        List.of(row)
          ..[fix] = f
          ..[comment] = c
      else
        row,
  ];
}

void main() {
  final langs = translations();

  test('переводы — все ARB, кроме русского', () {
    expect(langs, containsAll(['uk', 'pl', 'ro', 'ka', 'uz']));
    expect(langs, isNot(contains('ru')));
  });

  group('ARB записывается без лишних изменений', () {
    for (final lang in ['ru', ...langs]) {
      test(lang, () {
        final file = arbFile(lang);
        final dir = Directory.systemTemp.createTempSync('arb_');
        addTearDown(() => dir.deleteSync(recursive: true));
        final copy = File('${dir.path}/app_$lang.arb');
        writeArb(copy, readArb(file));
        expect(copy.readAsStringSync(), file.readAsStringSync());
      });
    }
  });

  group('plural и select разбираются и собираются обратно', () {
    for (final lang in ['ru', ...langs]) {
      test(lang, () {
        var icu = 0;
        for (final value in arb(lang).values.whereType<String>()) {
          final m = IcuMessage.parse(value);
          if (m == null) continue;
          icu++;
          expect(m.build(), value);
          expect(m.cases, contains('other'));
        }
        expect(icu, greaterThanOrEqualTo(15));
      });
    }
  });

  test('сообщение без конструкции и с подстановками — не ICU', () {
    expect(IcuMessage.parse('с {time}'), isNull);
    expect(IcuMessage.parse('Просто текст'), isNull);
  });

  group('таблица вычитки', () {
    test('каждая строка перевода — в таблице, варианты — отдельно', () {
      for (final lang in langs) {
        final ids = {for (final r in parseCsv(exportCsv(lang)).skip(1)) r[0]};
        for (final MapEntry(:key, :value) in arb(lang).entries) {
          if (key.startsWith('@') || value is! String) continue;
          final icu = IcuMessage.parse(value);
          if (icu == null) {
            expect(ids, contains(key), reason: '$lang: $key');
          } else {
            for (final c in icu.cases.keys) {
              expect(ids, contains('$key#$c'), reason: '$lang: $key#$c');
            }
            expect(ids.contains(key), icu.frame != null, reason: key);
          }
        }
      }
    });

    test('фраза вокруг числа — с меткой, русский — рядом', () {
      final rows = {for (final r in parseCsv(exportCsv('uk')).skip(1)) r[0]: r};
      final frame = rows['infrCardSoonText']!;
      expect(frame[3], 'Осталось [[days]].');
      expect(frame[5], 'Залишилося [[days]].');
      expect(rows['infrCardSoonText#many']![3], '{days} дней');
      expect(rows['infrCardSoonText#many']![5], '{days} днів');
      expect(rows['countryName#PL']![5], 'Польща');
    });

    test('CSV для Excel: BOM, CRLF, значения в кавычках', () {
      final csv = exportCsv('pl');
      expect(csv, startsWith('﻿"id","section"'));
      expect(csv, contains('\r\n'));
      expect(csv.replaceAll('\r\n', ''), isNot(contains('\n')));
    });

    test('какие числа берут форму — по CLDR языка', () {
      expect(pluralNumbers('ru', 'one'), '1, 21, 31, 41, 51, 61, …');
      expect(pluralNumbers('pl', 'few'), '2, 3, 4, 22, 23, 24, …');
      expect(pluralNumbers('pl', 'many'), startsWith('0, 5, 6'));
      expect(pluralNumbers('ro', 'few'), startsWith('0, 2, 3'));
      expect(pluralNumbers('ka', 'one'), '1');
      expect(pluralNumbers('uz', 'other'), startsWith('0, 2, 3'));
    });
  });

  group('загрузка исправлений', () {
    test('таблица без исправлений ничего не меняет', () {
      for (final lang in langs) {
        final translation = arb(lang);
        final before = Map.of(translation);
        final report = applyCorrections(translation, parseCsv(exportCsv(lang)));
        expect(report.applied, isEmpty);
        expect(report.rejected, isEmpty);
        expect(translation, before);
      }
    });

    test('исправление строки, варианта и фразы вокруг числа', () {
      final translation = arb('uk');
      final report = applyCorrections(
        translation,
        edited('uk', {
          'navMore': ('Більше', 'так звичніше'),
          'infrCardSoonText': ('Лишилося [[days]].', ''),
          'infrCardSoonText#other': ('{days} доби', ''),
          'ofLimit': ('', 'гарно'),
        }),
      );
      expect(report.rejected, isEmpty);
      expect(report.applied, [
        'navMore',
        'infrCardSoonText',
        'infrCardSoonText#other',
      ]);
      expect(report.comments, [
        ('navMore', 'так звичніше'),
        ('ofLimit', 'гарно'),
      ]);
      expect(translation['navMore'], 'Більше');
      expect(
        translation['infrCardSoonText'],
        'Лишилося {days, plural, one{{days} день} few{{days} дні} '
        'many{{days} днів} other{{days} доби}}.',
      );
    });

    test('подстановки, метка и скобки не должны пострадать', () {
      final translation = arb('pl');
      final before = Map.of(translation);
      final report = applyCorrections(
        translation,
        edited('pl', {
          'ofLimit': ('z {limt}', ''),
          'infrCardSoonText': ('Zostało dni.', ''),
          'infrCardSoonText#one': ('{days} dzień}', ''),
          'navHome': ('Start {', ''),
        }),
      );
      expect(report.applied, isEmpty);
      expect(
        {for (final (id, _) in report.rejected) id},
        {'ofLimit', 'infrCardSoonText', 'infrCardSoonText#one', 'navHome'},
      );
      expect(translation, before);
    });

    test('таблица из Excel с «;» и лишними пробелами читается', () {
      const csv =
          '﻿id;section;context;russian;numbers;translation;correction;'
          'comment\r\n'
          'navHome;Bottom navigation;;Главная;;Główna; Start ;\r\n'
          '"close";"Common";;"Закрыть";;"Zamknij";"";"ok; ""tak"""\r\n';
      final translation = arb('pl');
      final report = applyCorrections(translation, parseCsv(csv));
      expect(report.applied, ['navHome']);
      expect(translation['navHome'], 'Start');
      expect(report.comments, [('close', 'ok; "tak"')]);
    });

    test('исправление в файле: ARB меняется только в исправленной строке', () {
      final dir = Directory.systemTemp.createTempSync('l10n_review_');
      addTearDown(() => dir.deleteSync(recursive: true));
      for (final lang in ['ru', 'ro']) {
        arbFile(lang).copySync('${dir.path}/app_$lang.arb');
      }
      final table = File('${dir.path}/tachogo-ro (1).csv')
        ..writeAsStringSync(
          toCsv(edited('ro', {'navHome': ('Pagina principală', '')})),
        );
      expect(languageOf(table.path), 'ro');
      return importFile(table, dir: dir.path).then((report) {
        expect(report.applied, ['navHome']);
        final before = arbFile('ro').readAsLinesSync();
        final after = File('${dir.path}/app_ro.arb').readAsLinesSync();
        expect(after.length, before.length);
        final changed = [
          for (var i = 0; i < before.length; i++)
            if (before[i] != after[i]) after[i],
        ];
        expect(changed, ['  "navHome": "Pagina principală",']);
      });
    });
  });
}
