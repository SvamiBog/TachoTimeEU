// SITE-01 (docs/testing.md): лендинг сайта собирается на английском,
// польском и немецком (`tool/site_build.dart`, тексты — `docs/site/`): в
// текстах все строки, ссылки ведут туда же, куда приложение, файлы на месте, на странице
// нет незаполненных подстановок, а сайт ничего не грузит с других сайтов.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../../tool/site_build.dart';

void main() {
  late Map<String, String> files;

  setUpAll(() async {
    await initializeDateFormatting();
    files = await buildSite();
  });

  test('языки сайта — английский, польский и немецкий, тексты с одним '
      'набором строк', () {
    expect(siteLanguages, ['en', 'pl', 'de']);
    // У телефона на странице — строки приложения на том же языке
    expect({
      for (final l in AppLocalizations.supportedLocales) l.languageCode,
    }, containsAll(siteLanguages));
    expect(languageNames.keys.toSet(), siteLanguages.toSet());
    final texts = {
      for (final f in Directory('../docs/site').listSync())
        if (f.path.endsWith('.json'))
          f.uri.pathSegments.last.replaceAll('.json', ''): jsonDecode(
            File(f.path).readAsStringSync(),
          ) as Map<String, Object?>,
    };
    expect(texts.keys.toSet(), siteLanguages.toSet());
    final keys = texts['en']!.keys.toSet();
    for (final MapEntry(:key, :value) in texts.entries) {
      expect(value.keys.toSet(), keys, reason: 'docs/site/$key.json');
      for (final MapEntry(key: k, :value) in value.entries) {
        final strings = switch (value) {
          final String s => [s],
          final List<Object?> l => l.cast<String>(),
          final Map<String, Object?> m => m.values.cast<String>(),
          _ => throw StateError('$key.$k'),
        };
        for (final s in strings) {
          expect(s.trim(), isNotEmpty, reason: '$key.$k');
          expect(s, isNot(contains('TODO')), reason: '$key.$k');
        }
      }
    }
  });

  test('адрес сайта, политика, регламент и дата — как в приложении', () {
    expect('${siteBase}privacy/', privacyPolicyPage);
    for (final l in siteLanguages) {
      expect(regulationUrl(l), regulationUri(l).toString(), reason: l);
      expect(
        '$siteBase${'privacy/'}#${privacyAnchor(l)}',
        privacyPolicyUri(l).toString(),
        reason: l,
      );
      final date = DateTime(2026, 9, 23);
      expect(weekdayDate(date, l), formatWeekdayDate(date, l), reason: l);
    }
    final privacy = File('../site/privacy/index.html').readAsStringSync();
    expect(privacy, contains('mailto:$contactEmail'));
  });

  test('страница на каждом языке и карта сайта', () {
    expect(files.keys.toSet(), {
      for (final l in siteLanguages) '${pagePath(l)}index.html',
      'sitemap.xml',
      'robots.txt',
    });
    expect(pagePath('en'), '');
    final sitemap = files['sitemap.xml']!;
    for (final l in siteLanguages) {
      expect(sitemap, contains('<loc>$siteBase${pagePath(l)}</loc>'));
    }
    expect(files['robots.txt'], contains('${siteBase}sitemap.xml'));
  });

  for (final language in siteLanguages) {
    test('страница $language', () {
      final page = files['${pagePath(language)}index.html']!;
      final root = language == 'en' ? '' : '../';

      expect(page, contains('<html lang="$language">'));
      expect(
        page,
        contains(
          '<link rel="canonical" href="$siteBase${pagePath(language)}">',
        ),
      );
      for (final l in siteLanguages) {
        expect(page, contains('hreflang="$l" href="$siteBase${pagePath(l)}"'));
      }
      expect(page, contains('hreflang="x-default" href="$siteBase"'));

      final title = RegExp('<title>(.*?)</title>').firstMatch(page)![1]!;
      expect(title, contains('TachoGo'));
      expect(title.length, lessThanOrEqualTo(70), reason: title);
      final description = RegExp('<meta name="description" content="([^"]*)"')
          .firstMatch(page)![1]!;
      expect(
        description.length,
        inInclusiveRange(70, 200),
        reason: description,
      );

      final h1 = RegExp('<h1>(.*?)</h1>').firstMatch(page)![1]!;
      expect(h1, contains('<mark>TachoGo</mark>'));

      expect(page, contains('href="${regulationUri(language)}"'));
      expect(
        page,
        contains('href="${root}privacy/#${privacyAnchor(language)}"'),
      );
      expect(page, contains('href="mailto:$contactEmail?subject='));
      for (final c in europeBans.keys) {
        expect(page, contains('<span aria-hidden="true">$c</span>'));
      }
      expect(page, contains('aria-current="page">${languageNames[language]}'));

      // Подстановки заполнены: строки приложения, тексты и число стран
      expect(page, isNot(matches(RegExp(r'\{[a-z_]+\}'))));
      // Сайт ничего не грузит с других сайтов: внешние адреса — только ссылки
      for (final m in RegExp(r'(src|url)\(?=?"?(https?:)').allMatches(page)) {
        fail('внешний ресурс: ${m[0]}');
      }
      // Свои файлы — на месте
      final local = RegExp(r'''(?:href|src)="([^"#:]+)"|url\(([^)]+)\)''');
      for (final m in local.allMatches(page)) {
        final path = (m[1] ?? m[2])!;
        if (path.isEmpty) continue;
        final target = Uri.parse('https://site/${pagePath(language)}')
            .resolve(path)
            .path
            .substring(1);
        final file = target.isEmpty || target.endsWith('/')
            ? '${target}index.html'
            : target;
        expect(
          files.containsKey(file) || File('../site/$file').existsSync(),
          isTrue,
          reason: '$language: $path',
        );
      }

      // Корень сайта открывает страницу на языке браузера, остальные — нет
      expect(page.contains('navigator.languages'), language == 'en');
    });
  }
}
