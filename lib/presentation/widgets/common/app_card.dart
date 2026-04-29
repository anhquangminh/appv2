import 'package:flutter/material.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_radius.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border.withValues(alpha: 0.3)),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.xlRadius,
        onTap: onTap,
        child: card,
      ),
    );
  }
}
