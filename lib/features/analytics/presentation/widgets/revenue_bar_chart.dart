import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

/// The analytics screen's 12-week revenue bar chart — recent weeks drawn
/// in brand color, older ones muted, matching the reference design's
/// plain `<div>` bars.
class RevenueBarChart extends StatelessWidget {
  const RevenueBarChart({super.key, required this.bars});

  /// Relative heights, 0–1.
  final List<double> bars;

  @override
  Widget build(BuildContext context) {
    final highlightFrom = bars.length - (bars.length / 3).round();

    return SizedBox(
      height: 110.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bars.length; i++) ...[
            Expanded(
              child: FractionallySizedBox(
                heightFactor: bars[i].clamp(0.04, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: i >= highlightFrom
                        ? AppColors.primaryColor.themeColor
                        : AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
            if (i != bars.length - 1) SizedBox(width: 5.w),
          ],
        ],
      ),
    );
  }
}
