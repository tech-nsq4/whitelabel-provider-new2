import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
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
  const ConsultationHistoryTab({
    super.key,
    required this.history,
    required this.onEditVitals,
  });

  final PatientHistoryModel history;
  final VoidCallback onEditVitals;

  @override
  Widget build(BuildContext context) {
    final vitals = history.vitals;
    final hasOtherHistory = history.lastVisitSummary.isNotEmpty ||
        history.recentResults.isNotEmpty ||
        history.activeMedications.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          LocaleKeys.consultation_vitalsTitle.tr(),
          actionLabel: vitals != null ? LocaleKeys.consultation_vitalSignsEdit.tr() : null,
          onAction: vitals != null ? onEditVitals : null,
        ),
        10.height,
        if (vitals == null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.consultation_vitalSignsEmpty.tr(),
                    fontSize: 11.5, height: 1.6, color: AppColors.mutedColor.themeColor),
                12.height,
                CustomButton(
                  onTap: onEditVitals,
                  title: LocaleKeys.consultation_vitalSignsAdd.tr(),
                  isOutlined: true,
                  height: 40,
                  radius: 12,
                  fontSize: 12.5,
                ),
              ],
            ),
          )
        else ...[
          ConsultationVitalsGrid(vitals: vitals),
          if (vitals.updatedAt != null) ...[
            6.height,
            AppText(
              '${LocaleKeys.consultation_vitalUpdatedAt.tr()}: '
              '${ConvertHelper.formatDateTime(vitals.updatedAt!, includeDate: true, includeTime: true)}',
              fontSize: 9.5,
              color: AppColors.mutedColor.themeColor,
            ),
          ],
        ],
        if (history.lastVisitSummary.isNotEmpty) ...[
          20.height,
          AppSectionTitle(
            history.lastVisitDate != null
                ? '${LocaleKeys.consultation_lastVisitTitle.tr()} — '
                    '${ConvertHelper.formatDateTime(history.lastVisitDate!, includeDate: true)}'
                : LocaleKeys.consultation_lastVisitTitle.tr(),
          ),
          10.height,
          AppCard(child: AppText(history.lastVisitSummary, fontSize: 12.5)),
        ],
        if (history.recentResults.isNotEmpty) ...[
          20.height,
          AppSectionTitle(LocaleKeys.consultation_recentResultsTitle.tr()),
          10.height,
          for (final result in history.recentResults)
            ConsultationResultTile(result: result),
        ],
        if (history.activeMedications.isNotEmpty) ...[
          10.height,
          AppSectionTitle(LocaleKeys.consultation_activeMedicationsTitle.tr()),
          10.height,
          AppCard(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (var i = 0; i < history.activeMedications.length; i++)
                  ConsultationMedicationRow(medication: history.activeMedications[i]),
              ],
            ),
          ),
        ],
        if (!hasOtherHistory) ...[
          14.height,
          AppText(LocaleKeys.consultation_historyEmpty.tr(),
              fontSize: 11.5, color: AppColors.mutedColor.themeColor),
        ],
      ],
    );
  }
}
