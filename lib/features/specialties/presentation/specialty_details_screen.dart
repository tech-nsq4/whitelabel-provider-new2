import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/specialty_model.dart';

/// The specialties directory's read-only details screen — the
/// specialty's description and its sub-specialties.
class SpecialtyDetailsScreen extends StatelessWidget {
  const SpecialtyDetailsScreen({super.key, required this.specialty});

  final SpecialtyModel specialty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            Row(
              children: [
                AppHeaderIconButton(
                  svgIcon: AppSvgIcons.chevronBack,
                  onTap: () => Navigator.pop(context),
                ),
                12.width,
                AppText(LocaleKeys.specialtiesScreen_detailsTitle.tr(),
                    isHeading: true,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
              ],
            ),
            20.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIconBox(svgIcon: AppSvgIcons.stethoscope, size: 48),
                14.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(specialty.title,
                          isHeading: true,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      if (specialty.description != null) ...[
                        4.height,
                        AppText(specialty.description!,
                            fontSize: 12,
                            height: 1.6,
                            color: AppColors.textSecondaryColor.themeColor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (specialty.subSpecialties.isNotEmpty) ...[
              22.height,
              AppSectionTitle(LocaleKeys.specialtiesScreen_subSpecialties.tr()),
              10.height,
              for (final sub in specialty.subSpecialties)
                AppCard(
                  margin: 8.paddingBottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(sub.title,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      if (sub.description != null) ...[
                        4.height,
                        AppText(sub.description!,
                            fontSize: 11,
                            height: 1.5,
                            color: AppColors.textSecondaryColor.themeColor),
                      ],
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
