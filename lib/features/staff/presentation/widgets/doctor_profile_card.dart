import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';

/// One doctor row on the staff-pricing screen — matches the reference
/// design's card with a per-mode price strip and a rating/occupancy row.
class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({
    super.key,
    required this.doctor,
    required this.onEditPricing,
    required this.onSchedules,
  });

  final DoctorProfileModel doctor;
  final VoidCallback onEditPricing;
  final VoidCallback onSchedules;

  @override
  Widget build(BuildContext context) {
    final available = doctor.availability == StaffAvailability.available;

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(doctor.initial),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(doctor.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(doctor.specialty, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              AppStatusChip(
                available ? LocaleKeys.status_available.tr() : LocaleKeys.status_onLeave.tr(),
                tone: available ? AppStatusTone.positive : AppStatusTone.muted,
              ),
            ],
          ),
          12.height,
          Row(
            children: [
              for (final entry in doctor.pricing.entries) ...[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor.themeColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        AppText('${entry.value}',
                            isHeading: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor.themeColor),
                        AppText(entry.key, fontSize: 9, color: AppColors.mutedColor.themeColor),
                      ],
                    ),
                  ),
                ),
                if (entry.key != doctor.pricing.keys.last) 6.width,
              ],
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AppText(doctor.rating.toStringAsFixed(1),
                        isHeading: true,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGold.themeColor),
                    AppText(LocaleKeys.staff_ratingLabel.tr(),
                        fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    AppText(doctor.occupancyPercent != null ? '${doctor.occupancyPercent}٪' : '—',
                        isHeading: true, fontSize: 15, fontWeight: FontWeight.w600),
                    AppText(LocaleKeys.staff_occupancyLabel.tr(),
                        fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: onEditPricing,
                  title: LocaleKeys.staff_editPricing.tr(),
                  height: 36,
                  radius: 11,
                  fontSize: 12,
                  color: AppColors.surfaceColor.themeColor,
                  textColor: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              8.width,
              Expanded(
                child: CustomButton(
                  onTap: onSchedules,
                  title: LocaleKeys.staff_schedules.tr(),
                  height: 36,
                  radius: 11,
                  fontSize: 12,
                  isOutlined: true,
                  borderColor: AppColors.dividerColor.themeColor,
                  textColor: AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
