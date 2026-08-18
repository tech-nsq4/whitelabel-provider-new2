import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/queue_patient_model.dart';
import '../../../../core/widgets/booked_by_caption.dart';

/// One patient row in the "في الانتظار" tab — matches the reference
/// design's `.qc` card: avatar, appointment/MRN line, wait label, and a
/// "استدعاء المريض" call-in button. Tapping the card body (outside the
/// buttons) opens the full details screen, which carries its own copy of
/// the same actions.
class QueueWaitingCard extends StatelessWidget {
  const QueueWaitingCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onCallIn,
    required this.onCancel,
  });

  final QueuePatientModel patient;
  final VoidCallback onTap;
  final VoidCallback onCallIn;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final waitColor = patient.justArrived
        ? AppColors.primaryColor.themeColor
        : patient.highlightWait
            ? AppColors.warningColor.themeColor
            : AppColors.mutedColor.themeColor;

    final waitLabel = patient.justArrived
        ? LocaleKeys.status_arrived.tr()
        : (patient.waitMinutes ?? 0) <= 1
            ? LocaleKeys.status_waitingOneMinute.tr()
            : LocaleKeys.status_waitingMinutes
                .tr(namedArgs: {'minutes': '${patient.waitMinutes}'});

    return AppCard(
      margin: 10.paddingBottom,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInitialsAvatar(patient.avatarLabel),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookedByCaption(bookedByName: patient.bookedByName),
                    AppText(patient.name,
                        fontSize:16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText(

                      patient.scheduledLabel ?? LocaleKeys.queue_noAppointment.tr(),
                      fontSize: 12.5,
                      color: AppColors.mutedColor.themeColor,
                    ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       if (patient.doctorName != null) ...[
                         AppText(patient.doctorName!,
                             fontSize: 11, color: AppColors.mutedColor.themeColor),
                       ],
                       AppText(waitLabel,
                           fontSize: 11,
                           fontWeight: FontWeight.w600,
                           color: waitColor),
                     ],
                   )
                  ],
                ),
              ),
              AppSvgIcon(AppSvgIcons.chevronRow,
                  size: 17.sp, color: AppColors.hintColor.themeColor),
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: onCallIn,
                  title: LocaleKeys.queue_callIn.tr(),
                  height: 40,
                  radius: 12,
                ),
              ),
              8.width,
              CustomButton(
                onTap: onCancel,
                title: LocaleKeys.queue_cancelAction.tr(),
                width: 84,
                height: 40,
                radius: 12,
                isOutlined: true,
                borderColor: AppColors.errorColor.themeColor,
                textColor: AppColors.errorColor.themeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
