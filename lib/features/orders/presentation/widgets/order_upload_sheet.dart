import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../data/models/test_request_model.dart';

class OrderUploadSheet extends StatefulWidget {
  const OrderUploadSheet({super.key, required this.request, required this.onSubmit});

  final TestRequestModel request;
  final Future<bool> Function(
      {required ResultRate resultRate, String? note, File? image}) onSubmit;

  @override
  State<OrderUploadSheet> createState() => _OrderUploadSheetState();
}

class _OrderUploadSheetState extends State<OrderUploadSheet> {
  final _noteController = TextEditingController();
  ResultRate _rate = ResultRate.normal;
  File? _image;
  bool _submitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final success = await widget.onSubmit(
      resultRate: _rate,
      note: _noteController.text.trim(),
      image: _image,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20.w, 14.h, 20.w, 26.h + MediaQuery.viewInsetsOf(context).bottom),
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
            AppText(
                '${widget.request.patientName ?? ''} — ${widget.request.testName ?? ''}',
                fontSize: 12, color: AppColors.mutedColor.themeColor),
            18.height,
            AppText(LocaleKeys.orders_resultRateLabel.tr(),
                fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
            8.height,
            Wrap(
              spacing: 8.w,
              children: [
                AppToggleChip(
                  label: LocaleKeys.status_normal.tr(),
                  selected: _rate == ResultRate.normal,
                  onTap: () => setState(() => _rate = ResultRate.normal),
                ),
                AppToggleChip(
                  label: LocaleKeys.status_abnormal.tr(),
                  selected: _rate == ResultRate.notNormal,
                  onTap: () => setState(() => _rate = ResultRate.notNormal),
                ),
                AppToggleChip(
                  label: LocaleKeys.status_caution.tr(),
                  selected: _rate == ResultRate.caution,
                  onTap: () => setState(() => _rate = ResultRate.caution),
                ),
              ],
            ),
            14.height,
            AppText(LocaleKeys.orders_noteLabel.tr(),
                fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
            8.height,
            CustomTextField(
              controller: _noteController,
              hint: LocaleKeys.orders_noteHint.tr(),
              maxLines: 3,
            ),
            16.height,
            InkWell(
              onTap: _pickImage,
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Image.file(_image!, height: 140.h, width: double.infinity, fit: BoxFit.cover),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(22.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.hintColor.themeColor, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          AppSvgIcon(AppSvgIcons.document,
                              size: 26.sp, color: AppColors.mutedColor.themeColor),
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
              onTap: _submit,
              title: LocaleKeys.orders_uploadSubmit.tr(),
              loading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
