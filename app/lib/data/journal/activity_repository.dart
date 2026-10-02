import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/period_store.dart';

/// Журнал режимов в БД.
///
/// Переключение режима — отдельный путь «живой» записи: он не проходит через
/// слой ручных правок и проверку Premium (docs/premium.md). Логику переходов
/// задаёт движок (`changeMode`), репозиторий только сохраняет разницу.
class ActivityRepository {
  new(this._db, {DateTime Function()? clock, this._onChanged})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Вызывается после записи: сообщить другому Flutter-движку (приложению
  /// или фоновому сервису), что журнал изменился.
  final void Function()? _onChanged;

  /// Все записи журнала по возрастанию начала.
  Stream<List<ActivityPeriod>> watchPeriods() =>
      orderedPeriods(_db)
          .watch()
          .map((rows) => [for (final r in rows) periodFromRow(r)]);

  Future<List<ActivityPeriod>> periods() async => [
    for (final r in await orderedPeriods(_db).get()) periodFromRow(r),
  ];

  /// Переключает режим. Повторное нажатие на активный режим ничего не
  /// меняет. [ferry] — водитель на пароме / поезде (ст. 9); без него новая
  /// запись продолжает отметку текущей.
  ///
  /// [at] — момент переключения, если он уже прошёл: автоопределение
  /// замечает движение с задержкой и переключает с начала движения. Момент
  /// не позже текущего и не раньше начала текущей записи.
  Future<void> switchMode(DriverMode mode, {bool? ferry, DateTime? at}) =>
      _changeOpen(
        (open, at) => changeMode(open, mode, at, ferry: ferry),
        at: at,
      );

  /// «Завершить день»: отдых, который сразу завершает смену. Во время
  /// перерыва текущий отдых становится концом дня. [weekly] — «Начать
  /// недельный отдых»: пока отдых идёт, он недельный.
  Future<void> endDay({bool weekly = false}) => _changeOpen(
    (open, at) =>
        changeMode(open, DriverMode.rest, at, dayEnd: true, weeklyRest: weekly),
  );

  /// Режим «паром / поезд» (ст. 9): отметка у текущей записи, следующие
  /// записи её наследуют. Без открытой записи ничего не меняет.
  Future<void> setFerryMode({required bool on}) =>
      _changeOpen((open, _) => setFerry(open, ferry: on));

  /// Переходы между режимами затрагивают только открытую запись, поэтому
  /// журнал целиком не читаем.
  Future<void> _changeOpen(
    List<ActivityPeriod> Function(List<ActivityPeriod> open, DateTime at)
    change, {
    DateTime? at,
  }) async {
    final changed = await _db.transaction(() async {
      final now = _clock().toUtc();
      final rows = await (_db.select(
        _db.activityPeriods,
      )..where((t) => t.endUtc.isNull())).get();
      final open = [for (final r in rows) periodFromRow(r)];
      var when = at == null || at.isAfter(now) ? now : at.toUtc();
      for (final p in open) {
        if (p.start.isAfter(when)) when = p.start;
      }
      final updated = change(open, when);
      if (identical(updated, open)) return false;
      await savePeriodChanges(_db, open, updated, now, EntrySource.live);
      return true;
    });
    if (changed) _onChanged?.call();
  }
}
