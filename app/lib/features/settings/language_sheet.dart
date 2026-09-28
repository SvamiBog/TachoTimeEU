import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/l10n/languages.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

/// Шторка «Язык» (экраны 3 и 13): «Как в телефоне» и переводы из ARB.
/// Выбор сразу меняет язык интерфейса.
Future<void> showLanguageSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const LanguageSheet(),
    );

/// Язык интерфейса сейчас: «Русский».
String currentLanguageName(BuildContext context) =>
    languageName(Localizations.localeOf(context));

class LanguageSheet extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final selected = ref.watch(preferencesProvider).value?.language;
    // Язык из настроек, которого нет среди переводов, — как в телефоне
    final current =
        AppLocalizations.supportedLocales.any(
          (locale) => locale.languageCode == selected,
        )
        ? selected
        : null;
    void pick(String? language) {
      unawaited(ref.read(settingsRepositoryProvider).setLanguage(language));
      Navigator.of(context).pop();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: l.settingsLanguage,
          explicitChildNodes: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding + 4,
                  0,
                  AppSpacing.screenPadding + 4,
                  16,
                ),
                child: Text(l.settingsLanguage, style: AppTextStyles.header),
              ),
              CardGroup(
                children: [
                  _LanguageRow(
                    title: l.settingsLanguageSystem,
                    selected: current == null,
                    onTap: () => pick(null),
                  ),
                  for (final locale in languagesInOrder(
                    AppLocalizations.supportedLocales,
                  ))
                    _LanguageRow(
                      title: languageName(locale),
                      selected: current == locale.languageCode,
                      onTap: () => pick(locale.languageCode),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const new({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    inMutuallyExclusiveGroup: true,
    button: true,
    child: InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSize.listRow),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
          ),
          child: Row(
            children: [
              Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
              if (selected)
                Icon(Icons.check, size: 22, color: context.colors.text),
            ],
          ),
        ),
      ),
    ),
  );
}
