import 'package:ducanherp/common/fa_icons.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NhomThanhVienListItem extends StatelessWidget {
  final QuanLyNhanVienModel thanhVien;
  final VoidCallback onDelete;
  final ValueChanged<String> onActionSelected;

  const NhomThanhVienListItem({
    super.key,
    required this.thanhVien,
    required this.onDelete,
    required this.onActionSelected,
  });

  IconData _getGroupIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return FontAwesomeIcons.users;
    }
    return faIcons[iconName] ?? FontAwesomeIcons.users;
  }

  String _statusLabel() {
    switch (thanhVien.isActive) {
      case 3:
        return 'Đã duyệt';
      case 0:
        return 'Chờ duyệt thêm';
      case 1:
        return 'Chờ duyệt sửa';
      case 2:
        return 'Chờ duyệt xóa';
      case 90:
        return 'Không duyệt';
      default:
        return 'Không rõ';
    }
  }

  Color _statusColor(BuildContext context) {
    switch (thanhVien.isActive) {
      case 3:
        return context.success;
      case 1:
        return context.warning;
      case 2:
      case 90:
        return context.error;
      default:
        return context.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);
    final isApproved = thanhVien.isActive == 3;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.secondaryContainer,
              borderRadius: AppRadius.smRadius,
            ),
            alignment: Alignment.center,
            child: FaIcon(
              _getGroupIcon(thanhVien.iconName),
              color: context.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thanhVien.tenNhanVien.isEmpty
                      ? 'Chưa có tên nhân viên'
                      : '${thanhVien.tenNhanVien} (${thanhVien.taiKhoan})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 13,
                      color: context.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        thanhVien.companyName.isEmpty
                            ? 'Chưa có chi nhánh'
                            : thanhVien.companyName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.pillRadius,
                  ),
                  child: Text(
                    _statusLabel(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Tác vụ thành viên',
            color: context.surfaceHighest,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
            icon: Icon(Icons.more_vert_rounded, color: context.textSecondary),
            onSelected: (action) {
              if (action == 'delete') {
                onDelete();
                return;
              }
              onActionSelected(action);
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: context.error,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('Xóa khỏi nhóm'),
                      ],
                    ),
                  ),
                  if (!isApproved) const PopupMenuDivider(),
                  if (!isApproved)
                    PopupMenuItem(
                      value: 'approve',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: context.success,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text('Duyệt'),
                        ],
                      ),
                    ),
                  if (!isApproved)
                    PopupMenuItem(
                      value: 'unapprove',
                      child: Row(
                        children: [
                          Icon(
                            Icons.undo_rounded,
                            size: 18,
                            color: context.warning,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text('Hủy duyệt'),
                        ],
                      ),
                    ),
                ],
          ),
        ],
      ),
    );
  }
}
