import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/analytics_cubit.dart';
import 'widgets/analytics_stat_tile.dart';
import 'widgets/revenue_bar_chart.dart';
import 'widgets/specialty_share_bar.dart';

/// "التقارير الإدارية" — revenue, patient growth and specialty mix.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final _cubit = getIt<AnalyticsCubit>()..loadOverview();

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
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is AnalyticsLoading || state is AnalyticsInitial,
              error: state is AnalyticsError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final overview = (state as AnalyticsSuccess).overview;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.analyticsScreen_title.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.document,
                        color: AppColors.primaryColor.themeColor,
                        onTap: () =>
                            AppOverlay.showSuccess(LocaleKeys.analyticsScreen_exportToast.tr()),
                      ),
                    ),
                    18.height,
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 1.5,
                      children: [
                        AnalyticsStatTile(
                          label: LocaleKeys.analyticsScreen_statRevenue.tr(),
                          value: '${overview.monthlyRevenue}',
                          sub: '+${overview.revenueGrowthPercent}٪',
                          subColor: AppColors.primaryColor.themeColor,
                        ),
                        AnalyticsStatTile(
                          label: LocaleKeys.analyticsScreen_statNewPatients.tr(),
                          value: '${overview.newPatients}',
                          sub: LocaleKeys.analyticsScreen_statNewPatientsSub.tr(),
                          subColor: AppColors.primaryColor.themeColor,
                        ),
                        AnalyticsStatTile(
                          label: LocaleKeys.analyticsScreen_statNoShow.tr(),
                          value: '${overview.noShowPercent}٪',
                          sub: LocaleKeys.analyticsScreen_statNoShowSub.tr(),
                          valueColor: AppColors.warningColor.themeColor,
                        ),
                        AnalyticsStatTile(
                          label: LocaleKeys.analyticsScreen_statVideo.tr(),
                          value: '${overview.videoConsultations}',
                          sub: LocaleKeys.analyticsScreen_statVideoSub
                              .tr(namedArgs: {'percent': '${overview.videoShareOfBookingsPercent}'}),
                          subColor: AppColors.primaryColor.themeColor,
                        ),
                      ],
                    ),
                    18.height,
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSectionTitle(LocaleKeys.analyticsScreen_revenueChartTitle.tr()),
                          14.height,
                          RevenueBarChart(bars: overview.weeklyRevenueBars),
                        ],
                      ),
                    ),
                    16.height,
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSectionTitle(LocaleKeys.analyticsScreen_specialtyBreakdownTitle.tr()),
                          14.height,
                          for (final share in overview.specialtyShares)
                            SpecialtyShareBar(share: share),
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
