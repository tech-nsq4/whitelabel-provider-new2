import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/vital_signs_model.dart';

/// Add/edit form for a patient's vital signs — prefilled with [initial]
/// when editing an existing reading, blank otherwise.
class VitalSignsSheet extends StatefulWidget {
  const VitalSignsSheet({super.key, this.initial, required this.onSubmit});

  final VitalSignsModel? initial;
  final Future<bool> Function({
    required String bloodPressure,
    required int pulse,
    required double temperature,
    required int oxygen,
  }) onSubmit;

  @override
  State<VitalSignsSheet> createState() => _VitalSignsSheetState();
}

class _VitalSignsSheetState extends State<VitalSignsSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _bpController =
      TextEditingController(text: widget.initial?.bloodPressure);
  late final _pulseController =
      TextEditingController(text: widget.initial?.pulse.toString());
  late final _tempController =
      TextEditingController(text: widget.initial?.temperature.toString());
  late final _oxygenController =
      TextEditingController(text: widget.initial?.oxygen.toString());
  bool _submitting = false;

  @override
  void dispose() {
    _bpController.dispose();
    _pulseController.dispose();
    _tempController.dispose();
    _oxygenController.dispose();
    super.dispose();
  }

  String? _validateBp(String? value) {
    if (!RegExp(r'^\d{2,3}/\d{2,3}$').hasMatch(value?.trim() ?? '')) {
      return LocaleKeys.consultation_vitalBpError.tr();
    }
    return null;
  }

  String? _validatePulse(String? value) {
    final n = int.tryParse(value?.trim() ?? '');
    if (n == null || n < 20 || n > 300) return LocaleKeys.consultation_vitalPulseError.tr();
    return null;
  }

  String? _validateTemperature(String? value) {
    final n = double.tryParse(value?.trim() ?? '');
    if (n == null || n < 30 || n > 45) return LocaleKeys.consultation_vitalTempError.tr();
    return null;
  }

  String? _validateOxygen(String? value) {
    final n = int.tryParse(value?.trim() ?? '');
    if (n == null || n < 50 || n > 100) return LocaleKeys.consultation_vitalOxygenError.tr();
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final success = await widget.onSubmit(
      bloodPressure: _bpController.text.trim(),
      pulse: int.parse(_pulseController.text.trim()),
      temperature: double.parse(_tempController.text.trim()),
      oxygen: int.parse(_oxygenController.text.trim()),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20.w, 14.h, 20.w, 26.h + MediaQuery.viewInsetsOf(context).bottom),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                isEdit
                    ? LocaleKeys.consultation_vitalSheetTitleEdit.tr()
                    : LocaleKeys.consultation_vitalSheetTitleAdd.tr(),
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              18.height,
              _field(
                label: LocaleKeys.consultation_vitalPressure.tr(),
                description: LocaleKeys.consultation_vitalBpDesc.tr(),
                hint: LocaleKeys.consultation_vitalBpHint.tr(),
                controller: _bpController,
                validator: _validateBp,
              ),
              14.height,
              _field(
                label: LocaleKeys.consultation_vitalPulse.tr(),
                description: LocaleKeys.consultation_vitalPulseDesc.tr(),
                hint: LocaleKeys.consultation_vitalPulseHint.tr(),
                controller: _pulseController,
                validator: _validatePulse,
                keyboardType: TextInputType.number,
              ),
              14.height,
              _field(
                label: LocaleKeys.consultation_vitalTemp.tr(),
                description: LocaleKeys.consultation_vitalTempDesc.tr(),
                hint: LocaleKeys.consultation_vitalTempHint.tr(),
                controller: _tempController,
                validator: _validateTemperature,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              14.height,
              _field(
                label: LocaleKeys.consultation_vitalO2.tr(),
                description: LocaleKeys.consultation_vitalOxygenDesc.tr(),
                hint: LocaleKeys.consultation_vitalOxygenHint.tr(),
                controller: _oxygenController,
                validator: _validateOxygen,
                keyboardType: TextInputType.number,
              ),
              18.height,
              CustomButton(
                onTap: _submit,
                title: LocaleKeys.consultation_vitalSubmit.tr(),
                loading: _submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String description,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label,
            fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
        4.height,
        AppText(description,
            fontSize: 10, height: 1.5, color: AppColors.textSecondaryColor.themeColor),
        8.height,
        CustomTextField(
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
