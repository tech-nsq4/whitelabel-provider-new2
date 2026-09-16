import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class ScheduleEmptyNote extends StatelessWidget {
  const ScheduleEmptyNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: AppText(
        text,
        fontSize: 11,
        color: AppColors.mutedColor.themeColor,
      ),
    );
  }
}
