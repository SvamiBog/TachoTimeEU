import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Экран деталей: «← Заголовок», прокручиваемое содержимое, кнопки снизу.
class DetailScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.children,
    this.bottom,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 64,
            child: Row(
              children: [
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: context.l10n.back,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: AppTextStyles.header,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.screenPadding),
              ],
            ),
          ),
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
