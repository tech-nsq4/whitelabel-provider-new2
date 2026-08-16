import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/dashboard_stats_model.dart';

/// The dashboard's 2×2 stat tiles — appointments, new bookings, waiting
/// count and pending results, matching the reference design's `.tile`
/// grid with a big Readex-Pro number and a colored sub-line.
class DashboardStatGrid extends StatelessWidget {
  const DashboardStatGrid({
    super.key,
    required this.stats,
    required this.onTapAppointments,
    required this.onTapBookings,
    required this.onTapWaiting,
    required this.onTapResults,
  });

  final DashboardStatsModel stats;
  final VoidCallback onTapAppointments;
  final VoidCallback onTapBookings;
  final VoidCallback onTapWaiting;
  final VoidCallback onTapResults;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 1.55,
      children: [
        _StatTile(
          label: LocaleKeys.dashboard_statAppointments.tr(),
          value: '${stats.appointmentsTotal}',
          valueColor: AppColors.textPrimaryColor.themeColor,
          subLabel: LocaleKeys.dashboard_statAppointmentsSub.tr(namedArgs: {
            'online': '${stats.appointmentsOnline}',
            'clinic': '${stats.appointmentsClinic}',
          }),
          subColor: AppColors.primaryColor.themeColor,
          onTap: onTapAppointments,
        ),
        _StatTile(
          label: LocaleKeys.dashboard_statNewBookings.tr(),
          value: '${stats.newBookings}',
          valueColor: AppColors.primaryColor.themeColor,
          subLabel: LocaleKeys.dashboard_statNewBookingsSub.tr(),
          subColor: AppColors.mutedColor.themeColor,
          onTap: onTapBookings,
        ),
        _StatTile(
          label: LocaleKeys.dashboard_statWaiting.tr(),
          value: '${stats.waitingCount}',
          valueColor: AppColors.warningColor.themeColor,
          subLabel: LocaleKeys.dashboard_statWaitingSub
              .tr(namedArgs: {'minutes': '${stats.waitingAvgMinutes}'}),
          subColor: AppColors.mutedColor.themeColor,
          onTap: onTapWaiting,
        ),
        _StatTile(
          label: LocaleKeys.dashboard_statPendingResults.tr(),
          value: '${stats.pendingResults}',
          valueColor: AppColors.errorColor.themeColor,
          subLabel: LocaleKeys.dashboard_statPendingResultsSub
              .tr(namedArgs: {'critical': '${stats.pendingResultsCritical}'}),
          subColor: AppColors.errorColor.themeColor,
          onTap: onTapResults,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.subLabel,
    required this.subColor,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String subLabel;
  final Color subColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(label, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          4.height,
          AppText(value, isHeading: true, fontSize: 24, fontWeight: FontWeight.w600, color: valueColor),
          3.height,
          AppText(subLabel,
              fontSize: 10, fontWeight: FontWeight.w600, color: subColor, maxLines: 1),
        ],
      ),
    );
  }
}
