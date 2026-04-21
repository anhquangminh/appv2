import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class JobActionMenu extends StatelessWidget {
  const JobActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: context.textSecondary,
      ),
      onPressed: () => _showMenu(context),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuItem(
                context,
                icon: Icons.info_outline,
                label: 'Chi tiết',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                context,
                icon: Icons.star_border,
                label: 'Đánh giá',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                context,
                icon: Icons.edit_outlined,
                label: 'Sửa',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.textPrimary,
            ),
      ),
      onTap: onTap,
    );
  }
}