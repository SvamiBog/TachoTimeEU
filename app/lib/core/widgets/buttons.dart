import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

final _shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(AppRadius.button),
);

/// Основная кнопка 56 dp: заливка цветом режима (по умолчанию —
/// вождения), подпись тёмная.
class PrimaryButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color ?? colors.drive,
        foregroundColor: colors.onAccent,
        disabledBackgroundColor: colors.surface2,
        disabledForegroundColor: colors.textSecondary,
        minimumSize: const Size.fromHeight(AppSize.button),
        shape: _shape,
        textStyle: AppTextStyles.button,
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

/// Вторичная кнопка 56 dp с обводкой.
class SecondaryButton extends StatelessWidget {
  const new({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.text,
        side: BorderSide(color: colors.switchOff),
        minimumSize: const Size.fromHeight(AppSize.button),
        shape: _shape,
        textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

/// Опасное действие 56 dp: «Удалить смену» — обводка и текст цвета ошибки.
class DangerButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = this.icon;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 20),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.errorText,
        side: BorderSide(color: colors.errorText),
        minimumSize: const Size.fromHeight(AppSize.button),
        shape: _shape,
        textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
      ),
      label: Text(label, textAlign: TextAlign.center),
    );
  }
}
