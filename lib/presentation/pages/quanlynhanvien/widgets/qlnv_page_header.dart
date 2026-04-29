import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class QLNVPageHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAdd;

  const QLNVPageHeader({super.key, required this.onBack, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: context.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Quản lý nhân viên',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: Icon(
              Icons.person_add_alt_1_outlined,
              color: context.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
