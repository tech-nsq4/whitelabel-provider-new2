import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

/// Tone of an [AppStatusChip] — mirrors the reference design's
/// `.c-ok` / `.c-warn` / `.c-hot` / `.c-mut` pill variants.
enum AppStatusTone { positive, warning, critical, muted }

/// Small rounded status pill — "متاحة", "بانتظار الدفع", "حرج"... Used on
/// dashboard/queue/consultation/patient cards instead of a raw `Container`.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip(this.label, {super.key, this.tone = AppStatusTone.muted});

  final String label;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      AppStatusTone.positive => (
          AppColors.surfaceColor.themeColor,
          AppColors.primaryColor.themeColor,
        ),
      AppStatusTone.warning => (
          AppColors.warningBgColor.themeColor,
          AppColors.warningColor.themeColor,
        ),
      AppStatusTone.critical => (
          AppColors.criticalBgColor.themeColor,
          AppColors.errorColor.themeColor,
        ),
      AppStatusTone.muted => (
          AppColors.primaryColor.themeColor.withOpacity(0.8),
          Colors.white
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99.r)),
      child: AppText(label, fontSize: 10.5, fontWeight: FontWeight.w600, color: fg),
    );
  }
}
