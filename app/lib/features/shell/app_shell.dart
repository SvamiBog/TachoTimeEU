import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';

/// Вкладки нижней навигации.
enum AppTab { home, journal, settings, more }

/// Нижняя навигация «Главная · Журнал · Настройки · Ещё». Вкладки живут в
/// [IndexedStack]: переход не сбрасывает прокрутку и открытые экраны.
class AppShell extends StatefulWidget {
  const new({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _tab = AppTab.home;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Scaffold(
      body: IndexedStack(
        index: _tab.index,
        children: const [
          HomeScreen(),
          JournalScreen(),
          SettingsScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.surface2)),
        ),
        child: NavigationBar(
          selectedIndex: _tab.index,
          onDestinationSelected: (i) => setState(() => _tab = AppTab.values[i]),
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
