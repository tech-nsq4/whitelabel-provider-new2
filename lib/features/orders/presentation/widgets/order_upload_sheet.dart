import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../data/models/lab_order_model.dart';

enum OrderResultFlag { normal, abnormal, critical }

/// The reference design's `#sh-upload` sheet — records a test's reading,
/// clinical flag and (mock) attached file, then hands them back via
/// [onSubmit].
class OrderUploadSheet extends StatefulWidget {
  const OrderUploadSheet({super.key, required this.order, required this.onSubmit});

  final LabOrderModel order;
  final void Function(String reading, OrderResultFlag flag) onSubmit;

  @override
  State<OrderUploadSheet> createState() => _OrderUploadSheetState();
}

class _OrderUploadSheetState extends State<OrderUploadSheet> {
  final _readingController = TextEditingController();
  OrderResultFlag _flag = OrderResultFlag.normal;
  bool _attached = false;

  @override
  void dispose() {
    _readingController.dispose();
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
      child: SingleChildScrollView(
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
            AppText(LocaleKeys.orders_uploadTitle.tr(),
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            AppText('${widget.order.patientName} — ${widget.order.testName}',
                fontSize: 12, color: AppColors.mutedColor.themeColor),
            18.height,
            AppText(LocaleKeys.orders_uploadReadingLabel.tr(),
                fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
            8.height,
            CustomTextField(
              controller: _readingController,
              hint: LocaleKeys.orders_uploadReadingHint.tr(),
            ),
            14.height,
            Wrap(
              spacing: 8.w,
              children: [
                AppToggleChip(
                  label: LocaleKeys.status_normal.tr(),
                  selected: _flag == OrderResultFlag.normal,
                  onTap: () => setState(() => _flag = OrderResultFlag.normal),
                ),
                AppToggleChip(
                  label: LocaleKeys.status_abnormal.tr(),
                  selected: _flag == OrderResultFlag.abnormal,
                  onTap: () => setState(() => _flag = OrderResultFlag.abnormal),
                ),
                AppToggleChip(
                  label: LocaleKeys.status_critical.tr(),
                  selected: _flag == OrderResultFlag.critical,
                  onTap: () => setState(() => _flag = OrderResultFlag.critical),
                ),
              ],
            ),
            16.height,
            InkWell(
              onTap: () => setState(() => _attached = true),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(22.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: _attached
                        ? AppColors.primaryColor.themeColor
                        : AppColors.hintColor.themeColor,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    AppSvgIcon(
                      _attached ? AppSvgIcons.checkCircle : AppSvgIcons.document,
                      size: 26.sp,
                      color: _attached
                          ? AppColors.primaryColor.themeColor
                          : AppColors.mutedColor.themeColor,
                    ),
                    7.height,
                    AppText(LocaleKeys.orders_uploadFileHint.tr(),
                        fontSize: 11.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
            ),
            16.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: AppText(LocaleKeys.orders_uploadNote.tr(),
                  fontSize: 11, height: 1.6, color: AppColors.textSecondaryColor.themeColor),
            ),
            16.height,
            CustomButton(
              onTap: () {
                Navigator.pop(context);
                widget.onSubmit(_readingController.text.trim(), _flag);
              },
              title: LocaleKeys.orders_uploadSubmit.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
