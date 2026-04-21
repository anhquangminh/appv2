import 'package:flutter/material.dart';

class QuaHanBadge extends StatefulWidget {
  final String tooltip;

  const QuaHanBadge({
    super.key,
    this.tooltip = 'Công việc quá hạn',
  });

  @override
  State<QuaHanBadge> createState() => _QuaHanBadgeState();
}

class _QuaHanBadgeState extends State<QuaHanBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 400),
      showDuration: const Duration(seconds: 2),
      preferBelow: false,
      verticalOffset: 12,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.red.withOpacity(0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
