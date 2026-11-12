// «Нарушения» в «Ещё»: нарушения за 56 дней по расчёту движка и пояснения
// водителя к ним. Правила — в движке (violation_log_test). План тестов:
// UI-31 в docs/testing.md.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/violations/violation_notes.dart';
import 'package:tachogo/data/violations/violation_providers.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/violations/violations_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const DriverMode _drive = DriverMode.driving;
const DriverMode _rest = DriverMode.rest;

Duration _h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

/// Пн 21.09: 5 ч без перерыва (ст. 7). Вт 22.09: 10:30 вождения за день
/// (ст. 6(1)). Ср 23.09: с 06:00 за рулём без перерыва — в 11:00 нарушение
/// ещё идёт.
final List<ActivityPeriod> _journal = consecutive(
  DateTime.utc(2026, 9, 21, 6),
  [
    (_drive, _h(5)),
    (_rest, _h(0, 45)),
    (_drive, _h(4)),
    (_rest, _h(14, 15)),
    (_drive, _h(4, 30)),
    (_rest, _h(0, 45)),
    (_drive, _h(4, 30)),
    (_rest, _h(0, 45)),
    (_drive, _h(1, 30)),
    (_rest, _h(12)),
    (_drive, _h(5)),
  ],
  open: true,
);

final DateTime _now = DateTime.utc(2026, 9, 23, 11);

/// Репозиторий, у которого база отказала.
class _BrokenNotes extends ViolationNoteRepository {
  new(super._db);

  @override
  Future<void> save(
    LoggedViolation violation,
    String text, {
    ViolationNote? existing,
  }) => Future.error(StateError('disk full'));
}

Future<void> _pump(
  WidgetTester tester, {
  List<ActivityPeriod>? periods,
  DateTime? now,
  Widget screen = const ViolationsScreen(),
  List<Override> overrides = const [],
}) => pumpScreen(
  tester,
  screen,
  viewport: const Size(412, 2400),
  overrides: [
    ...journalOverrides(periods: periods ?? _journal, now: now ?? _now),
    ...overrides,
  ],
);

/// Значение строки итога с названием [title].
Finder _valueOf(String title, String value) => find.descendant(
  of: find.ancestor(of: find.text(title), matching: find.byType(Row)).first,
  matching: find.text(value),
);

