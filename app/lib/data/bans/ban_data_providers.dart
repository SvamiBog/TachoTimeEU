import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/data/bans/ban_data_repository.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';

/// HTTP-клиент приложения: правила запретов с сайта.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final banDataRepositoryProvider = Provider<BanDataRepository>(
  (ref) => BanDataRepository(
    ref.watch(databaseProvider),
    ref.watch(httpClientProvider),
  ),
);

/// Правила запретов на экранах: встроенные в приложение или скачанные с
/// сайта — какие новее. Сразу — встроенные; скачанные приходят после
/// [BanDataNotifier.refresh]: при запуске и на экране запретов.
final banDataProvider =
    NotifierProvider<BanDataNotifier, Map<String, CountryBans>>(
      BanDataNotifier.new,
    );

class BanDataNotifier extends Notifier<Map<String, CountryBans>> {
  Future<void>? _refreshing;
  var _storedRead = false;

  @override
  Map<String, CountryBans> build() => europeBans;

  /// Скачанные раньше правила из БД (один раз), потом — с сайта, если
  /// пора. Вызов во время обновления ждёт его, второго не начинает.
  Future<void> refresh() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<void> _refresh() async {
    final repository = ref.read(banDataRepositoryProvider);
    if (!_storedRead) {
      _storedRead = true;
      _offer(await repository.stored());
    }
    if (!ref.mounted) return;
    _offer(await repository.update(ref.read(clockProvider)));
  }

  /// Скачанные правила — на экраны, если сверены не раньше встроенных;
  /// иначе — встроенные: они новее, когда приложение обновили, а сайт ещё
  /// нет.
  void _offer(Map<String, CountryBans>? downloaded) {
    if (downloaded == null || !ref.mounted) return;
    final builtIn = latestCheck(europeBans.values);
    state = latestCheck(downloaded.values).compareTo(builtIn) >= 0
        ? downloaded
        : europeBans;
  }
}
