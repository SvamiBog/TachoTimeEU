import 'dart:io' show sleep;
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.steps.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/db/utc_date_time_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ActivityPeriods, Shifts, ManualShifts, CardDownloads, Settings],
)
class AppDatabase extends _$AppDatabase {
  new([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'tachogo',
              native: const DriftNativeOptions(setup: configureConnection),
            ),
      );

  /// Сколько запись ждёт, пока база занята другим соединением.
  static const busyTimeout = Duration(seconds: 5);

  static const _busyPauses = [
    Duration(milliseconds: 1),
    Duration(milliseconds: 2),
    Duration(milliseconds: 5),
    Duration(milliseconds: 10),
    Duration(milliseconds: 20),
  ];

  /// Журнал пишут два Flutter-движка: приложение и фоновый сервис
  /// автоопределения (Android). `shareAcrossIsolates` между независимыми
  /// движками не работает, поэтому у каждого своё соединение: WAL позволяет
  /// читать во время записи, а при занятой базе запись ждёт до [timeout].
  /// Об изменениях движки сообщают друг другу сами (`markTablesUpdated`).
  ///
  /// Ожидание считаем по часам сами, а не через `PRAGMA busy_timeout`: SQLite
  /// спит между попытками через `nanosleep` и засчитывает паузу целиком, даже
  /// если сон прервал сигнал. Профилировщик Dart (debug- и profile-сборки,
  /// `flutter test`) шлёт сигналы потоку примерно раз в миллисекунду, и 5 с
  /// ожидания заканчивались примерно за 70 мс.
  static void configureConnection(
    CommonDatabase db, {
    Duration timeout = busyTimeout,
  }) {
    final waited = Stopwatch();
    db
      ..execute('PRAGMA journal_mode = WAL')
      ..busyHandler = (attempt) {
        if (attempt == 0) {
          waited
            ..reset()
            ..start();
        }
        if (waited.elapsed >= timeout) return false;
        sleep(_busyPauses[math.min(attempt, _busyPauses.length - 1)]);
        return true;
      };
  }

  // При изменении схемы: увеличить версию, затем
  // `dart run drift_dev make-migrations` и дописать шаг в onUpgrade.
  @override
  int get schemaVersion => 4;

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
      from2To3: (m, schema) async {
        // Ручные смены и заметки к сменам (Фаза 2, журнал).
        await m.createTable(schema.manualShifts);
        await m.addColumn(schema.shifts, schema.shifts.note);
      },
      from3To4: (m, schema) async {
        // Недельный отдых, объявленный водителем (отзыв 01.10.2026).
        final periods = schema.activityPeriods;
        await m.addColumn(periods, periods.weeklyRest);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
