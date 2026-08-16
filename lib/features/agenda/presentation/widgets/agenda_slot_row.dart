import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/agenda_slot_model.dart';

(String label, AppStatusTone tone) _statusFor(AgendaSlotStatus status) => switch (status) {
      AgendaSlotStatus.done => (LocaleKeys.agenda_statusDone.tr(), AppStatusTone.muted),
      AgendaSlotStatus.arrived => (LocaleKeys.agenda_statusArrived.tr(), AppStatusTone.positive),
      AgendaSlotStatus.notArrived => (
          LocaleKeys.agenda_statusNotArrived.tr(),
          AppStatusTone.warning,
        ),
      AgendaSlotStatus.paid => (LocaleKeys.status_paid.tr(), AppStatusTone.positive),
      AgendaSlotStatus.confirmed => (LocaleKeys.status_confirmed.tr(), AppStatusTone.muted),
    };

/// One time-slot row in today's schedule list.
class AgendaSlotRow extends StatelessWidget {
  const AgendaSlotRow({super.key, required this.slot, required this.onTap, this.showDivider = true});

  final AgendaSlotModel slot;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = _statusFor(slot.status);
    final dimmed = slot.status == AgendaSlotStatus.done;

    return Opacity(
      opacity: dimmed ? 0.55 : 1,
      child: InkWell(
        onTap: dimmed ? null : onTap,
        child: Container(
          padding: 12.paddingVert,
          decoration: showDivider
              ? BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: AppColors.dividerColor.themeColor),
                  ),
                )
              : null,
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: AppText(slot.time,
                    isHeading: true,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: dimmed
                        ? AppColors.mutedColor.themeColor
                        : AppColors.primaryColor.themeColor),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(slot.patientName,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText(slot.subtitle, fontSize: 10, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              AppStatusChip(label, tone: tone),
            ],
          ),
        ),
      ),
    );
  }
}
