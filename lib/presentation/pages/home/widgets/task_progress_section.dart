import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/status_report_model.dart';
import 'package:flutter/material.dart';

class TaskProgressSection extends StatefulWidget {
  final StatusReportModel model;
  final Function(String type)? onTap;

  const TaskProgressSection({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  State<TaskProgressSection> createState() => _TaskProgressSectionState();
}

class _TaskProgressSectionState extends State<TaskProgressSection> {
  String? selectedKey;

  @override
  Widget build(BuildContext context) {
    final total = widget.model.tongSo;

    double calculatePercent(int value) {
      if (total == 0) return 0;
      return value / total;
    }

    return _SectionCard(
      title: 'PHÂN BỔ TRẠNG THÁI CV',
      child: Column(
        children: [
          _animatedBar(
            keyName: 'cho',
            label: 'CHỜ',
            percent: calculatePercent(widget.model.cho),
            value: '${widget.model.cho}',
            color: context.info,
          ),
          _animatedBar(
            keyName: 'chuaLam',
            label: 'CHƯA LÀM',
            percent: calculatePercent(widget.model.chuaLam),
            value: '${widget.model.chuaLam}',
            color: context.primary,
          ),
          _animatedBar(
            keyName: 'dangThucHien',
            label: 'ĐANG LÀM',
            percent: calculatePercent(widget.model.dangThucHien),
            value: '${widget.model.dangThucHien}',
            color: context.warning,
          ),
          _animatedBar(
            keyName: 'hoanThanh',
            label: 'HOÀN TẤT',
            percent: calculatePercent(widget.model.hoanThanh),
            value: '${widget.model.hoanThanh}',
            color: context.success,
          ),
          _animatedBar(
            keyName: 'quaHan',
            label: 'TRỄ HẠN',
            percent: calculatePercent(widget.model.quaHan),
            value: '${widget.model.quaHan}',
            color: context.error,
          ),
        ],
      ),
    );
  }

  Widget _animatedBar({
    required String keyName,
    required String label,
    required double percent,
    required String value,
    required Color color,
  }) {
    final isSelected = selectedKey == keyName;

    return GestureDetector(
      onTap: () {
        setState(() => selectedKey = isSelected ? null : keyName);
        widget.onTap?.call(keyName);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          // Focus Pulse: Hiệu ứng glow nhẹ khi được chọn
          color: isSelected ? context.opacity(color, 0.08) : Colors.transparent,
          borderRadius: AppRadius.lgRadius,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100, // Tăng width một chút cho Editorial Clarity
              child: Text(
                label,
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? color : context.textSecondary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent.clamp(0, 1)),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuart,
                builder: (context, animValue, _) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Track background
                      Container(
                        height: isSelected ? 10 : 8,
                        decoration: BoxDecoration(
                          color: context.surfaceLow,
                          borderRadius: AppRadius.pillRadius,
                        ),
                      ),
                      // Progress bar với hiệu ứng bo tròn cực đại (Pill)
                      FractionallySizedBox(
                        widthFactor: animValue,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isSelected ? 10 : 8,
                          decoration: BoxDecoration(
                            color: isSelected ? color : context.opacity(color, 0.7),
                            borderRadius: AppRadius.pillRadius,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: context.opacity(color, 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Value với typography Authority
            SizedBox(
              width: 30,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? color : context.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.surfaceHighest, // Tonal Layering
          borderRadius: AppRadius.xlRadius,
          boxShadow: AppShadows.soft, // Botanical Shadow
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: context.theme.textTheme.labelMedium?.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            widget.child,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}