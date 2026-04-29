import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:flutter/material.dart';

class QLNVPopupMenu extends StatelessWidget {
  final NhanVienModel nhanVien;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String action) onActionSelected;

  const QLNVPopupMenu({
    super.key,
    required this.nhanVien,
    required this.onEdit,
    required this.onDelete,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = nhanVien.isActive == 3;

    return PopupMenuButton<String>(
      tooltip: 'Tuy chon',
      color: context.surfaceHighest,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
      icon: Icon(Icons.more_horiz_rounded, color: context.textSecondary),
      onSelected: (action) {
        switch (action) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
          default:
            onActionSelected(action);
        }
      },
      itemBuilder: (_) {
        final items = <PopupMenuEntry<String>>[
          _buildItem(
            context,
            value: 'edit',
            icon: Icons.edit_outlined,
            label: 'Sua',
          ),
          _buildItem(
            context,
            value: 'delete',
            icon: Icons.delete_outline,
            label: 'Xoa',
            iconColor: context.error,
          ),
        ];

        if (!isApproved) {
          items.add(const PopupMenuDivider());
          items.add(
            _buildItem(
              context,
              value: 'approve',
              icon: Icons.check_circle_outline,
              label: 'Duyet',
              iconColor: context.success,
            ),
          );
          items.add(
            _buildItem(
              context,
              value: 'unapprove',
              icon: Icons.undo_rounded,
              label: 'Huy duyet',
              iconColor: context.warning,
            ),
          );
        }

        return items;
      },
    );
  }

  PopupMenuItem<String> _buildItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    Color? iconColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? context.textPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.textPrimary),
          ),
        ],
      ),
    );
  }
}
