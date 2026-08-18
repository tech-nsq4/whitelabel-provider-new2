import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// "#15" — the request's id as a small pill, shared between the order
/// card and its details screen.
class OrderIdBadge extends StatelessWidget {
  const OrderIdBadge({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: AppText('#$id',
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedColor.themeColor),
    );
  }
}
