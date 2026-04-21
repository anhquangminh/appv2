import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class TabSwitcher extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;

  const TabSwitcher({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;

        return Container(
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.surfaceLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              /// 🔥 SLIDING INDICATOR
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                left: currentIndex * width,
                top: 0,
                bottom: 0,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: context.opacity(Colors.black, 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              /// 🔥 TABS
              Row(
                children: [
                  _tab(context, 0, 'Chờ duyệt'),
                  _tab(context, 1, 'Đã duyệt'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tab(BuildContext context, int index, String text) {
    final isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color:
                  isActive ? context.textPrimary : context.textSecondary,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}