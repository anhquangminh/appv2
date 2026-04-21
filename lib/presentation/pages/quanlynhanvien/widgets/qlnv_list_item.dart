import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final status = _status(context);

    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TÊN NHÂN VIÊN
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          size: 14,
                          color: context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            nhanVien.tenNhanVien.isNotEmpty
                                ? '${nhanVien.tenNhanVien[0].toUpperCase()}${nhanVien.tenNhanVien.substring(1)}'
                                : '.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    /// EMAIL / TÀI KHOẢN
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 12,
                          color: context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            nhanVien.taiKhoan.isNotEmpty
                                ? nhanVien.taiKhoan
                                : '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    /// CÔNG TY / PHÒNG BAN
                    Row(
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 12,
                          color: context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${nhanVien.companyName}/${nhanVien.departmentName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    /// TRẠNG THÁI
                    Row(
                      children: [
                        Icon(
                          Icons.info_outlined,
                          size: 12,
                          color: context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: context.opacity(status.color, 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.text,
                            style: TextStyle(
                              color: status.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// POPUP MENU
              QLNVPopupMenu(
                nhanVien: nhanVien,
                onEdit: onEdit,
                onDelete: onDelete,
                onActionSelected: onActionSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}