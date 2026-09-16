import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/queue_patient_model.dart';
import 'widgets/booking_details_body.dart';

/// The queue's full appointment-details screen — opened from a card in
/// any of the three tabs. Shows everything the API returns for the
/// booking and, depending on [tabIndex], carries its own copy of the
/// call-in/cancel action (waiting) or the start/finish-consultation
/// action (in room) — the done tab is informational only.
class QueueDetailsScreen extends StatelessWidget {
  const QueueDetailsScreen({
    super.key,
    required this.patient,
    required this.tabIndex,
    this.onCallIn,
    this.onCancel,
    this.onConsultAction,
  });

  final QueuePatientModel patient;
  final int tabIndex;
  final VoidCallback? onCallIn;
  final VoidCallback? onCancel;
  final VoidCallback? onConsultAction;

  @override
  Widget build(BuildContext context) {
    final inProgress = patient.status == 'in_progress';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            Row(
              children: [
                AppHeaderIconButton(
                  svgIcon: AppSvgIcons.chevronBack,
                  onTap: () => Navigator.pop(context),
                ),
                12.width,
                AppText(LocaleKeys.queue_detailsTitle.tr(),
                    isHeading: true,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
              ],
            ),
            20.height,
            BookingDetailsBody(patient: patient),
            if (tabIndex == 0) ...[
              26.height,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                        onCallIn?.call();
                      },
                      title: LocaleKeys.queue_callIn.tr(),
                    ),
                  ),
                  8.width,
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                    title: LocaleKeys.queue_cancelAction.tr(),
                    width: 96,
                    isOutlined: true,
                    borderColor: AppColors.errorColor.themeColor,
                    textColor: AppColors.errorColor.themeColor,
                  ),
                ],
              ),
            ] else if (tabIndex == 1) ...[
              26.height,
              CustomButton(
                onTap: () {
                  Navigator.pop(context);
                  onConsultAction?.call();
                },
                color: inProgress ? AppColors.accentGold.themeColor : null,
                borderColor: inProgress ? AppColors.accentGold.themeColor : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inProgress) ...[
                      AppSvgIcon(AppSvgIcons.checkCircle,
                          size: 16.sp, color: Colors.white),
                      6.width,
                    ],
                    AppText(
                      (inProgress
                              ? LocaleKeys.queue_finishConsult
                              : LocaleKeys.queue_startConsult)
                          .tr(),
                      isHeading: true,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
