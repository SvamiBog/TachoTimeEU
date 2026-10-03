// BAN-12, BAN-13 (docs/testing.md): правила запретов с сайта. Файл
// подписан ключом из приложения, скачивается не чаще раза в сутки, без
// сети и с чужим или испорченным файлом остаются прежние правила;
// показываются скачанные или встроенные — какие сверены позже.

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/data/bans/ban_data_file.dart';
import 'package:tachogo/data/bans/ban_data_providers.dart';
import 'package:tachogo/data/bans/ban_data_repository.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/bans/ban_format.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';

/// Закрытые ключи для тестов: открытые — в [testKeys].
final seed = List<int>.generate(32, (i) => i);
final otherSeed = List<int>.generate(32, (i) => 255 - i);

late Map<String, String> testKeys;

/// Сайт: отвечает [body] или бросает [error], считает запросы.
class Site {
  String? body;
  int status = 200;
  Exception? error;
  final requests = <Uri>[];

  http.Client get client => MockClient((request) async {
    requests.add(request.url);
    if (error case final e?) throw e;
    return http.Response.bytes(utf8.encode(body ?? ''), status);
  });
}

final noon = DateTime.utc(2026, 10, 4, 10);
final AppLocalizations ru = lookupAppLocalizations(const Locale('ru'));

