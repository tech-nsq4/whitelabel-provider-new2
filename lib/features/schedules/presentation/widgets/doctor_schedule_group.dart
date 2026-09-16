import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_schedule_model.dart';
import 'clinic_schedule_group.dart';
import 'expandable_panel.dart';
import 'schedule_empty_note.dart';

class DoctorScheduleGroup extends StatelessWidget {
  const DoctorScheduleGroup({super.key, required this.doctor});

  final DoctorScheduleModel doctor;

  @override
  Widget build(BuildContext context) {
    final summary = [
      LocaleKeys.schedules_clinicsCount.tr(
        namedArgs: {'count': '${doctor.clinics.length}'},
      ),
      LocaleKeys.schedules_timetablesCount.tr(
        namedArgs: {'count': '${doctor.timetablesCount}'},
      ),
    ].join(' · ');

    return ExpandablePanel(
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInitialsAvatar(doctor.initial, size: 40),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  doctor.name,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                if (doctor.specializationsLabel.isNotEmpty) ...[
                  2.height,
                  AppText(
                    doctor.specializationsLabel,
                    fontSize: 10.5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ],
                5.height,
                AppText(
                  summary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor.themeColor,
                ),
                5.height,

              ],
            ),
          ),
        ],
      ),
      child: doctor.clinics.isEmpty
          ? ScheduleEmptyNote(LocaleKeys.schedules_noClinics.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final clinic in doctor.clinics)
                  ClinicScheduleGroup(clinic: clinic, boxed: false),
              ],
            ),
    );
  }
}
