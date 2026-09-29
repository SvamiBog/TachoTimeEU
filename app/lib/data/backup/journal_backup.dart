import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// Почему файл переноса не загрузить.
enum BackupError {
  /// Не файл переноса TachoGo: другой файл или не JSON.
  notBackup,

  /// Файл из более новой версии приложения — сначала обновить приложение.
  newerVersion,

  /// Файл переноса, но повреждён: не хватает полей, неверные значения.
  damaged,
}

class BackupException implements Exception {
  const new(this.error, [this.detail]);

  final BackupError error;

  /// Что именно не так, по-английски — для журнала ошибок, водителю не
  /// показывается.
  final String? detail;

  @override
  String toString() =>
      'BackupException(${error.name}${detail == null ? '' : ': $detail'})';
}

/// Журнал из файла переноса: проверен и готов к записи.
class BackupContents {
  const new({
    required this.periods,
    required this.shifts,
    required this.manualShifts,
    required this.cardDownloads,
    required this.settings,
  });

  final List<ActivityPeriodsCompanion> periods;
  final List<ShiftsCompanion> shifts;
  final List<ManualShiftsCompanion> manualShifts;
  final List<DateTime> cardDownloads;
  final Map<String, String> settings;

  /// Журнал в файле пустой: нет ни записей режимов, ни ручных смен.
  bool get isEmpty => periods.isEmpty && manualShifts.isEmpty;

  /// Начало самой ранней записи или ручной смены; null — журнал пустой.
  DateTime? get first {
    final starts = [
      for (final p in periods) p.startUtc.value,
      for (final m in manualShifts) m.startUtc.value,
    ];
    return starts.isEmpty ? null : starts.reduce(_min);
  }

  /// Конец (у идущей — начало) самой поздней записи или ручной смены.
  DateTime? get last {
    final ends = [
      for (final p in periods) p.endUtc.value ?? p.startUtc.value,
      for (final m in manualShifts) m.endUtc.value ?? m.startUtc.value,
    ];
    return ends.isEmpty ? null : ends.reduce(_max);
  }

