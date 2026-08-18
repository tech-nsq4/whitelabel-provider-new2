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
import '../../../../core/widgets/booked_by_caption.dart';
import 'queue_status_chip.dart';

/// An already-seen row in the "انتهى" tab — the visit's schedule/doctor
/// line, its status chip, and (once the API returns them) the complaint
/// and diagnosis it was closed with.
class QueueDoneTile extends StatelessWidget {
  const QueueDoneTile({super.key, required this.patient, required this.onTap});

  final QueuePatientModel patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInitialsAvatar(patient.avatarLabel, size: 42),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookedByCaption(bookedByName: patient.bookedByName),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(patient.name,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        8.width,
                        QueueStatusChip(status: patient.status),
                      ],
                    ),
                    3.height,
                    AppText(
                      patient.scheduledLabel ?? patient.doneAtLabel ?? '',
                      fontSize: 12,
                      color: AppColors.mutedColor.themeColor,
                    ),
                    if (patient.doctorName != null) ...[
                      5.height,
                      Row(
                        children: [
                          AppSvgIcon(AppSvgIcons.stethoscope,
                              size: 13.sp, color: AppColors.primaryColor.themeColor),
                          5.width,
                          Expanded(
                            child: AppText(
                              patient.doctorSpecializations != null
                                  ? '${patient.doctorName} · ${patient.doctorSpecializations}'
                                  : patient.doctorName!,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondaryColor.themeColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            ],
          ),
          if ((patient.complaint?.isNotEmpty ?? false) ||
              (patient.diagnosis?.isNotEmpty ?? false)) ...[
            10.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (patient.complaint?.isNotEmpty ?? false)
                    AppText(
                      '${LocaleKeys.consultation_complaintLabel.tr()}: ${patient.complaint}',
                      fontSize: 10.5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  if ((patient.complaint?.isNotEmpty ?? false) &&
                      (patient.diagnosis?.isNotEmpty ?? false))
                    4.height,
                  if (patient.diagnosis?.isNotEmpty ?? false)
                    AppText(
                      '${LocaleKeys.consultation_diagnosisLabel.tr()}: ${patient.diagnosis}',
                      fontSize: 10.5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
