import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool clickable;

  const AppCard({
    super.key,
    required this.child,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.clickable = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? const EdgeInsets.fromLTRB(12, 12, 12, 0),
      elevation: 0,
      color: context.surface,
      shadowColor: context.opacity(context.textPrimary, 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.border,
          width: 0.6,
        ),
      ),
      child: child,
    );

    if (!clickable) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onLongPress,
      child: card,
    );
  }
}