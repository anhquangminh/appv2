import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';

import 'qlnv_popup_menu.dart';

class QLNVListItem extends StatelessWidget {
  final NhanVienModel nhanVien;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String action) onActionSelected;

  const QLNVListItem({
    super.key,
    required this.nhanVien,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onActionSelected,
  });

  ({String text, Color color}) _status(BuildContext context) {
    switch (nhanVien.isActive) {
      case 3:
        return (text: 'Đã duyệt', color: context.success);
      case 0:
        return (text: 'Chờ duyệt thêm', color: context.textSecondary);
      case 1:
        return (text: 'Chờ duyệt sửa', color: context.warning);
      case 2:
        return (text: 'Chờ duyệt xóa', color: context.error);
      case 90:
        return (text: 'Đã xóa', color: context.error);
      default:
        return (text: 'Không rõ', color: context.textSecondary);
    }
  }

  String _initials() {
    final words = nhanVien.tenNhanVien.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return '${words.first.characters.first}${words.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final status = _status(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xlRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.secondaryContainer,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nhanVien.tenNhanVien.isEmpty
                              ? 'Nhan vien chua dat ten'
                              : nhanVien.tenNhanVien,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: context.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xxs),

                        _MetaRow(
                          icon: Icons.work_outline,
                          text: nhanVien.chucVu.isEmpty ? '-' : nhanVien.chucVu,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        _MetaRow(
                          icon: Icons.mail_outline_rounded,
                          text:
                              nhanVien.taiKhoan.isEmpty
                                  ? '-'
                                  : nhanVien.taiKhoan,
                        ),
                      ],
                    ),
                  ),
                  QLNVPopupMenu(
                    nhanVien: nhanVien,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onActionSelected: onActionSelected,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                icon: Icons.apartment_rounded,
                label: 'CHI NHANH',
                value:
                    nhanVien.companyName.isEmpty
                        ? '-'
                        : nhanVien.companyName.toUpperCase(),
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(
                icon: Icons.verified_outlined,
                label: 'TRANG THAI',
                value: status.text.toUpperCase(),
                valueColor: status.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: context.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: context.textPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: valueColor ?? context.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
