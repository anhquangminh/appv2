import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class QLNVStatsSection extends StatelessWidget {
  final int totalEmployees;
  final int totalDepartments;
  final int approvedEmployees;

  const QLNVStatsSection({
    super.key,
    required this.totalEmployees,
    required this.totalDepartments,
    required this.approvedEmployees,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Nhan su',
            value: '$totalEmployees',
            icon: Icons.group_outlined,
            backgroundColor: context.primary,
            foregroundColor: context.onPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'Phong ban',
            value: '$totalDepartments',
            icon: Icons.domain_outlined,
            backgroundColor: context.surfaceHighest,
            foregroundColor: context.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'Da duyet',
            value: '$approvedEmployees',
            icon: Icons.check_circle_outline,
            backgroundColor: context.surfaceHighest,
            foregroundColor: context.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final muted = foregroundColor.withValues(alpha: 0.7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color:
              backgroundColor == context.surfaceHighest
                  ? context.borderStrong
                  : backgroundColor,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: muted, size: 18),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
