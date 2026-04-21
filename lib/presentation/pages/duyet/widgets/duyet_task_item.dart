import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/core/utils/date_utils.dart';
import 'package:ducanherp/presentation/widgets/common/html_content_box.dart';
import 'package:google_fonts/google_fonts.dart';
class DuyetTaskItem extends StatelessWidget {
  final dynamic item;

  final bool isSelectionMode;
  final bool isSelected;
  final bool isExpanded;

  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggleExpand;
  final Future<void> Function(bool isApprove)? onMenuAction;
  final ValueChanged<bool?>? onCheckboxChanged;

  /// 👉 control show checkbox (có thể tắt hoàn toàn)
  final bool showCheckbox;

  const DuyetTaskItem({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
    required this.onLongPress,
    required this.onToggleExpand,
    this.onMenuAction,
    this.onCheckboxChanged,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context;
    final status = _mapStatus(item.isActive, context);
    final canAction = onMenuAction != null;

    final bool displayCheckbox = showCheckbox && isSelectionMode;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MAIN CONTENT
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ICON
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: c.surfaceLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.description,
                          size: 20,
                          color: c.primary,
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TITLE + EXPAND + CHECKBOX (bên phải)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: c.textPrimary,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),

                                GestureDetector(
                                  onTap: onToggleExpand,
                                  child: AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration:
                                        const Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.expand_more,
                                      size: 18,
                                      color: c.primary,
                                    ),
                                  ),
                                ),

                                /// ✅ CHECKBOX RIGHT (không đè UI)
                                if (displayCheckbox) ...[
                                  const SizedBox(width: 6),
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: onCheckboxChanged,
                                    activeColor: c.primary,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity:
                                        const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// META
                            Row(
                              children: [
                                Icon(Icons.person,
                                    size: 12, color: c.textSecondary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.createBy ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: c.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text("•",
                                    style: TextStyle(
                                        color: c.textSecondary)),
                                const SizedBox(width: 6),
                                Text(
                                  item.createAt != null
                                      ? DateUtilsHelper.formatDateCustom(
                                          item.createAt!,
                                          'HH:mm dd/MM',
                                        )
                                      : 'N/A',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: c.textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Divider(
                              color: c.border.withValues(alpha: 0.25),
                              height: 1,
                            ),

                            const SizedBox(height: 6),

                            /// STATUS
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TRẠNG THÁI",
                                      style: GoogleFonts.inter(
                                        fontSize: 8,
                                        letterSpacing: 1,
                                        color: c.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      status.text,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: status.color,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: status.color
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    status.text.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// ACTION
                  if (canAction) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _actionButton(
                          context,
                          icon: Icons.cancel,
                          label: "Từ chối",
                          bg: c.surfaceLow,
                          color: c.textSecondary,
                          onTap: () => onMenuAction!(false),
                        ),
                        const SizedBox(width: 6),
                        _actionButton(
                          context,
                          icon: Icons.check_circle,
                          label: "Duyệt",
                          bg: c.primary,
                          color: Colors.white,
                          onTap: () => onMenuAction!(true),
                        ),
                      ],
                    ),
                  ],

                  /// CONTENT
                  if (isExpanded)
                    HtmlContentBox(content: item.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color bg,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusInfo _mapStatus(int? isActive, BuildContext context) {
    switch (isActive) {
      case 3:
        return _StatusInfo('Đã duyệt', context.success);
      case 0:
        return _StatusInfo('Chờ duyệt', context.textSecondary);
      case 1:
        return _StatusInfo('Chờ sửa', context.warning);
      case 2:
        return _StatusInfo('Chờ xóa', context.error);
      case 90:
        return _StatusInfo('Đã xóa', context.error);
      default:
        return _StatusInfo('Không rõ', context.textSecondary);
    }
  }
}

class _StatusInfo {
  final String text;
  final Color color;

  _StatusInfo(this.text, this.color);
}