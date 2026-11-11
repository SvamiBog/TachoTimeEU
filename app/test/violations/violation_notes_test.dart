// Пояснения водителя к нарушениям: хранение и поиск «своего» нарушения
// после пересчёта журнала. План тестов: JRN-14 в docs/testing.md.

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/journal_cleaner.dart';
import 'package:tachogo/data/violations/violation_notes.dart';
import 'package:tachogo/data/violations/violation_providers.dart';

LoggedViolation _violation(
  DateTime at, {
  DateTime? until,
  InfringementType type = InfringementType.continuousExceeded,
  Duration time = const Duration(minutes: 20),
}) => LoggedViolation(
  at: at,
  until: until,
  infringement: Infringement(type, time: time),
);

ViolationNote _note(
  int id,
  DateTime at,
  DateTime until, {
  InfringementType type = InfringementType.continuousExceeded,
}) => ViolationNote(id: id, type: type, at: at, until: until, text: 'n$id');

ViolationLogInputs _inputs({
  required List<ActivityPeriod> periods,
  required List<ManualShift> manualShifts,
  required ComplianceSettings settings,
  required Map<DateTime, ShiftRoute> routes,
  required DateTime from,
  required DateTime now,
}) => (
  periods: periods,
  manualShifts: manualShifts,
  settings: settings,
  routes: routes,
  from: from,
  now: now,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final now = DateTime.utc(2026, 9, 23, 18);
  final at = DateTime.utc(2026, 9, 23, 10, 31);
  final until = DateTime.utc(2026, 9, 23, 11, 35);

  group('JRN-14: хранение', () {
    late AppDatabase db;
    late ViolationNoteRepository notes;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      notes = ViolationNoteRepository(db, clock: () => now);
    });
    tearDown(() => db.close());

    test('пояснение записано с видом и временем нарушения, пробелы по '
        'краям убраны', () async {
      await notes.save(_violation(at, until: until), '  пробка на A2\n');
      final saved = await notes.watchAll().first;
      expect(saved, hasLength(1));
      expect(saved.single.type, InfringementType.continuousExceeded);
      expect(saved.single.at, at);
      expect(saved.single.until, until);
      expect(saved.single.text, 'пробка на A2');
    });

    test('у ещё не устранённого нарушения конец — момент записи', () async {
      await notes.save(_violation(at), 'нет стоянки');
      expect((await notes.watchAll().first).single.until, now);
    });

    test('новый текст заменяет прежний и привязывается к нарушению '
        'заново', () async {
      await notes.save(_violation(at, until: until), 'пробка');
      final first = (await notes.watchAll().first).single;
      final moved = _violation(
        at.add(const Duration(minutes: 5)),
        until: until,
      );
      await notes.save(moved, 'пробка и ремонт дороги', existing: first);
      final saved = await notes.watchAll().first;
      expect(saved, hasLength(1));
      expect(saved.single.id, first.id);
      expect(saved.single.at, moved.at);
      expect(saved.single.text, 'пробка и ремонт дороги');
    });

    test('пустой текст пояснение удаляет, а нового не создаёт', () async {
      await notes.save(_violation(at, until: until), '   ');
      expect(await notes.watchAll().first, isEmpty);

      await notes.save(_violation(at, until: until), 'пробка');
      final saved = (await notes.watchAll().first).single;
      await notes.save(_violation(at, until: until), ' ', existing: saved);
      expect(await notes.watchAll().first, isEmpty);
    });

    test('текст длиннее 500 знаков обрезается', () async {
      await notes.save(_violation(at, until: until), 'я' * 600);
      expect(
        (await notes.watchAll().first).single.text,
        hasLength(ViolationNoteRepository.maxLength),
      );
    });

    test('пояснение к виду нарушения, которого в этой версии нет, не '
        'читается и чтению не мешает', () async {
      await notes.save(_violation(at, until: until), 'пробка');
      await db
          .into(db.violationNotes)
          .insert(
            ViolationNotesCompanion.insert(
              type: 'fromNewerApp',
              atUtc: at,
              untilUtc: until,
              note: 'из новой версии',
              createdAt: now,
              updatedAt: now,
            ),
          );
      expect((await notes.watchAll().first).map((n) => n.text), ['пробка']);
    });

    test('«Очистить все данные» удаляет и пояснения', () async {
      await notes.save(_violation(at, until: until), 'пробка');
      await JournalCleaner(db).clearAll();
      expect(await db.select(db.violationNotes).get(), isEmpty);
    });
  });

  group('JRN-14: пояснение находит своё нарушение', () {
    test('та же первая минута — своё, другой вид — нет', () {
      final violations = [
        _violation(at, until: until),
        _violation(at, until: until, type: InfringementType.shiftExceeded),
      ];
      final matched = matchViolationNotes(violations, [
        _note(1, at, until),
      ], now);
      expect(matched.map((n) => n?.id), [1, null]);
    });

    test('после правки смены нарушение началось раньше или позже — время '
        'пересекается, пояснение остаётся', () {
      final note = _note(1, at, until);
      for (final shift in const [
        Duration(minutes: -20),
        Duration(minutes: 15),
      ]) {
        final moved = _violation(at.add(shift), until: until.add(shift));
        expect(matchViolationNotes([moved], [note], now).single?.id, 1);
      }
    });

    test('нарушение того же вида на другой день чужое пояснение не '
        'получает', () {
      final next = _violation(
        at.add(const Duration(days: 1)),
        until: until.add(const Duration(days: 1)),
      );
      expect(
        matchViolationNotes([next], [_note(1, at, until)], now).single,
        isNull,
      );
    });

    test('одно пояснение — одному нарушению: точное совпадение важнее, '
        'из пересекающихся — ближайшее', () {
      final early = _violation(
        at.subtract(const Duration(minutes: 30)),
        until: until,
      );
      final exact = _violation(at, until: until);
      final matched = matchViolationNotes(
        [early, exact],
        [_note(1, at, until)],
        now,
      );
      expect(matched.map((n) => n?.id), [null, 1]);

      final far = _note(2, at.subtract(const Duration(minutes: 25)), until);
      final near = _note(3, at.add(const Duration(minutes: 2)), until);
      final moved = _violation(
        at.add(const Duration(minutes: 5)),
        until: until,
      );
      expect(matchViolationNotes([moved], [far, near], now).single?.id, 3);
    });

    test('у идущего нарушения конец — сейчас', () {
      final active = _violation(at);
      final later = _note(1, at.add(const Duration(hours: 2)), now);
      expect(matchViolationNotes([active], [later], now).single?.id, 1);
    });
  });

  group('JRN-14: расчёт для экрана', () {
    final start = DateTime.utc(2026, 9, 23, 6);
    final periods = [
      ActivityPeriod(mode: DriverMode.driving, start: start, end: at),
      ActivityPeriod(mode: DriverMode.driving, start: at),
    ];

    test('в приложении журнал нарушений считается в отдельном изоляте — '
        'результат тот же', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final inputs = _inputs(
        periods: periods,
        manualShifts: [
          ManualShift(
            start: DateTime.utc(2026, 9, 20, 6),
            end: DateTime.utc(2026, 9, 20, 22),
            driving: const Duration(hours: 11),
            restKind: RestKind.daily,
          ),
        ],
        settings: const ComplianceSettings(baseCountry: 'PL'),
        routes: {start: const ShiftRoute(from: 'PL', to: 'D')},
        from: inspectionStart(now),
        now: now,
      );
      final computed = await container.read(violationLogComputerProvider)(
        inputs,
      );
      expect(computed, computeViolationLog(inputs));
      expect(computed.map((v) => v.type), [
        InfringementType.dailyDriveExceeded,
        InfringementType.shiftExceeded,
        InfringementType.continuousExceeded,
        InfringementType.dailyDriveExceeded,
      ]);
    });

    test('список — от новых к старым, с пояснением и сроком в '
        'проверке', () async {
      final container = ProviderContainer(
        overrides: [
          violationLogProvider.overrideWith(
            (ref) async => (
              from: inspectionStart(now),
              now: now,
              violations: [
                _violation(at.subtract(const Duration(days: 3)), until: until),
                _violation(at),
              ],
            ),
          ),
          violationNotesProvider.overrideWith(
            (ref) => Stream.value([_note(7, at, now)]),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(violationListProvider, (_, _) {});
      addTearDown(subscription.close);
      expect(container.read(violationListProvider).isLoading, isTrue);
      await container.read(violationLogProvider.future);
      await container.read(violationNotesProvider.future);

      final list = container.read(violationListProvider).value!;
      expect(list.entries.map((e) => e.violation.at), [
        at,
        at.subtract(const Duration(days: 3)),
      ]);
      expect(list.entries.map((e) => e.note?.id), [7, null]);
      expect(list.entries.map((e) => e.daysLeft), [56, 53]);
      expect(list.unexplained, 1);
      expect(list.from, DateTime.utc(2026, 7, 30));
    });

    test('расчёт не удался — ошибка, а не пустой список', () async {
      final container = ProviderContainer(
        overrides: [
          violationLogProvider.overrideWith(
            (ref) async => throw StateError('no journal'),
          ),
          violationNotesProvider.overrideWith((ref) => Stream.value([])),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(violationListProvider, (_, _) {});
      addTearDown(subscription.close);
      await expectLater(
        container.read(violationLogProvider.future),
        throwsStateError,
      );
      expect(container.read(violationListProvider).hasError, isTrue);
    });
  });

  group('JRN-14: период проверки — 56 суток UTC вместе с сегодняшними', () {
    test('начало — 00:00 UTC 55 дней назад', () {
      expect(inspectionStart(now), DateTime.utc(2026, 7, 30));
    });

    test('сегодняшнее нарушение в проверке 56 суток, начатое в первый '
        'день периода — последние', () {
      expect(inspectionDaysLeft(at, now), 56);
      expect(inspectionDaysLeft(DateTime.utc(2026, 9, 22, 23, 59), now), 55);
      expect(inspectionDaysLeft(inspectionStart(now), now), 1);
    });
  });
}
