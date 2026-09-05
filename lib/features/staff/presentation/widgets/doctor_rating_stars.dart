import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_svg_icon.dart';

/// Five-star row for a doctor's average rating — stars up to the rounded
/// rating filled gold, the rest muted outline.
class DoctorRatingStars extends StatelessWidget {
  const DoctorRatingStars({super.key, required this.rating, this.size = 13});

  final double rating;
  final double size;

  static const int _starCount = 5;

  @override
  Widget build(BuildContext context) {
    final filled = rating.round().clamp(0, _starCount).toInt();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _starCount; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : 1.5.w),
            child: AppSvgIcon(AppSvgIcons.star,
                size: size.sp,
                color: i < filled
                    ? AppColors.accentGold.themeColor
                    : AppColors.dividerColor.themeColor),
          ),
      ],
    );
  }
}
