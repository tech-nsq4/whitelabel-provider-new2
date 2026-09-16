import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_schedule_model.dart';
import 'day_schedule_row.dart';
import 'expandable_panel.dart';
import 'schedule_empty_note.dart';
import 'schedule_labels.dart';

class TimetableCard extends StatelessWidget {
  const TimetableCard({super.key, required this.table});

  final TimeTableModel table;

  List<DayScheduleModel> get _orderedDays {
    final days = [...table.days];
    days.sort((a, b) {
      final ia = ScheduleLabels.weekOrder.indexOf(a.day);
      final ib = ScheduleLabels.weekOrder.indexOf(b.day);
      return (ia < 0 ? 99 : ia).compareTo(ib < 0 ? 99 : ib);
    });
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      if (table.startDate != null && table.endDate != null)
        LocaleKeys.schedules_dateRange.tr(
          namedArgs: {'start': table.startDate!, 'end': table.endDate!},
        ),
      if (table.sessionMinutes != null)
        LocaleKeys.schedules_sessionDuration.tr(
          namedArgs: {'minutes': '${table.sessionMinutes}'},
        ),
      if (table.minutesBetweenSessions != null)
        LocaleKeys.schedules_sessionGap.tr(
          namedArgs: {'minutes': '${table.minutesBetweenSessions}'},
        ),
    ];

    return ExpandablePanel(
      boxed: false,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  table.name,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              if (table.type != null && table.type!.isNotEmpty) ...[
                8.width,
                AppStatusChip(
                  ScheduleLabels.type(table.type),
                  tone: AppStatusTone.positive,
                ),
              ],
            ],
          ),
          if (table.notes != null && table.notes!.isNotEmpty) ...[
            3.height,
            AppText(
              table.notes!,
              fontSize: 10.5,
              color: AppColors.mutedColor.themeColor,
            ),
          ],
          if (meta.isNotEmpty) ...[
            5.height,
            AppText(
              meta.join('  •  '),
              fontSize: 9.5,
              height: 1.6,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ],
          4.height,
          AppText(
            LocaleKeys.schedules_slotsCount.tr(
              namedArgs: {'count': '${table.slotsCount}'},
            ),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor.themeColor,
          ),
        ],
      ),
      child: table.days.isEmpty
          ? ScheduleEmptyNote(LocaleKeys.schedules_noSlots.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final day in _orderedDays) DayScheduleRow(day: day),
              ],
            ),
    );
  }
}
