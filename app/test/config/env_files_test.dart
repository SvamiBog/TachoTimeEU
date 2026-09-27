// Файлы окружений env/*.json: окружение из списка и никаких ключей
// сервисов — они только в секретах CI. План тестов: OBS-05 в
// docs/testing.md.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/config/app_env.dart';

void main() {
  final files = [
    for (final f in Directory('env').listSync())
      if (f is File && f.path.endsWith('.json')) f,
  ];

  test('есть окружение на каждое значение AppEnv', () {
    expect(
      {for (final f in files) f.uri.pathSegments.last},
      {for (final e in AppEnv.values) '${e.name}.json'},
    );
  });

  for (final f in files) {
    final name = f.uri.pathSegments.last;

    test('$name: APP_ENV совпадает с именем файла', () {
      final values = jsonDecode(f.readAsStringSync()) as Map<String, Object?>;
      expect(values['APP_ENV'], name.replaceAll('.json', ''));
      expect(AppEnv.values.asNameMap(), contains(values['APP_ENV']));
    });

    test('$name: ключей сервисов нет', () {
      final values = jsonDecode(f.readAsStringSync()) as Map<String, Object?>;
      expect(values.keys, isNot(contains('CRASH_DSN')));
      expect(values.keys, isNot(contains('ANALYTICS_KEY')));
      expect(values.keys, ['APP_ENV']);
    });
  }
}
