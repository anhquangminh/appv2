import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class AppTag extends StatelessWidget {
  final String text;

  const AppTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final _TagStyle style = _resolveStyle(context, text);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          style.icon,
          size: 14,
          color: style.color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.theme.textTheme.labelSmall?.copyWith(
            color: style.color,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

_TagStyle _resolveStyle(BuildContext context, String text) {
  switch (text.toLowerCase()) {
    case 'thấp':
      return _TagStyle(
        color: context.success,
        icon: Icons.south_rounded,
      );

    case 'trung bình':
      return _TagStyle(
        color: context.info,
        icon: Icons.drag_handle_rounded,
      );

    case 'cao':
      return _TagStyle(
        color: context.warning,
        icon: Icons.north_rounded,
      );

    case 'khẩn cấp':
      return _TagStyle(
        color: context.error,
        icon: Icons.warning_amber_rounded,
      );

    default:
      return _TagStyle(
        color: context.textSecondary,
        icon: Icons.sell_outlined,
      );
  }
}

class _TagStyle {
  final Color color;
  final IconData icon;

  const _TagStyle({
    required this.color,
    required this.icon,
  });
}