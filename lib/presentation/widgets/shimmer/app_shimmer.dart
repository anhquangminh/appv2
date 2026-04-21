import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

// =============================
// SHIMMER BASE
// =============================
class AppShimmer extends StatefulWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.surfaceLow;
    final highlight = context.opacity(context.surfaceLow, 0.5);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: [
                base,
                highlight,
                base,
              ],
              stops: const [0.2, 0.5, 0.8],
            ).createShader(rect);
          },
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SummaryCardShimmer extends StatelessWidget {
  const SummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: context.border.withValues(alpha: 0.2),
        ),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Expanded(child: _item(context)),
          _divider(context),
          Expanded(child: _item(context)),
          _divider(context),
          Expanded(child: _item(context)),
          _divider(context),
          Expanded(child: _item(context)),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: context.border.withValues(alpha: 0.25),
    );
  }

  Widget _item(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        ShimmerBox(height: 20, width: 20, radius: 6), // icon giả
        SizedBox(height: AppSpacing.xs),
        ShimmerBox(height: 10, width: 40), // label
        SizedBox(height: 4),
        ShimmerBox(height: 18, width: 30), // value
      ],
    );
  }
}
// =============================
// SHIMMER BOX
// =============================
class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: context.surfaceLow,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// =============================
// SUMMARY SHIMMER
// =============================
class SummaryShimmer extends StatelessWidget {
  const SummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerBox(height: 20, width: 120),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(child: ShimmerBox(height: 60)),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 60)),
          ],
        ),
      ],
    );
  }
}

// =============================
// CHART SHIMMER
// =============================
class ChartShimmer extends StatelessWidget {
  const ChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _card(context),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _card(context),
        ),
      ],
    );
  }

  Widget _card(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(height: 12, width: 80),
          SizedBox(height: 12),
          ShimmerBox(height: 140),
        ],
      ),
    );
  }
}

// =============================
// TEAM SHIMMER
// =============================
class TeamShimmer extends StatelessWidget {
  final int itemCount;

  const TeamShimmer({
    super.key,
    this.itemCount = 8, // giống logic tối đa 8 item
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'TRẠNG THÁI NHÓM',
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
        children: List.generate(
          itemCount,
          (index) => _item(context),
        ),
      ),
    );
  }

  Widget _item(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // avatar
            AppShimmer(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: context.surfaceLow,
              ),
            ),

            // badge
            Positioned(
              top: -4,
              right: -4,
              child: AppShimmer(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: context.surfaceLow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.surface,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // text
        const ShimmerBox(height: 10, width: 40),
      ],
    );
  }
}

// =============================
// SECTION CARD (reuse style)
// =============================
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: context.border.withValues(alpha: 0.2)),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerBox(height: 12, width: 120),
              ShimmerBox(height: 12, width: 50), // "xem tất cả"
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// =============================
// TASK PROGRESS SHIMMER
// =============================
class TaskProgressShimmer extends StatelessWidget {
  const TaskProgressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCardShimmer(
      title: 'PHÂN BỔ TRẠNG THÁI CV',
      child: Column(
        children: const [
          _BarShimmer(),
          _BarShimmer(),
          _BarShimmer(),
          _BarShimmer(),
          _BarShimmer(),
        ],
      ),
    );
  }
}

// =============================
// BAR ITEM SHIMMER (match UI thật)
// =============================
class _BarShimmer extends StatelessWidget {
  const _BarShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // label
          const SizedBox(
            width: 90,
            child: ShimmerBox(height: 10, width: 70),
          ),

          // progress bar
          Expanded(
            child: AppShimmer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 10,
                  color: context.surfaceLow,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // value
          const ShimmerBox(height: 12, width: 24),
        ],
      ),
    );
  }
}

// =============================
// CARD SHIMMER (match _SectionCard)
// =============================
class _SectionCardShimmer extends StatefulWidget {
  final String title;
  final Widget child;

  const _SectionCardShimmer({
    required this.title,
    required this.child,
  });

  @override
  State<_SectionCardShimmer> createState() => _SectionCardShimmerState();
}

class _SectionCardShimmerState extends State<_SectionCardShimmer>
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
              // title shimmer
              const ShimmerBox(height: 12, width: 140),
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