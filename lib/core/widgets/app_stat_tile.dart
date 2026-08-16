import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_card.dart';
import 'app_text.dart';

/// A small "number + label" summary tile — used in stat rows across
/// dashboard/homecare/billing/patient-file screens instead of each
/// building its own.
class AppStatTile extends StatelessWidget {
  const AppStatTile({super.key, required this.value, required this.label, this.valueColor});

  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: AppCard(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              AppText(value,
                  isHeading: true,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: valueColor ?? AppColors.textPrimaryColor.themeColor),
              3.height,
              AppText(label,
                  fontSize: 9, color: AppColors.mutedColor.themeColor, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
