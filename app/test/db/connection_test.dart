// Соединение с базой: версия схемы, режим WAL, ожидание блокировки и два
// соединения с одним файлом, как у приложения и фонового сервиса.
// План тестов: DB-01…03 в docs/testing.md.
import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory dir;
  late File file;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('tachogo_db_');
    file = File('${dir.path}/tachogo.sqlite');
    // Выполняется последним — после закрытия соединений
    addTearDown(() async {
      try {
        await dir.delete(recursive: true);
      } on FileSystemException {
        // Windows отпускает файл не сразу; временную папку уберёт система
      }
    });
  });

  /// Соединение, как в приложении: в своём изоляте, с настройкой WAL.
  AppDatabase open() {
    final db = AppDatabase(
      NativeDatabase.createInBackground(
        file,
        setup: AppDatabase.configureConnection,
      ),
    );
    addTearDown(db.close);
    return db;
  }

  Future<Object?> pragma(AppDatabase db, String name) async =>
      (await db.customSelect('PRAGMA $name').getSingle()).data.values.single;

  test('DB-01: версия схемы — последняя из drift_schemas/', () {
    final versions = [
      for (final f in Directory('drift_schemas/app_database').listSync())
        if (RegExp(r'drift_schema_v(\d+)\.json$').firstMatch(f.path)
            case final m?)
          int.parse(m[1]!),
    ];
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(versions, isNotEmpty);
    expect(db.schemaVersion, versions.reduce((a, b) => a > b ? a : b));
  });

  test('DB-02: WAL, ожидание блокировки 5 с, внешние ключи', () async {
    final db = open();
    expect(await pragma(db, 'journal_mode'), 'wal');
    expect(await pragma(db, 'busy_timeout'), 5000);
    expect(await pragma(db, 'foreign_keys'), 1);
  });

  group('DB-03: два соединения с одним файлом', () {
    final t0 = DateTime.utc(2026, 9, 23, 6);

    test('занятая база ждёт, а не падает', () async {
      final app = open();
      final service = open();
      await app.customSelect('SELECT 1').get();
      await service.customSelect('SELECT 1').get();

      final release = Completer<void>();
      final holding = Completer<void>();
      final appWrite = app.transaction(() async {
        await ActivityRepository(
          app,
          clock: () => t0,
        ).switchMode(DriverMode.otherWork);
        holding.complete();
        await release.future;
      });
      await holding.future;

      // Пока приложение держит блокировку, сервис пишет и переключает режим
      final serviceWrites = Future.wait([
        service
            .into(service.cardDownloads)
            .insert(CardDownloadsCompanion.insert(downloadedAtUtc: t0)),
        ActivityRepository(
          service,
          clock: () => t0.add(const Duration(minutes: 1)),
        ).switchMode(DriverMode.driving),
      ]);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      release.complete();
      await appWrite;
      await serviceWrites;

      expect(await app.select(app.cardDownloads).get(), hasLength(1));
      // Сервис увидел запись приложения и закрыл её
      final periods = await ActivityRepository(service).periods();
      expect(periods.map((p) => p.mode), [
        DriverMode.otherWork,
        DriverMode.driving,
      ]);
      expect(periods.first.end, periods.last.start);
    });

    test('одновременные переключения из двух движков не теряются', () async {
      final app = open();
      final service = open();
      var now = t0;
      final appRepo = ActivityRepository(app, clock: () => now);
      final serviceRepo = ActivityRepository(service, clock: () => now);
      await appRepo.switchMode(DriverMode.rest);

      for (var i = 0; i < 20; i++) {
        now = now.add(const Duration(minutes: 1));
        await Future.wait([
          appRepo.switchMode(i.isEven ? DriverMode.otherWork : DriverMode.rest),
          serviceRepo.switchMode(DriverMode.driving),
        ]);
      }

      final periods = await appRepo.periods();
      expect(periods.where((p) => p.isOpen), hasLength(1));
      expect(
        () => calculateCompliance(periods: periods, now: now),
        returnsNormally,
      );
    });

    test('markTablesUpdated во втором соединении обновляет журнал', () async {
      final app = open();
      final service = open();
      final appRepo = ActivityRepository(app, clock: () => t0);
      final serviceRepo = ActivityRepository(service, clock: () => t0);

      final seen = <int>[];
      final sub = appRepo.watchPeriods().listen((p) => seen.add(p.length));
      addTearDown(sub.cancel);
      await _until(() => seen.isNotEmpty);
      expect(seen, [0]);

      await serviceRepo.switchMode(DriverMode.driving);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      // Другое соединение само об изменениях не узнаёт
      expect(seen, [0]);

      app.markTablesUpdated({app.activityPeriods});
      await _until(() => seen.length > 1);
      expect(seen.last, 1);
    });
  });
}

Future<void> _until(bool Function() done) async {
  for (var i = 0; i < 100 && !done(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}
