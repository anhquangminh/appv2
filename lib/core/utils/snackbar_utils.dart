import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

void showSnack(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor:
          isError ? AppColors.accentGreen : AppColors.accentRed,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    ),
  );
}
