import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/queue_patient_model.dart';

/// A dimmed, already-seen row in the "انتهى" tab — matches the reference
/// design's faded finished-visit tile with a trailing check mark, plus the
/// visit's time/doctor and its diagnosis once the API returns one.
class QueueDoneTile extends StatelessWidget {
  const QueueDoneTile({super.key, required this.patient});

  final QueuePatientModel patient;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (patient.scheduledLabel != null) patient.scheduledLabel!,
      if (patient.doctorName != null) patient.doctorName!,
    ].join(' · ');

    return Opacity(
      opacity: 0.8,
      child: AppCard(
        margin: 10.paddingBottom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AppInitialsAvatar(patient.initial, size: 34),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(patient.name,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      AppText(
                          subtitle.isNotEmpty
                              ? subtitle
                              : (patient.doneAtLabel ?? ''),
                          fontSize: 10.5,
                          color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                AppSvgIcon(AppSvgIcons.checkCircle,
                    size: 17.sp, color: AppColors.primaryColor.themeColor),
              ],
            ),
            if (patient.diagnosis?.isNotEmpty ?? false) ...[
              8.height,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: AppText(
                  '${LocaleKeys.consultation_diagnosisLabel.tr()}: ${patient.diagnosis}',
                  fontSize: 10.5,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
