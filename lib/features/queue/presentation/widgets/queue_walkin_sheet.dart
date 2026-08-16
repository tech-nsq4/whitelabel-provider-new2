import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

/// The reference design's `#sh-walkin` sheet — registers a patient with no
/// booked slot straight onto the queue. Returns the entered name/MRN via
/// [onSubmit], the screen owns actually mutating the queue.
class QueueWalkinSheet extends StatefulWidget {
  const QueueWalkinSheet({super.key, required this.onSubmit});

  final void Function(String name, String? mrn) onSubmit;

  @override
  State<QueueWalkinSheet> createState() => _QueueWalkinSheetState();
}

class _QueueWalkinSheetState extends State<QueueWalkinSheet> {
  final _mrnController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _mrnController.dispose();
    _nameController.dispose();
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
          AppText(
            LocaleKeys.queue_walkinTitle.tr(),
            isHeading: true,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          18.height,
          AppText(LocaleKeys.queue_walkinMrnLabel.tr(),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(
            controller: _mrnController,
            hint: LocaleKeys.queue_walkinMrnHint.tr(),
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.right,
          ),
          14.height,
          AppText(LocaleKeys.queue_walkinNameLabel.tr(),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(
              controller: _nameController,
              hint: LocaleKeys.queue_walkinNameHint.tr()),
          18.height,
          CustomButton(
            onTap: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context);
              widget.onSubmit(
                  name,
                  _mrnController.text.trim().isEmpty
                      ? null
                      : _mrnController.text.trim());
            },
            title: LocaleKeys.queue_walkinSubmit.tr(),
          ),
        ],
      ),
    );
  }
}
