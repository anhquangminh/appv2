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

class _TaskProgressSectionState extends State<TaskProgressSection>
    with TickerProviderStateMixin {
  String? selectedKey;

  @override
  Widget build(BuildContext context) {
    final total = widget.model.tongSo;

    double percent(int value) {
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
            percent: percent(widget.model.cho),
            value: '${widget.model.cho}',
            color: context.info,
          ),
          _animatedBar(
            keyName: 'chuaLam',
            label: 'CHƯA LÀM',
            percent: percent(widget.model.chuaLam),
            value: '${widget.model.chuaLam}',
            color: context.primary,
          ),
          _animatedBar(
            keyName: 'dangThucHien',
            label: 'ĐANG LÀM',
            percent: percent(widget.model.dangThucHien),
            value: '${widget.model.dangThucHien}',
            color: context.warning,
          ),
          _animatedBar(
            keyName: 'hoanThanh',
            label: 'HOÀN TẤT',
            percent: percent(widget.model.hoanThanh),
            value: '${widget.model.hoanThanh}',
            color: context.success,
          ),
          _animatedBar(
            keyName: 'quaHan',
            label: 'TRỄ HẠN',
            percent: percent(widget.model.quaHan),
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
        setState(() {
          selectedKey = keyName;
        });
        widget.onTap?.call(keyName);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? context.opacity(color, 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: context.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent.clamp(0, 1)),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, valueAnim, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: valueAnim,
                      minHeight: isSelected ? 12 : 10,
                      backgroundColor: context.surfaceLow,
                      valueColor: AlwaysStoppedAnimation(
                        isSelected
                            ? color
                            : context.opacity(color, 0.8),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 13 : 12,
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              child: Text(value),
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
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _slide = Tween(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(16),
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
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              widget.child,
            ],
          ),
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