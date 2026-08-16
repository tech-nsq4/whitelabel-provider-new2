import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_header_icon_button.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../queue/data/models/queue_patient_model.dart';

/// The consultation screen's top block — back button, patient name/MRN and
/// avatar, plus the allergy alert banner when the patient has one.
class ConsultationPatientHeader extends StatelessWidget {
  const ConsultationPatientHeader({super.key, required this.patient});

  final QueuePatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppHeaderIconButton(
              svgIcon: AppSvgIcons.chevronBack,
              size: 38,
              onTap: () => Navigator.pop(context),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    patient.name,
                    isHeading: true,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    '${patient.mrn ?? LocaleKeys.queue_noMrn.tr()}'
                    '${patient.age != null ? ' · ${patient.age} ' : ''}'
                    '${patient.bloodType ?? ''}',
                    fontSize: 11.5,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ],
              ),
            ),
            AppInitialsAvatar(patient.initial, filled: true),
          ],
        ),
        if (patient.allergy != null) ...[
          14.height,
          AppCard(
            color: AppColors.criticalBgColor.themeColor,
            borderColor: const Color(0xFFF0D5CF),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                AppSvgIcon(AppSvgIcons.info,
                    size: 18.sp, color: AppColors.errorColor.themeColor),
                10.width,
                Expanded(
                  child: AppText(
                    '${LocaleKeys.consultation_allergyPrefix.tr()} ${patient.allergy}',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.errorColor.themeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
