import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// A selectable pill chip that flips between an outlined and a solid-brand
/// look — the reference design's `.chip` used for lab-order/document
/// selection, day pickers, and similar multi/single-select rows.
class AppToggleChip extends StatelessWidget {
  const AppToggleChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor.themeColor : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(99.r),
          border: selected ? null : Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: AppText(
          label,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.textSecondaryColor.themeColor,
        ),
      ),
    );
  }
}
