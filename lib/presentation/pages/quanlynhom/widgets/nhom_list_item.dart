import 'package:ducanherp/common/fa_icons.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NhomListItem extends StatelessWidget {
  final NhomNhanVienModel nhom;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String action) onActionSelected;

  const NhomListItem({
    super.key,
    required this.nhom,
    required this.index,
    required this.onTap,
    required this.onEdit,
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
    switch (nhom.isActive) {
      case 3:
        return 'Đã duyệt';
      case 0:
        return 'Chờ duyệt thêm';
      case 1:
        return 'Chờ duyệt sửa';
      case 2:
        return 'Chờ duyệt xóa';
      case 90:
        return 'Đã xóa';
      default:
        return 'Không rõ';
    }
  }

  Color _statusColor(BuildContext context) {
    switch (nhom.isActive) {
      case 3:
        return context.focusPulse;
      case 1:
        return context.warning;
      case 90:
        return context.error;
      default:
        return context.primary;
    }
  }

  void _showMenu(BuildContext context, GlobalKey key) async {
    final isApproved = nhom.isActive == 3;

    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(
          Offset(0, renderBox.size.height),
          ancestor: overlay,
        ),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final value = await showMenu<String>(
      context: context,
      position: position,
      color: context.surfaceHighest,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
      items: [
        _menuItem(
          context,
          value: 'edit',
          icon: Icons.edit_outlined,
          label: 'Sửa',
        ),
        _menuItem(
          context,
          value: 'delete',
          icon: Icons.delete_outline,
          label: 'Xóa',
          color: context.error,
        ),
        if (!isApproved) const PopupMenuDivider(),
        if (!isApproved)
          _menuItem(
            context,
            value: 'approve',
            icon: Icons.check_circle_outline,
            label: 'Duyệt',
            color: context.success,
          ),
        if (!isApproved)
          _menuItem(
            context,
            value: 'unapprove',
            icon: Icons.undo_rounded,
            label: 'Hủy duyệt',
            color: context.warning,
          ),
      ],
    );

    switch (value) {
      case 'edit':
        onEdit();
        break;
      case 'delete':
        onDelete();
        break;
      case 'approve':
      case 'unapprove':
        onActionSelected(value!);
        break;
      default:
        break;
    }
  }

  PopupMenuItem<String> _menuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final resolvedColor = color ?? context.textPrimary;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: resolvedColor),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuKey = GlobalKey();
    final statusColor = _statusColor(context);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: context.secondaryContainer,
                  borderRadius: AppRadius.smRadius,
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  _getGroupIcon(nhom.iconName),
                  color: context.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nhom.tenNhom.isEmpty ? 'Nhóm chưa đặt tên' : nhom.tenNhom,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: context.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    _InfoRow(
                      icon: Icons.business,
                      text:
                          nhom.companyName.isEmpty
                              ? 'Chưa có công ty'
                              : nhom.companyName,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    _InfoRow(
                      icon: Icons.person,
                      text:
                          nhom.tenNhanVien.isEmpty
                              ? 'Chưa có quản lý'
                              : nhom.tenNhanVien,
                      valueColor: context.primary,
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Column(
                children: [
                  GestureDetector(
                    key: menuKey,
                    onTap: () => _showMenu(context, menuKey),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 22,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: AppRadius.smRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricColumn(
                    title: 'THÀNH VIÊN',
                    value: nhom.total.toString(),
                    color: context.primary,
                  ),
                ),
                Container(width: 2, height: 30, color: context.border),
                Expanded(
                  child: _MetricColumn(
                    title: 'TRẠNG THÁI',
                    value: _statusLabel(),
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? valueColor;
  final bool emphasize;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.valueColor,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: context.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor ?? context.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricColumn({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.textPrimary,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w700,
            fontSize: 10
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 10
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
