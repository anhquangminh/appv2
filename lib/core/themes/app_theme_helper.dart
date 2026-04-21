import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

extension AppThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get cs => theme.colorScheme;

  // =========================
  // 🎨 PRIMARY
  // =========================
  Color get primary => cs.primary;
  Color get onPrimary => cs.onPrimary;

  // =========================
  // 🧱 SURFACE
  // =========================
  Color get surface => cs.surface;
  Color get background => cs.surfaceContainer;
  Color get surfaceLow => cs.surfaceContainerLow;

  Color get surfaceHigh =>
      theme.brightness == Brightness.dark
          ? AppColors.surfaceLowDark
          : AppColors.surfaceLow;

  Color get divider =>
      theme.brightness == Brightness.dark
          ? AppColors.dividerDark
          : AppColors.divider;

  Color get disabled =>
      theme.brightness == Brightness.dark
          ? AppColors.disabledDark
          : AppColors.disabled;

  // =========================
  // ✍️ TEXT
  // =========================
  Color get textPrimary => cs.onSurface;
  Color get textSecondary => cs.onSurfaceVariant;

  Color get textHint =>
      theme.brightness == Brightness.dark
          ? AppColors.textMutedDark.withValues(alpha: 0.6)
          : AppColors.textMuted.withValues(alpha: 0.6);

  // =========================
  // 📏 BORDER
  // =========================
  Color get border => cs.outline;

  Color get borderStrong =>
      theme.brightness == Brightness.dark
          ? AppColors.borderDark
          : AppColors.border;

  // =========================
  // 🎯 ACCENT
  // =========================
  Color get success => AppColors.accentGreen;
  Color get info => AppColors.accentBlue;
  Color get warning => AppColors.accentOrange;
  Color get error => AppColors.accentRed;
  Color get purple => AppColors.accentPurple;

  // =========================
  // 🌈 COMMON COLORS (THÊM MỚI)
  // =========================
  Color get white => Colors.white;
  Color get black => Colors.black;

  Color get grey => Colors.grey;
  Color get grey100 => Colors.grey.shade100;
  Color get grey200 => Colors.grey.shade200;
  Color get grey300 => Colors.grey.shade300;
  Color get grey400 => Colors.grey.shade400;
  Color get grey500 => Colors.grey.shade500;
  Color get grey600 => Colors.grey.shade600;
  Color get grey700 => Colors.grey.shade700;
  Color get grey800 => Colors.grey.shade800;
  Color get grey900 => Colors.grey.shade900;

  Color get blue => Colors.blue;
  Color get red => Colors.red;
  Color get green => Colors.green;
  Color get orange => Colors.orange;
  Color get yellow => Colors.yellow;
  Color get teal => Colors.teal;
  Color get cyan => Colors.cyan;
  Color get indigo => Colors.indigo;
  Color get pink => Colors.pink;

  // =========================
  // 📊 CHART COLORS
  // =========================
  Color get chartBlue => AppColors.accentBlue;
  Color get chartGreen => AppColors.accentGreen;
  Color get chartOrange => AppColors.accentOrange;
  Color get chartRed => AppColors.accentRed;

  // =========================
  // 🌈 GRADIENTS
  // =========================
  List<Color> get primaryGradient => [
    theme.brightness == Brightness.dark
        ? AppColors.primaryDark
        : AppColors.primary,
    (theme.brightness == Brightness.dark
            ? AppColors.primaryDark
            : AppColors.primary)
        .withValues(alpha: 0.85),
  ];

  List<Color> get primaryG => theme.brightness == Brightness.dark
    ? [
        const Color(0xFF2DD4BF), // sáng hơn cho dark mode
        const Color(0xFF0EA5E9),
      ]
    : [
        const Color(0xFF0D4D3B), // đậm hơn cho light mode
        const Color(0xFF334155),
      ];

  // Gradient mềm cho card / container
  List<Color> get softGradient => [
    theme.brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFFFFFFF),
    theme.brightness == Brightness.dark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF1F5F9),
  ];

  // Gradient accent (nút, highlight)
  List<Color> get accentGradient => [
    const Color(0xFF3B82F6),
    const Color(0xFF6366F1),
  ];

  List<Color> get successGradient => [
    AppColors.accentGreen,
    AppColors.accentGreen.withValues(alpha: 0.7),
  ];

  List<Color> get warningGradient => [
    AppColors.accentOrange,
    AppColors.accentOrange.withValues(alpha: 0.7),
  ];

  List<Color> get errorGradient => [
    AppColors.accentRed,
    AppColors.accentRed.withValues(alpha: 0.7),
  ];

  // =========================
  // 🌫 SHADOW
  // =========================
  Color get shadow =>
      theme.brightness == Brightness.dark
          ? AppColors.shadowDark
          : AppColors.shadow;

  // =========================
  // ✨ UTILS
  // =========================
  Color opacity(Color color, double value) => color.withValues(alpha: value);
}
