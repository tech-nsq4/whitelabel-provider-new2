import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_status_model.dart';

/// One row in the "الأطباء الآن" live-status list.
class DashboardDoctorTile extends StatelessWidget {
  const DashboardDoctorTile({super.key, required this.doctor, this.onTap});

  final DoctorStatusModel doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (chipLabel, tone) = switch (doctor.availability) {
      DoctorAvailability.available => (LocaleKeys.status_available.tr(), AppStatusTone.positive),
      DoctorAvailability.inExam => (LocaleKeys.status_inExam.tr(), AppStatusTone.warning),
      DoctorAvailability.onLeave => (LocaleKeys.status_onLeave.tr(), AppStatusTone.muted),
    };

    return AppCard(
      onTap: onTap,
      margin: 9.paddingBottom,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInitialsAvatar(doctor.initial, size: 34),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(doctor.name,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                2.height,
                AppText(
                  '${doctor.specialty} · ${doctor.branch} · إشغال ${doctor.occupancyPercent}٪',
                  fontSize: 10,
                  color: AppColors.mutedColor.themeColor,
                ),
                3.height,
                Row(
                  children: [
                    AppText('${LocaleKeys.dashboard_nextLabel.tr()}: ',
                        fontSize: 10, color: AppColors.mutedColor.themeColor),
                    AppText(
                      doctor.nextSlot ?? '—',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppStatusChip(chipLabel, tone: tone),
        ],
      ),
    );
  }
}
