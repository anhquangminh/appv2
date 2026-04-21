import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:ducanherp/presentation/widgets/avatar/avatar_color_utils.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.index,
    required this.visibleCount,
    required this.remaining,
    required this.fullName,
    required this.initial,
    this.size = 32,
  });

  final int index;
  final int visibleCount;
  final int remaining;
  final String fullName;
  final String initial;
  final double size;

  bool get _isLastAndHasMore =>
      remaining > 0 && index == visibleCount - 1;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isLastAndHasMore
        ? AppColors.border
        : AvatarColorUtils.backgroundFromText(fullName);

    final textColor = _isLastAndHasMore
        ? AppColors.border
        : AvatarColorUtils.foreground(bgColor);

    return Tooltip(
      message: _isLastAndHasMore ? '' : fullName,
      verticalOffset: 12,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(
            color: Colors.white, // viền trắng nhẹ theo Material
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _isLastAndHasMore ? '+$remaining' : initial,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ),
    );
  }
}
