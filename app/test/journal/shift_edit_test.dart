// Правки журнала через экраны: форма смены (экран 11), дата и время
// (экран 12), корректировки (экран 7) с главной и экранов лимитов. Время и
// длительность вводятся с клавиатуры.
// База в памяти, фиксированные часы. План тестов: JRN-01…07 в
// docs/testing.md (логика — в движке, здесь — что пишут экраны).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/hm_field.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/period_store.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/pickers.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

Duration h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

// Время на экране — местное: ожидания считаются так же, чтобы тест шёл в
// любом часовом поясе (CI-01).
DateTime u(int day, int hour, [int minute = 0]) =>
    DateTime.utc(2026, 9, day, hour, minute);

/// «06:00 → 14:00», «06:00 → идёт» — строка смены в журнале.
String span(DateTime a, [DateTime? b]) =>
    '${formatClock(a)} → ${b == null ? 'идёт' : formatClock(b)}';

/// «Вт, 22.09» — кнопка даты в форме смены.
String dateButton(DateTime t) =>
    '${formatWeekdayShort(t, 'ru')}, ${formatDayMonth(t)}';

/// Местное время [t] так, как его набирают в поле: «0500».
String typed(DateTime t) {
  final local = t.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// Длительность [value] в строке отдыха с оценкой [status]: время суток
/// в других строках формы может выглядеть так же.
Finder restRow(String status, String value) => find.descendant(
  of: find.widgetWithText(Row, status),
  matching: find.text(value),
);

void main() {
  late AppDatabase db;
  late DateTime now;

  setUp(() {
    db = memoryDatabase();
    now = DateTime.utc(2026, 9, 23, 12);
  });
  tearDown(() => db.close());

  /// Запрос к базе из widget-теста: только внутри `runAsync`.
  Future<T> io<T>(WidgetTester tester, Future<T> Function() f) async =>
      (await tester.runAsync(f)) as T;

  Future<void> seed(WidgetTester tester, List<ActivityPeriod> periods) => io(
    tester,
    () => db.transaction(
      () => savePeriodChanges(db, const [], periods, now, EntrySource.live),
    ),
  );

  Future<void> defaultCountry(WidgetTester tester, String code) =>
      io(tester, () => SettingsRepository(db).setDefaultCountry(code));

  Future<void> pump(WidgetTester tester, Widget screen) => pumpScreen(
    tester,
    screen,
    viewport: const Size(412, 1600),
    overrides: databaseOverrides(db, now: () => now),
  );

  /// Касание и ожидание: потоки Drift доставляются только в `runAsync`,
  /// а `pumpAndSettle` не дождётся конца, пока крутится индикатор загрузки.
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    for (var i = 0; i < 3; i++) {
      await settle(tester);
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  ComplianceSnapshot snapshot(
    List<ActivityPeriod> periods, [
    List<ManualShift> manual = const [],
  ]) => calculateCompliance(periods: periods, now: now, manualShifts: manual);

  Future<List<ActivityPeriod>> periods(WidgetTester tester) =>
      io(tester, ActivityRepository(db).periods);

  Future<List<ManualShiftRecord>> manual(WidgetTester tester) => io(
    tester,
    () => JournalEditRepository(
      db,
      SettingsRepository(db),
    ).watchManualShifts().first,
  );

  /// Ввод в поле «Ч:ММ» шторки: цифры, двоеточие ставит поле.
  Future<void> enterHm(WidgetTester tester, String digits) async {
    await tester.enterText(
      find.descendant(
        of: find.byType(HmField).last,
        matching: find.byType(EditableText),
      ),
      digits,
    );
    await tester.pumpAndSettle();
  }

  /// День в календаре шторки «Дата и время».
  Finder day(int d) => find.descendant(
    of: find.descendant(
      of: find.byType(DateTimeField),
      matching: find.byType(InkWell),
    ),
    matching: find.text('$d'),
  );

  group('новая смена из журнала', () {
    testWidgets('«+ Смена» — по умолчанию «Не начат»: смена станет '
        'текущей', (tester) async {
      await defaultCountry(tester, 'PL');
      await pump(tester, const JournalScreen());
      await tap(tester, find.text('Смена'));
      expect(find.text('Новая смена'), findsOneWidget);
      // 10 ч до сейчас, смена идёт — конца и отдыха ещё нет
      expect(find.text(formatClock(u(23, 2))), findsOneWidget);
      expect(find.text('Сейчас (идёт)'), findsOneWidget);
      expect(find.textContaining('Смена станет текущей'), findsOneWidget);
      await tap(tester, find.byTooltip('Сохранить'));

      expect(find.byType(ShiftEditScreen), findsNothing);
      expect(await manual(tester), isEmpty);
      final m = snapshot(await periods(tester));
      expect(m.shift?.start, u(23, 2));
      expect(m.currentMode, DriverMode.otherWork);
      await unmount(tester);
    });

    testWidgets('«Суточный» — ручная смена с итогами и странами, вождение '
        'с клавиатуры', (tester) async {
      await defaultCountry(tester, 'PL');
      await pump(tester, const JournalScreen());
      await tap(tester, find.text('Смена'));
      await tap(tester, find.text('Суточный'));
      expect(find.text(formatClock(u(23, 12))), findsOneWidget);
      expect(find.text('PL'), findsNWidgets(2));
      // Следующей смены нет — отдых идёт, длительность не вводится
      expect(find.text('Идёт до начала следующей смены'), findsOneWidget);

      await tap(tester, find.text('За день'));
      await enterHm(tester, '100');
      expect(find.text('1:00'), findsOneWidget);
      await tap(tester, find.text('Сохранить'));
      await tap(tester, find.byTooltip('Сохранить'));

      expect(find.byType(ShiftEditScreen), findsNothing);
      final saved = (await manual(tester)).single;
      expect(saved.shift.start, DateTime.utc(2026, 9, 23, 2));
      expect(saved.shift.end, DateTime.utc(2026, 9, 23, 12));
      expect(saved.shift.driving, h(1));
      expect(saved.shift.restKind, RestKind.daily);
      expect(saved.meta, const ShiftMeta(startCountry: 'PL', endCountry: 'PL'));
      expect(
        find.textContaining('вручную', findRichText: true),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('шторка длительности — над клавиатурой, поле и «Сохранить» '
        'видны', (tester) async {
      await defaultCountry(tester, 'PL');
      await pump(tester, const JournalScreen());
      await tap(tester, find.text('Смена'));
      await tap(tester, find.text('Суточный'));
      await tap(tester, find.text('За день'));

      // Клавиатура поднялась: 300 dp снизу экрана
      const keyboard = 300.0;
      final ratio = tester.view.devicePixelRatio;
      tester.view.viewInsets = FakeViewPadding(bottom: keyboard * ratio);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();

      final top = tester.view.physicalSize.height / ratio - keyboard;
      final save = find.widgetWithText(PrimaryButton, 'Сохранить');
      expect(tester.getRect(find.byType(HmField).last).bottom, lessThan(top));
      expect(tester.getRect(save).bottom, lessThanOrEqualTo(top));
      await enterHm(tester, '100');
      await tap(tester, save);
      expect(find.text('1:00'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('лимиты сохранению не мешают — нарушения после сохранения', (
      tester,
    ) async {
      await defaultCountry(tester, 'PL');
      // Ручная смена пн 21.09 06:00–16:00; новая — 8 ч после неё
      await io(
        tester,
        () => JournalEditRepository(db, SettingsRepository(db)).saveManualShift(
          ManualShift(
            start: u(21, 6),
            end: u(21, 16),
            driving: h(8),
            restKind: RestKind.daily,
          ),
          const ShiftMeta(startCountry: 'PL', endCountry: 'PL'),
        ),
      );
      await pump(tester, const JournalScreen());
      await tap(tester, find.byIcon(Icons.add));
      // «Суточный» есть и в журнале под формой
      await tap(tester, find.text('Суточный').last);
      await tap(tester, find.text(dateButton(u(23, 2))).first);
      await tap(tester, day(u(22, 0).toLocal().day));
      await enterHm(tester, typed(u(22, 0)));
      await tap(tester, find.text('Конец').last);
      await tap(tester, day(u(22, 11).toLocal().day));
      await enterHm(tester, typed(u(22, 11)));
      await tap(tester, find.text('Готово'));
      await tap(tester, find.text('За день'));
      await enterHm(tester, '1030');
      await tap(tester, find.text('Сохранить'));
      await tap(tester, find.byTooltip('Сохранить'));

      expect(find.text('Смена сохранена. Есть нарушения'), findsOneWidget);
      expect(
        find.textContaining('суточное вождение 10:30 — больше 10 ч'),
        findsOneWidget,
      );
      expect(
        find.textContaining('отдых после смены 8:00 — недостаточный'),
        findsOneWidget,
        reason: 'отдых предыдущей смены закончился началом новой',
      );
      await tap(tester, find.text('Понятно'));
      expect(find.byType(ShiftEditScreen), findsNothing);
      final saved = await manual(tester);
      expect(saved, hasLength(2));
      expect(saved.last.shift.driving, h(10, 30));
      await unmount(tester);
    });

    testWidgets('без страны начала — ошибка и выбор страны', (tester) async {
      await pump(tester, const JournalScreen());
      await tap(tester, find.text('Смена'));
      await tap(tester, find.byTooltip('Сохранить'));
      expect(find.text('Выберите страну начала смены'), findsOneWidget);
      expect(find.text('Страна или код'), findsOneWidget);
      expect(await manual(tester), isEmpty);
      await unmount(tester);
    });

    testWidgets('JRN-02: поверх записанной смены — ошибка с её временем', (
      tester,
    ) async {
      // Текущая смена с 07:00 и ручная 05:00–09:00, которая на неё
      // заходит (записана в обход формы)
      await seed(
        tester,
        consecutive(u(22, 20), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(5)),
        ], open: true),
      );
      await io(
        tester,
        () => JournalEditRepository(db, SettingsRepository(db)).saveManualShift(
          ManualShift(
            start: u(23, 5),
            end: u(23, 9),
            driving: h(2),
            restKind: RestKind.daily,
          ),
          const ShiftMeta(startCountry: 'PL', endCountry: 'PL'),
        ),
      );
      await pump(tester, const JournalScreen());
      await tap(tester, find.text(span(u(23, 5), u(23, 9))));
      await tap(tester, find.text('Изменить смену'));
      await tap(tester, find.byTooltip('Сохранить'));
      final current = u(23, 7);
      expect(
        find.text(
          'Пересекается со сменой ${formatWeekdayDay(current, 'ru')} '
          '${formatClock(current)}–идёт',
        ),
        findsOneWidget,
      );
      expect(find.byType(ShiftEditScreen), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('несохранённые изменения — вопрос при выходе', (tester) async {
      await pump(tester, const JournalScreen());
      await tap(tester, find.text('Смена'));
      await tester.enterText(find.byType(TextField), 'ожидание загрузки');
      await tester.pumpAndSettle();
      await tap(tester, find.byTooltip('Назад'));
      expect(find.text('Сохранить изменения?'), findsOneWidget);
      await tap(tester, find.text('Не сохранять'));
      expect(find.byType(ShiftEditScreen), findsNothing);
      expect(await manual(tester), isEmpty);
      await unmount(tester);
    });
  });

  testWidgets('JRN-06: недельный отдых вручную задаёт отсчёт 144 ч', (
    tester,
  ) async {
    await defaultCountry(tester, 'PL');
    // Сейчас идёт смена с 06:00 — до неё записей нет
    await seed(tester, [
      ActivityPeriod(
        mode: DriverMode.driving,
        start: DateTime.utc(2026, 9, 23, 6),
      ),
    ]);
    await pump(tester, const WeeklyRestScreen());
    expect(find.textContaining('Нет данных'), findsWidgets);
    await tap(tester, find.text('Указать вручную'));
    expect(find.text('Новая смена'), findsOneWidget);
    // По умолчанию — 22.09 09:00–19:00, отдых до текущей смены — 11 ч:
    // для недельного мало. Длительность ищем в строке отдыха: в поясе
    // UTC+2 начало смены на экране — тоже «11:00»
    expect(restRow('недостаточный', '11:00'), findsOneWidget);

    // Смена пт 18.09 09:00–19:00 UTC: день меняется, время суток остаётся.
    // Отдых — до начала текущей смены, ср 23.09 06:00
    await tap(tester, find.text(dateButton(u(22, 9))).first);
    await tap(tester, day(u(18, 9).toLocal().day));
    await tap(tester, find.text('Конец').last);
    await tap(tester, day(u(18, 19).toLocal().day));
    await tap(tester, find.text('Готово'));
    expect(restRow('полный', '107:00'), findsOneWidget);
    await tap(tester, find.byTooltip('Сохранить'));
    expect(find.byType(ShiftEditScreen), findsNothing);

    final saved = (await manual(tester)).single.shift;
    expect(saved.start, DateTime.utc(2026, 9, 18, 9));
    expect(saved.end, DateTime.utc(2026, 9, 18, 19));
    expect(saved.restKind, RestKind.weekly);
    final m = snapshot(await periods(tester), [saved]);
    expect(m.workWeekStart, DateTime.utc(2026, 9, 23, 6));
    expect(m.weeklyRestDeadline, DateTime.utc(2026, 9, 29, 6));
    expect(find.text(formatDeadline(u(29, 6), 'ru')), findsOneWidget);
    await unmount(tester);
  });

  group('JRN-07: правки из записей не выходят за пределы движка', () {
    testWidgets('суточное вождение с главной — за счёт соседней записи', (
      tester,
    ) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 22, 22, 30), [
          (DriverMode.rest, h(11)),
          (DriverMode.otherWork, h(0, 30)),
          (DriverMode.driving, h(2)),
        ], open: true),
      );
      final before = await periods(tester);
      final bounds = drivingAdjustmentBounds(
        before,
        DateTime.utc(2026, 9, 23, 9, 30),
        now,
      )!;
      expect(bounds, (min: -h(2), max: h(0, 30)));

      await pump(tester, const HomeScreen());
      await tester.scrollUntilVisible(
        find.text('Суточное вождение'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tap(tester, find.text('Суточное вождение'));
      expect(find.text('Посчитано приложением'), findsOneWidget);
      expect(find.text('Можно от 0:00 до 2:30'), findsOneWidget);
      // Больше предела — ошибка, сохранить нельзя
      await enterHm(tester, '259');
      expect(find.text('Можно от 0:00 до 2:30'), findsOneWidget);
      expect(
        tester
            .widget<PrimaryButton>(
              find.widgetWithText(PrimaryButton, 'Сохранить'),
            )
            .onPressed,
        isNull,
      );
      await enterHm(tester, '230');
      expect(find.textContaining('+0:30 к расчёту'), findsOneWidget);
      await tap(tester, find.text('Сохранить'));

      final m = snapshot(await periods(tester));
      expect(m.dailyDriving, h(2, 30));
      expect(m.shift?.otherWork, Duration.zero);
      final rows = await io(tester, () => orderedPeriods(db).get());
      expect(rows.map((r) => r.source).toSet(), {EntrySource.live});
      await unmount(tester);
    });

    testWidgets('перерыв (экран 8) — от минуты до соседней записи', (
      tester,
    ) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 22, 22, 40), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(2)),
          (DriverMode.rest, h(0, 20)),
        ], open: true),
      );
      final info = lastBreakInfo(
        await periods(tester),
        DateTime.utc(2026, 9, 23, 9, 40),
        now,
      )!;
      expect(info.max, h(2, 20));

      await pump(tester, const BreakScreen());
      expect(find.text('Текущий перерыв'), findsOneWidget);
      await tap(tester, find.text('Текущий перерыв'));
      expect(find.text('Можно от 0:01 до 2:20'), findsOneWidget);
      await enterHm(tester, '021');
      await tap(tester, find.text('Сохранить'));

      final last = (await periods(tester)).last;
      expect(last.mode, DriverMode.rest);
      expect(last.start, now.subtract(h(0, 21)));
      await unmount(tester);
    });

    testWidgets('начало смены (экран 6) — за счёт отдыха перед ней', (
      tester,
    ) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 22, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(6)),
        ], open: true),
      );
      await pump(tester, const WorkdayScreen());
      await tap(tester, find.text('Изменить начало смены'));
      await enterHm(tester, typed(u(23, 5)));
      await tap(tester, find.text('Готово'));

      final m = snapshot(await periods(tester));
      expect(m.shift?.start, DateTime.utc(2026, 9, 23, 5));
      expect(m.dailyDriving, h(7));
      await unmount(tester);
    });
  });

  group('смена из записей режимов', () {
    Future<void> openFromJournal(WidgetTester tester, String time) async {
      await pump(tester, const JournalScreen());
      await tap(tester, find.text(time));
      await tap(tester, find.text('Изменить смену'));
      expect(find.byType(ShiftEditScreen), findsOneWidget);
    }

    testWidgets('JRN-01: идущая смена — «Суточный» завершает её сейчас', (
      tester,
    ) async {
      await defaultCountry(tester, 'PL');
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 22, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(6)),
        ], open: true),
      );
      await openFromJournal(tester, span(u(23, 6)));
      expect(find.textContaining('Смена идёт по записям'), findsOneWidget);
      await tap(tester, find.text('Суточный'));
      expect(
        find.text(
          'Смена закончится в ${formatClock(now)}, дальше пойдёт отдых.',
        ),
        findsOneWidget,
      );
      await tap(tester, find.byTooltip('Сохранить'));

      final after = await periods(tester);
      expect(after.last.mode, DriverMode.rest);
      expect(after.last.dayEnd, isTrue);
      expect(snapshot(after).status, DriverStatus.dailyRest);
      await unmount(tester);
    });

    testWidgets('идущая смена: правка начала не стирает конечную страну', (
      tester,
    ) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 22, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(6)),
        ], open: true),
      );
      await io(
        tester,
        () => JournalEditRepository(db, SettingsRepository(db)).setShiftMeta(
          DateTime.utc(2026, 9, 23, 6),
          const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
        ),
      );
      await openFromJournal(tester, span(u(23, 6)));
      // «Не начат» уже выбран — касание ничего не меняет
      await tap(tester, find.text('Не начат'));
      expect(find.text('D'), findsOneWidget);
      await tap(tester, find.text(formatClock(u(23, 6))));
      await enterHm(tester, typed(u(23, 5)));
      await tap(tester, find.text('Готово'));
      await tap(tester, find.byTooltip('Сохранить'));

      final meta = await io(
        tester,
        () => JournalEditRepository(
          db,
          SettingsRepository(db),
        ).watchShiftMeta().first,
      );
      expect(meta, {
        DateTime.utc(2026, 9, 23, 5): const ShiftMeta(
          startCountry: 'PL',
          endCountry: 'D',
        ),
      });
      expect(
        snapshot(await periods(tester)).shift?.start,
        DateTime.utc(2026, 9, 23, 5),
      );
      await unmount(tester);
    });

    testWidgets('прошлая смена: страны без смены времени — только страны', (
      tester,
    ) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 21, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(8)),
          (DriverMode.rest, h(16)),
          (DriverMode.driving, h(2)),
        ], open: true),
      );
      await defaultCountry(tester, 'D');
      await openFromJournal(tester, span(u(22, 6), u(22, 14)));
      // Конечная страна не выбрана — кнопка «—»
      await tap(tester, find.text('—'));
      await tester.enterText(
        find.descendant(
          of: find.byType(CountryPicker),
          matching: find.byType(TextField),
        ),
        'LT',
      );
      await tester.pump();
      await tap(tester, find.text('Литва'));
      await tap(tester, find.byTooltip('Сохранить'));

      final meta = await io(
        tester,
        () => JournalEditRepository(
          db,
          SettingsRepository(db),
        ).watchShiftMeta().first,
      );
      expect(
        meta[DateTime.utc(2026, 9, 22, 6)],
        const ShiftMeta(startCountry: 'D', endCountry: 'LT'),
      );
      expect(await manual(tester), isEmpty, reason: 'записи режимов на месте');
      await unmount(tester);
    });

    testWidgets('прошлая смена с другим вождением становится ручной', (
      tester,
    ) async {
      await defaultCountry(tester, 'D');
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 21, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(8)),
          (DriverMode.rest, h(16)),
          (DriverMode.driving, h(2)),
        ], open: true),
      );
      await io(
        tester,
        () => JournalEditRepository(db, SettingsRepository(db)).setShiftMeta(
          DateTime.utc(2026, 9, 22, 6),
          const ShiftMeta(startCountry: 'D', endCountry: 'PL'),
        ),
      );
      await openFromJournal(tester, span(u(22, 6), u(22, 14)));
      await tap(tester, find.text('За день'));
      await enterHm(tester, '700');
      await tap(tester, find.text('Сохранить'));
      expect(find.textContaining('сохранится как ручная'), findsOneWidget);
      await tap(tester, find.byTooltip('Сохранить'));

      final saved = (await manual(tester)).single;
      expect(saved.meta, const ShiftMeta(startCountry: 'D', endCountry: 'PL'));
      expect(saved.shift.driving, h(7));
      expect(saved.shift.continuousDrivingAtEnd, h(7));
      expect(saved.shift.start, DateTime.utc(2026, 9, 22, 6));
      expect((await periods(tester)).map((p) => p.mode), [
        DriverMode.rest,
        DriverMode.driving,
      ]);
      await unmount(tester);
    });

    testWidgets('JRN-05: «Удалить смену» после подтверждения', (tester) async {
      await seed(
        tester,
        consecutive(DateTime.utc(2026, 9, 21, 19), [
          (DriverMode.rest, h(11)),
          (DriverMode.driving, h(8)),
          (DriverMode.rest, h(16)),
          (DriverMode.driving, h(2)),
        ], open: true),
      );
      await openFromJournal(tester, span(u(22, 6), u(22, 14)));
      await tap(tester, find.text('Удалить смену'));
      expect(find.text('Удалить смену?'), findsOneWidget);
      await tap(tester, find.text('Отмена'));
      expect(await periods(tester), hasLength(4));

      await tap(tester, find.text('Удалить смену'));
      await tap(tester, find.text('Удалить'));
      expect(find.byType(ShiftEditScreen), findsNothing);
      final after = await periods(tester);
      expect(after, hasLength(3));
      expect(
        snapshot(after).weeklyDriving,
        h(6),
        reason: 'осталась 06:00–12:00',
      );
      expect(find.text(span(u(22, 6), u(22, 14))), findsNothing);
      await unmount(tester);
    });
  });
}
