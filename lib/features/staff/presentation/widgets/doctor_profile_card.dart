import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';

/// One read-only doctor row on the "الأطباء" directory. Tapping it opens
/// the doctor's full details screen.
class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({super.key, required this.doctor, required this.onTap});

  final DoctorProfileModel doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInitialsAvatar(doctor.initial),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(doctor.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (doctor.specializations.isNotEmpty) ...[
                  3.height,
                  AppText(doctor.specializations.join('، '),
                      fontSize: 11.5,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                if (doctor.clinicName != null) ...[
                  5.height,
                  Row(
                    children: [
                      AppSvgIcon(AppSvgIcons.mapPin,
                          size: 12.sp, color: AppColors.mutedColor.themeColor),
                      4.width,
                      Expanded(
                        child: AppText(doctor.clinicName!,
                            fontSize: 11,
                            color: AppColors.mutedColor.themeColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (doctor.price != null)
                AppText(
                    '${doctor.price} ${LocaleKeys.common_currency.tr()}',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor.themeColor),
              if (doctor.experience != null) ...[
                2.height,
                AppText(
                    LocaleKeys.queue_detailsExperienceValue
                        .tr(namedArgs: {'years': '${doctor.experience}'}),
                    fontSize: 10, color: AppColors.mutedColor.themeColor),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
