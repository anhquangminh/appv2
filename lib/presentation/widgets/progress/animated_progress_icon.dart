// widgets/progress/animated_progress_icon.dart
import 'package:flutter/material.dart';

class AnimatedProgressIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool isAnimating;
  final double size;

  const AnimatedProgressIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.isAnimating,
    this.size = 16,
  });

  @override
  State<AnimatedProgressIcon> createState() =>
      _AnimatedProgressIconState();
}

class _AnimatedProgressIconState extends State<AnimatedProgressIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        widget.icon,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
