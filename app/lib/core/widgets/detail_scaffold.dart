import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Экран деталей: «← Заголовок», прокручиваемое содержимое, кнопки снизу.
class DetailScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.children,
    this.subtitle,
    this.action,
    this.bottom,
    this.onBack,
    this.banner,
    super.key,
  });

  final String title;

  /// Строка под заголовком: «Вторник, 22 сентября».
  final String? subtitle;

  /// Кнопка справа в шапке: «Сохранить».
  final Widget? action;
  final List<Widget> children;
  final Widget? bottom;

  /// «Назад»; по умолчанию закрывает экран.
  final VoidCallback? onBack;

  /// Плашка под шапкой, которая не уезжает при прокрутке: ошибка формы.
  final Widget? banner;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Row(
              children: [
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  tooltip: context.l10n.back,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          title,
                          style: AppTextStyles.header,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (subtitle case final subtitle?)
                        Text(
                          subtitle,
                          style: AppTextStyles.small.copyWith(
                            color: context.colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (action case final action?)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: action,
                  )
                else
                  const SizedBox(width: AppSpacing.screenPadding),
              ],
            ),
          ),
          ?banner,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: children,
            ),
          ),
          if (bottom case final bottom?)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                8,
                AppSpacing.screenPadding,
                24,
              ),
              child: bottom,
            ),
        ],
      ),
    ),
  );
}
