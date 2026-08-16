import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/calendar_slot_model.dart';

/// One row in the selected day's slot list — booked (with patient info)
/// or open (a dashed "اضغط للحجز" placeholder).
class CalendarSlotRow extends StatelessWidget {
  const CalendarSlotRow({super.key, required this.slot, required this.onTap, this.showDivider = true});

  final CalendarSlotModel slot;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: 12.paddingVert,
        decoration: showDivider
            ? BoxDecoration(
                border: BorderDirectional(bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
              )
            : null,
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: AppText(slot.time,
                  isHeading: true,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: slot.isAvailable
                      ? AppColors.mutedColor.themeColor
                      : AppColors.primaryColor.themeColor),
            ),
            if (slot.isAvailable)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.hintColor.themeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: AppText(LocaleKeys.calendarScreen_slotOpen.tr(),
                      fontSize: 11, color: AppColors.mutedColor.themeColor),
                ),
              )
            else ...[
              AppIconBox(svgIcon: AppSvgIcons.stethoscope, size: 34),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(slot.patientName!,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    if (slot.subtitle != null)
                      AppText(slot.subtitle!, fontSize: 10, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              AppStatusChip(LocaleKeys.status_confirmed.tr(), tone: AppStatusTone.positive),
            ],
          ],
        ),
      ),
    );
  }
}
