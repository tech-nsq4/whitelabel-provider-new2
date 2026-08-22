import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_initials_avatar.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../notifications/logic/notifications_badge_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../logic/dashboard_cubit.dart';
import 'widgets/dashboard_booking_tile.dart';
import 'widgets/dashboard_doctor_tile.dart';
import 'widgets/dashboard_setup_grid.dart';
import 'widgets/dashboard_stat_grid.dart';

/// The bottom nav's "Today" landing screen — the reference design's `#today`.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onGoToQueue});

  /// Lets the shell (`LayoutScreen`) switch the bottom nav to the queue tab
  /// — e.g. from the "ابدأ الكشفيات" button or a stat tile tap.
  final VoidCallback onGoToQueue;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final _cubit = getIt<DashboardCubit>()..loadOverview();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DashboardCubit, DashboardState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is DashboardLoading || state is DashboardInitial,
              error: state is DashboardError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadOverview(),
              builder: (context) {
                final overview = (state as DashboardSuccess).overview;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 108.h),
                  children: [
                    AppScreenHeader(
                      eyebrow: overview.date != null
                          ? '${LocaleKeys.dashboard_eyebrowToday.tr()} · '
                              '${ConvertHelper.formatDateTime(overview.date!, includeDate: true)}'
                          : LocaleKeys.dashboard_eyebrowToday.tr(),
                      title: LocaleKeys.dashboard_title.tr(),
                      trailing: Row(
                        children: [
                          BlocBuilder<NotificationsBadgeCubit, int>(
                            bloc: getIt<NotificationsBadgeCubit>(),
                            builder: (context, unreadCount) {
                              return AppHeaderIconButton(
                                svgIcon: AppSvgIcons.bell,
                                badgeCount: unreadCount,
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.notifications),
                              );
                            },
                          ),
                          9.width,
                          Builder(builder: (context) {
                            final profileState =
                                context.watch<ProfileCubit>().state;
                            final name = profileState is ProfileSuccess
                                ? profileState.manager.name.trim()
                                : '';
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, Routes.more),
                              child: AppInitialsAvatar(
                                  name.isNotEmpty ? name[0] : '؟',
                                  filled: true),
                            );
                          }),
                        ],
                      ),
                    ),
                    18.height,
                    DashboardStatGrid(
                      stats: overview.stats,
                      onTapAppointments: () =>
                          Navigator.pushNamed(context, Routes.agenda),
                      onTapBookings: () =>
                          Navigator.pushNamed(context, Routes.bookings),
                      onTapWaiting: widget.onGoToQueue,
                      onTapResults: () =>
                          Navigator.pushNamed(context, Routes.inbox),
                    ),
                    12.height,
                    CustomButton(
                      onTap: widget.onGoToQueue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.dashboard_startShift.tr(),
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          7.width,
                          Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 18.sp),
                        ],
                      ),
                    ),
                    24.height,
                    AppSectionTitle(LocaleKeys.dashboard_setupTitle.tr()),
                    12.height,
                    DashboardSetupGrid(items: [
                      DashboardSetupItem(
                        icon: AppSvgIcons.grid2x2,
                        label: LocaleKeys.dashboard_setupServices.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.services),
                      ),
                      DashboardSetupItem(
                        icon: AppSvgIcons.stethoscope,
                        label: LocaleKeys.dashboard_setupSpecialties.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.specialties),
                      ),
                      DashboardSetupItem(
                        icon: AppSvgIcons.family,
                        label: LocaleKeys.dashboard_setupDoctors.tr(),
                        onTap: () => Navigator.pushNamed(context, Routes.staff),
                      ),
                      DashboardSetupItem(
                        icon: AppSvgIcons.calendar,
                        label: LocaleKeys.dashboard_setupSchedules.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.schedules),
                      ),
                      DashboardSetupItem(
                        icon: AppSvgIcons.home2,
                        label: LocaleKeys.dashboard_setupBranches.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.branches),
                      ),
                      DashboardSetupItem(
                        icon: AppSvgIcons.clock,
                        label: LocaleKeys.dashboard_setupPolicy.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.policy),
                      ),
                    ]),
                    26.height,
                    AppSectionTitle(
                      LocaleKeys.dashboard_doctorsNowTitle.tr(),
                      actionLabel: LocaleKeys.dashboard_manage.tr(),
                      onAction: () =>
                          Navigator.pushNamed(context, Routes.staff),
                    ),
                    12.height,
                    if (overview.doctors.isEmpty)
                      AppText(LocaleKeys.dashboard_noDoctorsToday.tr(),
                          fontSize: 12, color: AppColors.mutedColor.themeColor)
                    else
                      for (final doctor in overview.doctors)
                        DashboardDoctorTile(
                          doctor: doctor,
                          onTap: () => Navigator.pushNamed(
                              context, Routes.doctorDetails,
                              arguments: {'doctor': doctor}),
                        ),
                    14.height,
                    AppSectionTitle(
                      LocaleKeys.dashboard_recentBookingsTitle.tr(),
                      actionLabel: LocaleKeys.dashboard_seeAll.tr(),
                      onAction: () =>
                          Navigator.pushNamed(context, Routes.bookings),
                    ),
                    12.height,
                    if (overview.recentAppointments.isEmpty)
                      AppText(LocaleKeys.dashboard_noRecentBookings.tr(),
                          fontSize: 12, color: AppColors.mutedColor.themeColor)
                    else
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < overview.recentAppointments.length;
                                i++) ...[
                              if (i > 0)
                                Divider(
                                    height: 1,
                                    color: AppColors.dividerColor.themeColor),
                              DashboardBookingTile(
                                appointment: overview.recentAppointments[i],
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.queueDetails,
                                    arguments: {
                                      'patient': QueuePatientModel.fromAppointment(
                                          overview.recentAppointments[i]),
                                      'tabIndex': 2,
                                    }),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
