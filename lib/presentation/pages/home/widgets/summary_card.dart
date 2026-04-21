import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/data/models/status_report_model.dart';

class SummaryCard extends StatelessWidget {
  final StatusReportModel model;
  final Function() onTap;

  const SummaryCard({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: context.border.withValues(alpha: 0.2), // 👈 viền mờ hơn
        ),
        boxShadow: AppShadows.soft, // 👈 thêm shadow
      ),
      child: Row(
        children: [
          Expanded(
            child: _item(
              context,
              Icons.file_upload_outlined,
              'T.CỘNG',
              model.tongSo.toString(),
              context.primary,
              'tong',
              onTap,
            ),
          ),
          _divider(context),
          Expanded(
            child: _item(
              context,
              Icons.check_circle,
              'XONG',
              model.hoanThanh.toString(),
              context.success,
              'done',
              onTap,
            ),
          ),
          _divider(context),
          Expanded(
            child: _item(
              context,
              Icons.more_horiz,
              'ĐANG LÀM',
              model.dangThucHien.toString(),
              context.warning,
              'doing',
              onTap,
            ),
          ),
          _divider(context),
          Expanded(
            child: _item(
              context,
              Icons.error,
              'TRỄ HẠN',
              model.quaHan.toString(),
              context.error,
              'late',
              onTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: context.border.withValues(alpha: 0.25), // 👈 mờ hơn luôn
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    String type,
    final Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
