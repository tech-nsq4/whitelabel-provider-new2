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
import '../../data/models/patient_file_model.dart';

/// The patient-file screen's top block — back button, identity, and the
/// allergy alert banner when present.
class PatientFileHeader extends StatelessWidget {
  const PatientFileHeader({super.key, required this.file});

  final PatientFileModel file;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
                  AppText(file.name,
                      isHeading: true,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textPrimaryColor.themeColor),
                  AppText('${file.mrn} · ${file.age} · ${file.bloodType}',
                      fontSize: 11.5, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
            AppInitialsAvatar(file.initial, filled: true),
          ],
        ),
        if (file.allergy != null) ...[
          14.height,
          AppCard(
            color: AppColors.criticalBgColor.themeColor,
            borderColor: const Color(0xFFF0D5CF),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                AppSvgIcon(AppSvgIcons.info, size: 18.sp, color: AppColors.errorColor.themeColor),
                10.width,
                Expanded(
                  child: AppText(
                    '${LocaleKeys.consultation_allergyPrefix.tr()} ${file.allergy}',
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
