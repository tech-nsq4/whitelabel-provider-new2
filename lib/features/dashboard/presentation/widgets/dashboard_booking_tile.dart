import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/recent_booking_model.dart';

/// One row in the dashboard's "آخر الحجوزات" list — no card chrome of its
/// own, meant to sit inside a shared [AppCard] as a plain row like the
/// reference design's `.row`.
class DashboardBookingTile extends StatelessWidget {
  const DashboardBookingTile({super.key, required this.booking, this.onTap});

  final RecentBookingModel booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (chipLabel, tone) = switch (booking.status) {
      BookingStatus.paid => (LocaleKeys.status_paid.tr(), AppStatusTone.positive),
      BookingStatus.confirmed => (LocaleKeys.status_confirmed.tr(), AppStatusTone.positive),
      BookingStatus.pendingPayment => (
          LocaleKeys.status_pendingPayment.tr(),
          AppStatusTone.warning,
        ),
    };

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            AppIconBox(svgIcon: booking.isVideo ? AppSvgIcons.videoCam : AppSvgIcons.calendar),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(booking.patientName,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  AppText('${booking.serviceLabel} · ${booking.subLabel}',
                      fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
            AppStatusChip(chipLabel, tone: tone),
          ],
        ),
      ),
    );
  }
}
