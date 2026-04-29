import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/data/models/status_report_model.dart';

class SummaryCard extends StatelessWidget {
  final StatusReportModel model;
  final VoidCallback onTap;

  const SummaryCard({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      // Sử dụng Tonal Nesting: Card trắng (surfaceHighest) trên nền background xám nhẹ
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _item(
                context,
                Icons.file_upload_outlined,
                'T.CỘNG',
                model.tongSo.toString(),
                context.primary,
              ),
            ),
            _softDivider(context),
            Expanded(
              child: _item(
                context,
                Icons.check_circle_outline_rounded,
                'XONG',
                model.hoanThanh.toString(),
                context.success,
              ),
            ),
            _softDivider(context),
            Expanded(
              child: _item(
                context,
                Icons.hourglass_empty_rounded,
                'ĐANG LÀM',
                model.dangThucHien.toString(),
                context.warning,
              ),
            ),
            _softDivider(context),
            Expanded(
              child: _item(
                context,
                Icons.error_outline_rounded,
                'TRỄ HẠN',
                model.quaHan.toString(),
                context.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softDivider(BuildContext context) {
    return Container(
      width: 1.0,
      // Bỏ thuộc tính height cố định để nó tự fill theo IntrinsicHeight của Row
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ), // Tạo khoảng cách nhỏ ở trên/dưới nếu muốn divider không chạm sát mép card
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.borderStrong.withValues(alpha: 0.2),
            context.borderStrong.withValues(alpha: 0.6),
            context.borderStrong.withValues(alpha: 0.2),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color accent,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      highlightColor: context.opacity(accent, 0.05),
      splashColor: context.opacity(accent, 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container với hiệu ứng Tonal Depth
            Icon(icon, color: accent, size: 20),
            const SizedBox(height: AppSpacing.sm),
            // Label sử dụng Inter LabelSmall với letter spacing chuẩn editorial
            Text(
              label,
              style: context.theme.textTheme.labelSmall?.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            // Value sử dụng TitleMedium để giữ sự Authority
            Text(
              value,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
