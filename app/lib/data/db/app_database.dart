import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.steps.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/db/utc_date_time_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ActivityPeriods, Shifts, CardDownloads, Settings])
class AppDatabase extends _$AppDatabase {
  new([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'tachogo',
              native: const DriftNativeOptions(setup: configureConnection),
            ),
      );

  /// Журнал пишут два Flutter-движка: приложение и фоновый сервис
  /// автоопределения (Android). `shareAcrossIsolates` между независимыми
  /// движками не работает, поэтому у каждого своё соединение: WAL позволяет
  /// читать во время записи, а при занятой базе запись ждёт до 5 с.
  /// Об изменениях движки сообщают друг другу сами (`markTablesUpdated`).
  static void configureConnection(CommonDatabase db) => db
    ..execute('PRAGMA journal_mode = WAL')
    ..execute('PRAGMA busy_timeout = 5000');

  // При изменении схемы: увеличить версию, затем
  // `dart run drift_dev make-migrations` и дописать шаг в onUpgrade.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // Отметки «паром» и «конец дня» для движка (Фаза 1).
        final periods = schema.activityPeriods;
        await m.addColumn(periods, periods.ferry);
        await m.addColumn(periods, periods.dayEnd);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
