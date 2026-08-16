import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/queue_patient_model.dart';

/// A patient currently in the exam room — matches the reference design's
/// `.rc` card.
class QueueRoomCard extends StatefulWidget {
  const QueueRoomCard({super.key, required this.patient, required this.onTap});

  final QueuePatientModel patient;
  final Future<void> Function() onTap;

  @override
  State<QueueRoomCard> createState() => _QueueRoomCardState();
}

class _QueueRoomCardState extends State<QueueRoomCard> {
  bool _loading = false;

  Future<void> _handleTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    await widget.onTap();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final started = widget.patient.status == 'in_progress';

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(widget.patient.initial, filled: true),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(widget.patient.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(
                      '${widget.patient.mrn ?? LocaleKeys.queue_noMrn.tr()} · '
                      '${widget.patient.scheduledLabel ?? LocaleKeys.status_arrived.tr()}',
                      fontSize: 10.5,
                      color: AppColors.mutedColor.themeColor,
                    ),
                    if (widget.patient.doctorName != null) ...[
                      2.height,
                      AppText(widget.patient.doctorName!,
                          fontSize: 10, color: AppColors.mutedColor.themeColor),
                    ],
                  ],
                ),
              ),
            ],
          ),
          12.height,
          CustomButton(
            onTap: _handleTap,
            title: (started
                    ? LocaleKeys.queue_finishConsult
                    : LocaleKeys.queue_startConsult)
                .tr(),
            loading: _loading,
            height: 40,
            radius: 12,
          ),
        ],
      ),
    );
  }
}
