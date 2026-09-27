import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Вариант-«пилюля» 44 dp: недавние страны (экран 10), период отчёта
/// (экран 16). Выбранный — цветом вождения.
class ChoicePill extends StatelessWidget {
  const new(
    this.text, {
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.drive : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? colors.drive : colors.switchOff),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSize.minTouch,
              minWidth: AppSize.minTouch + 12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                widthFactor: 1,
                child: Text(
                  text,
                  style: AppTextStyles.rowTitle.copyWith(
                    color: selected ? colors.onAccent : colors.text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
