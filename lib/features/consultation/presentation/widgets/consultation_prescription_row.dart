import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/prescription_entry_model.dart';

/// One editable medication line in the prescription list — keeps its own
/// text controllers so typing doesn't lose focus/cursor position on every
/// cubit rebuild.
class ConsultationPrescriptionRow extends StatefulWidget {
  const ConsultationPrescriptionRow({
    super.key,
    required this.index,
    required this.entry,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final PrescriptionEntryModel entry;
  final void Function({String? name, String? dose, String? duration}) onChanged;
  final VoidCallback onRemove;

  @override
  State<ConsultationPrescriptionRow> createState() =>
      _ConsultationPrescriptionRowState();
}

class _ConsultationPrescriptionRowState
    extends State<ConsultationPrescriptionRow> {
  late final _nameController = TextEditingController(text: widget.entry.name);
  late final _doseController = TextEditingController(text: widget.entry.dose);
  late final _durationController =
      TextEditingController(text: widget.entry.duration);

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 10.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  '${LocaleKeys.consultation_addMedication.tr()} ${widget.index + 1}',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedColor.themeColor,
                ),
              ),
              CustomTapEffect(
                onTap: widget.onRemove,
                child: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: AppColors.criticalBgColor.themeColor,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 15.sp, color: AppColors.errorColor.themeColor),
                ),
              ),
            ],
          ),
          10.height,
          CustomTextField(
            controller: _nameController,
            hint: '',
            label: LocaleKeys.consultation_medicationNameLabel.tr(),
            onChanged: (v) => widget.onChanged(name: v),
          ),
          8.height,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _doseController,
                  hint: '',
                  label: LocaleKeys.consultation_medicationDoseLabel.tr(),
                  onChanged: (v) => widget.onChanged(dose: v),
                ),
              ),
              8.width,
              Expanded(
                child: CustomTextField(
                  controller: _durationController,
                  hint: '',
                  label: LocaleKeys.consultation_medicationDurationLabel.tr(),
                  onChanged: (v) => widget.onChanged(duration: v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
