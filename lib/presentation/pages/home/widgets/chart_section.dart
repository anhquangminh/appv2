import 'package:ducanherp/core/themes/app_theme_helper.dart';
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
    return Row(
      children: [
        // LEFT: LINE CHART
        Expanded(
          child: status != null
              ? _ChartCard(
                  title: "TRẠNG THÁI",
                  child: LineChartWidget(status: status!),
                )
              : _loadingCard(context, "TRẠNG THÁI"),
        ),

        const SizedBox(width: 12),

        // RIGHT: BAR CHART
        Expanded(
          child: (groups != null && groups!.isNotEmpty)
              ? _ChartCard(
                  title: "ĐỘI NHÓM",
                  child: BarChartWidget(groups: groups!),
                )
              : _loadingCard(context, "ĐỘI NHÓM"),
        ),
      ],
    );
  }

  Widget _loadingCard(BuildContext context, String title) {
    return _ChartCard(
      title: title,
      child: Center(
        child: CircularProgressIndicator(color: context.primary),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
        boxShadow: [
          BoxShadow(
            color: context.opacity(Colors.black, 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
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