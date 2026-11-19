/// What a transfer file holds and how it is read: every field is checked by
/// name, and a bad one names its path in the error. The file itself is
/// written and loaded by `JournalBackup` (`journal_backup.dart`).
library;

import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/violations/violation_notes.dart';

/// Why a transfer file cannot be loaded.
enum BackupError {
  /// Не файл переноса TachoGo: другой файл или не JSON.
  notBackup,

  /// Файл из более новой версии приложения — сначала обновить приложение.
  newerVersion,

  /// Файл переноса, но повреждён: не хватает полей, неверные значения.
  damaged,
}

/// A transfer file that cannot be loaded, with the reason.
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

/// The journal from a transfer file, validated and ready to be written.
class BackupContents {
  const new({
    required this.periods,
    required this.shifts,
    required this.manualShifts,
    required this.cardDownloads,
    required this.settings,
    this.violationNotes = const [],
  });

  /// Журнал из файла переноса [json], формат и версия которого уже
  /// проверены. Бросает [BackupException] с путём к неверному полю. Части
  /// читаются по порядку: записи режимов, смены, ручные смены, пояснения,
  /// считывания карты, настройки — ошибка называет первую неверную.
  factory read(Map<String, Object?> json) {
    final file = _Fields(json, 'file');
    final periods = _periods(file);
    final shifts = _shifts(file);
    final manual = _manualShifts(file);
    final notes = _violationNotes(file);
    return BackupContents(
      periods: periods,
      shifts: shifts,
      manualShifts: manual,
      cardDownloads: file.timeList('cardDownloads'),
      settings: file.stringMap('settings'),
      violationNotes: notes,
    );
  }

  final List<ActivityPeriodsCompanion> periods;
  final List<ShiftsCompanion> shifts;
  final List<ManualShiftsCompanion> manualShifts;
  final List<DateTime> cardDownloads;
  final Map<String, String> settings;

  /// Пояснения водителя к нарушениям; в файлах до 11.11.2026 их нет.
  final List<ViolationNotesCompanion> violationNotes;

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

  /// Записи режимов. Открытая — не больше одной, конец не раньше начала.
  static List<ActivityPeriodsCompanion> _periods(_Fields file) {
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
          // С 01.10.2026; в файлах прежних версий поля нет
          weeklyRest: Value(p.optBoolean('weeklyRest')),
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
      // Конец раньше начала; запись нулевой длины безвредна
      if (end != null && end.isBefore(p.startUtc.value)) {
        throw BackupException(
          BackupError.damaged,
          'period ${p.startUtc.value}',
        );
      }
    }
    return periods;
  }

  /// Смены со странами и заметками.
  static List<ShiftsCompanion> _shifts(_Fields file) => [
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

  /// Смены, внесённые итогами; конец не раньше начала.
  static List<ManualShiftsCompanion> _manualShifts(_Fields file) {
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
      if (end != null && end.isBefore(m.startUtc.value)) {
        throw BackupException(
          BackupError.damaged,
          'manual shift ${m.startUtc.value}',
        );
      }
    }
    return manual;
  }

  /// Пояснения водителя к нарушениям. С 11.11.2026; в файлах прежних версий
  /// списка нет. Вид нарушения — текстом, как в БД: неизвестный этой версии
  /// приложения не мешает.
  static List<ViolationNotesCompanion> _violationNotes(_Fields file) => [
    for (final n in file.optList('violationNotes'))
      ViolationNotesCompanion.insert(
        type: n.text('type', max: _maxTypeLength),
        atUtc: n.time('at'),
        untilUtc: n.time('until'),
        note: n.text('note', max: ViolationNoteRepository.maxLength),
        createdAt: n.time('createdAt'),
        updatedAt: n.time('updatedAt'),
      ),
  ];

  /// Длиннее имён видов нарушений не бывает.
  static const _maxTypeLength = 64;
}

/// Fields of an object in the file: a bad field throws [BackupError.damaged]
/// with its path.
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

  /// Список, которого нет в файлах прежних версий приложения: нет — пусто.
  List<_Fields> optList(String key) => _map[key] == null ? const [] : list(key);

  /// Непустой текст не длиннее [max] знаков.
  String text(String key, {required int max}) => switch (_map[key]) {
    final String s when s.trim().isNotEmpty && s.length <= max => s,
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

  /// Поле, которого нет в файлах прежних версий приложения: нет — false.
  bool optBoolean(String key) => switch (_map[key]) {
    null => false,
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
