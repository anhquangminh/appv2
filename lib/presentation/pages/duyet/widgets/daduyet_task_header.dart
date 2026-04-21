import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/core/utils/date_utils.dart';

class DaDuyetTaskHeader extends StatelessWidget {
  final dynamic item;

  const DaDuyetTaskHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final (statusText, statusColor) = _mapStatus(context, item.isActive);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TaskTitle(title: item.title),
        const SizedBox(height: 4),

        _TaskDateRow(
          icon: Icons.calendar_today,
          label: 'Ngày tạo',
          date: item.createAt,
        ),

        _TaskDateRow(
          icon: Icons.calendar_month,
          label: 'Ngày duyệt',
          date: item.dateApproval,
        ),

        const SizedBox(height: 4),

        _TaskStatus(
          text: statusText,
          color: statusColor,
        ),
      ],
    );
  }

  (String, Color) _mapStatus(BuildContext context, int status) {
    switch (status) {
      case 3:
        return ('Đã duyệt', context.success);
      case 0:
        return ('Chờ duyệt thêm', context.warning);
      case 1:
        return ('Chờ duyệt sửa', context.chartOrange);
      case 2:
        return ('Chờ duyệt xóa', context.error);
      case 90:
        return ('Đã xóa', context.error);
      default:
        return ('Không rõ', context.textSecondary);
    }
  }
}

// =======================================================
// TITLE
// =======================================================
class _TaskTitle extends StatelessWidget {
  final String? title;

  const _TaskTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: context.textPrimary,
      ),
    );
  }
}

// =======================================================
// DATE ROW
// =======================================================
class _TaskDateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime? date;

  const _TaskDateRow({
    required this.icon,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: context.textSecondary),
        const SizedBox(width: 4),
        Text(
          '$label: ${date != null ? DateUtilsHelper.formatDateCustom(date!, 'yyyy/MM/dd HH:mm:ss') : 'N/A'}',
          style: TextStyle(
            fontSize: 11,
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =======================================================
// STATUS
// =======================================================
class _TaskStatus extends StatelessWidget {
  final String text;
  final Color color;

  const _TaskStatus({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 14, color: context.textSecondary),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: context.opacity(color, 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.opacity(color, 0.3)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}