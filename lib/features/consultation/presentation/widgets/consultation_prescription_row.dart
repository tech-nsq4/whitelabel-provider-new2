import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/prescription_entry_model.dart';

/// One editable medication line in the prescription list — keeps its own
/// text controllers so typing doesn't lose focus/cursor position on every
/// cubit rebuild.
class ConsultationPrescriptionRow extends StatefulWidget {
  const ConsultationPrescriptionRow({
    super.key,
    required this.entry,
    required this.onChanged,
    required this.onRemove,
  });

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
      margin: 8.paddingBottom,
      padding: const EdgeInsetsDirectional.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  hint: LocaleKeys.consultation_medicationNameHint.tr(),
                  onChanged: (v) => widget.onChanged(name: v),
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _doseController,
                        hint: LocaleKeys.consultation_medicationDoseHint.tr(),
                        onChanged: (v) => widget.onChanged(dose: v),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: CustomTextField(
                        controller: _durationController,
                        hint:
                            LocaleKeys.consultation_medicationDurationHint.tr(),
                        onChanged: (v) => widget.onChanged(duration: v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          8.width,
          InkWell(
            onTap: widget.onRemove,
            child: Icon(Icons.close_rounded,
                size: 20, color: AppColors.errorColor.themeColor),
          ),
        ],
      ),
    );
  }
}
