import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../more/presentation/widgets/more_menu_row.dart';

/// "إعداد العيادة" — the hub every clinic-content settings screen hangs
/// off (services, specialties, doctors, schedules, branches, policy...).
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            AppScreenHeader(
              title: LocaleKeys.setupScreen_title.tr(),
              eyebrow: LocaleKeys.setupScreen_subtitle.tr(),
              leading: AppHeaderIconButton(
                svgIcon: AppSvgIcons.chevronBack,
                size: 38,
                onTap: () => Navigator.pop(context),
              ),
            ),
            18.height,
            AppSectionTitle(LocaleKeys.setupScreen_contentSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  MoreMenuRow(
                    icon: AppSvgIcons.grid2x2,
                    title: LocaleKeys.dashboard_setupServices.tr(),
                    subtitle: LocaleKeys.setupScreen_servicesSub.tr(),
                    onTap: () => Navigator.pushNamed(context, Routes.services),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.stethoscope,
                    title: LocaleKeys.dashboard_setupSpecialties.tr(),
                    subtitle: LocaleKeys.setupScreen_specialtiesSub.tr(),
                    onTap: () => Navigator.pushNamed(context, Routes.specialties),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.family,
                    title: LocaleKeys.dashboard_setupDoctors.tr(),
                    subtitle: LocaleKeys.setupScreen_doctorsSub.tr(),
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.staff),
                  ),
                ],
              ),
            ),
            22.height,
            AppSectionTitle(LocaleKeys.setupScreen_appointmentsSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  MoreMenuRow(
                    icon: AppSvgIcons.calendar,
                    title: LocaleKeys.dashboard_setupSchedules.tr(),
                    subtitle: LocaleKeys.setupScreen_schedulesSub.tr(),
                    onTap: () => Navigator.pushNamed(context, Routes.schedules),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.sparkle,
                    title: LocaleKeys.setupScreen_brandingTitle.tr(),
                    subtitle: LocaleKeys.setupScreen_brandingSub.tr(),
                    onTap: () => Navigator.pushNamed(context, Routes.branding),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.clock,
                    title: LocaleKeys.dashboard_setupPolicy.tr(),
                    subtitle: LocaleKeys.setupScreen_policySub.tr(),
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.policy),
                  ),
                ],
              ),
            ),
            22.height,
            AppSectionTitle(LocaleKeys.setupScreen_branchSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: MoreMenuRow(
                icon: AppSvgIcons.home2,
                title: LocaleKeys.dashboard_setupBranches.tr(),
                subtitle: LocaleKeys.setupScreen_branchesSub.tr(),
                showDivider: false,
                onTap: () => Navigator.pushNamed(context, Routes.branches),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
