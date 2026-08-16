import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

/// One row inside the "more" screen's menu cards — leading tinted icon,
/// title/subtitle, and either a trailing chevron or a small count badge.
class MoreMenuRow extends StatelessWidget {
  const MoreMenuRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeLabel,
    this.badgeTone = AppStatusTone.critical,
    this.showDivider = true,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeLabel;
  final AppStatusTone badgeTone;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: showDivider
            ? BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: AppColors.dividerColor.themeColor),
                ),
              )
            : null,
        child: Row(
          children: [
            AppIconBox(svgIcon: icon),
            13.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  AppText(subtitle, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
            if (badgeLabel != null)
              AppStatusChip(badgeLabel!, tone: badgeTone)
            else
              AppSvgIcon(AppSvgIcons.chevronRow, size: 15.sp, color: AppColors.hintColor.themeColor),
          ],
        ),
      ),
    );
  }
}
