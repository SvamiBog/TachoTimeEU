/// Bottom navigation of the app.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';

/// Tabs of the bottom navigation.
enum AppTab { home, journal, settings, more }

/// Bottom navigation "Home · Journal · Settings · More". Tabs live in an
/// [IndexedStack]: switching keeps the scroll position and open screens. A tab
/// is built when it is first opened, so the launch draws only the home screen.
class AppShell extends StatefulWidget {
  const new({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

/// The selected tab.
class _AppShellState extends State<AppShell> {
  AppTab _tab = AppTab.home;

  /// Вкладки, которые водитель уже открывал. Остальные не строятся: журнал
  /// по неделям за всю историю и экраны настроек при запуске не нужны.
  final Set<AppTab> _opened = {AppTab.home};

  void _select(AppTab tab) => setState(() {
    _tab = tab;
    _opened.add(tab);
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Scaffold(
      body: IndexedStack(
        index: _tab.index,
        children: [
          for (final tab in AppTab.values)
            if (_opened.contains(tab))
              switch (tab) {
                AppTab.home => const HomeScreen(),
                AppTab.journal => const JournalScreen(),
                AppTab.settings => const SettingsScreen(),
                AppTab.more => const MoreScreen(),
              }
            else
              const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.surface2)),
        ),
        child: NavigationBar(
          selectedIndex: _tab.index,
          onDestinationSelected: (i) => _select(AppTab.values[i]),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.format_list_bulleted),
              label: l.navJournal,
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune),
              label: l.navSettings,
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              label: l.navMore,
            ),
          ],
        ),
      ),
    );
  }
}
