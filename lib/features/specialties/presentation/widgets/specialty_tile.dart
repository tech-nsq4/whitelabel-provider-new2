import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/specialty_model.dart';

/// One read-only row on the "التخصصات" directory. Tapping it opens the
/// specialty's details, including its sub-specialties.
class SpecialtyTile extends StatelessWidget {
  const SpecialtyTile({super.key, required this.specialty, required this.onTap});

  final SpecialtyModel specialty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(svgIcon: AppSvgIcons.stethoscope),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(specialty.title,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (specialty.description != null) ...[
                  3.height,
                  AppText(specialty.description!,
                      fontSize: 11.5,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (specialty.subSpecialties.isNotEmpty) ...[
            8.width,
            AppStatusChip(
              LocaleKeys.specialtiesScreen_subCount
                  .tr(namedArgs: {'count': '${specialty.subSpecialties.length}'}),
              tone: AppStatusTone.muted,
            ),
          ],
        ],
      ),
    );
  }
}
