// Страны смен и страна по умолчанию. План тестов: UI-06, DOC-04 в
// docs/testing.md.

import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/countries/tacho_countries.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late CountryRepository repo;
  final monday = DateTime.utc(2026, 9, 21, 6, 10);
  final tuesday = DateTime.utc(2026, 9, 22, 6);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    settings = SettingsRepository(db);
    repo = CountryRepository(db, settings);
  });
  tearDown(() => db.close());

  group('страны смены', () {
    test('записываются и меняются по началу смены', () async {
      await repo.setShiftCountries(monday, const ShiftCountries(start: 'PL'));
      await repo.setShiftCountries(
        monday,
        const ShiftCountries(start: 'PL', end: 'D'),
      );
      await repo.setShiftCountries(tuesday, const ShiftCountries(start: 'D'));

      expect(await repo.watchShifts().first, {
        monday: const ShiftCountries(start: 'PL', end: 'D'),
        tuesday: const ShiftCountries(start: 'D'),
      });
      expect(await db.select(db.shifts).get(), hasLength(2));
    });

    test('начало смены хранится в UTC', () async {
      await repo.setShiftCountries(
        monday.toLocal(),
        const ShiftCountries(start: 'PL'),
      );
      final row = await db.select(db.shifts).getSingle();
      expect(row.startUtc, monday);
      expect(row.startUtc.isUtc, isTrue);
    });

    test(
      'выбор — страна по умолчанию: конечная, без неё — начальная',
      () async {
        await repo.setShiftCountries(monday, const ShiftCountries(start: 'PL'));
        expect(await settings.defaultCountry(), 'PL');
        await repo.setShiftCountries(
          monday,
          const ShiftCountries(start: 'PL', end: 'LT'),
        );
        expect(await settings.defaultCountry(), 'LT');
      },
    );

    test('не код тахографа — ошибка, ничего не пишется', () async {
      expect(
        () => repo.setShiftCountries(monday, const ShiftCountries(start: 'DE')),
        throwsArgumentError,
      );
      expect(
        () => repo.setShiftCountries(
          monday,
          const ShiftCountries(start: 'PL', end: 'xx'),
        ),
        throwsArgumentError,
      );
      expect(await db.select(db.shifts).get(), isEmpty);
    });
  });

  group('часто используемые', () {
    ShiftCountryUse use(DateTime start, String? from, [String? to]) =>
        (start: start, from: from, to: to);
    DateTime day(int d) => DateTime.utc(2026, 9, d, 6);

    test('по числу смен, при равенстве — та, что позже; начальная и '
        'конечная сразу — один раз; не больше четырёх', () {
      expect(
        frequentCountries([
          use(day(1), 'PL', 'D'),
          use(day(2), 'D', 'D'),
          use(day(3), 'D', 'CH'),
          use(day(4), 'CH', 'NL'),
          use(day(5), 'NL', 'B'),
          use(day(6), 'B', 'F'),
        ]),
        ['D', 'B', 'NL', 'CH'],
      );
    });

    test('только за 8 недель до последней смены: новый маршрут поднимается '
        'наверх', () {
      final old = [
        for (var i = 0; i < 20; i++)
          use(DateTime.utc(2026, 5).add(Duration(days: i)), 'PL', 'NL'),
      ];
      final recent = [
        for (var i = 0; i < 3; i++)
          use(DateTime.utc(2026, 9, 20).add(Duration(days: i)), 'PL', 'F'),
      ];
      expect(frequentCountries([...old, ...recent]), ['PL', 'F']);
      // Давно не открытое приложение помнит маршрут: окно — от последней
      // смены, а не от сегодня
      expect(frequentCountries(old), ['PL', 'NL']);
    });

    test('без стран и без смен — пусто', () {
      expect(frequentCountries([use(day(1), null)]), isEmpty);
      expect(frequentCountries(const []), isEmpty);
    });

    test('из смен по записям режимов и смен, внесённых итогами; поток '
        'обновляется при новой смене итогом', () async {
      // Как у водителя, который внёс две недели итогами (журнал беты)
      final frequent = repo.watchFrequent();
      expect(await frequent.first, isEmpty);
      for (final (d, from, to) in [
        (15, 'PL', 'D'),
        (16, 'D', 'D'),
        (17, 'D', 'CH'),
        (18, 'CH', 'D'),
        (19, 'D', 'PL'),
        (21, 'PL', 'D'),
      ]) {
        final start = DateTime.utc(2026, 9, d, 5);
        await db
            .into(db.manualShifts)
            .insert(
              ManualShiftsCompanion.insert(
                startUtc: start,
                endUtc: Value(start.add(const Duration(hours: 12))),
                drivingMinutes: 480,
                restKind: RestKind.daily,
                startCountry: Value(from),
                endCountry: Value(to),
                utcOffsetMinutes: 120,
                createdAt: start,
                updatedAt: start,
              ),
            );
      }
      await repo.setShiftCountries(
        DateTime.utc(2026, 9, 29, 4, 23),
        const ShiftCountries(start: 'D'),
      );
      expect(await repo.watchFrequent().first, ['D', 'PL', 'CH']);
    });
  });

  group('новая смена', () {
    test('получает страну по умолчанию', () async {
      await settings.setDefaultCountry('LT');
      await repo.ensureShift(monday);
      expect(await repo.watchShifts().first, {
        monday: const ShiftCountries(start: 'LT'),
      });
    });

    test('уже выбранную страну не трогает', () async {
      await settings.setDefaultCountry('LT');
      await repo.setShiftCountries(monday, const ShiftCountries(start: 'PL'));
      await settings.setDefaultCountry('LT');
      await repo.ensureShift(monday);
      expect((await repo.watchShifts().first)[monday]!.start, 'PL');
    });

    test('без страны по умолчанию ничего не пишет', () async {
      await repo.ensureShift(monday);
      expect(await db.select(db.shifts).get(), isEmpty);
    });
  });

  group('страна по умолчанию в настройках', () {
    test('нет, пока водитель не выбрал', () async {
      expect(await settings.defaultCountry(), isNull);
      expect(await settings.watchDefaultCountry().first, isNull);
    });

    test('мусор в БД — как будто не выбрана', () async {
      await db
          .into(db.settings)
          .insert(
            SettingsCompanion.insert(key: 'default_country', value: 'Mars'),
          );
      expect(await settings.defaultCountry(), isNull);
      expect(await settings.watchDefaultCountry().first, isNull);
    });
  });

  group('DOC-04: коды тахографа', () {
    test('коды из docs/domain/eu-561-rules.md есть в приложении', () {
      final rules = File('../docs/domain/eu-561-rules.md').readAsStringSync();
      final line = RegExp('коды тахографа: ([A-Z, ]+)').firstMatch(rules)!;
      final documented = line[1]!.split(',').map((c) => c.trim());
      expect(documented, isNotEmpty);
      expect(TachoCountries.codes, containsAll(documented));
    });

    test('коды без повторов, 1–3 латинские буквы, как в таблице shifts', () {
      expect(
        TachoCountries.codes.toSet(),
        hasLength(TachoCountries.codes.length),
      );
      for (final code in TachoCountries.codes) {
        expect(code, matches(RegExp(r'^[A-Z]{1,3}$')));
      }
    });

    test('у каждого кода есть название', () async {
      final l = await AppLocalizations.delegate.load(const Locale('ru'));
      for (final code in TachoCountries.codes) {
        expect(l.countryName(code), isNot(code), reason: code);
      }
      expect(l.countryName('PL'), 'Польша');
    });
  });
}
