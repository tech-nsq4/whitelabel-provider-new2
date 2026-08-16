import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// The reference design's `.tabs` segmented control — a pill-shaped strip
/// with one raised, shadowed segment for the active tab. Reused by the
/// queue (waiting/in room/done) and consultation (consultation/history)
/// screens instead of each building its own `Row` of tap targets.
class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.counts,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// Optional trailing count shown after each label (e.g. queue tab sizes).
  final List<int>? counts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: CustomTapEffect(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: AppConstants.shortAnimationDuration,
                  padding: EdgeInsets.symmetric(vertical: 9.h),
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? AppColors.cardColor.themeColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11.r),
                    boxShadow: i == selectedIndex
                        ? [
                            BoxShadow(
                              color: AppColors.textPrimaryColor.themeColor
                                  .withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: AppText(
                    counts == null ? labels[i] : '${labels[i]} ${counts![i]}',
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w500,
                    color: i == selectedIndex
                        ? AppColors.textPrimaryColor.themeColor
                        : AppColors.mutedColor.themeColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
