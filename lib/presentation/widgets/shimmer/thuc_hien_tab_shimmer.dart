import 'package:flutter/material.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';

class ThucHienTabShimmer extends StatelessWidget {
  const ThucHienTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(context, height: 100),

          const SizedBox(height: AppSpacing.md),
          _card(context, height: 220),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(child: _card(context, height: 180)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _card(context, height: 180)),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          _card(context, height: 160),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required double height}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(context, width: 120, height: 14),
          const SizedBox(height: AppSpacing.sm),
          _shimmerBox(context, width: double.infinity, height: height),
        ],
      ),
    );
  }

  Widget _shimmerBox(
    BuildContext context, {
    double width = double.infinity,
    double height = 12,
  }) {
    return _Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.surfaceLow,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// ================= SHIMMER EFFECT =================

class _Shimmer extends StatefulWidget {
  final Widget child;

  const _Shimmer({required this.child});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 - _controller.value, 0),
              end: Alignment(1 - _controller.value, 0),
              colors: [
                context.surfaceLow,
                context.surface.withValues(alpha: 0.4),
                context.surfaceLow,
              ],
              stops: const [0.2, 0.5, 0.8],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}