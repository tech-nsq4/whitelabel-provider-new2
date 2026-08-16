import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

/// One "إعداد العيادة" shortcut — icon, label and its tap action.
class DashboardSetupItem {
  const DashboardSetupItem({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;
}

/// The dashboard's 6-tile "إعداد العيادة" shortcut grid (services,
/// specialties, doctors, schedules, branches, policy) — two rows of three
/// square icon tiles.
class DashboardSetupGrid extends StatelessWidget {
  const DashboardSetupGrid({super.key, required this.items});

  final List<DashboardSetupItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 9.h,
      crossAxisSpacing: 9.w,
      childAspectRatio: 0.95,
      children: [for (final item in items) _SetupTile(item: item)],
    );
  }
}

class _SetupTile extends StatelessWidget {
  const _SetupTile({required this.item});

  final DashboardSetupItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: item.onTap,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSvgIcon(item.icon, size: 26.sp, color: AppColors.primaryColor.themeColor),
          7.height,
          AppText(
            item.label,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: AppColors.textPrimaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
