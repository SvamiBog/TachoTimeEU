import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/features/home/home_screen.dart';

class TachoGoApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TachoGo',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      // Тёмная тема по умолчанию; выбор темы в настройках — Фаза 2.
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
