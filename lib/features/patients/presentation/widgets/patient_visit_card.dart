import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/patient_visit_model.dart';
import 'patient_visit_item_row.dart';

/// One expandable visit row in the patient file's "الزيارات" tab — matches
/// the reference design's collapsible visit tile.
class PatientVisitCard extends StatelessWidget {
  const PatientVisitCard({
    super.key,
    required this.visit,
    required this.expanded,
    required this.onToggle,
  });

  final PatientVisitModel visit;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTapEffect(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.all(15.r),
              child: Row(
                children: [
                  AppIconBox(svgIcon: AppSvgIcons.stethoscope),
                  12.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(visit.title,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                        2.height,
                        AppText('${visit.doctor} · ${visit.code}',
                            fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        6.height,
                        AppText(
                          visit.diagnosisSummary,
                          fontSize: 10.5,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ],
                    ),
                  ),
                  8.width,
                  AppText(visit.dateLabel, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h),
              decoration: BoxDecoration(color: AppColors.backgroundColor.themeColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(color: AppColors.dividerColor.themeColor, height: 1),
                  10.height,
                  if (visit.items.isEmpty)
                    Padding(
                      padding: 8.paddingVert,
                      child: AppText(LocaleKeys.pfile_noVisitContent.tr(),
                          fontSize: 11, color: AppColors.mutedColor.themeColor),
                    )
                  else
                    for (final item in visit.items) PatientVisitItemRow(item: item),
                  6.height,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () {},
                          title: LocaleKeys.pfile_visitSummary.tr(),
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
                          onTap: () {},
                          title: LocaleKeys.pfile_print.tr(),
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
            ),
        ],
      ),
    );
  }
}
