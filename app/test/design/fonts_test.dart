// DES-03: шрифты Onest и JetBrains Mono лежат в assets/fonts/, объявлены
// в pubspec.yaml, лицензии OFL рядом. Без файла Flutter молча берёт
// системный шрифт — таймер перестаёт быть моноширинным.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:yaml/yaml.dart';

/// Семейство → начертание → файл, как в pubspec.yaml.
Map<String, Map<int, String>> _declaredFonts() {
  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
  final families = (pubspec['flutter'] as YamlMap)['fonts'] as YamlList;
  return {
    for (final f in families.cast<YamlMap>())
      f['family'] as String: {
        for (final font in (f['fonts'] as YamlList).cast<YamlMap>())
          font['weight'] as int: font['asset'] as String,
      },
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final declared = _declaredFonts();

  test('объявлены семейства из темы и запасной для грузинского', () {
    expect(
      declared.keys,
      unorderedEquals([AppFonts.ui, AppFonts.numeric, AppFonts.fallback]),
    );
  });

  test('каждое начертание из AppTextStyles есть в pubspec.yaml', () {
    for (final style in AppTextStyles.all) {
      expect(
        declared[style.fontFamily]?.keys,
        contains(style.fontWeight!.value),
        reason: '${style.fontFamily} ${style.fontWeight}',
      );
    }
  });

  test('файлы шрифтов на месте и попадают в сборку', () async {
    for (final asset in declared.values.expand((w) => w.values)) {
      expect(File(asset).existsSync(), isTrue, reason: asset);
      final data = await rootBundle.load(asset);
      // TrueType: 0x00010000 в начале файла
      expect(data.getUint32(0), 0x00010000, reason: asset);
    }
  });

  test('рядом с каждым семейством — лицензия OFL', () {
    for (final assets in declared.values) {
      final file = File(assets.values.first);
      final family = file.uri.pathSegments.last.split('-').first;
      final license = File('${file.parent.path}/$family-OFL.txt');
      expect(license.existsSync(), isTrue, reason: license.path);
      expect(
        license.readAsStringSync(),
        contains('SIL Open Font License, Version 1.1'),
      );
    }
  });
}
