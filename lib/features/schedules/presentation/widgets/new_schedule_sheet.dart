import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../data/models/work_schedule_model.dart';

class _NamedDoctor {
  const _NamedDoctor(this.name, this.initial);
  final String name;
  final String initial;
}

const _kBranches = ['العليا', 'المرجس', 'الياسمين'];
const _kDoctors = [
  _NamedDoctor('د. خالد العتيبي', 'خ'),
  _NamedDoctor('د. رهف الدسري', 'ر'),
  _NamedDoctor('د. سارة المحطاني', 'س'),
  _NamedDoctor('د. وليد الشهري', 'و'),
];

/// The reference design's `#sh-newsch` — a 3-step picker (branch → doctor →
/// schedule type) that leads into the full-screen `#schedule` editor.
class NewScheduleSheet extends StatefulWidget {
  const NewScheduleSheet({super.key, required this.onNext});

  final void Function(String doctorName, String doctorInitial, WorkScheduleMode mode) onNext;

  @override
  State<NewScheduleSheet> createState() => _NewScheduleSheetState();
}

class _NewScheduleSheetState extends State<NewScheduleSheet> {
  int _branchIndex = 0;
  int _doctorIndex = 0;
  WorkScheduleMode _mode = WorkScheduleMode.clinic;

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
            AppText(LocaleKeys.newScheduleSheet_title.tr(),
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            16.height,
            _label(LocaleKeys.newScheduleSheet_branchLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (var i = 0; i < _kBranches.length; i++)
                  AppToggleChip(
                    label: _kBranches[i],
                    selected: _branchIndex == i,
                    onTap: () => setState(() => _branchIndex = i),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.newScheduleSheet_doctorLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (var i = 0; i < _kDoctors.length; i++)
                  AppToggleChip(
                    label: _kDoctors[i].name,
                    selected: _doctorIndex == i,
                    onTap: () => setState(() => _doctorIndex = i),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.newScheduleSheet_typeLabel.tr()),
            8.height,
            Row(
              children: [
                Expanded(
                  child: AppToggleChip(
                    label: LocaleKeys.newScheduleSheet_typeClinic.tr(),
                    selected: _mode == WorkScheduleMode.clinic,
                    onTap: () => setState(() => _mode = WorkScheduleMode.clinic),
                  ),
                ),
                8.width,
                Expanded(
                  child: AppToggleChip(
                    label: LocaleKeys.newScheduleSheet_typeOnline.tr(),
                    selected: _mode == WorkScheduleMode.online,
                    onTap: () => setState(() => _mode = WorkScheduleMode.online),
                  ),
                ),
                8.width,
                Expanded(
                  child: AppToggleChip(
                    label: LocaleKeys.newScheduleSheet_typeHome.tr(),
                    selected: _mode == WorkScheduleMode.home,
                    onTap: () => setState(() => _mode = WorkScheduleMode.home),
                  ),
                ),
              ],
            ),
            18.height,
            CustomButton(
              onTap: () {
                final doctor = _kDoctors[_doctorIndex];
                Navigator.pop(context);
                widget.onNext(doctor.name, doctor.initial, _mode);
              },
              title: LocaleKeys.newScheduleSheet_next.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
