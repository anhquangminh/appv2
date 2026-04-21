import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
enum JobProgressState { notStarted, doing, almostDone, done }

JobProgressState progressState(int progress) {
  if (progress <= 0) return JobProgressState.notStarted;
  if (progress < 50) return JobProgressState.doing;
  if (progress < 100) return JobProgressState.almostDone;
  return JobProgressState.done;
}

IconData progressIcon(JobProgressState state) {
  switch (state) {
    case JobProgressState.notStarted:
      return Icons.star_rate_sharp; 
    case JobProgressState.doing:
      return Icons.sync; 
    case JobProgressState.almostDone:
      return Icons.schedule; 
    case JobProgressState.done:
      return Icons.check_circle; 
  }
}
Color progressColor(BuildContext context, JobProgressState state) {
  switch (state) {
    case JobProgressState.notStarted:
      return AppColors.accentRed;

    case JobProgressState.doing:
      return AppColors.accentPurple;

    case JobProgressState.almostDone:
      return AppColors.accentBlue;

    case JobProgressState.done:
      return AppColors.accentGreen;

    }
}



