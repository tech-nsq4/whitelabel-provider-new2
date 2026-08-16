import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/pending_result_model.dart';
import 'inbox_result_tile.dart' show flagVisualFor;

/// The reference design's `#sh-review` sheet — the doctor's sign-off
/// before a result reaches the patient's app.
class InboxReviewSheet extends StatefulWidget {
  const InboxReviewSheet({super.key, required this.result, required this.onApprove});

  final PendingResultModel result;
  final VoidCallback onApprove;

  @override
  State<InboxReviewSheet> createState() => _InboxReviewSheetState();
}

class _InboxReviewSheetState extends State<InboxReviewSheet> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final (label, tone, _, _) = flagVisualFor(result.flag, context);

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
          AppText(result.testName,
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          AppText(result.patientName, fontSize: 12, color: AppColors.mutedColor.themeColor),
          16.height,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                AppText(result.value,
                    isHeading: true,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                8.height,
                AppStatusChip(label, tone: tone),
              ],
            ),
          ),
          16.height,
          AppText(LocaleKeys.inbox_noteLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(
            controller: _noteController,
            hint: LocaleKeys.inbox_noteHint.tr(),
            maxLines: 4,
          ),
          16.height,
          CustomButton(
            onTap: () {
              Navigator.pop(context);
              widget.onApprove();
            },
            title: LocaleKeys.inbox_approveSubmit.tr(),
          ),
        ],
      ),
    );
  }
}
