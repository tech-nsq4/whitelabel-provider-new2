import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/specialty_model.dart';

/// One row on the "التخصصات" screen.
class SpecialtyTile extends StatelessWidget {
  const SpecialtyTile({super.key, required this.specialty, required this.onEdit});

  final SpecialtyModel specialty;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: AppSvgIcons.stethoscope),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(specialty.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(specialty.summary, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              CustomButton(
                onTap: onEdit,
                title: LocaleKeys.common_edit.tr(),
                width: 72,
                height: 32,
                radius: 10,
                fontSize: 11.5,
                color: AppColors.surfaceColor.themeColor,
                textColor: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ),
          11.height,
          Container(
            padding: const EdgeInsets.only(top: 11),
            decoration: BoxDecoration(
              border: BorderDirectional(top: BorderSide(color: AppColors.dividerColor.themeColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.specialtiesScreen_availableAt.tr(),
                    fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                6.height,
                if (specialty.branches.isEmpty)
                  AppStatusChip(LocaleKeys.specialtiesScreen_noBranch.tr(), tone: AppStatusTone.warning)
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final branch in specialty.branches)
                        AppStatusChip(branch, tone: AppStatusTone.muted),
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
