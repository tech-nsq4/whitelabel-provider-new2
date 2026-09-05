import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/prescription_entry_model.dart';
import 'consultation_prescription_row.dart';

/// "الوصفة الدوائية" — the section header with its add action and the list
/// of editable prescription rows (or a tap-to-add empty state).
class ConsultationPrescriptionSection extends StatelessWidget {
  const ConsultationPrescriptionSection({
    super.key,
    required this.prescriptions,
    required this.onAdd,
    required this.onChanged,
    required this.onRemove,
  });

  final List<PrescriptionEntryModel> prescriptions;
  final VoidCallback onAdd;
  final void Function(String id, {String? name, String? dose, String? duration})
      onChanged;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          LocaleKeys.consultation_prescriptionLabel.tr(),
          actionLabel: '+ ${LocaleKeys.consultation_addMedication.tr()}',
          onAction: onAdd,
        ),
        12.height,
        if (prescriptions.isEmpty)
          CustomTapEffect(
            onTap: onAdd,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 22.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.dividerColor.themeColor),
              ),
              child: AppText(LocaleKeys.consultation_noMedications.tr(),
                  fontSize: 11.5, color: AppColors.mutedColor.themeColor),
            ),
          )
        else
          for (var i = 0; i < prescriptions.length; i++)
            ConsultationPrescriptionRow(
              key: ValueKey(prescriptions[i].id),
              index: i,
              entry: prescriptions[i],
              onChanged: ({name, dose, duration}) => onChanged(
                  prescriptions[i].id,
                  name: name,
                  dose: dose,
                  duration: duration),
              onRemove: () => onRemove(prescriptions[i].id),
            ),
      ],
    );
  }
}
