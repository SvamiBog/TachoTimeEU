import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:tacho_engine/driving_bans.dart';

// Без Flutter: этот файл читает и `tool/bans_publish.dart`, который
// подписывает правила для сайта.

/// Файл с правилами запретов на сайте TachoGo (GitHub Pages, тот же сайт,
/// что у политики конфиденциальности — `app_links.dart`). Публикует
/// `.github/workflows/pages.yml` при каждом изменении правил на main. При
/// переезде сайта по старому адресу оставить переадресацию: адрес из уже
/// установленных версий не поменять.
final Uri banDataUri = Uri.parse(
  'https://svamibog.github.io/TachoTimeEU/bans/v$banDataFormat.json',
);

/// Открытые ключи подписи файла запретов по имени. Закрытый — секрет
/// `BANS_SIGNING_KEY` в GitHub (docs/domain/driving-bans.md). Смена
/// ключа: новый — добавить сюда и выпустить версию; подписывать им — когда
/// старыми версиями уже не пользуются: они файл с незнакомым ключом не
/// примут и останутся на своих правилах.
const banSigningKeys = {
  '2026-10': 'FDfi7SoZ22/akxj8iNRU9lAgEcbzX8sJi/BxC3N5Lmg=',
};

/// Подпись — над этой строкой и текстом правил: подписью файла запретов
/// не подписать ничего другого.
const _context = 'tachogo/bans/v$banDataFormat\n';

List<int> _message(String data) => utf8.encode('$_context$data');

/// Файл для сайта: правила [data] (текст `encodeBanData`), подпись Ed25519
/// закрытым ключом [seed] (32 байта) и имя ключа [keyId].
Future<String> sealBanData(
  String data, {
  required List<int> seed,
  required String keyId,
}) async {
  final algorithm = Ed25519();
  final signature = await algorithm.sign(
    _message(data),
    keyPair: await algorithm.newKeyPairFromSeed(seed),
  );
  return jsonEncode({
    'key': keyId,
    'signature': base64Encode(signature.bytes),
    'data': data,
  });
}

/// Текст правил из файла [file], если он подписан ключом из [keys]. Чужой
/// ключ, неверная подпись, не тот файл — [FormatException].
Future<String> openBanData(
  String file, {
  Map<String, String> keys = banSigningKeys,
}) async {
  if (jsonDecode(file) case {
    'key': final String keyId,
    'signature': final String signature,
    'data': final String data,
  }) {
    final publicKey = keys[keyId];
    if (publicKey == null) {
      throw FormatException('Файл запретов подписан незнакомым ключом $keyId');
    }
    final signatureBytes = base64Decode(signature);
    final publicKeyBytes = base64Decode(publicKey);
    if (signatureBytes.length != 64 || publicKeyBytes.length != 32) {
      throw const FormatException('Подпись файла запретов — не Ed25519');
    }
    final valid = await Ed25519().verify(
      _message(data),
      signature: Signature(
        signatureBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      ),
    );
    if (!valid) throw const FormatException('Подпись файла запретов неверна');
    return data;
  }
  throw const FormatException('Не файл запретов');
}

/// Правила стран из подписанного файла [file]: подпись, потом формат —
/// [FormatException], если что-то не так.
Future<Map<String, CountryBans>> readBanData(
  String file, {
  Map<String, String> keys = banSigningKeys,
}) async => decodeBanData(await openBanData(file, keys: keys));

/// Открытый ключ (base64) для закрытого [seed]: 32 байта, иначе
/// [ArgumentError].
Future<String> banPublicKey(List<int> seed) async {
  if (seed.length != 32) {
    throw ArgumentError.value(seed.length, 'seed', 'нужно 32 байта');
  }
  final keyPair = await Ed25519().newKeyPairFromSeed(seed);
  return base64Encode((await keyPair.extractPublicKey()).bytes);
}

/// Файл для сайта с правилами [countries] (встроенные в движок), подписанный
/// закрытым ключом [seed]. Имя ключа — по открытому в [keys]; там его нет —
/// [ArgumentError]: такой файл не примет ни одна версия приложения. Готовый
/// файл читается так же, как в приложении, и правила сверяются с исходными.
Future<String> publishBanData(
  List<int> seed, {
  Iterable<CountryBans>? countries,
  Map<String, String> keys = banSigningKeys,
}) async {
  final publicKey = await banPublicKey(seed);
  final keyId = [
    for (final MapEntry(:key, :value) in keys.entries)
      if (value == publicKey) key,
  ].firstOrNull;
  if (keyId == null) {
    throw ArgumentError.value(publicKey, 'seed', 'ключа нет в banSigningKeys');
  }
  final data = encodeBanData(countries ?? europeBans.values);
  final file = await sealBanData(data, seed: seed, keyId: keyId);
  if (encodeBanData((await readBanData(file, keys: keys)).values) != data) {
    throw StateError('Правила из файла не совпали с исходными');
  }
  return file;
}
