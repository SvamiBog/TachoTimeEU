// STORE-01 (docs/testing.md): тексты страницы в Google Play — все языки
// страницы, лимиты Play, без запрещённых политикой о метаданных слов
// в названии и кратком описании, перед концом — источники правил и что
// приложение не связано с властями (политика Play о госинформации), в
// конце — дисклеймер «не заменяет тахограф» (вопрос 8 PRD), восемь подписей
// скриншотов.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/config/app_links.dart';

import 'store_listing.dart';

/// Слова, которые политика Play о метаданных не допускает в названии
/// и кратком описании: «бесплатно», «лучший», «№ 1», «топ», «новинка»,
/// скидки — на языках страницы.
final _forbidden = [
  RegExp(
    r'\b(free|best|top|new|sale|discount|darmo|gratuit|gratis|kostenlos|'
    r'beste|mejor|zdarma|zadarmo)\b|\b(najlep|nejlep|miglior|meilleur)',
    caseSensitive: false,
  ),
  RegExp(
    '#1|№|(?<![а-яё])топ(?![а-яё])|бесплатн|безкоштовн|лучш|найкращ|'
    'новинк|скидк|знижк|უფასო|საუკეთესო',
    caseSensitive: false,
  ),
];

/// Названия конкурентов — политика запрещает их в текстах страницы.
const _competitors = [
  'Uniapp',
  'AntiBAG',
  'TachoPlus',
  'Tachogram',
  'TachoMobile',
  'TachoGuard',
  'TruckerTimer',
  'VDO',
  'Stoneridge',
];

/// «Тахограф» на языке страницы: им кончается описание — дисклеймер.
const _tachograph = {
  'ru-RU': 'тахограф',
  'uk': 'тахограф',
  'pl-PL': 'tachograf',
  'ro': 'tahograf',
  'ka-GE': 'ტაქოგრაფ',
  'en-US': 'tachograph',
  'de-DE': 'Fahrtenschreiber',
  'fr-FR': 'chronotachygraphe',
  'es-ES': 'tacógrafo',
  'it-IT': 'tachigrafo',
  'nl-NL': 'tachograaf',
  'cs-CZ': 'tachograf',
  'sk': 'tachograf',
};

/// Эмодзи и пиктограммы: в названии и кратком описании Play их не допускает.
final _emoji = RegExp(r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}]', unicode: true);

void main() {
  test('шаблон запрещённых слов', () {
    bool bad(String s) => _forbidden.any((r) => r.hasMatch(s));
    for (final s in [
      'Free timer',
      'Лучший тахограф',
      'Najlepszy',
      'TOP',
      'топ',
    ]) {
      expect(bad(s), isTrue, reason: s);
    }
    for (final s in ['bestelwagen', 'stop', 'Топливо', 'Rij- en rusttijden']) {
      expect(bad(s), isFalse, reason: s);
    }
  });

  test('языки страницы — ровно языки из storeLocales', () {
    final dirs = [
      for (final d in listingDir.listSync().whereType<Directory>())
        d.uri.pathSegments.lastWhere((s) => s.isNotEmpty),
    ]..sort();
    expect(dirs, [...storeLocales.keys]..sort());
    expect(_tachograph.keys, unorderedEquals(storeLocales.keys));
  });

  for (final locale in storeLocales.keys) {
    group(locale, () {
      final listing = readListing(locale);

      test('название: TachoGo и до 30 знаков', () {
        expect(listing.title, startsWith('TachoGo'));
        expect(listing.title.length, lessThanOrEqualTo(30));
      });

      test('краткое описание — до 80 знаков, полное — до 4000', () {
        expect(listing.short, isNotEmpty);
        expect(listing.short.length, lessThanOrEqualTo(80));
        expect(listing.full.length, lessThanOrEqualTo(4000));
        expect(listing.full, contains('561/2006'));
      });

      test('название и краткое описание без запрещённых слов и эмодзи', () {
        for (final text in [listing.title, listing.short]) {
          for (final word in _forbidden) {
            expect(word.hasMatch(text), isFalse, reason: '$word в «$text»');
          }
          expect(_emoji.hasMatch(text), isFalse, reason: text);
        }
      });

      test('без названий конкурентов', () {
        final texts = [
          listing.title,
          listing.short,
          listing.full,
          for (final c in listing.captions) ...[c.title, c.subtitle],
        ];
        for (final text in texts) {
          for (final name in _competitors) {
            expect(text, isNot(contains(name)));
          }
        }
      });

      test('перед концом — источники и независимость от властей '
          '(политика Play о госинформации)', () {
        final paragraphs = listing.full.split('\n\n');
        final sources = paragraphs[paragraphs.length - 2];
        expect(sources, contains(regulationPage));
        expect(sources, contains('TachoGo'));
      });

      test('в конце — не заменяет тахограф (вопрос 8 PRD)', () {
        final last = listing.full.split('\n\n').last;
        expect(last, contains(_tachograph[locale]));
        expect(last, contains('TachoGo'));
      });

      test('восемь подписей скриншотов: заголовок и пояснение', () {
        expect(listing.captions, hasLength(8));
        for (final c in listing.captions) {
          expect(c.title, isNotEmpty);
          expect(c.subtitle, isNotEmpty);
        }
      });
    });
  }
}
