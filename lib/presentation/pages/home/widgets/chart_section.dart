import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/data/models/status_report_model.dart';
import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:ducanherp/presentation/pages/home/widgets/bar_chart.dart';
import 'package:ducanherp/presentation/pages/home/widgets/line_chart.dart';
import 'package:flutter/material.dart';

class ChartSection extends StatelessWidget {
  final StatusReportModel? status;
  final List<GroupReportModel>? groups;

  const ChartSection({
    super.key,
    this.status,
    this.groups,
  });

  @override
  Widget build(BuildContext context) {
    // Cố định Row để luôn hiển thị 2 biểu đồ song song theo chiều ngang
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BIỂU ĐỒ TRÁI: XU HƯỚNG
        Expanded(
          child: status != null
              ? _ChartCard(
                  title: "XU HƯỚNG (TUẦN)",
                  child: LineChartWidget(status: status!),
                )
              : _loadingCard(context, "XU HƯỚNG (TUẦN)"),
        ),

        const SizedBox(width: AppSpacing.md), // Khoảng cách nhỏ gọn giữa 2 biểu đồ

        // BIỂU ĐỒ PHẢI: ĐỘI NHÓM
        Expanded(
          child: (groups != null && groups!.isNotEmpty)
              ? _ChartCard(
                  title: "ĐỘI NHÓM (%)",
                  child: BarChartWidget(groups: groups!),
                )
              : _loadingCard(context, "ĐỘI NHÓM (%)"),
        ),
      ],
    );
  }

  Widget _loadingCard(BuildContext context, String title) {
    return _ChartCard(
      title: title,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: context.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Giảm padding một chút để phù hợp khi chia đôi màn hình ngang
      padding: const EdgeInsets.all(AppSpacing.md), 
      decoration: BoxDecoration(
        color: context.surfaceHighest, // Trắng (surface-container-lowest) theo Tonal Nesting
        borderRadius: AppRadius.xlRadius, // 1.5rem (xl) theo đúng quy định cho Task cards
        boxShadow: AppShadows.soft, // Botanical Shadow nhẹ nhàng
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 120, // Điều chỉnh chiều cao để cân đối với chiều rộng khi chia đôi
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}