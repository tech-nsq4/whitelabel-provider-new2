import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_list_item_model.dart';

/// The patient file's stats grid — every field on the `/users` row's
/// `statistics` object, sourced straight from it (2 rows of 3 tiles).
class PatientFileStatsRow extends StatelessWidget {
  const PatientFileStatsRow({super.key, required this.patient});

  final PatientListItemModel patient;

  @override
  Widget build(BuildContext context) {
    final stats = patient.statistics;
    final lastVisit = stats.lastCompletedBookingDate;

    return Column(
      children: [
        Row(
          children: [
            _Stat(value: '${stats.bookingsCount}', label: LocaleKeys.pfile_statBookings.tr()),
            _Stat(
              value: '${stats.waitingBookingsCount}',
              label: LocaleKeys.pfile_statWaiting.tr(),
              valueColor: AppColors.warningColor.themeColor,
            ),
            _Stat(
              value: lastVisit != null
                  ? ConvertHelper.formatDateTime(lastVisit, includeDate: true)
                  : '—',
              fontSize: 9,
              label: LocaleKeys.pfile_statLastVisit.tr(),
              isText: true,
            ),
          ],
        ),
        8.height,
        Row(
          children: [
            _Stat(value: '${stats.analysesCount}', label: LocaleKeys.pfile_statAnalyses.tr()),
            _Stat(value: '${stats.xraysCount}', label: LocaleKeys.pfile_statXrays.tr()),
            _Stat(
              value: '${stats.prescriptionsCount}',
              label: LocaleKeys.pfile_statPrescriptions.tr(),
              valueColor: AppColors.primaryColor.themeColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.valueColor, this.isText = false, this.fontSize});

  final String value;
  final String label;
  final Color? valueColor;
  final bool isText;
  final double? fontSize;

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
                fontSize: fontSize??(isText ? 13 : 17),
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
