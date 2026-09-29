// Перенос журнала на другой телефон файлом. План тестов: TRF-04…06 в
// docs/testing.md (экран — more/transfer_sheet_test.dart).
import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/backup/journal_backup.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  final now = DateTime.utc(2026, 9, 23, 8);
  late AppDatabase oldPhone;
  late AppDatabase newPhone;

  setUp(() {
    oldPhone = AppDatabase(NativeDatabase.memory());
    newPhone = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() async {
    await oldPhone.close();
    await newPhone.close();
  });

  /// Журнал старого телефона: смена с перерывом и идущим отдыхом, паром,
  /// «Завершить день», страны и заметка, смена итогами, считывание карты,
  /// настройки расчёта.
  Future<void> seed(AppDatabase db) async {
    var t = now.subtract(const Duration(hours: 12));
    final activity = ActivityRepository(db, clock: () => t);
    await activity.switchMode(DriverMode.driving);
    t = t.add(const Duration(hours: 4, minutes: 30));
    await activity.switchMode(DriverMode.rest);
    t = t.add(const Duration(minutes: 45));
    await activity.switchMode(DriverMode.driving, ferry: true);
    t = t.add(const Duration(hours: 2));
    await activity.endDay();

    final settings = SettingsRepository(db);
    final edits = JournalEditRepository(db, settings, clock: () => now);
    await edits.setShiftMeta(
      now.subtract(const Duration(hours: 12)),
      const ShiftMeta(startCountry: 'PL', endCountry: 'D', note: 'паром'),
    );
    await edits.saveManualShift(
      ManualShift(
        start: DateTime.utc(2026, 9, 10, 6),
        end: DateTime.utc(2026, 9, 10, 16),
        driving: const Duration(hours: 8, minutes: 15),
      ),
      const ShiftMeta(startCountry: 'LT', note: 'до установки'),
    );
    await CardDownloadRepository(
      db,
      clock: () => now.subtract(const Duration(days: 3)),
    ).record();
    await settings.updateComplianceSettings(
      crew: CrewMode.team,
      mobilityPackage: false,
      warningLead: const Duration(minutes: 60),
    );
    await settings.setTachograph(TachographType.analog);
    await settings.setDefaultCountry('PL');
  }

  JournalBackup backup(AppDatabase db, {void Function()? onChanged}) =>
      JournalBackup(db, clock: () => now, onChanged: onChanged);

  /// Всё, что переносится, в сравнимом виде: без id и в порядке времени.
  Future<Map<String, Object?>> snapshot(AppDatabase db) async => {
    'periods': [
      for (final p in await ActivityRepository(db).periods())
        (p.mode, p.start, p.end, p.ferry, p.dayEnd),
    ],
    'rows': [
      for (final r in await db.select(db.activityPeriods).get())
        (r.utcOffsetMinutes, r.source, r.note, r.createdAt, r.updatedAt),
    ],
    'shifts': [
      for (final s in await db.select(db.shifts).get())
        (s.startUtc, s.endUtc, s.startCountry, s.endCountry, s.note),
    ],
    'manual': [
      for (final m in await db.select(db.manualShifts).get())
        (
          m.startUtc,
          m.endUtc,
          m.drivingMinutes,
          m.restKind,
          m.splitRest,
          m.startCountry,
          m.note,
        ),
    ],
    'cards': [
      for (final c in await db.select(db.cardDownloads).get())
        c.downloadedAtUtc,
    ],
    'settings': await SettingsRepository(db).transferableSettings(),
  };

  group('TRF-04: круговой перенос', () {
    test('журнал, смены итогами, считывания и настройки на новом телефоне '
        'те же', () async {
      await seed(oldPhone);
      final bytes = await backup(oldPhone).export();

      var changed = 0;
      final target = backup(newPhone, onChanged: () => changed++);
      final contents = JournalBackup.parse(bytes);
      expect(contents.isEmpty, isFalse);
      expect(contents.first, DateTime.utc(2026, 9, 10, 6));
      await target.restore(contents);

      expect(await snapshot(newPhone), await snapshot(oldPhone));
      expect(changed, 1, reason: 'фоновому сервису сообщено');

      // Расчёт на новом телефоне — тот же
      final settings = SettingsRepository(newPhone);
      expect((await settings.complianceSettings()).crew, CrewMode.team);
      expect((await settings.preferences()).tachograph, TachographType.analog);
      final periods = await ActivityRepository(newPhone).periods();
      expect(periods.last.isOpen, isTrue, reason: 'отдых идёт дальше');
    });

    test('журнал нового телефона заменяется целиком, настройки расчёта — '
        'как на старом; язык, тема, согласие и автоопределение нового '
        'телефона остаются', () async {
      await seed(oldPhone);
      final settings = SettingsRepository(newPhone);
      await settings.setLanguage('pl');
      await settings.setTheme(ThemeChoice.light);
      await settings.setAnalyticsConsent(granted: true);
      await settings.setAutoDetect(const AutoDetectSettings(enabled: true));
      // На старом не задан — после переноса умолчание, как там
      await settings.setReportLanguage('pl');
      await ActivityRepository(
        newPhone,
        clock: () => now,
      ).switchMode(DriverMode.otherWork);
      final target = backup(newPhone);
      expect(await target.hasJournal(), isTrue);

      await target.restore(
        JournalBackup.parse(await backup(oldPhone).export()),
      );

      expect(await snapshot(newPhone), await snapshot(oldPhone));
      final prefs = await settings.preferences();
      expect(prefs.language, 'pl');
      expect(prefs.theme, ThemeChoice.light);
      expect(await settings.watchAnalyticsConsent().first, isTrue);
      expect((await settings.autoDetect()).enabled, isTrue);
      expect(prefs.reportLanguage, isNull);
    });

    test('пустой журнал переносится как пустой', () async {
      final contents = JournalBackup.parse(await backup(oldPhone).export());
      expect(contents.isEmpty, isTrue);
      expect(contents.first, isNull);
      expect(contents.last, isNull);
      expect(await backup(newPhone).hasJournal(), isFalse);
    });

    test('файл — JSON с форматом, версией и временем в UTC; имя — по дате '
        'телефона', () async {
      await seed(oldPhone);
      final json = jsonDecode(
        utf8.decode(await backup(oldPhone).export()),
      ) as Map<String, Object?>;
      expect(json['format'], 'tachogo-journal');
      expect(json['version'], JournalBackup.formatVersion);
      final periods = json['periods']! as List<Object?>;
      final first = periods.first! as Map<String, Object?>;
      expect(first['start'], '2026-09-22T20:00:00.000Z');
      expect(first['mode'], 'driving');
      expect(
        backup(oldPhone).fileName(),
        matches(r'^tachogo-journal-2026-09-2\d\.json$'),
      );
    });
  });

  group('TRF-05: версия формата', () {
    Uint8List file(Object? version) => utf8.encode(
      jsonEncode({
        'format': 'tachogo-journal',
        'version': version,
        'periods': <Object?>[],
        'shifts': <Object?>[],
        'manualShifts': <Object?>[],
        'cardDownloads': <Object?>[],
        'settings': <String, Object?>{},
      }),
    );

    test('файл новой версии — просьба обновить приложение', () {
      expect(
        () => JournalBackup.parse(file(JournalBackup.formatVersion + 1)),
        throwsA(isBackupError(BackupError.newerVersion)),
      );
    });

    test('без версии или с неверной — файл повреждён', () {
      for (final version in [null, 0, '1']) {
        expect(
          () => JournalBackup.parse(file(version)),
          throwsA(isBackupError(BackupError.damaged)),
          reason: '$version',
        );
      }
    });

    test('текущая версия и BOM в начале читаются', () {
      final bytes = Uint8List.fromList([
        0xEF,
        0xBB,
        0xBF,
        ...file(JournalBackup.formatVersion),
      ]);
      expect(JournalBackup.parse(bytes).isEmpty, isTrue);
    });
  });

  group('TRF-06: чужой или повреждённый файл', () {
    late Map<String, Object?> good;

    setUp(() async {
      await seed(oldPhone);
      good = jsonDecode(
        utf8.decode(await backup(oldPhone).export()),
      ) as Map<String, Object?>;
    });

    Uint8List encode(Map<String, Object?> json) =>
        utf8.encode(jsonEncode(json));

    /// Копия файла, где у первой записи [list] поле [key] = [value].
    Map<String, Object?> withField(String list, String key, Object? value) {
      final copy = jsonDecode(jsonEncode(good)) as Map<String, Object?>;
      final items = copy[list]! as List<Object?>;
      (items.first! as Map<String, Object?>)[key] = value;
      return copy;
    }

    test('не JSON, чужой JSON — не файл переноса', () {
      for (final bytes in [
        utf8.encode('activity,start_utc\nDRIVING,2026-09-22T06:30:00Z'),
        utf8.encode('{"hello": "world"}'),
        utf8.encode('[1, 2, 3]'),
        Uint8List.fromList([0xFF, 0xFE, 0x00]),
      ]) {
        expect(
          () => JournalBackup.parse(bytes),
          throwsA(isBackupError(BackupError.notBackup)),
        );
      }
    });

    test('неверные поля — файл повреждён', () {
      for (final broken in [
        withField('periods', 'mode', 'flying'),
        withField('periods', 'start', '2026-09-22 20:00'),
        withField('periods', 'start', null),
        withField('periods', 'end', '2026-09-22T19:00:00.000Z'),
        withField('periods', 'utcOffsetMinutes', 24 * 60),
        withField('periods', 'ferry', 'yes'),
        withField('shifts', 'startCountry', 'POLAND'),
        withField('manualShifts', 'drivingMinutes', -5),
        withField('manualShifts', 'restKind', 'nap'),
        {...good, 'periods': 'none'},
        {
          ...good,
          'cardDownloads': ['вчера'],
        },
        {
          ...good,
          'settings': {'crew_mode': 2},
        },
      ]) {
        expect(
          () => JournalBackup.parse(encode(broken)),
          throwsA(isBackupError(BackupError.damaged)),
          reason: jsonEncode(broken).substring(0, 80),
        );
      }
    });

    test('две идущие записи — файл повреждён', () {
      final copy = withField('periods', 'end', null);
      expect(
        () => JournalBackup.parse(encode(copy)),
        throwsA(isBackupError(BackupError.damaged)),
      );
    });

    test('ошибка записи — журнал нового телефона прежний', () async {
      await ActivityRepository(
        newPhone,
        clock: () => now,
      ).switchMode(DriverMode.otherWork);
      final before = await snapshot(newPhone);
      final contents = JournalBackup.parse(encode(good));
      // Запись с тем же id, что уже вставлена первой, — нарушение ключа
      final broken = BackupContents(
        periods: [
          ...contents.periods,
          contents.periods.first.copyWith(id: const Value(1)),
          contents.periods.first.copyWith(id: const Value(1)),
        ],
        shifts: contents.shifts,
        manualShifts: contents.manualShifts,
        cardDownloads: contents.cardDownloads,
        settings: contents.settings,
      );
      var changed = 0;
      await expectLater(
        backup(newPhone, onChanged: () => changed++).restore(broken),
        throwsA(anything),
      );
      expect(await snapshot(newPhone), before);
      expect(changed, 0);
    });

    test('чужие ключи настроек не записываются', () async {
      final copy = {
        ...good,
        'settings': {'analytics_consent': 'true', 'crew_mode': 'solo'},
      };
      await backup(newPhone).restore(JournalBackup.parse(encode(copy)));
      final settings = SettingsRepository(newPhone);
      expect(await settings.watchAnalyticsConsent().first, isFalse);
      expect((await settings.complianceSettings()).crew, CrewMode.solo);
    });
  });
}

Matcher isBackupError(BackupError error) =>
    isA<BackupException>().having((e) => e.error, 'error', error);
