/// Driving ban rules file for the site (`docs/domain/driving-bans.md`, "Network
/// updates"): the engine's built-in rules signed with the key from the
/// BANS_SIGNING_KEY variable (Ed25519 private key, 32 bytes in base64). The
/// finished file is read back the same way the app reads it.
///
/// ```sh
/// dart run tool/bans_publish.dart <site directory>
/// ```
///
/// Writes `<directory>/bans/v1.json`; without the key it fails. Without a
/// directory it only checks: with the key — that it matches the app
/// (`banSigningKeys`), without the key — signing with a random key.
library;

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
