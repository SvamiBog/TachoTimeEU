/// Layout of detail screens: back arrow with title, scrolling content, buttons
/// at the bottom.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// A detail screen: "← Title", scrolling content, buttons at the bottom.
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
          _Header(
            title: title,
            subtitle: subtitle,
            action: action,
            onBack: onBack,
          ),
          ?banner,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.screenBottom),
              children: children,
            ),
          ),
          if (bottom case final bottom?)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.s8,
                AppSpacing.screenPadding,
                AppSpacing.screenBottom,
              ),
              child: bottom,
            ),
        ],
      ),
    ),
  );
}

/// The header of a details screen: "‹", the title with its subtitle and the
/// action on the right.
class _Header extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: AppSize.header),
    child: Row(
      children: [
        const SizedBox(width: AppSpacing.s4),
        IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          tooltip: context.l10n.back,
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        const SizedBox(width: AppSpacing.s8),
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
            padding: const EdgeInsets.only(right: AppSpacing.s4),
            child: action,
          )
        else
          const SizedBox(width: AppSpacing.screenPadding),
      ],
    ),
  );
}
