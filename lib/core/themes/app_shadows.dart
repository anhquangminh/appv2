import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> get soft => [
        const BoxShadow(
          color: AppColors.botanicalShadow,
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get botanicalModal => [
        const BoxShadow(
          color: AppColors.botanicalShadow,
          blurRadius: 40,
          offset: Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get focusPulse => [
        const BoxShadow(
          color: Color(0x4D93D4B9),
          blurRadius: 24,
          spreadRadius: 2,
          offset: Offset(0, 0),
        ),
      ];
}
