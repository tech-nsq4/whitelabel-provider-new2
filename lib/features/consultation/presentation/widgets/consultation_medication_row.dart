import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/active_medication_model.dart';

/// One row in the consultation history's "أدوية نشطة" list.
class ConsultationMedicationRow extends StatelessWidget {
  const ConsultationMedicationRow({super.key, required this.medication});

  final ActiveMedicationModel medication;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.paddingVert,
      child: Row(
        children: [
          AppIconBox(svgIcon: AppSvgIcons.pill),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(medication.name,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                AppText(medication.schedule,
                    fontSize: 10.5, color: AppColors.mutedColor.themeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
