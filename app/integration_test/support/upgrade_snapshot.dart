// Снимок базы для проверки обновления поверх прошлой версии (UPG-01,
// tool/integration/upgrade_on_emulator.sh): версия схемы и все таблицы
// строками, как лежат в SQLite. Прошлая версия пишет его рядом с базой,
// новая сверяет со своим чтением той же базы.
//
// Файл запускается и из кода прошлой версии, поэтому здесь только Drift и
// path_provider — без классов приложения.

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

/// Снимок лежит в каталоге приложения, как и база: переживает обновление
/// вместе с ней и пропадает вместе с ней при переустановке.
Future<File> upgradeSnapshotFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/upgrade_expected.json');
}

/// Версия схемы и строки всех таблиц в порядке вставки.
Future<Map<String, Object?>> databaseSnapshot(GeneratedDatabase db) async {
  final version = await db.customSelect('PRAGMA user_version').getSingle();
  final names = [
    for (final row
        in await db
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'table' "
              "AND name NOT LIKE 'sqlite_%' AND name != 'android_metadata' "
              'ORDER BY name',
            )
            .get())
      row.read<String>('name'),
  ];
  return {
    'userVersion': version.read<int>('user_version'),
    'tables': {
      for (final name in names)
        name: [
          for (final row
              in await db
                  .customSelect('SELECT * FROM "$name" ORDER BY rowid')
                  .get())
            row.data,
        ],
    },
  };
}
