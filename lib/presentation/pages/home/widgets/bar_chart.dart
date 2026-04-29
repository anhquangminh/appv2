import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  final List<GroupReportModel> groups;

  const BarChartWidget({super.key, required this.groups});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int? _tappedIndex;

  /// Hàm xử lý viết tắt theo phong cách Editorial: IT, KT, VH...
  String _getAbbreviation(String name) {
    if (name.isEmpty) return "";
    List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].length > 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
    }
    return words.map((w) => w[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng số lượng để tính toán tỷ lệ phần trăm chiều cao cột
    final total = widget.groups.fold<int>(0, (sum, e) => sum + e.soLuong);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widget.groups.asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        final percent = total == 0 ? 0.0 : e.soLuong / total;

        // Palette màu sắc từ Design System (Chart Tokens)
        final color = [
          context.chartBlue,
          context.chartGreen,
          context.chartOrange,
          context.chartRed,
          context.purple,
        ][index % 5];

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                // Toggle chọn/bỏ chọn khi chạm
                _tappedIndex = (_tappedIndex == index) ? null : index;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tooltip (Số lượng): Tonal Nesting
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    opacity: _tappedIndex == index ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xxs,
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: context.surfaceHighest,
                        borderRadius: AppRadius.smRadius,
                        boxShadow: AppShadows.soft, // Botanical Shadow deep green tint
                      ),
                      child: Text(
                        '${e.soLuong}',
                        style: context.theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  
                  // Bar: Thiết kế sắc cạnh (No Border Radius) theo yêu cầu
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: percent),
                    duration: Duration(milliseconds: 700 + (index * 80)),
                    curve: Curves.easeOutQuart,
                    builder: (context, value, _) {
                      return Container(
                        height: 120 * value, 
                        decoration: BoxDecoration(
                          color: color,
                          // Loại bỏ hoàn toàn borderRadius để cột vuông vức
                          borderRadius: BorderRadius.zero, 
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Label (Viết tắt): Editorial Style
                  Text(
                    _getAbbreviation(e.tenNhom),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}