import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// A section's small-caps eyebrow label with an optional trailing text
/// link ("إدارة", "الكل"...) — matches the reference design's row of
/// `.eyebrow` + brand-colored action text above a list.
class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle(this.title, {super.key, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedColor.themeColor,
        ),
        if (actionLabel != null)
          CustomTapEffect(
            onTap: onAction,
            child: AppText(
              actionLabel!,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor.themeColor,
            ),
          ),
      ],
    );
  }
}
