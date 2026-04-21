import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/common/fa_icons.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';

class NhomListItem extends StatelessWidget {
  final NhomNhanVienModel nhom;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String action) onActionSelected;

  const NhomListItem({
    super.key,
    required this.nhom,
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
      color: context.surface,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: context.textPrimary),
              const SizedBox(width: 8),
              Text('Sửa', style: TextStyle(color: context.textPrimary)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: context.error),
              const SizedBox(width: 8),
              Text('Xóa', style: TextStyle(color: context.textPrimary)),
            ],
          ),
        ),
        if (!isApproved) const PopupMenuDivider(),
        if (!isApproved)
          PopupMenuItem(
            value: 'approve',
            child: Row(
              children: [
                Icon(Icons.check, size: 18, color: context.success),
                const SizedBox(width: 8),
                Text('Duyệt', style: TextStyle(color: context.textPrimary)),
              ],
            ),
          ),
        if (!isApproved)
          PopupMenuItem(
            value: 'unapprove',
            child: Row(
              children: [
                Icon(Icons.undo, size: 18, color: context.warning),
                const SizedBox(width: 8),
                Text('Hủy duyệt', style: TextStyle(color: context.textPrimary)),
              ],
            ),
          ),
      ],
    );

    if (value == null) return;

    switch (value) {
      case 'edit':
        onEdit();
        break;
      case 'delete':
        onDelete();
        break;
      default:
        onActionSelected(value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuKey = GlobalKey();

    String statusText;

    switch (nhom.isActive) {
      case 3:
        statusText = 'Đã duyệt';
        break;
      case 0:
        statusText = 'Chờ duyệt thêm';
        break;
      case 1:
        statusText = 'Chờ duyệt sửa';
        break;
      case 2:
        statusText = 'Chờ duyệt xóa';
        break;
      case 90:
        statusText = 'Đã xóa';
        break;
      default:
        statusText = 'Không rõ';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 48, // 👉 vuông
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.textSecondary,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(
                      color: context.border.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadow.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getGroupIcon(nhom.iconName),
                    color: context.onPrimary.withValues(
                      alpha: 0.9,
                    ), // 👉 icon vẫn nổi
                    size: 22,
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nhom.tenNhom.isNotEmpty ? nhom.tenNhom : '.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 12,
                            color: context.textSecondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              nhom.companyName.isNotEmpty
                                  ? nhom.companyName
                                  : '-',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 12,
                            color: context.textSecondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              nhom.tenNhanVien,
                              style: TextStyle(
                                fontSize: 10,
                                color: context.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 👉 anchor icon
                GestureDetector(
                  key: menuKey,
                  onTap: () => _showMenu(context, menuKey),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.expand_more,
                      color: context.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _stat(
                    "Thành viên",
                    "${nhom.total}",
                    context.textSecondary,
                  ),
                ),
                Container(height: 30, width: 1, color: context.divider),
                Expanded(
                  child: _stat("Trạng thái", statusText, context.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: color.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
