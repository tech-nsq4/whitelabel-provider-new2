import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../staff/data/models/doctor_profile_model.dart';

/// One row in the "الأطباء اليوم" list.
class DashboardDoctorTile extends StatelessWidget {
  const DashboardDoctorTile({super.key, required this.doctor, this.onTap});

  final DoctorProfileModel doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (doctor.specializations.isNotEmpty) doctor.specializations.join('، '),
      if (doctor.clinicName != null) doctor.clinicName!,
    ].join(' · ');

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
                if (subtitle.isNotEmpty) ...[
                  2.height,
                  AppText(subtitle,
                      fontSize: 10,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (doctor.price != null) ...[
            8.width,
            AppText('${doctor.price} ${LocaleKeys.common_currency.tr()}',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor.themeColor),
          ],
        ],
      ),
    );
  }
}
