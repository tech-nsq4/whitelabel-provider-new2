import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

class DashboardDoctorShortcuts extends StatelessWidget {
  const DashboardDoctorShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ShortcutCard(
              icon: AppSvgIcons.calendar,
              label: LocaleKeys.dashboard_setupSchedules.tr(),
              description: LocaleKeys.dashboard_doctorSchedulesHint.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.schedules),
            ),
          ),
          12.width,
          Expanded(
            child: _ShortcutCard(
              icon: AppSvgIcons.home2,
              label: LocaleKeys.dashboard_setupBranches.tr(),
              description: LocaleKeys.dashboard_doctorBranchesHint.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.branches),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final String icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: icon, size: 40),
              const Spacer(),
              AppSvgIcon(
                AppSvgIcons.chevronRow,
                size: 16.sp,
                color: AppColors.hintColor.themeColor,
              ),
            ],
          ),
          14.height,
          AppText(
            label,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          4.height,
          AppText(
            description,
            fontSize: 10.5,
            height: 1.5,
            color: AppColors.mutedColor.themeColor,
          ),
        ],
      ),
    );
  }
}
