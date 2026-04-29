import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      icon: Icon(Icons.more_horiz_rounded, color: context.textSecondary),
      color: context.surfaceHighest,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
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
          final approve = action == 'approve';
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(approve ? 'Xác nhận duyệt' : 'Xác nhận hủy duyệt'),
              content: Text(
                approve
                    ? 'Bạn có chắc muốn duyệt "${nhom.tenNhom}"?'
                    : 'Bạn có chắc muốn hủy duyệt "${nhom.tenNhom}"?',
              ),
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
            if (!context.mounted) return;
            if (approve) {
              context.read<NhomNhanVienBloc>().add(
                    DuyetNhomNhanVien(nhom.id, user.userName),
                  );
            } else {
              context.read<NhomNhanVienBloc>().add(
                    HuyDuyetNhomNhanVien(nhom.id, user.userName),
                  );
            }
          }
        }
      },
      itemBuilder: (ctx) {
        final items = <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 18, color: context.textPrimary),
                const SizedBox(width: 8),
                const Text('Sửa'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: context.error),
                const SizedBox(width: 8),
                const Text('Xóa'),
              ],
            ),
          ),
        ];

        if (!isApproved) {
          items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem(
              value: 'approve',
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 18, color: context.success),
                  const SizedBox(width: 8),
                  const Text('Duyệt'),
                ],
              ),
            ),
          );
          items.add(
            PopupMenuItem(
              value: 'unapprove',
              child: Row(
                children: [
                  Icon(Icons.undo_rounded, size: 18, color: context.warning),
                  const SizedBox(width: 8),
                  const Text('Hủy duyệt'),
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
