/// The layout of a card row with a value on the right: the text on the left,
/// then an optional chip and the value. On a narrow screen or with a large
/// system font the chip and the value move to a line of their own under the
/// text, so the text keeps its words whole and nothing overflows.
library;

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tachogo/core/theme/app_tokens.dart';

/// The parts of a [ValueRowLayout], in reading order.
enum ValueRowSlot { text, chip, value }

/// A card row: [text] on the left, then [chip] and [value] on the right, like
/// a [Row] with the text in [Expanded] and the children centred vertically.
/// When the chip and the value leave the text less room than its longest
/// word, they move under the text: the chip on the left, the value on the
/// right. When even there they do not fit side by side, the chip takes a line
/// of its own and the value goes under it, so the state is never cut short.
class ValueRowLayout
    extends SlottedMultiChildRenderObjectWidget<ValueRowSlot, RenderBox> {
  const new({required this.text, required this.value, this.chip, super.key});

  /// Название строки и подпись под ним.
  final Widget text;

  /// Значение справа, с шевроном, если строка открывает шторку.
  final Widget value;
  final Widget? chip;

  @override
  Iterable<ValueRowSlot> get slots => ValueRowSlot.values;

  @override
  Widget? childForSlot(ValueRowSlot slot) => switch (slot) {
    ValueRowSlot.text => text,
    ValueRowSlot.chip => chip,
    ValueRowSlot.value => value,
  };

  @override
  RenderValueRow createRenderObject(BuildContext context) =>
      RenderValueRow(textDirection: Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, RenderValueRow renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

/// Where [RenderValueRow] puts its children and how big it is.
typedef _Placement = ({Size size, Offset text, Offset chip, Offset value});

/// The render object of [ValueRowLayout].
class RenderValueRow extends RenderBox
    with SlottedContainerRenderObjectMixin<ValueRowSlot, RenderBox> {
  new({required this._textDirection});

  /// Промежуток между текстом, чипом и значением — как в строке.
  static const double _gap = AppSpacing.s8;

  /// Промежуток между текстом и строкой чипа и значения под ним.
  static const double _lineGap = AppSpacing.s4;

  TextDirection _textDirection;

  /// Направление письма: справа налево строка зеркальна.
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  // Слоты text и value в виджете обязательны
  RenderBox get _text => childForSlot(ValueRowSlot.text)!;
  RenderBox get _value => childForSlot(ValueRowSlot.value)!;
  RenderBox? get _chip => childForSlot(ValueRowSlot.chip);

  // Обход — в порядке чтения, а не в порядке появления детей: диктор
  // читает название, чип и значение.
  @override
  Iterable<RenderBox> get children => [
    for (final slot in ValueRowSlot.values) ?childForSlot(slot),
  ];

  /// Ширина чипа и значения с промежутком между ними.
  double _trailingWidth(double height) {
    final chip = _chip;
    final value = _value.getMaxIntrinsicWidth(height);
    return chip == null
        ? value
        : chip.getMaxIntrinsicWidth(height) + _gap + value;
  }

  // Уже некуда: чип и значение — каждый своей строкой под текстом
  @override
  double computeMinIntrinsicWidth(double height) => [
    _text.getMinIntrinsicWidth(height),
    _chip?.getMaxIntrinsicWidth(height) ?? 0,
    _value.getMaxIntrinsicWidth(height),
  ].reduce(math.max);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _text.getMaxIntrinsicWidth(height) + _gap + _trailingWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) => _place(
    BoxConstraints(maxWidth: width),
    ChildLayoutHelper.dryLayoutChild,
  ).size.height;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      computeMinIntrinsicHeight(width);

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      _place(constraints, ChildLayoutHelper.dryLayoutChild).size;

  @override
  void performLayout() {
    final placement = _place(constraints, ChildLayoutHelper.layoutChild);
    size = placement.size;
    _position(_text, placement.text);
    _position(_value, placement.value);
    if (_chip case final chip?) _position(chip, placement.chip);
  }

  /// Ставит [child] в [offset] слева направо, справа налево — зеркально.
  void _position(RenderBox child, Offset offset) {
    (child.parentData! as BoxParentData).offset =
        _textDirection == TextDirection.ltr
        ? offset
        : Offset(size.width - offset.dx - child.size.width, offset.dy);
  }

  /// Размеры и места детей слева направо: в одну строку, если текст
  /// не рвёт слово, иначе чип и значение — строкой под текстом, а если и
  /// так не помещаются — чип и значение каждый своей строкой.
  _Placement _place(BoxConstraints constraints, ChildLayouter layoutChild) {
    final chip = _chip;
    final loose = BoxConstraints(maxWidth: constraints.maxWidth);
    final valueSize = layoutChild(_value, loose);
    final chipSize = chip == null ? Size.zero : layoutChild(chip, loose);
    final trailing =
        (chip == null ? 0.0 : chipSize.width + _gap) + valueSize.width;
    final textMin = _text.getMinIntrinsicWidth(double.infinity);
    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : _text.getMaxIntrinsicWidth(double.infinity) + _gap + trailing;

    if (textMin + _gap + trailing <= width) {
      // Как Row: текст занимает всё, что осталось от чипа и значения
      final textWidth = width - _gap - trailing;
      final textSize = layoutChild(
        _text,
        BoxConstraints.tightFor(width: textWidth),
      );
      final height = [
        textSize.height,
        chipSize.height,
        valueSize.height,
      ].reduce(math.max);
      final size = constraints.constrain(Size(width, height));
      double middle(Size child) => (size.height - child.height) / 2;
      return (
        size: size,
        text: Offset(0, middle(textSize)),
        chip: Offset(textWidth + _gap, middle(chipSize)),
        value: Offset(width - valueSize.width, middle(valueSize)),
      );
    }

    // Текст — во всю ширину, под ним чип слева и значение справа
    final textSize = layoutChild(_text, BoxConstraints.tightFor(width: width));
    final top = textSize.height + _lineGap;
    if (trailing > width) {
      // Чип и значение не помещаются рядом: чип — своей строкой, значение —
      // под ним справа. Состояние не сокращается многоточием.
      final valueTop = top + chipSize.height + _lineGap;
      return (
        size: constraints.constrain(Size(width, valueTop + valueSize.height)),
        text: Offset.zero,
        chip: Offset(0, top),
        value: Offset(width - valueSize.width, valueTop),
      );
    }
    final line = math.max(chipSize.height, valueSize.height);
    return (
      size: constraints.constrain(Size(width, top + line)),
      text: Offset.zero,
      chip: Offset(0, top + (line - chipSize.height) / 2),
      value: Offset(
        width - valueSize.width,
        top + (line - valueSize.height) / 2,
      ),
    );
  }

  Offset _offsetOf(RenderBox child) =>
      (child.parentData! as BoxParentData).offset;

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      context.paintChild(child, offset + _offsetOf(child));
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in children) {
      final hit = result.addWithPaintOffset(
        offset: _offsetOf(child),
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }
}
