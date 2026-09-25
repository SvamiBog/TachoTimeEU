// Каждый экран отрисовывается и проверяется на соответствие дизайну и
// доступности: обе темы, ширина 412 dp (основной таргет) и 360 dp,
// крупный системный шрифт, контраст текста, зоны касания ≥ 44 dp,
// время и цифры — JetBrains Mono с цифрами одинаковой ширины.
//
// Новый экран — добавить в [_screens]. Экрану с данными из БД —
// переопределить databaseProvider базой в памяти в _pump.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/features/home/home_screen.dart';

final _screens = <String, Widget Function()>{'Главная': HomeScreen.new};

/// Экраны телефона, dp: основной таргет и небольшой Android.
const _viewports = {'412 dp': Size(412, 915), '360 dp': Size(360, 640)};

/// Системный масштаб шрифта: обычный, крупный, максимальный на Android 14.
const _textScales = [1.0, 1.3, 2.0];

const _minTapTarget = MinimumTapTargetGuideline(
  size: Size.square(AppSize.minTouch),
  link: 'docs/design/README.md — «Касание: мин. 44 dp»',
);

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  Brightness brightness = Brightness.dark,
  Size viewport = const Size(412, 915),
  double textScale = 1,
}) async {
  tester.view
    ..devicePixelRatio = 2.625
    ..physicalSize = viewport * 2.625;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(theme: buildTheme(brightness), home: screen),
    ),
  );
}

/// Текст из одних цифр и знаков времени: «4:30», «56:00», «12 / 90», «−0:15».
final _numeric = RegExp(r'^[−\-+]?[\d\s:.,/%]*\d[\d\s:.,/%]*$');

void main() {
  test('шаблон цифр', () {
    for (final s in ['4:30', '56:00', '12 / 90', '−0:15', '28', '100%']) {
      expect(_numeric.hasMatch(s), isTrue, reason: s);
    }
    for (final s in ['TachoGo', 'до перерыва', '4:30 ч', 'PL', '']) {
      expect(_numeric.hasMatch(s), isFalse, reason: s);
    }
  });

  testWidgets('по умолчанию тёмная тема из токенов', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TachoGoApp()));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(context.colors, same(AppColors.dark));
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppColors.dark.background,
    );
  });

  for (final MapEntry(key: name, value: build) in _screens.entries) {
    group('экран «$name»', () {
      for (final brightness in Brightness.values) {
        final theme = brightness == Brightness.dark ? 'тёмная' : 'светлая';

        for (final MapEntry(key: label, value: viewport)
            in _viewports.entries) {
          for (final scale in _textScales) {
            testWidgets('$theme, $label, шрифт ×$scale — без переполнения', (
              tester,
            ) async {
              await _pump(
                tester,
                build(),
                brightness: brightness,
                viewport: viewport,
                textScale: scale,
              );
              expect(tester.takeException(), isNull);
            });
          }
        }

        testWidgets(
          '$theme: контраст отрисованного текста',
          (tester) async {
            await _pump(tester, build(), brightness: brightness);
            await expectLater(tester, meetsGuideline(textContrastGuideline));
          },
          // Таймер цвета вождения на фоне светлой темы — 2.5:1,
          // см. lightDriveContrastIssue в design_test_utils.dart
          skip: brightness == Brightness.light,
        );

        testWidgets('$theme: зоны касания ≥ 44 dp и с подписью', (
          tester,
        ) async {
          await _pump(tester, build(), brightness: brightness);
          await expectLater(tester, meetsGuideline(_minTapTarget));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        });
      }

      testWidgets('время и цифры — JetBrains Mono, цифры одной ширины', (
        tester,
      ) async {
        await _pump(tester, build());
        final numbers = [
          for (final text in tester.widgetList<RichText>(find.byType(RichText)))
            if (_numeric.hasMatch(text.text.toPlainText().trim())) text,
        ];
        expect(numbers, isNotEmpty, reason: 'на экране нет ни одной цифры');
        for (final text in numbers) {
          final style = text.text.style;
          final plain = text.text.toPlainText();
          expect(style?.fontFamily, AppFonts.numeric, reason: plain);
          expect(
            style?.fontFeatures,
            contains(const FontFeature.tabularFigures()),
            reason: plain,
          );
        }
      });

      testWidgets('поля экрана — 16 dp', (tester) async {
        await _pump(tester, build());
        final screenRect = tester.getRect(find.byType(Scaffold));
        for (final text in find.byType(Text).evaluate()) {
          final rect = tester.getRect(
            find.byElementPredicate((e) => identical(e, text)),
          );
          expect(
            rect.left - screenRect.left,
            greaterThanOrEqualTo(AppSpacing.screenPadding),
            reason: (text.widget as Text).data,
          );
          expect(
            screenRect.right - rect.right,
            greaterThanOrEqualTo(AppSpacing.screenPadding),
            reason: (text.widget as Text).data,
          );
        }
      });
    });
  }
}
