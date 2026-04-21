import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class DuyetActionMenu extends StatelessWidget {
  final Future<void> Function(bool isApprove) onSelected;

  const DuyetActionMenu({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: context.textSecondary,
      ),
      color: context.surface,
      padding: EdgeInsets.zero,
      onSelected: (value) {
        onSelected(value == 'approve');
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'approve',
          height: 36,
          child: _menuItem(
            context,
            Icons.check,
            'Duyệt',
            context.success,
          ),
        ),
        PopupMenuItem(
          value: 'unapprove',
          height: 36,
          child: _menuItem(
            context,
            Icons.undo,
            'Hủy duyệt',
            context.warning,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}