void main() {
  setUpAll(() async {
    testKeys = {'test': await banPublicKey(seed)};
  });

  group('BAN-12: подписанный файл', () {
    test('ключ приложения — открытый ключ Ed25519, файл — на сайте по '
        'https своей версии формата', () {
      expect(banSigningKeys, isNotEmpty);
      for (final key in banSigningKeys.values) {
        expect(base64Decode(key), hasLength(32));
      }
      expect(banDataUri.scheme, 'https');
      expect(banDataUri.path, endsWith('/bans/v$banDataFormat.json'));
    });

    test('подписанный файл читается, правила те же', () async {
      final data = encodeBanData(europeBans.values);
      final file = await sealBanData(data, seed: seed, keyId: 'test');
      expect(await openBanData(file, keys: testKeys), data);
      expect((await readBanData(file, keys: testKeys)).keys, europeBans.keys);
    });

    test('не читается: правка правил после подписи, чужой ключ, '
        'незнакомое имя ключа, не тот файл', () async {
      final data = encodeBanData(europeBans.values);
      final file = await sealBanData(data, seed: seed, keyId: 'test');
      final json = jsonDecode(file) as Map<String, Object?>;
      final cases = {
        'правка правил': jsonEncode({
          ...json,
          'data': data.replaceFirst('"22:00"', '"23:00"'),
        }),
        'чужой ключ': await sealBanData(data, seed: otherSeed, keyId: 'test'),
        'незнакомое имя ключа': jsonEncode({...json, 'key': '2020-01'}),
        'подпись не той длины': jsonEncode({...json, 'signature': 'AAAA'}),
        'подпись не base64': jsonEncode({...json, 'signature': '%%%'}),
        'без подписи': jsonEncode({'key': 'test', 'data': data}),
        'не JSON': '<html>404</html>',
        'правила без подписи': data,
      };
      for (final MapEntry(key: name, value: broken) in cases.entries) {
        await expectLater(
          openBanData(broken, keys: testKeys),
          throwsFormatException,
          reason: name,
        );
      }
    });

    test('файл для сайта: подписан ключом приложения, правила из файла — '
        'встроенные', () async {
      final file = await publishBanData(seed, keys: testKeys);
      expect(jsonDecode(file), containsPair('key', 'test'));
      final countries = await readBanData(file, keys: testKeys);
      expect(encodeBanData(countries.values), encodeBanData(europeBans.values));
    });

    test('файл для сайта не подписывается ключом, которого нет в '
        'приложении, и ключом не той длины', () async {
      await expectLater(
        publishBanData(otherSeed, keys: testKeys),
        throwsArgumentError,
      );
      await expectLater(
        publishBanData(seed.sublist(1), keys: testKeys),
        throwsArgumentError,
      );
    });
  });

  group('BAN-12: скачивание и хранение', () {
    late AppDatabase db;
    late Site site;
    late BanDataRepository repository;

    setUp(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      db = memoryDatabase();
      site = Site();
      repository = BanDataRepository(db, site.client, keys: testKeys);
    });
    tearDown(() => db.close());

    Future<String> signed(Iterable<CountryBans> countries) =>
        sealBanData(encodeBanData(countries), seed: seed, keyId: 'test');

    test('первый раз — скачивает и сохраняет; через сутки — снова; '
        'раньше — не спрашивает', () async {
      site.body = await signed(europeBans.values);
      final first = await repository.update(noon);
      expect(first?.keys, europeBans.keys);
      expect(site.requests, [banDataUri]);
      expect((await repository.stored())?.keys, europeBans.keys);

      final later = noon.add(BanDataRepository.checkEvery);
      expect(
        await repository.update(later.subtract(const Duration(minutes: 1))),
        isNull,
      );
      expect(site.requests, hasLength(1));
      expect(await repository.update(later), isNotNull);
      expect(site.requests, hasLength(2));
    });

    test('часы переведены назад — спрашивает сразу', () async {
      site.body = await signed(europeBans.values);
      await repository.update(noon);
      await repository.update(noon.subtract(const Duration(hours: 1)));
      expect(site.requests, hasLength(2));
    });

    test('нет сети, ответ не 200, файл слишком большой — ничего не '
        'сохраняет и спрашивает снова при следующем вызове', () async {
      site.error = const SocketException('нет сети');
      expect(await repository.update(noon), isNull);
      site
        ..error = null
        ..status = 404
        ..body = await signed(europeBans.values);
      expect(await repository.update(noon), isNull);
      site
        ..status = 200
        ..body = ' ' * (BanDataRepository.maxBytes + 1);
      expect(await repository.update(noon), isNull);
      expect(site.requests, hasLength(3));
      expect(await repository.stored(), isNull);
    });

    test('чужая подпись или нет страны из встроенных — файл не '
        'сохраняется, прежний остаётся', () async {
      site.body = await signed(europeBans.values);
      await repository.update(noon);
      final day2 = noon.add(BanDataRepository.checkEvery);

      final newer = downloadedBans(const BanDate(2026, 11, 2));
      site.body = await sealBanData(
        encodeBanData(newer.values),
        seed: otherSeed,
        keyId: 'test',
      );
      expect(await repository.update(day2), isNull);

      site.body = await signed(newer.values.where((c) => c.code != 'D'));
      expect(await repository.update(day2), isNull);

      final stored = await repository.stored();
      expect(stored?['D']?.checkedOn, const BanDate(2026, 10, 1));
    });

    test('страна, которой нет во встроенных, пропускается', () async {
      site.body = await signed([
        ...europeBans.values,
        const CountryBans(
          code: 'MD',
          zone: BanZone.eet,
          coverage: BanCoverage.none,
          checkedOn: BanDate(2026, 10, 1),
        ),
      ]);
      expect((await repository.update(noon))?.keys, europeBans.keys);
    });

    test('сохранённый файл с подписью, которая больше не сходится, — '
        'нет скачанных правил', () async {
      site.body = await signed(europeBans.values);
      await repository.update(noon);
      final strict = BanDataRepository(
        db,
        site.client,
        keys: {'test': await banPublicKey(otherSeed)},
      );
      expect(await strict.stored(), isNull);
    });
  });

  group('BAN-13: какие правила показывать', () {
    ProviderContainer container(FakeBanData bans) {
      final c = ProviderContainer(
        overrides: [
          banDataRepositoryProvider.overrideWithValue(bans),
          clockProvider.overrideWith(() => TestClock(noon)),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('сначала — встроенные; скачанные сверены позже — они', () async {
      final newer = downloadedBans(const BanDate(2026, 11, 2));
      final c = container(FakeBanData(downloaded: newer));
      expect(c.read(banDataProvider), same(europeBans));
      await c.read(banDataProvider.notifier).refresh();
      expect(c.read(banDataProvider), same(newer));
    });

    test('сверены в тот же день — скачанные: на сайте правка без новой '
        'даты', () async {
      final sameDay = downloadedBans(const BanDate(2026, 10, 1));
      final c = container(FakeBanData(downloaded: sameDay));
      await c.read(banDataProvider.notifier).refresh();
      expect(c.read(banDataProvider), same(sameDay));
    });

    test('скачанные старше встроенных — встроенные: приложение обновили, '
        'а сайт ещё нет', () async {
      final older = downloadedBans(const BanDate(2026, 9, 1));
      final c = container(FakeBanData(downloaded: older));
      await c.read(banDataProvider.notifier).refresh();
      expect(c.read(banDataProvider), same(europeBans));
    });

    test('сохранённые читаются один раз; второй вызов во время '
        'обновления ждёт его', () async {
      final bans = FakeBanData();
      final c = container(bans);
      final notifier = c.read(banDataProvider.notifier);
      await Future.wait([notifier.refresh(), notifier.refresh()]);
      expect(bans.updates, 1);
      await notifier.refresh();
      expect(bans.updates, 2);
    });

    testWidgets('экраны — по скачанным правилам; открытый экран запретов '
        'спрашивает сайт', (tester) async {
      // В скачанных Германия запрещает с 06:00 воскресенья
      const sundayFrom6 = BanRule(
        kind: BanKind.weekend,
        days: Weekdays({DateTime.sunday}),
        from: BanTime(6),
        to: BanTime(22),
      );
      final bans = FakeBanData(
        downloaded: downloadedBans(
          const BanDate(2026, 11, 2),
          rules: {
            'D': [sundayFrom6, ...germany.rules.skip(1)],
          },
        ),
      );
      await pumpScreen(
        tester,
        const DrivingBansScreen(),
        viewport: const Size(412, 2400),
        overrides: [
          ...journalOverrides(periods: const [], now: noon, bans: bans),
        ],
      );
      expect(bans.updates, 1);

      await tester.tap(find.text(ru.countryName('D')));
      await settle(tester);
      expect(find.byType(CountryBansScreen), findsOneWidget);
      expect(find.text(banRuleText(ru, sundayFrom6, 'ru')), findsOneWidget);
      expect(find.textContaining(ru.bansChecked('02.11.2026')), findsOneWidget);
    });
  });
}
