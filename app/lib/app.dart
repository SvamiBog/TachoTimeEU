import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/features/shell/app_shell.dart';
import 'package:tachogo/l10n/app_localizations.dart';

class TachoGoApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      // Тёмная тема по умолчанию; выбор темы в настройках — Фаза 2.
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
