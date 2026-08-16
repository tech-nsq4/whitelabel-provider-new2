import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import 'widgets/more_language_sheet.dart';
import 'widgets/more_menu_row.dart';
import 'widgets/more_profile_card.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  int _roleIndex = 0;

  void _switchRole(int index) {
    setState(() => _roleIndex = index);
    final role = switch (index) {
      0 => LocaleKeys.more_roleDoctor.tr(),
      1 => LocaleKeys.more_roleReception.tr(),
      _ => LocaleKeys.more_roleAdmin.tr(),
    };
    AppOverlay.showSuccess(LocaleKeys.more_roleSwitchToast.tr(namedArgs: {'role': role}));
  }

  void _openLanguageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MoreLanguageSheet(parentContext: context),
    );
  }

  void _openLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AppConfirmDialog(
        icon: Icons.logout_rounded,
        iconColor: AppColors.errorColor.themeColor,
        title: LocaleKeys.settings_logoutDialogTitle.tr(),
        message: LocaleKeys.settings_logoutDialogMessage.tr(),
        confirmLabel: LocaleKeys.settings_logout.tr(),
        cancelLabel: LocaleKeys.common_cancel.tr(),
        confirmColor: AppColors.errorColor.themeColor,
        onConfirm: () {
          Navigator.pop(context);
          context.read<ProfileCubit>().reset();
          context.read<AuthCubit>().logout();
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (_) => false);
        },
      ),
    );
  }

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
              title: LocaleKeys.more_title.tr(),
              leading: AppHeaderIconButton(
                svgIcon: AppSvgIcons.chevronBack,
                size: 38,
                onTap: () => Navigator.pop(context),
              ),
            ),
            18.height,
            const MoreProfileCard(),
            22.height,
            AppSectionTitle(LocaleKeys.more_roleTitle.tr()),
            10.height,
            AppSegmentedTabs(
              labels: [
                LocaleKeys.more_roleDoctor.tr(),
                LocaleKeys.more_roleReception.tr(),
                LocaleKeys.more_roleAdmin.tr(),
              ],
              selectedIndex: _roleIndex,
              onChanged: _switchRole,
            ),
            22.height,
            AppSectionTitle(LocaleKeys.more_clinicSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  MoreMenuRow(
                    icon: AppSvgIcons.calendar,
                    title: LocaleKeys.more_agendaTitle.tr(),
                    subtitle: LocaleKeys.more_agendaSub.tr(namedArgs: {'count': '18'}),
                    onTap: () => Navigator.pushNamed(context, Routes.agenda),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.document,
                    title: LocaleKeys.more_docsTitle.tr(),
                    subtitle: LocaleKeys.more_docsSub.tr(),
                    onTap: () => Navigator.pushNamed(context, Routes.docs),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.home2,
                    title: LocaleKeys.more_homecareTitle.tr(),
                    subtitle: LocaleKeys.more_homecareSub.tr(namedArgs: {'count': '3'}),
                    badgeLabel: '3',
                    onTap: () => Navigator.pushNamed(context, Routes.homecare),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.card,
                    title: LocaleKeys.more_billingTitle.tr(),
                    subtitle: LocaleKeys.more_billingSub.tr(namedArgs: {'count': '3'}),
                    badgeLabel: '640',
                    badgeTone: AppStatusTone.warning,
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.billing),
                  ),
                ],
              ),
            ),
            22.height,
            AppSectionTitle(LocaleKeys.more_setupSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: MoreMenuRow(
                icon: AppSvgIcons.grid2x2,
                title: LocaleKeys.more_setupRowTitle.tr(),
                subtitle: LocaleKeys.more_setupRowSub.tr(),
                showDivider: false,
                onTap: () => Navigator.pushNamed(context, Routes.setup),
              ),
            ),
            22.height,
            AppSectionTitle(LocaleKeys.more_adminSection.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  MoreMenuRow(
                    icon: AppSvgIcons.stethoscope,
                    title: LocaleKeys.more_staffTitle.tr(),
                    subtitle: LocaleKeys.more_staffSub.tr(namedArgs: {'count': '3'}),
                    onTap: () => Navigator.pushNamed(context, Routes.staff),
                  ),
                  MoreMenuRow(
                    icon: AppSvgIcons.heartbeat,
                    title: LocaleKeys.more_analyticsTitle.tr(),
                    subtitle: LocaleKeys.more_analyticsSub.tr(),
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.analytics),
                  ),
                ],
              ),
            ),
            22.height,
            AppCard(
              onTap: _openLanguageSheet,
              child: Row(
                children: [
                  Icon(Icons.language_rounded, color: AppColors.primaryColor.themeColor),
                  12.width,
                  Expanded(
                    child: Text(
                      LocaleKeys.settings_changeLanguage.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocSelector<ProfileCubit, ProfileState, bool>(
              selector: (state) => state is ProfileSuccess,
              builder: (context, isLoggedIn) {
                if (!isLoggedIn) return const SizedBox.shrink();
                return Padding(
                  padding: 10.paddingTop,
                  child: AppCard(
                    onTap: _openLogoutDialog,
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.errorColor.themeColor),
                        12.width,
                        Text(
                          LocaleKeys.settings_logout.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.errorColor.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
