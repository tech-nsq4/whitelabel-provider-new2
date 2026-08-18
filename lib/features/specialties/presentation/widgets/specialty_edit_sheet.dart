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
import '../../data/models/specialty_model.dart';

const _kDoctors = ['د. خالد العتيبي', 'د. رهف الدسري', 'د. سارة المحطاني', 'د. وليد الشهري'];

/// The reference design's `#sh-spec` — add/edit a specialty with its name,
/// a short patient-facing description, and the doctors who cover it.
class SpecialtyEditSheet extends StatefulWidget {
  const SpecialtyEditSheet({super.key, required this.onSubmit, this.existing});

  final ValueChanged<SpecialtyModel> onSubmit;
  final SpecialtyModel? existing;

  @override
  State<SpecialtyEditSheet> createState() => _SpecialtyEditSheetState();
}

class _SpecialtyEditSheetState extends State<SpecialtyEditSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name);
  late final _descController = TextEditingController(text: widget.existing?.summary);
  late final Set<String> _selectedDoctors = {
    for (final d in _kDoctors)
      if (widget.existing?.summary.contains(d) ?? false) d,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context);
    widget.onSubmit(SpecialtyModel(
      id: widget.existing?.id ?? 'sp-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      summary: _selectedDoctors.isEmpty
          ? _descController.text.trim()
          : _selectedDoctors.join('، '),
      branches: widget.existing?.branches ?? const [],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

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
            AppText(
              (isEdit ? LocaleKeys.specialtySheet_titleEdit : LocaleKeys.specialtySheet_titleAdd).tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            16.height,
            _label(LocaleKeys.specialtySheet_nameLabel.tr()),
            8.height,
            CustomTextField(controller: _nameController, hint: LocaleKeys.specialtySheet_nameHint.tr()),
            14.height,
            _label(LocaleKeys.specialtySheet_descLabel.tr()),
            8.height,
            CustomTextField(
              controller: _descController,
              hint: LocaleKeys.specialtySheet_descHint.tr(),
              maxLines: 3,
            ),
            14.height,
            _label(LocaleKeys.specialtySheet_doctorsLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (final d in _kDoctors)
                  AppToggleChip(
                    label: d,
                    selected: _selectedDoctors.contains(d),
                    onTap: () => setState(
                      () => _selectedDoctors.contains(d)
                          ? _selectedDoctors.remove(d)
                          : _selectedDoctors.add(d),
                    ),
                  ),
              ],
            ),
            18.height,
            CustomButton(onTap: _submit, title: LocaleKeys.specialtySheet_save.tr()),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
