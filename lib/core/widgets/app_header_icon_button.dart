import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_svg_icon.dart';
import 'custom_tap_effect.dart';

/// A bordered white square button used in screen headers — back arrows,
/// "add" shortcuts, notification bells. Matches the reference design's
/// plain (non-`.ibox`) header tile.
class AppHeaderIconButton extends StatelessWidget {
  const AppHeaderIconButton({
    super.key,
    required this.svgIcon,
    required this.onTap,
    this.size = 40,
    this.color,
    this.badgeCount,
  });

  final String svgIcon;
  final VoidCallback onTap;
  final double size;
  final Color? color;

  /// Small red count badge pinned to the top-start corner (e.g. unread
  /// notifications).
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
      ),
      child: AppSvgIcon(svgIcon, size: 17.sp, color: color ?? AppColors.textPrimaryColor.themeColor),
    );

    return CustomTapEffect(
      onTap: onTap,
      child: badgeCount == null || badgeCount == 0
          ? button
          : Stack(
              clipBehavior: Clip.none,
              children: [
                button,
                Positioned(
                  top: -5.h,
                  left: -8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    constraints: BoxConstraints(minWidth: 22.r, minHeight: 22.r),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.errorColor.themeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.backgroundColor.themeColor, width: 2),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
