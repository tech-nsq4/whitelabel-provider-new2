import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_svg_icon.dart';

/// The reference design's `.ibox` — a tinted rounded square holding a
/// leading icon, used in front of list rows (setup grid, "more" menu,
/// document rows...).
class AppIconBox extends StatelessWidget {
  const AppIconBox({
    super.key,
    required this.svgIcon,
    this.size = 42,
    this.background,
    this.iconColor,
  });

  final String svgIcon;
  final double size;
  final Color? background;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular((size * 0.31).r),
      ),
      child: AppSvgIcon(
        svgIcon,
        size: size * 0.4,
        color: iconColor ?? AppColors.primaryColor.themeColor,
      ),
    );
  }
}
