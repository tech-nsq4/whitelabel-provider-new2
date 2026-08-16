import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_history_model.dart';
import 'consultation_medication_row.dart';
import 'consultation_result_tile.dart';
import 'consultation_vitals_grid.dart';

/// The consultation screen's "السجل" tab — vitals, last visit summary,
/// recent results and active medications, all read-only.
class ConsultationHistoryTab extends StatelessWidget {
  const ConsultationHistoryTab({super.key, required this.history});

  final PatientHistoryModel history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(LocaleKeys.consultation_vitalsTitle.tr()),
        10.height,
        ConsultationVitalsGrid(vitals: history.vitals),
        20.height,
        AppSectionTitle(
          '${LocaleKeys.consultation_lastVisitTitle.tr()} — ${history.lastVisitLabel}',
        ),
        10.height,
        AppCard(child: AppText(history.lastVisitSummary, fontSize: 12.5)),
        20.height,
        AppSectionTitle(LocaleKeys.consultation_recentResultsTitle.tr()),
        10.height,
        for (final result in history.recentResults)
          ConsultationResultTile(result: result),
        10.height,
        AppSectionTitle(LocaleKeys.consultation_activeMedicationsTitle.tr()),
        10.height,
        AppCard(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (var i = 0; i < history.activeMedications.length; i++)
                ConsultationMedicationRow(
                    medication: history.activeMedications[i]),
            ],
          ),
        ),
      ],
    );
  }
}
