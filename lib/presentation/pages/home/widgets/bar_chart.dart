import 'package:ducanherp/core/themes/app_theme_helper.dart';
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

  @override
  Widget build(BuildContext context) {
    final total = widget.groups.fold<int>(0, (sum, e) => sum + e.soLuong);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widget.groups.asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        final percent = total == 0 ? 0.0 : e.soLuong / total;

        final color = [
          context.chartBlue,
          context.chartGreen,
          context.chartOrange,
          context.chartRed,
          context.purple,
        ][index % 5];

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _tappedIndex = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tooltip hiển thị trên cột khi nhấn
                  if (_tappedIndex == index)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4)
                        ],
                      ),
                      child: Text(
                        '${e.soLuong}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: percent),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    builder: (context, value, _) {
                      return Container(
                        height: 100 * value,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    e.tenNhom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: context.textSecondary,
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