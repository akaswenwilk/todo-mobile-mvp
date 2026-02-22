import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0B0D12);
  static const Color surface = Color(0xFF121723);
  static const Color surfaceElevated = Color(0xFF171E2B);
  static const Color textPrimary = Color(0xFFF4F7FF);
  static const Color textSecondary = Color(0xFF9AA6BF);
  static const Color accent = Color(0xFF6EA8FF);

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: accent,
      surface: surface,
      onSurface: textPrimary,
      onPrimary: Colors.black,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodySmall: TextStyle(fontSize: 13, color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textPrimary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
