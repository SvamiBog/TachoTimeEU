// Файл с правилами запретов для сайта (docs/domain/driving-bans.md,
// «Обновление по сети»): встроенные правила движка, подписанные ключом из
// переменной BANS_SIGNING_KEY (закрытый ключ Ed25519, 32 байта в base64).
// Готовый файл читается так же, как в приложении.
//
//   dart run tool/bans_publish.dart <каталог сайта>
//
// пишет <каталог>/bans/v1.json; без ключа — ошибка. Без каталога — только
// проверка: с ключом — что он из приложения (banSigningKeys), без ключа —
// подпись случайным ключом.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/data/bans/ban_data_file.dart';

Future<void> main(List<String> args) async {
  if (args.length > 1) {
    stderr.writeln('dart run tool/bans_publish.dart [каталог сайта]');
    exit(64);
  }
  final site = args.firstOrNull;
  final secret = Platform.environment['BANS_SIGNING_KEY']?.trim() ?? '';
  if (secret.isEmpty) {
    if (site != null) {
      stderr.writeln('Нет ключа BANS_SIGNING_KEY: файл для сайта не подписать');
      exit(1);
    }
    final random = Random.secure();
    final seed = List.generate(32, (_) => random.nextInt(256));
    await publishBanData(seed, keys: {'check': await banPublicKey(seed)});
    stdout.writeln('Без ключа: файл подписан случайным ключом и прочитан');
    return;
  }

  final List<int> seed;
  try {
    seed = base64Decode(secret);
  } on FormatException {
    stderr.writeln('BANS_SIGNING_KEY — не base64');
    exit(1);
  }
  if (seed.length != 32) {
    stderr.writeln('BANS_SIGNING_KEY — ${seed.length} байт, нужно 32');
    exit(1);
  }
  final publicKey = await banPublicKey(seed);
  if (!banSigningKeys.containsValue(publicKey)) {
    stderr.writeln(
      'Открытого ключа $publicKey нет в banSigningKeys '
      '(lib/data/bans/ban_data_file.dart): файл не примет приложение',
    );
    exit(1);
  }
  final file = await publishBanData(seed);
  final checked = latestCheck(europeBans.values);
  if (site == null) {
    stdout.writeln('Ключ BANS_SIGNING_KEY — из приложения, файл читается');
    return;
  }
  final target = File('$site/bans/v$banDataFormat.json');
  await target.parent.create(recursive: true);
  await target.writeAsString(file);
  stdout.writeln(
    '${target.path}: ${europeBans.length} стран, сверены до '
    '${checked.day}.${checked.month}.${checked.year}, ${file.length} байт',
  );
}
