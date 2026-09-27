import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Подпись строки: название и, при необходимости, пояснение под ним.
class _Titles extends StatelessWidget {
  const new({required this.title, this.subtitle, this.strong = true});

  final String title;
  final String? subtitle;

  /// Название 15 / 600, как «Пакет мобильности»; иначе 15 / 500, как
  /// строки категорий уведомлений.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: strong
              ? AppTextStyles.rowTitle
              : AppTextStyles.rowTitle.copyWith(fontWeight: FontWeight.w500),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Строка с переключателем (экраны 3, 14): касание всей строки меняет
/// значение, диктор читает название, пояснение и состояние вместе.
class SwitchRow extends StatelessWidget {
  const new({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.strong = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    return MergeSemantics(
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.listRow),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              10,
              AppSpacing.cardPadding - 4,
              10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Titles(
                    title: title,
                    subtitle: subtitle,
                    strong: strong,
                  ),
                ),
                const SizedBox(width: 12),
                Switch(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Строка-переход 56 dp: «Язык · Русский ›», «Экспорт отчёта · PDF · CSV ›».
class NavRow extends StatelessWidget {
  const new({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.value,
    this.icon,
    this.chevron = true,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Текущее значение справа: «Русский».
  final String? value;

  /// Значок слева: «Экономия батареи».
  final IconData? icon;

  /// «›» справа: строка открывает экран, шторку или настройки системы.
  final bool chevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = this.value;
    final icon = this.icon;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.listRow),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                10,
                AppSpacing.cardPadding - 4,
                10,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 22, color: colors.text),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: _Titles(title: title, subtitle: subtitle),
                  ),
                  if (value != null) ...[
                    const SizedBox(width: 12),
                    // Значение прижато к «›» и не шире половины строки:
                    // длинное переносится, а не вытесняет название
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width / 2.5,
                      ),
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: AppTextStyles.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  if (chevron) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: colors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Настройка с вариантами под названием: «Оформление» с переключателем,
/// «Предупреждать о лимитах» с пилюлями 15 / 30 / 60 мин.
class ChoiceBlock extends StatelessWidget {
  const new({
    required this.title,
    required this.child,
    this.subtitle,
    this.strong = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool strong;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.cardPadding,
      14,
      AppSpacing.cardPadding,
      AppSpacing.cardPadding,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Titles(title: title, subtitle: subtitle, strong: strong),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

/// Пилюли вариантов в ряд с переносом: «15 мин · 30 мин · 1 час».
class PillWrap extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 8, runSpacing: 8, children: children);
}
