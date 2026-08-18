import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

/// The reference design's `.av` / `.av-s` rounded-square initials avatar —
/// a doctor's or patient's first letter on a tinted background. Pass
/// [filled] for the solid-brand variant used in screen headers.
class AppInitialsAvatar extends StatelessWidget {
  const AppInitialsAvatar(
    this.initial, {
    super.key,
    this.size = 42,
    this.filled = false,
  });

  final String initial;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final brand = AppColors.primaryColor.themeColor;
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? brand : AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular((size * 0.31).r),
      ),
      child: AppText(
        "$initial",
        isHeading: true,
        fontSize: size * 0.36,
        fontWeight: FontWeight.w600,
        color: filled ? Colors.white : brand,
      ),
    );
  }
}
