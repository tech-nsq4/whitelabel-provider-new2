import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/queue_patient_model.dart';

/// One patient row in the "في الانتظار" tab — matches the reference
/// design's `.qc` card: avatar, appointment/MRN line, wait label, and a
/// "نادِ للغرفة" call-in button.
class QueueWaitingCard extends StatelessWidget {
  const QueueWaitingCard({
    super.key,
    required this.patient,
    required this.onCallIn,
    required this.onCancel,
  });

  final QueuePatientModel patient;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInitialsAvatar(patient.initial),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(patient.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(
                      '${patient.mrn ?? LocaleKeys.queue_noMrn.tr()} · '
                      '${patient.scheduledLabel ?? LocaleKeys.queue_noAppointment.tr()}',
                      fontSize: 10.5,
                      color: AppColors.mutedColor.themeColor,
                    ),
                    3.height,
                    AppText(waitLabel,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: waitColor),
                    if (patient.doctorName != null) ...[
                      2.height,
                      AppText(patient.doctorName!,
                          fontSize: 10, color: AppColors.mutedColor.themeColor),
                    ],
                  ],
                ),
              ),
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
