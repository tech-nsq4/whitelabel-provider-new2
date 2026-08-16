import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/prescription_entry_model.dart';
import 'consultation_prescription_row.dart';

/// "الوصفة الدوائية" — the section label, its "دواء" add button, and the
/// list of editable prescription rows (or an empty-state placeholder).
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              LocaleKeys.consultation_prescriptionLabel.tr(),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor,
            ),
            CustomTapEffect(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSvgIcon(AppSvgIcons.plus,
                        size: 14.sp,
                        color: AppColors.textPrimaryColor.themeColor),
                    5.width,
                    AppText(LocaleKeys.consultation_addMedication.tr(),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimaryColor.themeColor),
                  ],
                ),
              ),
            ),
          ],
        ),
        10.height,
        if (prescriptions.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: AppText(
              LocaleKeys.consultation_noMedications.tr(),
              textAlign: TextAlign.center,
              fontSize: 11.5,
              color: AppColors.mutedColor.themeColor,
            ),
          )
        else
          for (final entry in prescriptions)
            ConsultationPrescriptionRow(
              key: ValueKey(entry.id),
              entry: entry,
              onChanged: ({name, dose, duration}) => onChanged(entry.id,
                  name: name, dose: dose, duration: duration),
              onRemove: () => onRemove(entry.id),
            ),
      ],
    );
  }
}
