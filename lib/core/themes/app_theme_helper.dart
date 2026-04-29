import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

extension AppThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get cs => theme.colorScheme;

  Color get primary => cs.primary;
  Color get onPrimary => cs.onPrimary;
  Color get primaryContainer => cs.primaryContainer;
  Color get secondaryContainer => cs.secondaryContainer;

  Color get surface => cs.surface;
  Color get background => cs.surfaceContainer;
  Color get surfaceLow => cs.surfaceContainerLow;
  Color get surfaceHigh => cs.surfaceContainerHigh;
  Color get surfaceHighest => cs.surfaceContainerHighest;

  Color get divider => cs.outlineVariant.withValues(alpha: 0.15);

  Color get disabled =>
      theme.brightness == Brightness.dark
          ? AppColors.disabledDark
          : AppColors.disabled;

  Color get textPrimary => cs.onSurface;
  Color get textSecondary => cs.onSurfaceVariant;

  Color get textHint =>
      theme.brightness == Brightness.dark
          ? AppColors.textHintDark
          : AppColors.textHint;

  Color get border => cs.outline;
  Color get borderStrong => cs.outlineVariant.withValues(alpha: 0.15);

  Color get success => AppColors.accentGreen;
  Color get info => AppColors.accentBlue;
  Color get warning => AppColors.accentOrange;
  Color get error => AppColors.accentRed;
  Color get purple => AppColors.accentPurple;
  Color get focusPulse => AppColors.primaryFixedDim;

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

  Color get chartBlue => AppColors.accentBlue;
  Color get chartGreen => AppColors.accentGreen;
  Color get chartOrange => AppColors.accentOrange;
  Color get chartRed => AppColors.accentRed;

  List<Color> get primaryGradient => const [
        AppColors.gradientStart,
        AppColors.gradientEnd,
      ];

  List<Color> get primaryG => primaryGradient;

  List<Color> get softGradient => [
        cs.surfaceContainerLowest,
        cs.surfaceContainer,
      ];

  List<Color> get accentGradient => primaryGradient;

  List<Color> get successGradient => [
        AppColors.accentGreen,
        AppColors.accentGreen.withValues(alpha: 0.72),
      ];

  List<Color> get warningGradient => [
        AppColors.accentOrange,
        AppColors.accentOrange.withValues(alpha: 0.72),
      ];

  List<Color> get errorGradient => [
        AppColors.accentRed,
        AppColors.accentRed.withValues(alpha: 0.72),
      ];

  Color get shadow =>
      theme.brightness == Brightness.dark
          ? AppColors.shadowDark
          : AppColors.shadow;

  Color opacity(Color color, double value) => color.withValues(alpha: value);
}
