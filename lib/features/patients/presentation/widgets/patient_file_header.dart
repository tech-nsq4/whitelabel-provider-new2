import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_header_icon_button.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_list_item_model.dart';

/// The patient-file screen's top block — back button and identity.
class PatientFileHeader extends StatelessWidget {
  const PatientFileHeader({super.key, required this.patient});

  final PatientListItemModel patient;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (patient.phone != null) patient.phone!,
      if (patient.age != null) '${patient.age}',
    ].join(' · ');

    return Row(
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
              AppText(patient.displayName,
                  isHeading: true,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textPrimaryColor.themeColor),
              if (subtitle.isNotEmpty)
                AppText(subtitle, fontSize: 11.5, color: AppColors.mutedColor.themeColor),
            ],
          ),
        ),
        AppInitialsAvatar(patient.initial, filled: true),
      ],
    );
  }
}
