// «Ещё» (экран 4): экспорт, инструкция и правила, о приложении (лицензии
// пакетов и шрифтов — строкой на нём), политика конфиденциальности, в бете —
// «Сообщить о проблеме». План тестов: UI-21, BETA-02 в docs/testing.md.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/core/diagnostics/diagnostics.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/more/about_screen.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/more/problem_report.dart';

import '../notifications/fake_notification_platform.dart';
import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

/// «Поделиться» в памяти: что ушло водителю в меню отправки.
class _FakeSharer implements TextSharer {
  final sent = <({String text, String subject})>[];
  Error? error;

  @override
  Future<void> share({required String text, required String subject}) async {
    if (error case final e?) throw e;
    sent.add((text: text, subject: subject));
  }
}

/// Браузер в памяти: какие ссылки открывались.
class _FakeLinks implements LinkOpener {
  final opened = <Uri>[];

  /// false — на телефоне нет браузера.
  bool canOpen = true;

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return canOpen;
  }
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    bool beta = false,
    _FakeSharer? sharer,
    _FakeLinks? links,
    Locale locale = const Locale('ru'),
  }) {
    final week = designWeek();
    return pumpScreen(
      tester,
      const MoreScreen(),
      locale: locale,
      overrides: [
        ...journalOverrides(periods: week.periods, now: week.now),
        problemReportEnabledProvider.overrideWithValue(beta),
        if (sharer != null) textSharerProvider.overrideWithValue(sharer),
        if (links != null) linkOpenerProvider.overrideWithValue(links),
        diagnosticsCollectorProvider.overrideWith(
          (ref) => DiagnosticsCollector(
            settings: ref.watch(settingsRepositoryProvider),
            journal: ref.watch(activityRepositoryProvider),
            edits: ref.watch(journalEditRepositoryProvider),
            cards: ref.watch(cardDownloadRepositoryProvider),
            tracking: ref.watch(trackingServiceProvider),
            notifications: FakeNotificationPlatform(),
            appVersion: () async => '0.2.0-beta.1 (20001)',
            clock: () => week.now,
          ),
        ),
      ],
    );
  }

  testWidgets('UI-21: экспорт, инструкция, о приложении с версией', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Ещё'), findsOneWidget);
    expect(find.text('Экспорт отчёта'), findsOneWidget);
    expect(find.text('Инструкция и правила'), findsOneWidget);
    expect(find.text('О приложении'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
    expect(find.textContaining('не заменяет тахограф'), findsOneWidget);
  });

  testWidgets('«Инструкция и правила» открывает экран 17, «назад» — '
      'обратно', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Инструкция и правила'));
    await tester.pumpAndSettle();
    expect(find.byType(GuideScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    expect(find.byType(GuideScreen), findsNothing);
  });

  testWidgets('«Экспорт отчёта» открывает шторку отчёта', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Экспорт отчёта'));
    await tester.pumpAndSettle();
    expect(find.text('Создать отчёт'), findsOneWidget);
  });

  testWidgets('«О приложении» — название, версия и оговорка; лицензии — '
      'строкой на нём', (tester) async {
    await pump(tester);
    await tester.tap(find.text('О приложении'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.byType(LicensePage), findsNothing);
    expect(find.text('TachoGo'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
    expect(find.textContaining('не заменяет тахограф'), findsOneWidget);
    await tester.tap(find.text('Лицензии открытого ПО'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('TachoGo'), findsWidgets);
    expect(find.text('0.1.0'), findsWidgets);
  });

  group('UI-21: политика конфиденциальности', () {
    Future<void> openPolicy(WidgetTester tester, String title) async {
      await tester.scrollUntilVisible(
        find.text(title),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }

    testWidgets('открывается в браузере на русском', (tester) async {
      final links = _FakeLinks();
      await pump(tester, links: links);
      await openPolicy(tester, 'Политика конфиденциальности');
      expect(links.opened, [
        Uri.parse('https://svamibog.github.io/TachoTimeEU/privacy/#ru'),
      ]);
    });

    testWidgets('у остальных языков — английский текст', (tester) async {
      final links = _FakeLinks();
      await pump(tester, links: links, locale: const Locale('pl'));
      await openPolicy(tester, 'Polityka prywatności');
      expect(links.opened.single.fragment, 'en');
    });

    testWidgets('браузера нет — адрес страницы в плашке', (tester) async {
      final links = _FakeLinks()..canOpen = false;
      await pump(tester, links: links);
      await openPolicy(tester, 'Политика конфиденциальности');
      expect(
        find.text(
          'Не удалось открыть браузер. Адрес страницы: '
          'https://svamibog.github.io/TachoTimeEU/privacy/',
        ),
        findsOneWidget,
      );
    });
  });

  group('BETA-02: «Сообщить о проблеме»', () {
    testWidgets('в релизе строки нет', (tester) async {
      await pump(tester);
      expect(find.text('Сообщить о проблеме'), findsNothing);
    });

    testWidgets('в бете: шторка объясняет, что уйдёт, «Отправить» — '
        'в «Поделиться» с диагностикой', (tester) async {
      final sharer = _FakeSharer();
      await pump(tester, beta: true, sharer: sharer);
      expect(
        find.text('Бета-версия: отчёт уйдёт разработчикам'),
        findsOneWidget,
      );

      await tester.tap(find.text('Сообщить о проблеме'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Координат в нём нет'), findsOneWidget);
      await tester.tap(find.text('Отправить'));
      await settle(tester);
      await tester.pumpAndSettle();

      expect(sharer.sent, hasLength(1));
      final (:text, :subject) = sharer.sent.single;
      expect(subject, 'TachoGo — проблема в бете');
      expect(text, startsWith('Что случилось и когда'));
      expect(text, contains('TachoGo 0.2.0-beta.1 (20001)'));
      expect(text, contains('Status: '));
      expect(text, isNot(contains('lat')), reason: 'координат нет');
    });

    testWidgets('«Отмена» ничего не отправляет', (tester) async {
      final sharer = _FakeSharer();
      await pump(tester, beta: true, sharer: sharer);
      await tester.tap(find.text('Сообщить о проблеме'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(sharer.sent, isEmpty);
    });

    testWidgets('отправка не открылась — сообщение водителю', (tester) async {
      final sharer = _FakeSharer()..error = StateError('no share sheet');
      final errors = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      addTearDown(() => FlutterError.onError = previous);
      await pump(tester, beta: true, sharer: sharer);
      await tester.tap(find.text('Сообщить о проблеме'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отправить'));
      await settle(tester);
      expect(
        find.text('Не удалось открыть отправку. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      expect(errors.single.exception, isA<StateError>());
    });
  });

  test('лицензии OFL шрифтов регистрируются из assets', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LicenseRegistry.reset();
    addTearDown(LicenseRegistry.reset);
    registerFontLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    expect({for (final e in entries) ...e.packages}, fontLicenses.keys.toSet());
    for (final e in entries) {
      final text = e.paragraphs.map((p) => p.text).join('\n');
      expect(text, contains('SIL OPEN FONT LICENSE'));
    }
  });
}
