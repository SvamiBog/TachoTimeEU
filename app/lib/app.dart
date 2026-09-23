import 'package:flutter/material.dart';
import 'package:tachotime/core/theme/app_theme.dart';
import 'package:tachotime/features/home/home_screen.dart';

class TachoTimeApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TachoTime',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      // Тёмная тема по умолчанию; выбор темы в настройках — Фаза 2.
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
