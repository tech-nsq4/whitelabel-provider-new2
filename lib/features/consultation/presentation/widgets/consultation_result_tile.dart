import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/lab_result_model.dart';

/// One row in the consultation history's "نتائج حديثة" list.
class ConsultationResultTile extends StatelessWidget {
  const ConsultationResultTile({super.key, required this.result});

  final LabResultModel result;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (result.flag) {
      LabResultFlag.normal => (
          LocaleKeys.status_normal.tr(),
          AppStatusTone.positive
        ),
      LabResultFlag.low => (LocaleKeys.status_low.tr(), AppStatusTone.warning),
      LabResultFlag.critical => (
          LocaleKeys.status_critical.tr(),
          AppStatusTone.critical
        ),
      LabResultFlag.inProgress => (
          LocaleKeys.status_inProgress.tr(),
          AppStatusTone.warning
        ),
    };

    return AppCard(
      margin: 9.paddingBottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText(
              result.value.isEmpty
                  ? result.name
                  : '${result.name} — ${result.value}',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
            ),
          ),
          AppStatusChip(label, tone: tone),
        ],
      ),
    );
  }
}
