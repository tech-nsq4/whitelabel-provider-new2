import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_file_model.dart';

/// The patient file's 4-tile stats strip — total visits, in-progress
/// orders, active medications and the last-visit date.
class PatientFileStatsRow extends StatelessWidget {
  const PatientFileStatsRow({super.key, required this.file});

  final PatientFileModel file;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: '${file.visits.length}', label: LocaleKeys.pfile_statVisits.tr()),
        _Stat(
          value: '${file.inProgressCount}',
          label: LocaleKeys.pfile_statInProgress.tr(),
          valueColor: AppColors.warningColor.themeColor,
        ),
        _Stat(
          value: '${file.activeMedicationsCount}',
          label: LocaleKeys.pfile_statActiveMeds.tr(),
          valueColor: AppColors.primaryColor.themeColor,
        ),
        _Stat(value: file.lastVisitLabel, label: LocaleKeys.pfile_statLastVisit.tr(), isText: true),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.valueColor, this.isText = false});

  final String value;
  final String label;
  final Color? valueColor;
  final bool isText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: AppCard(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              AppText(
                value,
                isHeading: true,
                fontSize: isText ? 13 : 17,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: valueColor ?? AppColors.textPrimaryColor.themeColor,
              ),
              3.height,
              AppText(label, fontSize: 9, color: AppColors.mutedColor.themeColor),
            ],
          ),
        ),
      ),
    );
  }
}
