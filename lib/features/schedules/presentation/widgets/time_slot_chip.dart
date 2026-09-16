import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_schedule_model.dart';

class TimeSlotChip extends StatelessWidget {
  const TimeSlotChip({super.key, required this.slot});

  final TimeSlotModel slot;

  @override
  Widget build(BuildContext context) {
    final available = slot.available;
    final foreground = available
        ? AppColors.primaryColor.themeColor
        : AppColors.errorColor.themeColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: available
            ? AppColors.surfaceColor.themeColor
            : AppColors.criticalBgColor.themeColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: available
              ? AppColors.dividerColor.themeColor
              : AppColors.errorColor.themeColor.withValues(alpha: 0.25),
        ),
      ),
      child: AppText(
        slot.time,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: foreground,
        decoration: available ? null : TextDecoration.lineThrough,
      ),
    );
  }
}
