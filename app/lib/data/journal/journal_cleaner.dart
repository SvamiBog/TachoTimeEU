/// "Clear all data" in settings.
library;

import 'package:tachogo/data/db/app_database.dart';

/// "Clear all data" (screen 3): activity records, manual shifts, shift
/// countries and notes, card downloads, explanations of infringements — in one
/// transaction. Settings stay:
/// theme, language, calculation rules, automatic detection, analytics consent.
/// Free, like recording activities itself.
class JournalCleaner {
  new(this._db, {this._onChanged});

  final AppDatabase _db;

  /// Сообщить фоновому сервису, что журнал изменился.
  final void Function()? _onChanged;

  Future<void> clearAll() async {
    await _db.transaction(() async {
      await _db.delete(_db.activityPeriods).go();
      await _db.delete(_db.manualShifts).go();
      await _db.delete(_db.shifts).go();
      await _db.delete(_db.cardDownloads).go();
      await _db.delete(_db.violationNotes).go();
    });
    _onChanged?.call();
  }
}
