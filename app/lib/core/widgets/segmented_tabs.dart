/// Segmented switch between a few options.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// An option of the switch: a label and, if needed, a second line in digits —
/// "Start / 22.09 · 06:30".
typedef SegmentOption<T> = ({T value, String label, String? detail});

/// A switch between a few options (screens 10, 11, 12, 16): the selected one
/// sits on a `surface2` pad, touch targets are ≥ 44 dp.
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
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.background,
      borderRadius: BorderRadius.circular(AppRadius.badge),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final o in options)
              Expanded(
                child: _Tab(
                  o,
                  selected: o.value == value,
                  onTap: () => onChanged(o.value),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// One option: the label and the digits under it; the selected one on a pad.
class _Tab extends StatelessWidget {
  const new(this.option, {required this.selected, required this.onTap});

  final SegmentOption<Object?> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final detail = option.detail;
    final color = selected ? colors.text : colors.textSecondary;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: selected ? colors.surface2 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.icon),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.minTouch),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.label,
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
    );
  }
}
