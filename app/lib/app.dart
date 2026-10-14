/// The root widget: theme and language from settings, onboarding until the
/// driver finishes it, then the main navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/onboarding/onboarding_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// The app: `MaterialApp` with the theme and language from settings. While the
/// settings load it uses the dark theme and the phone's language — the same as
/// on the first launch.
class TachoGoApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Пока настройки читаются — тёмная тема и язык телефона: так выглядит
    // и первый запуск.
    final prefs =
        ref.watch(preferencesProvider).value ?? const AppPreferences();
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeModeOf(prefs.theme),
      locale: localeOf(prefs.language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppRoot(),
    );
  }
}

/// Тема из настроек. По умолчанию — тёмная.
ThemeMode themeModeOf(ThemeChoice choice) => switch (choice) {
  ThemeChoice.system => ThemeMode.system,
  ThemeChoice.light => ThemeMode.light,
  ThemeChoice.dark => ThemeMode.dark,
};

/// Язык из настроек, если он есть среди переводов; иначе — как в телефоне.
Locale? localeOf(String? language) => AppLocalizations.supportedLocales
    .where((l) => l.languageCode == language)
    .firstOrNull;

/// The first screen: onboarding until the first "Done", then the bottom
/// navigation. A root inside `MaterialApp` rather than a change of `home`:
/// "Done" replaces onboarding with the home screen without a back transition.
class AppRoot extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(preferencesProvider)) {
        AsyncData(value: AppPreferences(onboardingDone: false)) =>
          const OnboardingScreen(),
        // Настройки не прочитались — не держим водителя на онбординге.
        AsyncData() || AsyncError() => const AppShell(),
        _ => const Scaffold(),
      };
}
