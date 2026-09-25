import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachotime/data/db/app_database.dart';
import 'package:tachotime/data/db/database_provider.dart';
import 'package:tachotime/data/db/tables.dart';
import 'package:tachotime/data/journal/activity_repository.dart';
import 'package:tachotime/data/journal/card_download_repository.dart';
import 'package:tachotime/data/journal/journal_providers.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late ActivityRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 9, 23, 6);
    repo = ActivityRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  void advance(Duration d) => now = now.add(d);

  group('переключение режима', () {
    test('первое переключение открывает запись', () async {
      await repo.switchMode(DriverMode.driving);

      final periods = await repo.periods();
      expect(periods, hasLength(1));
      expect(periods.single.mode, DriverMode.driving);
      expect(periods.single.start, now);
      expect(periods.single.isOpen, isTrue);
      expect(periods.single.id, isNotNull);

      final row = await db.select(db.activityPeriods).getSingle();
      expect(row.source, EntrySource.live);
      expect(row.utcOffsetMinutes, now.toLocal().timeZoneOffset.inMinutes);
    });

    test('следующее закрывает текущую запись и открывает новую', () async {
      await repo.switchMode(DriverMode.driving);
      advance(const Duration(hours: 2));
      await repo.switchMode(DriverMode.rest);

      final [driving, rest] = await repo.periods();
      expect(driving.end, now);
      expect(rest.mode, DriverMode.rest);
      expect(rest.start, now);
      expect(rest.isOpen, isTrue);
    });

    test('повторное нажатие на активный режим ничего не меняет', () async {
      await repo.switchMode(DriverMode.rest);
      final before = await db.select(db.activityPeriods).get();
      advance(const Duration(minutes: 20));
      await repo.switchMode(DriverMode.rest);

      expect(await db.select(db.activityPeriods).get(), before);
    });

    test('паром сохраняется', () async {
      await repo.switchMode(DriverMode.otherWork, ferry: true);
      expect((await repo.periods()).single.ferry, isTrue);
    });
  });

  group('«Завершить день»', () {
    test('во время вождения начинает отдых — конец дня', () async {
      await repo.switchMode(DriverMode.driving);
      advance(const Duration(hours: 1));
      await repo.endDay();

      final periods = await repo.periods();
      expect(periods, hasLength(2));
      expect(periods.last.mode, DriverMode.rest);
      expect(periods.last.dayEnd, isTrue);
    });

    test('во время перерыва текущий отдых становится концом дня', () async {
      await repo.switchMode(DriverMode.driving);
      advance(const Duration(hours: 1));
      await repo.switchMode(DriverMode.rest);
      advance(const Duration(minutes: 20));
      await repo.endDay();

      final periods = await repo.periods();
      expect(periods, hasLength(2));
      expect(periods.last.dayEnd, isTrue);
      expect(periods.last.start, now.subtract(const Duration(minutes: 20)));
    });
  });

  test('журнал читается по возрастанию начала и в UTC', () async {
    for (final mode in [DriverMode.rest, DriverMode.driving, DriverMode.rest]) {
      await repo.switchMode(mode);
      advance(const Duration(minutes: 30));
    }
    final periods = await repo.watchPeriods().first;
    expect(periods.map((p) => p.mode), [
      DriverMode.rest,
      DriverMode.driving,
      DriverMode.rest,
    ]);
    expect(periods.every((p) => p.start.isUtc), isTrue);
    expect(periods.where((p) => p.isOpen), hasLength(1));
  });

  group('расчёт по журналу из БД', () {
    ProviderContainer container() {
      final c = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          activityRepositoryProvider.overrideWithValue(repo),
          cardDownloadRepositoryProvider.overrideWithValue(
            CardDownloadRepository(db, clock: () => now),
          ),
          clockProvider.overrideWith(() => _FixedClock(() => now)),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<ComplianceSnapshot> snapshot(ProviderContainer c) async {
      // Riverpod 3 приостанавливает провайдеры без слушателей.
      c.listen(complianceProvider, (_, _) {});
      await c.read(activityPeriodsProvider.future);
      await c.read(lastCardDownloadProvider.future);
      return c.read(complianceProvider).requireValue;
    }

    test('таймеры идут от записей режимов', () async {
      await repo.switchMode(DriverMode.rest);
      advance(const Duration(hours: 11));
      await repo.switchMode(DriverMode.driving);
      advance(const Duration(hours: 4));

      final m = await snapshot(container());
      expect(m.status, DriverStatus.driving);
      expect(m.continuousDriving, const Duration(hours: 4));
      expect(m.drivingUntilBreak, const Duration(minutes: 30));
      expect(
        m.infringement(InfringementType.breakSoon)?.time,
        const Duration(minutes: 30),
      );
      expect(m.cardDaysLeft, isNull);
    });

    test('считывание карты запускает таймер 28 дней', () async {
      await CardDownloadRepository(db, clock: () => now).record();
      advance(const Duration(days: 3));

      final m = await snapshot(container());
      expect(m.cardDaysLeft, 25);
    });
  });
}

class _FixedClock extends Clock {
  new(this._now);

  final DateTime Function() _now;

  @override
  DateTime build() => _now();
}
