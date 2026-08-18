import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// Placeholder shown on any of the queue's three tabs when its list is
/// empty.
class QueueEmptyState extends StatelessWidget {
  const QueueEmptyState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: AppText(text,
            fontSize: 11.5, color: AppColors.mutedColor.themeColor),
      ),
    );
  }
}
