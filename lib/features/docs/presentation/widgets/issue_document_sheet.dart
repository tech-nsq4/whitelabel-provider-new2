import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_chip.dart';

/// The reference design's `#sh-issue` sheet — issues a sick leave or a
/// medical report for a patient.
class IssueDocumentSheet extends StatefulWidget {
  const IssueDocumentSheet({super.key, required this.onSubmit});

  final void Function(String type, String patientName, String detail) onSubmit;

  @override
  State<IssueDocumentSheet> createState() => _IssueDocumentSheetState();
}

class _IssueDocumentSheetState extends State<IssueDocumentSheet> {
  final _patientController = TextEditingController();
  final _detailController = TextEditingController();
  bool _isSickLeave = true;

  @override
  void dispose() {
    _patientController.dispose();
    _detailController.dispose();
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
          AppText(LocaleKeys.docsScreen_issueTitle.tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          16.height,
          AppText(LocaleKeys.docsScreen_typeLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          Row(
            children: [
              Expanded(
                child: AppToggleChip(
                  label: LocaleKeys.status_docSickLeave.tr(),
                  selected: _isSickLeave,
                  onTap: () => setState(() => _isSickLeave = true),
                ),
              ),
              8.width,
              Expanded(
                child: AppToggleChip(
                  label: LocaleKeys.status_docMedicalReport.tr(),
                  selected: !_isSickLeave,
                  onTap: () => setState(() => _isSickLeave = false),
                ),
              ),
            ],
          ),
          14.height,
          AppText(LocaleKeys.appt_patientLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(controller: _patientController, hint: LocaleKeys.appt_patientHint.tr()),
          14.height,
          AppText(LocaleKeys.docsScreen_detailLabel.tr(),
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          8.height,
          CustomTextField(controller: _detailController, hint: LocaleKeys.docsScreen_detailHint.tr()),
          18.height,
          CustomButton(
            onTap: () {
              final name = _patientController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context);
              widget.onSubmit(
                _isSickLeave ? LocaleKeys.status_docSickLeave.tr() : LocaleKeys.status_docMedicalReport.tr(),
                name,
                _detailController.text.trim(),
              );
            },
            title: LocaleKeys.docsScreen_issueSubmit.tr(),
          ),
        ],
      ),
    );
  }
}
