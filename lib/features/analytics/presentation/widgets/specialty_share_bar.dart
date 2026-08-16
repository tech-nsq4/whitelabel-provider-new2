import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/analytics_overview_model.dart';

/// One "٪ of bookings" progress row in the specialty breakdown.
class SpecialtyShareBar extends StatelessWidget {
  const SpecialtyShareBar({super.key, required this.share});

  final SpecialtyShareModel share;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(share.label,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
              AppText('${share.percent}٪',
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryColor.themeColor),
            ],
          ),
          5.height,
          ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: share.percent / 100,
              minHeight: 6.h,
              backgroundColor: AppColors.surfaceColor.themeColor,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryColor.themeColor),
            ),
          ),
        ],
      ),
    );
  }
}
