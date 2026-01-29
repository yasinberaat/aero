import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/theme_provider.dart';

/// Reusable theme toggle button for all pages
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        );
      },
    );
  }
}
