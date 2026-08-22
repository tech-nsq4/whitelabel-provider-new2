import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/booked_by_caption.dart';
import '../../../queue/data/models/appointment_model.dart';
import '../../../queue/data/models/queue_patient_model.dart';
import '../../../queue/presentation/widgets/queue_status_chip.dart';

/// One row in the dashboard's "آخر الحجوزات" list — no card chrome of its
/// own, meant to sit inside a shared [AppCard] as a plain row like the
/// reference design's `.row`.
class DashboardBookingTile extends StatelessWidget {
  const DashboardBookingTile({super.key, required this.appointment, this.onTap});

  final AppointmentModel appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final patient = QueuePatientModel.fromAppointment(appointment);
    final subtitle = [
      if (patient.doctorName != null) patient.doctorName!,
      if (patient.scheduledLabel != null) patient.scheduledLabel!,
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconBox(svgIcon: AppSvgIcons.calendar),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookedByCaption(bookedByName: patient.bookedByName),
                  AppText(patient.name,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  if (subtitle.isNotEmpty)
                    AppText(subtitle, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
            QueueStatusChip(status: appointment.status),
          ],
        ),
      ),
    );
  }
}
