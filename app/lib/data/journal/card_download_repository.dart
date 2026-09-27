import 'package:drift/drift.dart';
import 'package:tachogo/data/db/app_database.dart';

/// Считывания карты водителя: от последнего считается лимит 28 дней.
class CardDownloadRepository {
  new(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Последнее считывание; null — водитель ещё не отмечал.
  Stream<DateTime?> watchLast() {
    final latest = _db.cardDownloads.downloadedAtUtc.max();
    return (_db.selectOnly(_db.cardDownloads)..addColumns([latest]))
        .map((row) => row.read(latest)?.toUtc())
        .watchSingle();
  }

  /// Последнее считывание для расчёта вне экрана (фоновое уведомление).
  Future<DateTime?> last() async {
    final latest = _db.cardDownloads.downloadedAtUtc.max();
    final row = await (_db.selectOnly(
      _db.cardDownloads,
    )..addColumns([latest])).getSingle();
    return row.read(latest)?.toUtc();
  }

  /// Отмечает считывание сейчас.
  Future<void> record() => _db
      .into(_db.cardDownloads)
      .insert(CardDownloadsCompanion.insert(downloadedAtUtc: _clock().toUtc()));
}
