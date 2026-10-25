// Контраст отрисованного текста — по снимку в пикселях устройства.
//
// textContrastGuideline из flutter_test снимает экран в логических
// пикселях (1 px на dp) и сравнивает самый частый светлый и самый частый
// тёмный цвет вокруг текста. При 1 px на dp штрих текста 12–14 px тоньше
// пикселя, и что окажется самым частым светлым цветом, решает растеризатор
// шрифтов ОС, на которой идут тесты. В CI (Linux) это чистый цвет текста.
// На Windows сглаживание даёт всего ~20 оттенков на строку, каждый набирает
// больше пикселей, чем чистый цвет, и проверка берёт за цвет текста
// полупрозрачный край буквы: вторичный текст #A3A8AE на #111315 (8:1)
// выходит 3.84:1 или 2.15:1. На плотности телефона (2,625 px на dp, как в
// pumpScreen) штрих шире нескольких пикселей, и самым частым на любой ОС
// оказывается цвет, которым текст нарисован.
//
// Отбор узлов, пороги WCAG и подсчёт — как в MinimumTextContrastGuideline
// (Flutter 3.47.5), другое только разрешение снимка. При обновлении Flutter
// сверить с его accessibility.dart.

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Контраст текста по WCAG AA, как [textContrastGuideline], на снимке
/// в пикселях устройства.
const deviceTextContrastGuideline = DeviceTextContrastGuideline();

/// [MinimumTextContrastGuideline] со снимком в пикселях устройства.
class DeviceTextContrastGuideline extends MinimumTextContrastGuideline {
  /// Проверка для [deviceTextContrastGuideline].
  const new();

  /// Допуск округления — как у [MinimumTextContrastGuideline].
  static const double _tolerance = -0.01;

  @override
  String get description =>
      'Text contrast should follow WCAG guidelines at device pixel ratio';

  @override
  Future<Evaluation> evaluate(WidgetTester tester) async {
    var result = const Evaluation.pass();
    for (final view in tester.binding.renderViews) {
      final layer = view.debugLayer! as OffsetLayer;
      // paintBounds вида — в физических пикселях: снимок без уменьшения
      final snapshot = await tester.binding.runAsync(() async {
        final image = await layer.toImage(view.paintBounds);
        final bytes = await image.toByteData();
        final snapshot = _Snapshot(bytes!, image.width, image.height);
        image.dispose();
        return snapshot;
      });
      result += _evaluateNode(
        view.owner!.semanticsOwner!.rootSemanticsNode!,
        snapshot!,
        view,
      );
    }
    return result;
  }

  Evaluation _evaluateNode(
    SemanticsNode node,
    _Snapshot snapshot,
    RenderView view,
  ) {
    var result = const Evaluation.pass();
    // Отключённые элементы WCAG не проверяет
    final disabled = node.flagsCollection.isEnabled == ui.Tristate.isFalse;
    if (node.isInvisible ||
        node.isMergedIntoParent ||
        node.flagsCollection.isHidden ||
        disabled) {
      return result;
    }
    final children = <SemanticsNode>[];
    node.visitChildren((child) {
      children.add(child);
      return true;
    });
    for (final child in children) {
      result += _evaluateNode(child, snapshot, view);
    }
    final data = node.getSemanticsData();
    if (shouldSkipNode(data)) return result;
    final text = data.label.isEmpty ? data.value : data.label;
    for (final element in find.text(text).hitTestable().evaluate()) {
      result += _evaluateElement(node, element, snapshot, view);
    }
    return result;
  }