void main() {
  final l = lookupAppLocalizations(const Locale('ru'));

  group('UI-31: нарушения за 56 дней', () {
    testWidgets('нарушений нет — ноль, период проверки и пояснение', (
      tester,
    ) async {
      // День по правилам: 4:30, перерыв 45 мин и ещё 2 ч за рулём
      final clean = consecutive(DateTime.utc(2026, 9, 23, 4), [
        (_drive, _h(4, 30)),
        (_rest, _h(0, 45)),
        (_drive, _h(2)),
      ], open: true);
      await _pump(tester, periods: clean);
      expect(_valueOf('нарушений за 56 дней', '0'), findsOneWidget);
      // 56 суток UTC вместе с 23.09
      expect(_valueOf('Период проверки', '30.07 – 23.09'), findsOneWidget);
      expect(find.text('За 56 дней нарушений нет'), findsOneWidget);
      expect(find.text('Без пояснения'), findsNothing);
      expect(find.text(l.violationsRule), findsOneWidget);
    });

    testWidgets('список от новых к старым: что превышено и на сколько, '
        'когда, статья, сколько ещё в проверке', (tester) async {
      await _pump(tester);
      expect(_valueOf('нарушения за 56 дней', '3'), findsOneWidget);
      expect(_valueOf('Без пояснения', '3'), findsOneWidget);

      final titles = [
        for (final e
            in find
                .byWidgetPredicate(
                  (w) =>
                      w is Text && (w.data?.startsWith('Превышено') ?? false),
                )
                .evaluate())
          (e.widget as Text).data,
      ];
      expect(titles, [
        'Превышено непрерывное вождение',
        'Превышено суточное вождение',
        'Превышено непрерывное вождение',
      ]);

      // Сегодняшнее ещё идёт: с 10:31 UTC, превышение растёт
      expect(find.text('сейчас'), findsOneWidget);
      expect(find.text('Превышение 0:30'), findsNWidgets(3));
      expect(find.text('ЕС 561/2006 · ст. 7'), findsNWidgets(2));
      expect(find.text('ЕС 561/2006 · ст. 6(1)'), findsOneWidget);
      expect(find.text('В проверке ещё 56 дней'), findsOneWidget);
      expect(find.text('В проверке ещё 55 дней'), findsOneWidget);
      expect(find.text('В проверке ещё 54 дня'), findsOneWidget);
      expect(find.text('без пояснения'), findsNWidgets(3));
    });

    testWidgets('пояснение: записать, изменить и удалить', (tester) async {
      await _pump(tester);
      await tester.tap(find.text('Добавить пояснение').first);
      await tester.pumpAndSettle();
      expect(find.text('Пояснение к нарушению'), findsOneWidget);

      // Пустое пояснение не сохранить
      final save = find.widgetWithText(FilledButton, 'Сохранить');
      expect(tester.widget<FilledButton>(save).onPressed, isNull);
      await tester.enterText(find.byType(TextField), 'пробка на A2');
      await tester.pump();
      await tester.tap(save);
      await settle(tester);
      await tester.pumpAndSettle();

      expect(find.text('Пояснение к нарушению'), findsNothing);
      expect(find.text('пробка на A2'), findsOneWidget);
      expect(_valueOf('Без пояснения', '2'), findsOneWidget);
      expect(find.text('без пояснения'), findsNWidgets(2));

      // Изменить
      await tester.tap(find.text('пробка на A2'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, 'пробка на A2'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'пробка и ремонт дороги');
      await tester.pump();
      await tester.tap(save);
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.text('пробка и ремонт дороги'), findsOneWidget);
      expect(_valueOf('Без пояснения', '2'), findsOneWidget);

      // Удалить
      await tester.tap(find.text('пробка и ремонт дороги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Удалить'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.text('пробка и ремонт дороги'), findsNothing);
      expect(_valueOf('Без пояснения', '3'), findsOneWidget);
    });

    testWidgets('запись не удалась — «Не удалось сохранить», шторка и текст '
        'остаются', (tester) async {
      final errors = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      addTearDown(() => FlutterError.onError = previous);

      await _pump(
        tester,
        overrides: [
          violationNoteRepositoryProvider.overrideWith(
            (ref) => _BrokenNotes(memoryDatabase()),
          ),
        ],
      );
      await tester.tap(find.text('Добавить пояснение').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'пробка');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Сохранить'));
      await settle(tester);
      FlutterError.onError = previous;

      expect(find.text(l.shiftSaveFailed), findsOneWidget);
      expect(find.text('Пояснение к нарушению'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'пробка'), findsOneWidget);
      expect(errors, hasLength(1), reason: 'ошибка ушла в отчёт о падениях');
    });

    testWidgets('«Ещё» → «Нарушения» открывает экран', (tester) async {
      await _pump(tester, screen: const MoreScreen());
      expect(find.text('За 56 дней, с вашими пояснениями'), findsOneWidget);
      await tester.tap(find.text('Нарушения'));
      await settle(tester);
      await tester.pumpAndSettle();
      expect(find.byType(ViolationsScreen), findsOneWidget);
      expect(find.text('нарушения за 56 дней'), findsOneWidget);
    });

    testWidgets('часы идут — список пересчитывается: нарушение появляется', (
      tester,
    ) async {
      // 10:30 — ровно 4:30 за рулём, нарушения ещё нет
      await _pump(tester, now: DateTime.utc(2026, 9, 23, 10, 30));
      expect(_valueOf('нарушения за 56 дней', '2'), findsOneWidget);
      expect(find.text('сейчас'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ViolationsScreen)),
      );
      (container.read(clockProvider.notifier) as TestClock).now = DateTime.utc(
        2026,
        9,
        23,
        10,
        36,
      );
      await settle(tester);
      expect(_valueOf('нарушения за 56 дней', '3'), findsOneWidget);
      expect(find.text('сейчас'), findsOneWidget);
      expect(find.text('Превышение 0:06'), findsOneWidget);
    });
  });
}
