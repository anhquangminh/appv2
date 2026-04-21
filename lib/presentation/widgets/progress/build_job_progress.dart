import 'package:ducanherp/core/helpers/icon_helper.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/widgets/progress/animated_progress_icon.dart';
import 'package:flutter/material.dart';

Widget buildJobProgress(BuildContext context, int progress) {
  final state = progressState(progress);
  final color = progressColor(context, state);
  final icon = progressIcon(state);

  return Tooltip(
    message: switch (state) {
      JobProgressState.notStarted => 'Chưa bắt đầu',
      JobProgressState.doing => 'Đang thực hiện',
      JobProgressState.almostDone => 'Sắp hoàn thành',
      JobProgressState.done => 'Đã hoàn thành',
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedProgressIcon(
          icon: icon,
          color: color,
          isAnimating: state == JobProgressState.doing,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 118,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tiến độ',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.textSecondary,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    '$progress%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.textSecondary,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 118,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: context.opacity(color, 0.1),
              ),
              clipBehavior: Clip.antiAlias,
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}