  Evaluation _evaluateElement(
    SemanticsNode node,
    Element element,
    _Snapshot snapshot,
    RenderView view,
  ) {
    final box = element.renderObject;
    if (box is! RenderBox) {
      throw StateError('Unexpected renderObject type: $box');
    }
    final toLogical = box.getTransformTo(null);
    // Корневое преобразование вида: логические пиксели → физические
    final toPhysical = Matrix4.identity();
    view.applyPaintTransform(view.child!, toPhysical);
    toPhysical.multiply(toLogical);

    final around = box.paintBounds.inflate(4);
    final screenBounds = MatrixUtils.transformRect(toPhysical, box.paintBounds);
    var nodeBounds = node.rect;
    for (SemanticsNode? n = node; n != null; n = n.parent) {
      final transform = n.transform;
      if (transform != null) {
        nodeBounds = MatrixUtils.transformRect(transform, nodeBounds);
      }
    }
    final intersection = nodeBounds.intersect(screenBounds);
    if (intersection.width <= 0 || intersection.height <= 0) {
      // Элемент не относится к этому узлу семантики
      return const Evaluation.pass();
    }

    final TextStyle style;
    switch (element.widget) {
      case final Text widget:
        final own = widget.style;
        style = own == null || own.inherit
            ? DefaultTextStyle.of(element).style.merge(own)
            : own;
      case final EditableText widget:
        style = widget.style;
      case final widget:
        throw StateError('Unexpected widget type: ${widget.runtimeType}');
    }
    final bold = style.fontWeight == FontWeight.bold;

    // Как в Flutter: за краем экрана — не проверяется
    if (isNodeOffScreen(
      MatrixUtils.transformRect(toLogical, around),
      view.flutterView,
    )) {
      return const Evaluation.pass();
    }
    final histogram = snapshot.colorsWithin(
      MatrixUtils.transformRect(toPhysical, around),
    );
    if (histogram.isEmpty) return const Evaluation.pass();

    final (:light, :dark) = _dominantColors(histogram);
    final ratio =
        (light.computeLuminance() + 0.05) / (dark.computeLuminance() + 0.05);
    final target = targetContrastRatio(style.fontSize, bold: bold);
    if (ratio - target >= _tolerance) return const Evaluation.pass();
    return Evaluation.fail(
      '$node:\n'
      'Expected contrast ratio of at least $target '
      'but found ${ratio.toStringAsFixed(2)} '
      'for a font size of ${style.fontSize}.\n'
      'The computed colors was:\n'
      'light - $light, dark - $dark\n'
      'See also: '
      'https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html',
    );
  }
}

/// Самый частый светлый и самый частый тёмный цвет: граница — средняя
/// светлота HSL по всем пикселям, как в flutter_test.
({Color light, Color dark}) _dominantColors(Map<Color, int> histogram) {
  var total = 0.0;
  var count = 0;
  for (final MapEntry(key: color, value: n) in histogram.entries) {
    total += HSLColor.fromColor(color).lightness * n;
    count += n;
  }
  final average = total / count;
  MapEntry<Color, int>? light;
  MapEntry<Color, int>? dark;
  for (final entry in histogram.entries) {
    if (HSLColor.fromColor(entry.key).lightness <= average) {
      if (entry.value > (dark?.value ?? 0)) dark = entry;
    } else if (entry.value > (light?.value ?? 0)) {
      light = entry;
    }
  }
  // Один цвет — он и светлый, и тёмный
  return (light: light?.key ?? dark!.key, dark: dark?.key ?? light!.key);
}

/// Снимок экрана: RGBA по строкам.
class _Snapshot {
  const new(this.bytes, this.width, this.height);

  final ByteData bytes;
  final int width;
  final int height;

  /// Сколько пикселей каждого цвета в прямоугольнике (физические пиксели).
  Map<Color, int> colorsWithin(Rect rect) {
    final r = rect.intersect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );
    final counts = <int, int>{};
    for (var x = r.left.floor(); x < r.right.ceil(); x++) {
      for (var y = r.top.floor(); y < r.bottom.ceil(); y++) {
        final rgba = bytes.getUint32((y * width + x) * 4);
        counts.update(rgba, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    // RGBA → ARGB
    return counts.map(
      (rgba, n) => MapEntry(Color(((rgba & 0xFF) << 24) | (rgba >> 8)), n),
    );
  }
}
