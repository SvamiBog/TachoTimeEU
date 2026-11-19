/// The frame shared by the journal picker sheets: the sheet above the keyboard
/// and the "Cancel" / main action buttons at its bottom.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/buttons.dart';

const _sheetPadding = EdgeInsets.fromLTRB(
  AppSpacing.textInset,
  0,
  AppSpacing.textInset,
  AppSpacing.screenBottom,
);

/// Шторка поднимается над клавиатурой: поле ввода и «Сохранить» не
/// прячутся под ней.
Future<T?> showPickerSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(padding: _sheetPadding, child: child),
        ),
      ),
    );

/// "Cancel" and the main action at the bottom of a sheet.
class PickerButtons extends StatelessWidget {
  const new({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SecondaryButton(
          label: context.l10n.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      const SizedBox(width: AppSpacing.s8),
      Expanded(
        child: PrimaryButton(label: label, onPressed: onPressed),
      ),
    ],
  );
}
