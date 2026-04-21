import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_radius.dart';

class JobTimeRange extends StatelessWidget {
  final DateTime? date;

  const JobTimeRange({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final text =
        date != null ? DateFormat('dd/MM/yy').format(date!) : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.surfaceLow,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: context.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: context.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}