import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_list_item_model.dart';

/// One row in the patients directory list.
class PatientListTile extends StatelessWidget {
  const PatientListTile({super.key, required this.patient, required this.onTap});

  final PatientListItemModel patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (patient.phone != null) patient.phone!,
      if (patient.age != null) '${patient.age}',
    ].join(' · ');

    return AppCard(
      onTap: onTap,
      margin: 10.paddingBottom,
      child: Row(
        children: [
          AppInitialsAvatar(patient.initial),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(patient.displayName,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (subtitle.isNotEmpty) ...[
                  2.height,
                  AppText(subtitle, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ],
            ),
          ),
          if (patient.statistics.waitingBookingsCount > 0)
            AppStatusChip(
              LocaleKeys.patients_waitingBadge
                  .tr(namedArgs: {'count': '${patient.statistics.waitingBookingsCount}'}),
              tone: AppStatusTone.warning,
            )
          else
            AppSvgIcon(AppSvgIcons.chevronRow, size: 15, color: AppColors.hintColor.themeColor),
        ],
      ),
    );
  }
}
