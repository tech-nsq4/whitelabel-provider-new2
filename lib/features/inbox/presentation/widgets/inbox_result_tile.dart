import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/pending_result_model.dart';

(String label, AppStatusTone tone, Color avatarBg, Color avatarFg) flagVisualFor(
    PendingResultFlag flag, BuildContext context) {
  return switch (flag) {
    PendingResultFlag.critical => (
        LocaleKeys.status_critical.tr(),
        AppStatusTone.critical,
        AppColors.criticalBgColor.themeColor,
        AppColors.errorColor.themeColor,
      ),
    PendingResultFlag.low => (
        LocaleKeys.status_low.tr(),
        AppStatusTone.warning,
        AppColors.warningBgColor.themeColor,
        AppColors.warningColor.themeColor,
      ),
    PendingResultFlag.normal => (
        LocaleKeys.status_normal.tr(),
        AppStatusTone.positive,
        AppColors.surfaceColor.themeColor,
        AppColors.primaryColor.themeColor,
      ),
  };
}

/// One row in "نتائج تنتظر مراجعتك".
class InboxResultTile extends StatelessWidget {
  const InboxResultTile({super.key, required this.result, required this.onTap});

  final PendingResultModel result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (label, tone, avatarBg, avatarFg) = flagVisualFor(result.flag, context);

    return AppCard(
      onTap: onTap,
      margin: 10.paddingBottom,
      borderColor: result.flag == PendingResultFlag.critical
          ? AppColors.errorColor.themeColor
          : null,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: avatarBg, borderRadius: BorderRadius.circular(11)),
            child: AppText(result.patientInitial,
                isHeading: true, fontSize: 13, fontWeight: FontWeight.w600, color: avatarFg),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(result.patientName,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                2.height,
                AppText('${result.testName} — ${result.value}',
                    fontSize: 10.5, color: AppColors.mutedColor.themeColor),
              ],
            ),
          ),
          AppStatusChip(label, tone: tone),
        ],
      ),
    );
  }
}
