import 'package:flutter/material.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';

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
      icon: const Icon(Icons.more_vert),
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
        final items = <PopupMenuEntry<String>>[];

        items.add(
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text('Sửa'),
              ],
            ),
          ),
        );

        items.add(
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Xóa'),
              ],
            ),
          ),
        );

        if (!isApproved) {
          items.add(const PopupMenuDivider());
          items.add(
            const PopupMenuItem(
              value: 'approve',
              child: Row(
                children: [
                  Icon(Icons.check, size: 18, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Duyệt'),
                ],
              ),
            ),
          );
          items.add(
            const PopupMenuItem(
              value: 'unapprove',
              child: Row(
                children: [
                  Icon(Icons.undo, size: 18, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Hủy duyệt'),
                ],
              ),
            ),
          );
        }

        return items;
      },
    );
  }
}
