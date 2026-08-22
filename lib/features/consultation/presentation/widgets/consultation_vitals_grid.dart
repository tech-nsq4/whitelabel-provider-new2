import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/vital_signs_model.dart';

/// The 2×2 "العلامات الحيوية" grid on the consultation history tab.
class ConsultationVitalsGrid extends StatelessWidget {
  const ConsultationVitalsGrid({super.key, required this.vitals});

  final VitalSignsModel vitals;

  String _formatTemperature(double value) =>
      value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 9.h,
      crossAxisSpacing: 9.w,
      childAspectRatio: 2.4,
      children: [
        _Vital(LocaleKeys.consultation_vitalPressure.tr(), vitals.bloodPressure),
        _Vital(LocaleKeys.consultation_vitalPulse.tr(),
            '${vitals.pulse} ${LocaleKeys.consultation_vitalPulseUnit.tr()}'),
        _Vital(LocaleKeys.consultation_vitalTemp.tr(),
            '${_formatTemperature(vitals.temperature)}°C'),
        _Vital(LocaleKeys.consultation_vitalO2.tr(), '${vitals.oxygen}%'),
      ],
    );
  }
}

class _Vital extends StatelessWidget {
  const _Vital(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(13.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(label, fontSize: 10, color: AppColors.mutedColor.themeColor),
          3.height,
          AppText(value,
              isHeading: true, fontSize: 17, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
