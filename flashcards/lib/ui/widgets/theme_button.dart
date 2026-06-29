import 'package:flashcards/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager().isDarkMode,
      builder: (context, isDark, child) {
        return IconButton(
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          onPressed: () => ThemeManager().toggleTheme(),
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}
