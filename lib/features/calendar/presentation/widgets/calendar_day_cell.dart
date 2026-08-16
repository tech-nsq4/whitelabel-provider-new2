import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/calendar_day_load_model.dart';

Color _levelColor(CalendarLoadLevel level) => switch (level) {
      CalendarLoadLevel.light => AppColors.primaryColor.themeColor,
      CalendarLoadLevel.medium => AppColors.warningColor.themeColor,
      CalendarLoadLevel.busy => AppColors.errorColor.themeColor,
    };

/// One cell in the month grid — the day number, its booking count and a
/// tiny load bar colored by [CalendarLoadLevel].
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.load,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final CalendarDayLoadModel? load;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasLoad = load != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.themeColor
              : hasLoad
                  ? AppColors.cardColor.themeColor
                  : Colors.transparent,
          border: !isSelected && hasLoad ? Border.all(color: AppColors.dividerColor.themeColor) : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  '$day',
                  isHeading: true,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : hasLoad
                          ? AppColors.textPrimaryColor.themeColor
                          : AppColors.hintColor.themeColor,
                ),
                if (hasLoad)
                  AppText(
                    '${load!.count}',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white70 : _levelColor(load!.level),
                  ),
              ],
            ),
            if (hasLoad && !isSelected)
              PositionedDirectional(
                bottom: 4.h,
                start: 6.w,
                end: 6.w,
                child: FractionallySizedBox(
                  widthFactor: (load!.count / 24).clamp(0.1, 1.0),
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 2.5.h,
                    decoration: BoxDecoration(
                      color: _levelColor(load!.level),
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
