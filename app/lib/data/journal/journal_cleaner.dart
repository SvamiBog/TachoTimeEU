import 'package:tachogo/data/db/app_database.dart';

/// «Очистить все данные» (экран 3): журнал режимов, ручные смены, страны
/// и заметки смен, считывания карты — одной транзакцией. Настройки
/// остаются: тема, язык, правила расчёта, автоопределение, согласие на
/// аналитику. Бесплатно, как и сам учёт режимов.
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
    });
    _onChanged?.call();
  }
}
