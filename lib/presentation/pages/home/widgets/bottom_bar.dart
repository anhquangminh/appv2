import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.border, // 👈 viền trên theo theme
            width: 0.5,
          ),
        ),
      ),
      child:  SizedBox(
      height: 64, // 👈 giảm tổng chiều cao BottomAppBar
      child: BottomAppBar(
        color: context.surface,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 4, // 👈 nhỏ lại thêm
        child: SizedBox(
          width: double.infinity,
          height: 40, // 👈 giảm chiều cao content bên trong
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(context, Icons.dashboard, 'QLCV', 0),
              _item(context, Icons.assignment_turned_in_outlined, 'DUYỆT', 1),
              const SizedBox(width: 40), // 👈 nhỏ lại để fit chiều cao
              _item(context, Icons.group_outlined, 'QLN', 2),
              _item(context, Icons.person_outline, 'test', 3),
              _item(context, Icons.person_outline, 'CÀI ĐẶT', 4),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20, // 👈 giảm size icon
              color: isActive ? context.primary : context.textSecondary,
            ),
            const SizedBox(height: 2), // 👈 giảm spacing
            Text(
              label,
              style: TextStyle(
                fontSize: 9, // 👈 nhỏ lại text
                fontWeight: FontWeight.w600,
                color: isActive ? context.primary : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}