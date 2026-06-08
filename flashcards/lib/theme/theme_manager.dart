import 'package:flutter/material.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal();

  final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
