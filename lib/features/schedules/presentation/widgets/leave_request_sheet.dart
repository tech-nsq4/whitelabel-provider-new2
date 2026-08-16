import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

/// The reference design's `#sh-leave` sheet — marks a doctor unavailable
/// for a date range.
class LeaveRequestSheet extends StatefulWidget {
  const LeaveRequestSheet({super.key, required this.doctorName, required this.onSubmit});

  final String doctorName;
  final VoidCallback onSubmit;

  @override
  State<LeaveRequestSheet> createState() => _LeaveRequestSheetState();
}

class _LeaveRequestSheetState extends State<LeaveRequestSheet> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 26.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.hintColor.themeColor,
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
          ),
          AppText(LocaleKeys.leave_title.tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          AppText(widget.doctorName, fontSize: 12, color: AppColors.mutedColor.themeColor),
          16.height,
          AppText(LocaleKeys.leave_fromLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(controller: _fromController, hint: LocaleKeys.leave_dateHint.tr()),
          12.height,
          AppText(LocaleKeys.leave_toLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(controller: _toController, hint: LocaleKeys.leave_dateHint.tr()),
          18.height,
          CustomButton(
            onTap: () {
              Navigator.pop(context);
              widget.onSubmit();
            },
            title: LocaleKeys.leave_submit.tr(),
          ),
        ],
      ),
    );
  }
}
