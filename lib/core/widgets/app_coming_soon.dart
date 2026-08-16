import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';

/// Placeholder body for a nav destination whose real screen hasn't been
/// built yet in this phase (e.g. Orders/Patients before their features
/// land) — a tinted icon plus a short explanation, not a raw blank screen.
class AppComingSoon extends StatelessWidget {
  const AppComingSoon({super.key, required this.icon, required this.title, required this.desc});

  final String icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                shape: BoxShape.circle,
              ),
              child: AppSvgIcon(icon, size: 28.sp, color: AppColors.primaryColor.themeColor),
            ),
            16.height,
            AppText(
              title,
              isHeading: true,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            6.height,
            AppText(
              desc,
              fontSize: 11.5,
              textAlign: TextAlign.center,
              color: AppColors.mutedColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