  static DateTime _min(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
  static DateTime _max(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
}

/// Перенос журнала на другой телефон файлом (Ещё → «Перенос на другой
/// телефон»). На старом телефоне [export] собирает файл со всем журналом:
/// записи режимов, смены со странами и заметками, смены итогами,
/// считывания карты и переносимые настройки
/// (`SettingsRepository.transferableSettings`). На новом [parse] проверяет
/// файл, [restore] заменяет журнал одной транзакцией.
///
/// Формат — JSON, время — ISO-8601 в UTC, длительности — в минутах.
/// [formatVersion] растёт, когда старое приложение не сможет прочитать
/// новый файл; поля читаются по именам, а не по колонкам БД, поэтому смена
/// схемы БД формат не ломает.
///
/// Перенос — Premium-операция (docs/premium.md, закрытие — Фаза 5): здесь
/// будет вторая проверка `EntitlementService`, кроме замка на экране.
class JournalBackup {
  new(this._db, {DateTime Function()? clock, this._onChanged})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Сообщить фоновому сервису, что журнал изменился.
  final void Function()? _onChanged;

  static const formatId = 'tachogo-journal';
  static const formatVersion = 1;
  static const mimeType = 'application/json';

  /// Имя файла: `tachogo-journal-2026-09-29.json`, дата — по телефону.
  String fileName() {
    final d = _clock().toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'tachogo-journal-${d.year}-${two(d.month)}-${two(d.day)}.json';
  }

  /// Есть ли на телефоне журнал, который заменит [restore].
  Future<bool> hasJournal() async =>
      (await (_db.select(_db.activityPeriods)..limit(1)).get()).isNotEmpty ||
      (await (_db.select(_db.manualShifts)..limit(1)).get()).isNotEmpty;

  /// Файл переноса со всем журналом, UTF-8.
  Future<Uint8List> export() async {
    final periods =
        await (_db.select(_db.activityPeriods)..orderBy([
              (p) => OrderingTerm(expression: p.startUtc),
              (p) => OrderingTerm(expression: p.id),
            ]))
            .get();
    final shifts =
        await (_db.select(_db.shifts)..orderBy([
              (s) => OrderingTerm(expression: s.startUtc),
              (s) => OrderingTerm(expression: s.id),
            ]))
            .get();
    final manual =
        await (_db.select(_db.manualShifts)..orderBy([
              (m) => OrderingTerm(expression: m.startUtc),
              (m) => OrderingTerm(expression: m.id),
            ]))
            .get();
    final cards = await (_db.select(
      _db.cardDownloads,
    )..orderBy([(c) => OrderingTerm(expression: c.downloadedAtUtc)])).get();
    final settings = await SettingsRepository(_db).transferableSettings();

    final json = <String, Object?>{
      'format': formatId,
      'version': formatVersion,
      'exportedAt': _time(_clock()),
      'periods': [
        for (final p in periods)
          {
            'mode': p.mode.name,
            'start': _time(p.startUtc),
            'end': _optTime(p.endUtc),
            'utcOffsetMinutes': p.utcOffsetMinutes,
            'source': p.source.name,
            'note': p.note,
            'ferry': p.ferry,
            'dayEnd': p.dayEnd,
            'createdAt': _time(p.createdAt),
            'updatedAt': _time(p.updatedAt),
          },
      ],
      'shifts': [
        for (final s in shifts)
          {
            'start': _time(s.startUtc),
            'end': _optTime(s.endUtc),
            'startCountry': s.startCountry,
            'endCountry': s.endCountry,
            'utcOffsetMinutes': s.utcOffsetMinutes,
            'note': s.note,
          },
      ],
      'manualShifts': [
        for (final m in manual)
          {
            'start': _time(m.startUtc),
            'end': _optTime(m.endUtc),
            'drivingMinutes': m.drivingMinutes,
            'continuousDrivingMinutes': m.continuousDrivingMinutes,
            'restKind': m.restKind.name,
            'restMinutes': m.restMinutes,
            'splitRest': m.splitRest,
            'startCountry': m.startCountry,
            'endCountry': m.endCountry,
            'note': m.note,
            'utcOffsetMinutes': m.utcOffsetMinutes,
            'createdAt': _time(m.createdAt),
            'updatedAt': _time(m.updatedAt),
          },
      ],
      'cardDownloads': [for (final c in cards) _time(c.downloadedAtUtc)],
      'settings': settings,
    };
    return utf8.encode(const JsonEncoder.withIndent(' ').convert(json));
  }

  /// Проверяет файл переноса. Бросает [BackupException].
  static BackupContents parse(Uint8List bytes) {
    final Object? json;
    try {
      var text = utf8.decode(bytes);
      if (text.startsWith('\uFEFF')) text = text.substring(1);
      json = jsonDecode(text);
    } on FormatException {
      throw const BackupException(BackupError.notBackup, 'not JSON');
    }
    if (json is! Map<String, Object?> || json['format'] != formatId) {
      throw const BackupException(BackupError.notBackup, 'no format');
    }
    final version = json['version'];
    if (version is! int || version < 1) {
      throw BackupException(BackupError.damaged, 'version $version');
    }
    if (version > formatVersion) {
      throw BackupException(BackupError.newerVersion, 'version $version');
    }
    return _contents(_Fields(json, 'file'));
  }

  /// Заменяет журнал на телефоне журналом из файла: записи режимов, смены,
  /// ручные смены и считывания карты — удаляются и пишутся заново,
  /// переносимые настройки — перезаписываются, остальные остаются. Одна
  /// транзакция: при ошибке журнал остаётся прежним.
  Future<void> restore(BackupContents contents) async {
    await _db.transaction(() async {
      await _db.delete(_db.activityPeriods).go();
      await _db.delete(_db.manualShifts).go();
      await _db.delete(_db.shifts).go();
      await _db.delete(_db.cardDownloads).go();
      await _db.batch((b) {
        b
          ..insertAll(_db.activityPeriods, contents.periods)
          ..insertAll(_db.shifts, contents.shifts)
          ..insertAll(_db.manualShifts, contents.manualShifts)
          ..insertAll(_db.cardDownloads, [
            for (final t in contents.cardDownloads)
              CardDownloadsCompanion.insert(downloadedAtUtc: t),
          ]);
      });
      await SettingsRepository(_db)
          .importTransferableSettings(contents.settings);
    });
    _onChanged?.call();
  }

  static BackupContents _contents(_Fields file) {
    final periods = [
      for (final p in file.list('periods'))
        ActivityPeriodsCompanion.insert(
          mode: p.enumOf('mode', DriverMode.values.asNameMap()),
          startUtc: p.time('start'),
          endUtc: Value(p.optTime('end')),
          utcOffsetMinutes: p.offset('utcOffsetMinutes'),
          source: p.enumOf('source', EntrySource.values.asNameMap()),
          note: Value(p.optString('note')),
          ferry: Value(p.boolean('ferry')),
          dayEnd: Value(p.boolean('dayEnd')),
          createdAt: p.time('createdAt'),
          updatedAt: p.time('updatedAt'),
        ),
    ];
    final open = periods.where((p) => p.endUtc.value == null).toList();
    if (open.length > 1) {
      throw BackupException(BackupError.damaged, '${open.length} open periods');
    }
    for (final p in periods) {
      final end = p.endUtc.value;
      if (end != null && !end.isAfter(p.startUtc.value)) {
        throw BackupException(
          BackupError.damaged,
          'period ${p.startUtc.value}',
        );
      }
    }

    final shifts = [
      for (final s in file.list('shifts'))
        ShiftsCompanion.insert(
          startUtc: s.time('start'),
          endUtc: Value(s.optTime('end')),
          startCountry: s.country('startCountry'),
          endCountry: Value(s.optCountry('endCountry')),
          utcOffsetMinutes: s.offset('utcOffsetMinutes'),
          note: Value(s.optString('note')),
        ),
    ];

    final manual = [
      for (final m in file.list('manualShifts'))
        ManualShiftsCompanion.insert(
          startUtc: m.time('start'),
          endUtc: Value(m.optTime('end')),
          drivingMinutes: m.minutes('drivingMinutes'),
          continuousDrivingMinutes: Value(
            m.minutes('continuousDrivingMinutes'),
          ),
          restKind: m.enumOf('restKind', RestKind.values.asNameMap()),
          restMinutes: Value(m.minutes('restMinutes')),
          splitRest: Value(m.boolean('splitRest')),
          startCountry: Value(m.optCountry('startCountry')),
          endCountry: Value(m.optCountry('endCountry')),
          note: Value(m.optString('note')),
          utcOffsetMinutes: m.offset('utcOffsetMinutes'),
          createdAt: m.time('createdAt'),
          updatedAt: m.time('updatedAt'),
        ),
    ];
    for (final m in manual) {
      final end = m.endUtc.value;
      if (end != null && !end.isAfter(m.startUtc.value)) {
        throw BackupException(
          BackupError.damaged,
          'manual shift ${m.startUtc.value}',
        );
      }
    }

    return BackupContents(
      periods: periods,
      shifts: shifts,
      manualShifts: manual,
      cardDownloads: file.timeList('cardDownloads'),
      settings: file.stringMap('settings'),
    );
  }

  static String _time(DateTime t) => t.toUtc().toIso8601String();

  static String? _optTime(DateTime? t) => t == null ? null : _time(t);
}

/// Поля объекта из файла: неверное поле — [BackupError.damaged] с путём.
class _Fields {
  const new(this._map, this._path);

  final Map<String, Object?> _map;
  final String _path;

  Never _bad(String key) =>
      throw BackupException(BackupError.damaged, '$_path.$key');

  List<_Fields> list(String key) => switch (_map[key]) {
    final List<Object?> items => [
      for (final (i, item) in items.indexed)
        if (item is Map<String, Object?>)
          _Fields(item, '$_path.$key[$i]')
        else
          _bad('$key[$i]'),
    ],
    _ => _bad(key),
  };

  String? optString(String key) => switch (_map[key]) {
    null => null,
    final String s => s,
    _ => _bad(key),
  };

  bool boolean(String key) => switch (_map[key]) {
    final bool b => b,
    _ => _bad(key),
  };

  /// Длительность в минутах, не меньше нуля.
  int minutes(String key) => switch (_map[key]) {
    final int n when n >= 0 => n,
    _ => _bad(key),
  };

  /// Смещение пояса в минутах: от −14 до +14 часов.
  int offset(String key) => switch (_map[key]) {
    final int n when n.abs() <= 14 * 60 => n,
    _ => _bad(key),
  };

  T enumOf<T>(String key, Map<String, T> values) =>
      values[_map[key]] ?? _bad(key);

  /// Код страны тахографа: 1–3 знака, как в БД.
  String country(String key) => optCountry(key) ?? _bad(key);

  String? optCountry(String key) => switch (_map[key]) {
    null => null,
    final String s when s.isNotEmpty && s.length <= 3 => s,
    _ => _bad(key),
  };

  DateTime time(String key) => optTime(key) ?? _bad(key);

  /// Момент в UTC: строка ISO-8601 с «Z».
  DateTime? optTime(String key) => switch (_map[key]) {
    null => null,
    final String s => _utc(s) ?? _bad(key),
    _ => _bad(key),
  };

  List<DateTime> timeList(String key) => switch (_map[key]) {
    final List<Object?> items => [
      for (final (i, item) in items.indexed)
        (item is String ? _utc(item) : null) ?? _bad('$key[$i]'),
    ],
    _ => _bad(key),
  };

  Map<String, String> stringMap(String key) => switch (_map[key]) {
    final Map<String, Object?> m => {
      for (final e in m.entries)
        e.key: switch (e.value) {
          final String s => s,
          _ => _bad('$key.${e.key}'),
        },
    },
    _ => _bad(key),
  };

  static DateTime? _utc(String s) {
    final t = DateTime.tryParse(s);
    return t != null && t.isUtc ? t : null;
  }
}
