import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'job_action_menu.dart';

class JobHeader extends StatelessWidget {
  final String title;

  const JobHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: context.surfaceLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.border),
          ),
          child: Icon(
            Icons.work_outline,
            color: context.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ),
        const JobActionMenu(),
      ],
    );
  }
}