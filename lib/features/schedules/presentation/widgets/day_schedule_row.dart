import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_schedule_model.dart';
import 'schedule_empty_note.dart';
import 'schedule_labels.dart';
import 'time_slot_chip.dart';

class DayScheduleRow extends StatelessWidget {
  const DayScheduleRow({super.key, required this.day});

  final DayScheduleModel day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvgIcon(
                AppSvgIcons.calendar,
                size: 13,
                color: AppColors.primaryColor.themeColor,
              ),
              6.width,
              AppText(
                ScheduleLabels.day(day.day),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              8.width,
              AppText(
                LocaleKeys.schedules_slotsCount.tr(
                  namedArgs: {'count': '${day.times.length}'},
                ),
                fontSize: 9.5,
                color: AppColors.mutedColor.themeColor,
              ),
            ],
          ),
          if (day.times.isEmpty)
            ScheduleEmptyNote(LocaleKeys.schedules_noSlots.tr())
          else ...[
            8.height,
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                for (final slot in day.times) TimeSlotChip(slot: slot),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
