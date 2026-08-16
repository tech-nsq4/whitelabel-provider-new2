import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

/// One of the homecare screen's three summary tiles.
class HomecareStatTile extends StatelessWidget {
  const HomecareStatTile({super.key, required this.value, required this.label, this.color});

  final String value;
  final String label;
  final Color? color;

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
                  color: color ?? AppColors.textPrimaryColor.themeColor),
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
