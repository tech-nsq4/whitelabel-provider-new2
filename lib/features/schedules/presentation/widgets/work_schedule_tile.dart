import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/work_schedule_model.dart';

(String label, AppStatusTone tone) _modeVisual(WorkScheduleMode mode) => switch (mode) {
      WorkScheduleMode.clinic => (LocaleKeys.schedules_modeClinic.tr(), AppStatusTone.positive),
      WorkScheduleMode.online => (LocaleKeys.schedules_modeOnline.tr(), AppStatusTone.muted),
      WorkScheduleMode.home => (LocaleKeys.schedules_modeHome.tr(), AppStatusTone.warning),
    };

/// One doctor × mode row on "جداول العمل".
class WorkScheduleTile extends StatelessWidget {
  const WorkScheduleTile({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onLeave,
  });

  final WorkScheduleModel schedule;
  final VoidCallback onEdit;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = _modeVisual(schedule.mode);

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(schedule.doctorInitial, size: 34),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(schedule.doctorName,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(schedule.note, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              AppStatusChip(label, tone: tone),
            ],
          ),
          11.height,
          Row(
            children: [
              Expanded(
                child: _InfoBlock(
                  label: LocaleKeys.schedules_daysLabel.tr(),
                  value: schedule.daysLabel,
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: LocaleKeys.schedules_hoursLabel.tr(),
                  value: schedule.hoursLabel,
                ),
              ),
              Column(
                children: [
                  AppText('${schedule.slotCount}',
                      isHeading: true,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor.themeColor),
                  AppText(schedule.unitLabel, fontSize: 9, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ],
          ),
          11.height,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: onEdit,
                  title: LocaleKeys.schedules_edit.tr(),
                  height: 36,
                  radius: 11,
                  fontSize: 12,
                  color: AppColors.surfaceColor.themeColor,
                  textColor: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              8.width,
              Expanded(
                child: CustomButton(
                  onTap: onLeave,
                  title: LocaleKeys.schedules_leave.tr(),
                  height: 36,
                  radius: 11,
                  fontSize: 12,
                  isOutlined: true,
                  borderColor: AppColors.dividerColor.themeColor,
                  textColor: AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 9, color: AppColors.mutedColor.themeColor),
        2.height,
        AppText(value,
            fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
      ],
    );
  }
}
