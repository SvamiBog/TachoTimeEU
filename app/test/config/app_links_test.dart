// Ссылка на политику конфиденциальности и страница, которую публикует
// GitHub Pages (`site/`, workflow «Сайт»). План тестов: UI-21 в
// docs/testing.md.
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
}
