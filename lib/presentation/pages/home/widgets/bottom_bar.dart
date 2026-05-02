import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.border, width: 0.5)),
      ),
      child: SizedBox(
        height: 64,
        child: BottomAppBar(
          color: context.surfaceHighest,
          elevation: 8,
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(
                  context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'QLCV',
                  index: 0,
                ),
                _item(
                  context,
                  icon: Icons.assignment_turned_in_outlined,
                  activeIcon: Icons.assignment_turned_in_rounded,
                  label: 'DUYỆT',
                  index: 1,
                ),
                const SizedBox(width: 40),
                _item(
                  context,
                  icon: Icons.group_outlined,
                  activeIcon: Icons.group_rounded,
                  label: 'QLN',
                  index: 2,
                ),
                _item(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'CÀI ĐẶT',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    final color =
        isActive
            ? context.primary
            : context.textSecondary.withValues(alpha: 0.62);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 60,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            AnimatedScale(
              scale: isActive ? 1.16 : 1,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: Icon(
                isActive ? activeIcon : icon,
                size: isActive ? 23 : 20,
                color: color,
                weight: isActive ? 800 : 400,
                fill: isActive ? 1 : 0,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: isActive ? 10.5 : 9,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
                color: color,
                letterSpacing: 0,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
