// Локализация Tier 1 и 2: полнота переводов, плюрали, тексты предупреждений
// движка, строки только в ARB, неделя с понедельника, форматы дат по
// локали. План тестов: L10N-01…07 в docs/testing.md. Переполнение экранов
// на переводах (L10N-06) — в design/screen_conformance_test.dart.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/l10n/languages.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/pickers.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const _arbDir = 'lib/l10n';

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('$_arbDir/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

/// Сообщения ARB без метаданных.
Map<String, String> _messages(Map<String, dynamic> arb) => {
  for (final MapEntry(:key, :value) in arb.entries)
    if (!key.startsWith('@')) key: value as String,
};

/// Варианты `select` / `plural` верхнего уровня: `{status, select, full{…}
/// other{…}}` → {status: {full, other}}.
Map<String, Set<String>> _cases(String message) {
  final result = <String, Set<String>>{};
  final head = RegExp(r'\{(\w+), (select|plural), ');
  for (final m in head.allMatches(message)) {
    final cases = <String>{};
    var i = m.end;
    var depth = 1;
    final name = StringBuffer();
    while (i < message.length && depth > 0) {
      final c = message[i];
      if (c == '{') {
        if (depth == 1) cases.add(name.toString().trim());
        name.clear();
        depth++;
      } else if (c == '}') {
        depth--;
      } else if (depth == 1) {
        name.write(c);
      }
      i++;
    }
    result[m.group(1)!] = cases;
  }
  return result;
}

/// Какие формы множественного числа нужны языку (CLDR).
const _pluralForms = {
  'ru': {'one', 'few', 'many', 'other'},
  'uk': {'one', 'few', 'many', 'other'},
  'pl': {'one', 'few', 'many', 'other'},
  'ro': {'one', 'few', 'other'},
  'ka': {'one', 'other'},
  'uz': {'one', 'other'},
  // Языки ЕС (Tier 2); many у романских — только для миллионов, у чешского
  // и словацкого — для дробей
  'bg': {'one', 'other'},
  'cs': {'one', 'few', 'other'},
  'da': {'one', 'other'},
  'de': {'one', 'other'},
  'el': {'one', 'other'},
  'en': {'one', 'other'},
  'es': {'one', 'other'},
  'et': {'one', 'other'},
  'fi': {'one', 'other'},
  'fr': {'one', 'other'},
  'ga': {'one', 'two', 'few', 'many', 'other'},
  'hr': {'one', 'few', 'other'},
  'hu': {'one', 'other'},
  'it': {'one', 'other'},
  'lt': {'one', 'few', 'other'},
  'lv': {'zero', 'one', 'other'},
  'mt': {'one', 'two', 'few', 'many', 'other'},
  'nl': {'one', 'other'},
  'pt': {'one', 'other'},
  'sk': {'one', 'few', 'other'},
  'sl': {'one', 'two', 'few', 'other'},
  'sv': {'one', 'other'},
};

String _normalize(String path) => path.replaceAll(r'\', '/');

/// Кириллица и грузинское письмо — буквы интерфейса. Латиница — нет:
/// коды, ключи и имена в коде латинские.
final _uiLetters = RegExp('[Ѐ-ӿႠ-ჿ]');

/// Строковые литералы в строке кода: '…' и "…", без комментария.
Iterable<String> _literals(String line) {
  final code = line.split('//').first;
  return RegExp(
    r"'(?:[^'\\]|\\.)*'|"
    r'"(?:[^"\\]|\\.)*"',
  ).allMatches(code).map((m) => m.group(0)!);
}

/// Строки интерфейса в коде: литерал с буквами интерфейса. Сообщения
/// исключений — для разработчика, водитель их не видит.
List<String> _uiStringsIn(String path, String source) {
  final found = <String>[];
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (RegExp(r'\b(throw|ArgumentError|StateError)\b').hasMatch(line)) {
      continue;
    }
    for (final literal in _literals(line)) {
      if (_uiLetters.hasMatch(literal)) {
        found.add('$path:${i + 1} — ${line.trim()}');
        break;
      }
    }
  }
  return found;
}

/// Названия языков — на самих языках: их не переводят (languages.dart).
const _uiStringsAllowed = {'lib/core/l10n/languages.dart'};

void main() {
  const locales = AppLocalizations.supportedLocales;
  final template = _arb('ru');
  final ruMessages = _messages(template);

  group('L10N-01: переводы полные', () {
    test('ARB на каждый язык, и каждый ARB — в supportedLocales', () {
      final files = Directory(_arbDir)
          .listSync()
          .map((f) => _normalize(f.path).split('/').last)
          .where((name) => name.endsWith('.arb'))
          .map((name) => name.substring(4, name.length - 4))
          .toSet();
      expect(
        files,
        locales.map((l) => l.languageCode).toSet(),
        reason: 'новый ARB — сгенерировать flutter gen-l10n',
      );
      // Tier 1 к релизу (docs/PRD.md, вопрос 4)
      expect(files, containsAll(['ru', 'uk', 'pl', 'ro', 'ka', 'uz']));
      // Телефон на языке без перевода — русский
      expect(locales.first, const Locale('ru'));
    });

    for (final locale in locales.where((l) => l.languageCode != 'ru')) {
      final code = locale.languageCode;
      group(code, () {
        final arb = _arb(code);
        final messages = _messages(arb);

        test('@@locale совпадает с именем файла', () {
          expect(arb['@@locale'], code);
        });

        test('все ключи исходного, лишних нет', () {
          final missing = ruMessages.keys.toSet().difference(
            messages.keys.toSet(),
          );
          final extra = messages.keys.toSet().difference(
            ruMessages.keys.toSet(),
          );
          expect(missing, isEmpty, reason: 'нет перевода');
          expect(extra, isEmpty, reason: 'нет в app_ru.arb');
        });

        test('подстановки и варианты select — как в исходном', () {
          for (final MapEntry(:key, value: ru) in ruMessages.entries) {
            final message = messages[key]!;
            final meta = template['@$key'] as Map<String, dynamic>?;
            final placeholders =
                (meta?['placeholders'] as Map<String, dynamic>?)?.keys ??
                const <String>[];
            for (final name in placeholders) {
              expect(
                message,
                matches(RegExp('\\{$name[,}]')),
                reason: '$key: нет {$name}',
              );
            }
            final ruCases = _cases(ru);
            final cases = _cases(message);
            expect(cases.keys, unorderedEquals(ruCases.keys), reason: key);
            for (final MapEntry(key: name, value: variants) in cases.entries) {
              if (ru.contains('{$name, select, ')) {
                expect(variants, ruCases[name], reason: '$key: $name');
              } else {
                expect(
                  variants,
                  containsAll(_pluralForms[code]!),
                  reason: '$key: формы множественного числа',
                );
              }
            }
          }
        });

        test('переводы не пустые', () {
          final empty = [
            for (final MapEntry(:key, :value) in messages.entries)
              if (value.trim().isEmpty) key,
          ];
          expect(empty, isEmpty);
        });
      });
    }
  });

  group('L10N-02: множественное число', () {
    const numbers = [0, 1, 2, 5, 11, 12, 14, 21, 22, 25, 101, 111];
    final expected = {
      'ru': [
        '0 часов', '1 час', '2 часа', '5 часов', '11 часов', '12 часов', //
        '14 часов', '21 час', '22 часа', '25 часов', '101 час', '111 часов',
      ],
      'uk': [
        '0 годин', '1 година', '2 години', '5 годин', '11 годин', //
        '12 годин', '14 годин', '21 година', '22 години', '25 годин',
        '101 година', '111 годин',
      ],
      'pl': [
        '0 godzin', '1 godzina', '2 godziny', '5 godzin', '11 godzin', //
        '12 godzin', '14 godzin', '21 godzin', '22 godziny', '25 godzin',
        '101 godzin', '111 godzin',
      ],
      'ro': [
        '0 ore', '1 oră', '2 ore', '5 ore', '11 ore', '12 ore', '14 ore', //
        '21 de ore', '22 de ore', '25 de ore', '101 ore', '111 ore',
      ],
      'ka': [for (final n in numbers) '$n საათი'],
      'uz': [for (final n in numbers) '$n soat'],
      'de': [
        for (final n in numbers)
          if (n == 1) '1 Stunde' else '$n Stunden',
      ],
      'cs': [
        '0 hodin', '1 hodina', '2 hodiny', '5 hodin', '11 hodin', //
        '12 hodin', '14 hodin', '21 hodin', '22 hodin', '25 hodin',
        '101 hodin', '111 hodin',
      ],
      // 0 — единственное число, как 1
      'fr': [
        for (final n in numbers)
          if (n < 2) '$n heure' else '$n heures',
      ],
    };
    for (final MapEntry(key: code, value: forms) in expected.entries) {
      test('$code: часы для диктора', () {
        final l = lookupAppLocalizations(Locale(code));
        expect([for (final n in numbers) l.spokenHours(n)], forms);
      });
    }

    test('дни: ru, uk, pl', () {
      String days(String code, int n) =>
          lookupAppLocalizations(Locale(code)).leadDays(n);
      expect(
        [for (final n in numbers) days('ru', n)],
        [
          '0 дней', '1 день', '2 дня', '5 дней', '11 дней', '12 дней', //
          '14 дней', '21 день', '22 дня', '25 дней', '101 день', '111 дней',
        ],
      );
      expect(
        [for (final n in numbers) days('uk', n)],
        [
          '0 днів', '1 день', '2 дні', '5 днів', '11 днів', '12 днів', //
          '14 днів', '21 день', '22 дні', '25 днів', '101 день', '111 днів',
        ],
      );
      expect(
        [for (final n in numbers) days('pl', n)],
        [
          '0 dni', '1 dzień', '2 dni', '5 dni', '11 dni', '12 dni', //
          '14 dni', '21 dni', '22 dni', '25 dni', '101 dni', '111 dni',
        ],
      );
    });

    test('смены в отчёте: ru, uk, pl', () {
      String count(String code, int n) =>
          lookupAppLocalizations(Locale(code)).exportCount(n);
      expect(count('ru', 21), '21 смена в отчёте');
      expect(count('uk', 3), '3 зміни у звіті');
      expect(count('pl', 5), '5 zmian w raporcie');
      expect(count('pl', 22), '22 zmiany w raporcie');
    });
  });

  group('L10N-03: предупреждения движка на каждом языке', () {
    // Значения, которые не встречаются в самих текстах
    const time = Duration(hours: 5, minutes: 48);
    const count = 2;
    const days = 16;
    Infringement sample(InfringementType type) => Infringement(
      type,
      time: time,
      limit: const Duration(hours: 9),
      requiredBreak: const Duration(minutes: 30),
      count: count,
      days: days,
    );
    final ru = lookupAppLocalizations(const Locale('ru'));

    for (final locale in locales) {
      test(locale.languageCode, () {
        final l = lookupAppLocalizations(locale);
        for (final type in InfringementType.values) {
          final i = sample(type);
          final text = l.infringement(i);
          final source = ru.infringement(i);
          expect(text.title, isNotEmpty, reason: type.name);
          expect(text.text, isNotEmpty, reason: type.name);
          expect(text.article, contains(i.article), reason: type.name);
          expect(text.article, contains(i.regulation), reason: type.name);
          // Подставляется то же, что в исходном тексте
          final values = {
            'time': formatHm(time),
            'limit': formatLimit(l, const Duration(hours: 9)),
            'count': '$count',
            'days': '$days',
            'required': '30',
          };
          final sourceValues = {...values, 'limit': formatLimit(ru, i.limit!)};
          for (final key in values.keys) {
            expect(
              text.text.contains(values[key]!),
              source.text.contains(sourceValues[key]!),
              reason: '${type.name}: $key в «${text.text}»',
            );
          }
        }
      });
    }
  });

  group('L10N-04: строки интерфейса — только в ARB', () {
    final sources =
        Directory('lib').listSync(recursive: true).whereType<File>().where((f) {
          final path = _normalize(f.path);
          return path.endsWith('.dart') &&
              !path.startsWith('lib/l10n/') &&
              !path.endsWith('.g.dart') &&
              !path.endsWith('.steps.dart') &&
              !_uiStringsAllowed.contains(path);
        }).toList()..sort((a, b) => a.path.compareTo(b.path));

    test('исходники найдены', () {
      expect(
        sources.map((f) => _normalize(f.path)),
        contains('lib/background/tracking_notification.dart'),
      );
    });

    test('в lib/ нет строк интерфейса в коде', () {
      final found = [
        for (final f in sources)
          ..._uiStringsIn(_normalize(f.path), f.readAsStringSync()),
      ];
      expect(found, isEmpty, reason: found.join('\n'));
    });

    test('правило срабатывает', () {
      for (final line in [
        "title: 'Машина едет',",
        r'text: "Вождение с $since",',
        "const Text('შესვენება')",
      ]) {
        expect(_uiStringsIn('x.dart', line), hasLength(1), reason: line);
      }
      for (final line in [
        "throw ArgumentError.value(code, 'code', 'не код страны');",
        '// «Вождение · 1:25»',
        "channelId: 'auto_detect',",
        r"'${formatClock(s.start)} → '",
      ]) {
        expect(_uiStringsIn('x.dart', line), isEmpty, reason: line);
      }
    });
  });

  group('L10N-05: неделя с понедельника во всех языках', () {
    test('неделя журнала и отчёта — понедельник 00:00 UTC', () {
      final sunday = DateTime.utc(2026, 9, 27, 23, 30);
      expect(weekStartUtc(sunday), DateTime.utc(2026, 9, 21));
      final range = reportRange(ReportPeriod.week, sunday);
      expect(range.start.weekday, DateTime.monday);
      expect(range.start, DateTime.utc(2026, 9, 21));
    });

    test('код не берёт первый день недели из локали', () {
      final found = [
        for (final f in Directory('lib').listSync(recursive: true))
          if (f is File &&
              f.path.endsWith('.dart') &&
              // Данные дат мальтийского из intl — поле обязательно, код его
              // не читает
              !_normalize(f.path)
                  .endsWith('l10n/fallback_localizations.dart') &&
              RegExp('firstDayOfWeekIndex|FIRSTDAYOFWEEK')
                  .hasMatch(f.readAsStringSync()))
            f.path,
      ];
      expect(found, isEmpty);
    });

    for (final locale in locales) {
      final code = locale.languageCode;
      testWidgets('$code: календарь и журнал', (tester) async {
        final j = designJournal();
        await pumpScreen(
          tester,
          const JournalScreen(),
          viewport: const Size(412, 2400),
          overrides: journalOverrides(periods: j.periods, now: j.now),
          locale: locale,
        );
        // Недели журнала: понедельник – воскресенье
        for (final monday in [
          DateTime.utc(2026, 9, 21),
          DateTime.utc(2026, 9, 14),
        ]) {
          expect(find.text(formatWeekRange(monday, code)), findsOneWidget);
        }

        await pumpScreen(
          tester,
          Scaffold(
            body: DateTimeField(
              value: j.now,
              max: j.now,
              withTime: false,
              onChanged: (_) {},
            ),
          ),
          overrides: journalOverrides(periods: j.periods, now: j.now),
          locale: locale,
        );
        final weekday = DateFormat('EEE', code);
        final header = [
          for (var i = 0; i < 7; i++)
            tester.getTopLeft(
              find.text(_capitalized(weekday.format(DateTime(2026, 1, 5 + i)))),
            ),
        ];
        // Слева направо: понедельник … воскресенье
        for (var i = 1; i < 7; i++) {
          expect(header[i].dx, greaterThan(header[i - 1].dx));
        }
      });
    }
  });

  group('L10N-07: даты и время в формате языка', () {
    setUpAll(() async {
      for (final l in [...locales, const Locale('en')]) {
        await initializeDateFormatting(l.languageCode);
      }
    });
    final t = DateTime(2026, 9, 2, 6, 5);

    test('время — 24 часа во всех языках, «06:05», как на распечатке '
        'тахографа', () {
      for (final locale in locales) {
        final code = locale.languageCode;
        // У языка в intl тоже 24 часа, хотя где-то «6:05» или «06.05»
        final pattern = DateFormat.Hm(code).pattern!;
        expect(pattern, contains('H'), reason: code);
        expect(pattern, isNot(contains('a')), reason: code);
      }
      expect(formatClock(t), '06:05');
      expect(formatClock(DateTime(2026, 9, 2, 18, 40)), '18:40');
    });

    test('день словами — шаблон языка', () {
      final expected = {
        'ru': ('Среда, 2 сентября', 'Ср, 2 сентября', 'Сентябрь 2026'),
        'uk': ('Середа, 2 вересня', 'Ср, 2 вересня', 'Вересень 2026'),
        'pl': ('Środa, 2 września', 'Śr., 2 września', 'Wrzesień 2026'),
        'ro': (
          'Miercuri, 2 septembrie',
          'Mie., 2 septembrie',
          'Septembrie 2026',
        ),
        'ka': (
          'ოთხშაბათი, 2 სექტემბერი',
          'ოთხ, 2 სექტემბერი',
          'სექტემბერი, 2026',
        ),
        'uz': ('Chorshanba, 2-sentabr', 'Chor, 2-sentabr', 'Sentabr, 2026'),
      };
      for (final MapEntry(key: code, value: v) in expected.entries) {
        expect(formatWeekdayFull(t, code), v.$1, reason: code);
        expect(formatWeekdayDate(t, code), v.$2, reason: code);
        expect(formatMonthYear(t, code), v.$3, reason: code);
      }
    });

    test('неделя: число перед месяцем — сокращённо, иначе целиком', () {
      final monday = DateTime.utc(2026, 9, 21);
      expect(formatWeekRange(monday, 'ru'), '21–27 сентября');
      expect(formatWeekRange(monday, 'pl'), '21–27 września');
      expect(formatWeekRange(monday, 'uz'), '21–27-sentabr');
      expect(
        formatWeekRange(DateTime.utc(2026, 9, 28), 'uk'),
        '28 вересня – 4 жовтня',
      );
      // Месяц перед числом (английский — Tier 3)
      expect(formatWeekRange(monday, 'en'), 'September 21 – September 27');
    });

    test('цифрами — день перед месяцем во всех языках', () {
      for (final locale in locales) {
        expect(formatDayMonth(t), '02.09', reason: locale.languageCode);
      }
      expect(formatUtcDate(DateTime.utc(2026, 7)), '01.07.2026');
    });
  });

  group('языки: список и выбор', () {
    test('в списке языков — сначала Tier 1, затем языки ЕС, у каждого своё '
        'название', () {
      final ordered = languagesInOrder(locales);
      expect(ordered.first, const Locale('ru'));
      expect(ordered.take(6).map((l) => l.languageCode), [
        'ru',
        'uk',
        'pl',
        'ro',
        'ka',
        'uz',
      ]);
      // Остальные — языки ЕС (docs/PRD.md, решение 28.09.2026)
      const eu = {
        'bg', 'cs', 'da', 'de', 'el', 'en', 'es', 'et', 'fi', 'fr', 'ga', //
        'hr', 'hu', 'it', 'lt', 'lv', 'mt', 'nl', 'pt', 'sk', 'sl', 'sv',
      };
      expect(
        ordered.skip(6).map((l) => l.languageCode),
        everyElement(isIn(eu)),
      );
      for (final locale in locales) {
        expect(languageName(locale), isNot(locale.languageCode));
      }
    });

    test('уведомления и сервис: язык настроек, иначе телефона', () {
      expect(appLocale('uk', const [Locale('pl')]), const Locale('uk'));
      expect(appLocale(null, const [Locale('pl', 'PL')]), const Locale('pl'));
      expect(
        appLocale(null, const [Locale('hi'), Locale('ro')]),
        const Locale('ro'),
      );
      expect(appLocale(null, const [Locale('de', 'AT')]), const Locale('de'));
      expect(appLocale(null, const [Locale('kk')]), const Locale('ru'));
      expect(appStrings('ka', const []).modeDriving, 'მართვა');
    });
  });
}

String _capitalized(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
