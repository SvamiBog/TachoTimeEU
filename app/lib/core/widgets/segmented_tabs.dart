import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Вариант в переключателе: подпись и, при необходимости, вторая строка
/// цифрами — «Начало / 22.09 · 06:30».
typedef SegmentOption<T> = ({T value, String label, String? detail});

/// Переключатель из нескольких вариантов (экраны 10, 11, 12, 16):
/// выбранный — на плашке `surface2`, касание ≥ 44 dp.
class SegmentedTabs<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<SegmentOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget tab(SegmentOption<T> o) {
      final on = o.value == value;
      final detail = o.detail;
      final color = on ? colors.text : colors.textSecondary;
      return Expanded(
        child: Semantics(
          selected: on,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Material(
            color: on ? colors.surface2 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.icon),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onChanged(o.value),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSize.minTouch),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          o.label,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.rowTitle.copyWith(color: color),
                        ),
                        if (detail != null)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              detail,
                              maxLines: 1,
                              style: AppTextStyles.numericCaption.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final o in options) tab(o)],
          ),
        ),
      ),
    );
  }
}
