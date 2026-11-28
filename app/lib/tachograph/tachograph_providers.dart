/// Providers of the tachograph link over Bluetooth (beta, read only).
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_reader.dart';

final tachographPlatformProvider = Provider<TachographPlatform>(
  (ref) => ReactiveBleTachographPlatform(),
);

/// Журнал обмена живёт, пока работает приложение: экран закрыли — отчёт о
/// проблеме его ещё видит.
final tachographLogProvider = Provider<ExchangeLog>((ref) => ExchangeLog());

/// Есть ли строка «Тахограф по Bluetooth» в «Ещё»: пока только в сборке
/// разработчика (dev — debug APK из CI и локальный запуск) на Android. Сборки
/// для Google Play — внутреннее тестирование и закрытая бета (staging), релиз
/// (prod) — её не показывают, пока чтение не проверено на настоящем тахографе
/// (BT-11). Потом — staging, затем prod.
bool tachographAvailable(AppEnv env, {required bool supported}) =>
    env == AppEnv.dev && supported;

/// Строка «Тахограф по Bluetooth» в «Ещё» в этой сборке.
final tachographEnabledProvider = Provider<bool>(
  (ref) => tachographAvailable(
    AppEnv.current,
    supported: ref.watch(tachographPlatformProvider).supported,
  ),
);

/// Журнал обмена прямо на экране тахографа — только в сборке разработчика
/// (dev): по нему видно, на каком шаге встало подключение. Водителям беты он
/// не нужен: журнал и так уходит в «Сообщить о проблеме».
final tachographLogVisibleProvider = Provider<bool>(
  (ref) => AppEnv.current == AppEnv.dev,
);

/// Client and reader of one connected tachograph.
typedef TachographSession = ({ItsClient client, TachographReader reader});

/// Как экран говорит с подключённым тахографом; тесты делают обмен быстрым.
/// Клиент порта выгрузки карты: ответ на запрос части может идти дольше,
/// пока тахограф читает карту.
final tachographDownloadClientProvider =
    Provider<ItsClient Function(ItsPort port, ExchangeLog log)>(
      (ref) =>
          (port, log) => ItsClient(
            port,
            log: log,
            timeout: const Duration(seconds: 10),
            // Тахограф готовит карту: после «подождите» — до 45 с
            pendingTimeout: const Duration(seconds: 45),
          ),
    );

/// Сохранить файл карты байт в байт — в папку приложения, вне журнала;
/// возвращает путь. Отправить фирме не предлагаем: считывание для фирмы —
/// забота фирмы (решение 2026-11-26).
final tachographCardStoreProvider =
    Provider<Future<String> Function(Uint8List bytes, DateTime atUtc)>(
      (ref) => (bytes, atUtc) async {
        final root = await getApplicationDocumentsDirectory();
        final dir = Directory('${root.path}/tachograph');
        await dir.create(recursive: true);
        String two(int v) => v.toString().padLeft(2, '0');
        final stamp =
            '${atUtc.year}${two(atUtc.month)}${two(atUtc.day)}_'
            '${two(atUtc.hour)}${two(atUtc.minute)}${two(atUtc.second)}';
        final file = File('${dir.path}/card_$stamp.ddd');
        await file.writeAsBytes(bytes, flush: true);
        return file.path;
      },
    );

final tachographSessionProvider =
    Provider<TachographSession Function(ItsPort port, ExchangeLog log)>(
      (ref) => (port, log) {
        final client = ItsClient(port, log: log);
        return (client: client, reader: TachographReader(client, log: log));
      },
    );
