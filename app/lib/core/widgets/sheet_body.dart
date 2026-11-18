/// The scrolling body of a bottom sheet, shared by the sheets of all screens.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_tokens.dart';

/// The body of a bottom sheet: within the safe area, scrolls when it does not
/// fit, and the screen reader announces it as a separate screen named
/// [label]. Children are stretched to the sheet's width.
class SheetBody extends StatelessWidget {
  const new({
    required this.label,
    required this.children,
    this.padding = defaultPadding,
    super.key,
  });

  /// Поля шторки: по бокам — как у заголовков разделов, снизу — над краем
  /// экрана.
  static const defaultPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenPadding + 4,
    0,
    AppSpacing.screenPadding + 4,
    24,
  );

  /// Название шторки для диктора: обычно её заголовок.
  final String label;

  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: padding,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        label: label,
        explicitChildNodes: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}
