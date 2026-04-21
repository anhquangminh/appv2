import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // =========================================================
  // 🌞 LIGHT THEME (Material 3 chuẩn)
  // =========================================================
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,

      surface: AppColors.surface,
      onSurface: AppColors.textMain,

      // 👇 thay background bằng surfaceContainer
      surfaceContainer: AppColors.background,
      surfaceContainerLow: const Color(0xFFF8FAFC),

      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.background,

      // TEXT
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textMain),
        bodyMedium: TextStyle(color: AppColors.textMuted),
      ),

      // CARD
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      // INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      // BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // 🌙 DARK THEME (Material 3 chuẩn)
  // =========================================================
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.accentBlue,
      onPrimary: Colors.white,

      surface: AppColors.surfaceDark,
      onSurface: AppColors.textMainDark,

      // 👇 thay background
      surfaceContainer: AppColors.backgroundDark,
      surfaceContainerLow: const Color(0xFF1A1A1A),

      outline: AppColors.borderDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.backgroundDark,

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textMainDark),
        bodyMedium: TextStyle(color: AppColors.textMutedDark),
      ),

      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
