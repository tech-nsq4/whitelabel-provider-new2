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
import 'queue_status_chip.dart';

/// A patient currently in the exam room — matches the reference design's
/// `.rc` card. Tapping the card body (outside the button) opens the full
/// details screen, which carries its own copy of the same
/// start/finish-consultation action.
class QueueRoomCard extends StatefulWidget {
  const QueueRoomCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onConsultAction,
  });

  final QueuePatientModel patient;
  final VoidCallback onTap;
  final Future<void> Function() onConsultAction;

  @override
  State<QueueRoomCard> createState() => _QueueRoomCardState();
}

class _QueueRoomCardState extends State<QueueRoomCard> {
  bool _loading = false;

  Future<void> _handleConsultTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    await widget.onConsultAction();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    final started = patient.status == 'in_progress';

    return AppCard(
      margin: 10.paddingBottom,
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInitialsAvatar(patient.avatarLabel, filled: true, size: 46),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookedByCaption(bookedByName: patient.bookedByName),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(patient.name,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                        Align(
                          alignment: Alignment.topLeft,
                          child: QueueStatusChip(status: patient.status),
                        ),
                      ],
                    ),
                    3.height,
                    AppText(
                      patient.scheduledLabel ?? LocaleKeys.status_arrived.tr(),
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
          14.height,
          CustomButton(
            onTap: _handleConsultTap,
            loading: _loading,
            height: 42,
            radius: 12,
            color: started ? AppColors.accentGold.themeColor : null,
            borderColor: started ? AppColors.accentGold.themeColor : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (started) ...[
                  AppSvgIcon(AppSvgIcons.checkCircle, size: 16.sp, color: Colors.white),
                  6.width,
                ],
                AppText(
                  (started
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
      ),
    );
  }
}
