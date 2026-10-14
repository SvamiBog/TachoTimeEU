// Ссылка на политику конфиденциальности и страница, которую публикует
// GitHub Pages (`site/`, workflow «Сайт»), ссылка на официальный текст
// правил. План тестов: UI-21, UI-26 в docs/testing.md.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/config/app_links.dart';

void main() {
  test('русский интерфейс — русский текст, остальные — английский', () {
    expect(
      privacyPolicyUri('ru').toString(),
      'https://svamibog.github.io/TachoTimeEU/privacy/#ru',
    );
    for (final code in ['uk', 'pl', 'ro', 'ka', 'uz', 'en', 'de']) {
      expect(privacyPolicyUri(code).fragment, 'en', reason: code);
    }
  });

  test('страница в site/ — с обоими текстами, на которые ведёт ссылка', () {
    final page = File('../site/privacy/index.html').readAsStringSync();
    expect(page, contains('<section id="ru" lang="ru">'));
    expect(page, contains('<section id="en" lang="en">'));
    expect(privacyPolicyPage, endsWith('/privacy/'));
  });

  test(
    'Регламент 561/2006: языки ЕС — свой текст, остальные — выбор языка',
    () {
      expect(regulationUri('ru').toString(), regulationPage);
      for (final code in ['uk', 'ka', 'uz']) {
        expect(regulationUri(code).toString(), regulationPage, reason: code);
      }
      for (final (code, eurLex) in [
        ('pl', 'pol'),
        ('ro', 'ron'),
        ('en', 'eng'),
        ('de', 'deu'),
        ('fr', 'fra'),
        ('es', 'spa'),
        ('it', 'ita'),
        ('nl', 'nld'),
        ('cs', 'ces'),
        ('sk', 'slk'),
      ]) {
        expect(regulationUri(code).toString(), '$regulationPage/$eurLex');
      }
    },
  );

  test('тот же адрес — в описании приложения в Google Play', () {
    for (final dir in Directory('../docs/store/listing').listSync()) {
      if (dir is! Directory) continue;
      final text = File('${dir.path}/full_description.txt').readAsStringSync();
      expect(text, contains(regulationPage), reason: dir.path);
    }
  });
}
