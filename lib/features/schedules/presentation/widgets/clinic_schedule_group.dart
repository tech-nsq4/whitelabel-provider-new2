import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_schedule_model.dart';
import 'expandable_panel.dart';
import 'schedule_empty_note.dart';
import 'timetable_card.dart';

class ClinicScheduleGroup extends StatelessWidget {
  const ClinicScheduleGroup({
    super.key,
    required this.clinic,
    this.boxed = true,
    this.initiallyExpanded = false,
  });

  final ClinicScheduleModel clinic;
  final bool boxed;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final location = clinic.location;
    final locationLine = [
      if (clinic.address != null && clinic.address!.isNotEmpty) clinic.address!,
      if (location != null && location.areaCityLabel.isNotEmpty)
        location.areaCityLabel,
    ].join(' · ');

    return ExpandablePanel(
      boxed: boxed,
      initiallyExpanded: initiallyExpanded,
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(svgIcon: AppSvgIcons.mapPin, size: 34),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  clinic.name,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                if (locationLine.isNotEmpty) ...[
                  3.height,
                  AppText(
                    locationLine,
                    fontSize: 10.5,
                    height: 1.5,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
                2.height,
                AppText(
                  LocaleKeys.schedules_timetablesCount.tr(
                    namedArgs: {'count': '${clinic.timeTables.length}'},
                  ),
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
      child: clinic.timeTables.isEmpty
          ? ScheduleEmptyNote(LocaleKeys.schedules_noTimetables.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final table in clinic.timeTables)
                  TimetableCard(table: table),
              ],
            ),
    );
  }
}
