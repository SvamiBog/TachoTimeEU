/// Moving the journal to another phone as a file: export, validation and
/// restore in one transaction.
library;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:tachogo/data/backup/backup_contents.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

export 'package:tachogo/data/backup/backup_contents.dart'
    show BackupContents, BackupError, BackupException;

/// Moves the journal to another phone as a file (More → "Move to another
/// phone"). On the old phone [export] builds a file with the whole journal:
/// activity records, shifts with countries and notes, manual shifts, card
/// downloads, the driver's explanations of infringements and the transferable
/// settings (`SettingsRepository.transferableSettings`). On the new phone
/// [parse] validates the file and [restore] replaces the journal in one
/// transaction.
///
/// The format is JSON, times are ISO-8601 UTC, durations are minutes.
/// [formatVersion] grows when an older app could not read a new file; fields
/// are read by name, not by database column, so a schema change does not break
/// the format.
///
/// Transfer is a Premium operation (`docs/premium.md`, locked in Phase 5):
/// there will be a second `EntitlementService` check here besides the lock on
/// the screen.
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
    final periods = await _selectPeriods();
    final shifts = await _selectShifts();
    final manual = await _selectManualShifts();
    final cards = await _selectCardDownloads();
    final notes = await _selectViolationNotes();
    final settings = await SettingsRepository(_db).transferableSettings();

    final json = <String, Object?>{
      'format': formatId,
      'version': formatVersion,
      'exportedAt': _time(_clock()),
      'periods': [for (final p in periods) _periodJson(p)],
      'shifts': [for (final s in shifts) _shiftJson(s)],
      'manualShifts': [for (final m in manual) _manualShiftJson(m)],
      'cardDownloads': [for (final c in cards) _time(c.downloadedAtUtc)],
      'violationNotes': [for (final n in notes) _violationNoteJson(n)],
      'settings': settings,
    };
    return utf8.encode(const JsonEncoder.withIndent(' ').convert(json));
  }

  /// Проверяет файл переноса. Бросает [BackupException].
  static BackupContents parse(Uint8List bytes) {
    final Object? json;
    try {
      var text = utf8.decode(bytes);
      if (text.startsWith('﻿')) text = text.substring(1);
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
    return BackupContents.read(json);
  }

  /// Заменяет журнал на телефоне журналом из файла: записи режимов, смены,
  /// ручные смены, считывания карты и пояснения к нарушениям — удаляются и
  /// пишутся заново,
  /// переносимые настройки — перезаписываются, остальные остаются. Одна
  /// транзакция: при ошибке журнал остаётся прежним.
  Future<void> restore(BackupContents contents) async {
    await _db.transaction(() async {
      await _db.delete(_db.activityPeriods).go();
      await _db.delete(_db.manualShifts).go();
      await _db.delete(_db.shifts).go();
      await _db.delete(_db.cardDownloads).go();
      await _db.delete(_db.violationNotes).go();
      await _db.batch((b) {
        b
          ..insertAll(_db.activityPeriods, contents.periods)
          ..insertAll(_db.shifts, contents.shifts)
          ..insertAll(_db.manualShifts, contents.manualShifts)
          ..insertAll(_db.cardDownloads, [
            for (final t in contents.cardDownloads)
              CardDownloadsCompanion.insert(downloadedAtUtc: t),
          ])
          ..insertAll(_db.violationNotes, contents.violationNotes);
      });
      await SettingsRepository(_db)
          .importTransferableSettings(contents.settings);
    });
    _onChanged?.call();
  }

  // Таблицы — в порядке времени, при равном времени — в порядке записи.

  Future<List<ActivityPeriodRow>> _selectPeriods() =>
      (_db.select(_db.activityPeriods)..orderBy([
            (p) => OrderingTerm(expression: p.startUtc),
            (p) => OrderingTerm(expression: p.id),
          ]))
          .get();

  Future<List<ShiftRow>> _selectShifts() =>
      (_db.select(_db.shifts)..orderBy([
            (s) => OrderingTerm(expression: s.startUtc),
            (s) => OrderingTerm(expression: s.id),
          ]))
          .get();

  Future<List<ManualShiftRow>> _selectManualShifts() =>
      (_db.select(_db.manualShifts)..orderBy([
            (m) => OrderingTerm(expression: m.startUtc),
            (m) => OrderingTerm(expression: m.id),
          ]))
          .get();

  Future<List<CardDownloadRow>> _selectCardDownloads() => (_db.select(
    _db.cardDownloads,
  )..orderBy([(c) => OrderingTerm(expression: c.downloadedAtUtc)])).get();

  Future<List<ViolationNoteRow>> _selectViolationNotes() =>
      (_db.select(_db.violationNotes)..orderBy([
            (n) => OrderingTerm(expression: n.atUtc),
            (n) => OrderingTerm(expression: n.id),
          ]))
          .get();

  // Поля в файле — по именам, порядок ключей в файле — как здесь.

  static Map<String, Object?> _periodJson(ActivityPeriodRow p) => {
    'mode': p.mode.name,
    'start': _time(p.startUtc),
    'end': _optTime(p.endUtc),
    'utcOffsetMinutes': p.utcOffsetMinutes,
    'source': p.source.name,
    'note': p.note,
    'ferry': p.ferry,
    'dayEnd': p.dayEnd,
    'weeklyRest': p.weeklyRest,
    'createdAt': _time(p.createdAt),
    'updatedAt': _time(p.updatedAt),
  };

  static Map<String, Object?> _shiftJson(ShiftRow s) => {
    'start': _time(s.startUtc),
    'end': _optTime(s.endUtc),
    'startCountry': s.startCountry,
    'endCountry': s.endCountry,
    'utcOffsetMinutes': s.utcOffsetMinutes,
    'note': s.note,
  };

  static Map<String, Object?> _manualShiftJson(ManualShiftRow m) => {
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
  };

  static Map<String, Object?> _violationNoteJson(ViolationNoteRow n) => {
    'type': n.type,
    'at': _time(n.atUtc),
    'until': _time(n.untilUtc),
    'note': n.note,
    'createdAt': _time(n.createdAt),
    'updatedAt': _time(n.updatedAt),
  };

  static String _time(DateTime t) => t.toUtc().toIso8601String();

  static String? _optTime(DateTime? t) => t == null ? null : _time(t);
}
