import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_prescription_model.dart';

/// One drug row in the patient file's "الأدوية" tab.
class PatientPrescriptionRow extends StatelessWidget {
  const PatientPrescriptionRow({super.key, required this.prescription});

  final PatientPrescriptionModel prescription;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (prescription.dosage?.isNotEmpty ?? false)
        '${LocaleKeys.pfile_medDose.tr()}: ${prescription.dosage}',
      if (prescription.duration?.isNotEmpty ?? false)
        '${LocaleKeys.pfile_medDuration.tr()}: ${prescription.duration}',
      if (prescription.date != null)
        ConvertHelper.formatDateTime(prescription.date!, includeDate: true),
    ].join(' · ');

    return Padding(
      padding: 9.paddingVert,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(svgIcon: AppSvgIcons.pill, size: 36),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(prescription.drugName,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (details.isNotEmpty)
                  AppText(details, fontSize: 10, color: AppColors.mutedColor.themeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
