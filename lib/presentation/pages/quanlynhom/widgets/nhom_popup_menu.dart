import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';

class NhomPopupMenu extends StatelessWidget {
  final NhomNhanVienModel nhom;
  final ApplicationUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NhomPopupMenu({
    super.key,
    required this.nhom,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = nhom.isActive == 3;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        if (action == 'edit') {
          onEdit();
          return;
        }

        if (action == 'delete') {
          onDelete();
          return;
        }

        if (action == 'approve' || action == 'unapprove') {
          final title =
              action == 'approve' ? 'Xác nhận duyệt' : 'Xác nhận hủy duyệt';
          final content =
              action == 'approve'
                  ? 'Bạn có chắc muốn duyệt "${nhom.tenNhom}"?'
                  : 'Bạn có chắc muốn hủy duyệt "${nhom.tenNhom}"?';

          final confirm = await showDialog<bool>(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Đồng ý'),
                    ),
                  ],
                ),
          );

          if (confirm == true) {
            if (action == 'approve') {
              // ignore: use_build_context_synchronously
              context.read<NhomNhanVienBloc>().add(
                    DuyetNhomNhanVien(nhom.id, user.userName),
                  );
            } else {
              // ignore: use_build_context_synchronously
              context.read<NhomNhanVienBloc>().add(
                    HuyDuyetNhomNhanVien(nhom.id, user.userName),
                  );
            }
          }
        }
      },
      itemBuilder: (ctx) {
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
