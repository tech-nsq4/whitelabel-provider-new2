import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../orders/data/models/test_request_model.dart';

/// One analysis/x-ray row in the patient file's "النتائج"/"الأشعة" tabs.
/// Tappable only once it has a result — opens the same read-only details
/// view the orders screen uses, image and all.
class PatientTestHistoryRow extends StatelessWidget {
  const PatientTestHistoryRow({super.key, required this.request, this.onTap});

  final TestRequestModel request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (request.doctorName != null) request.doctorName!,
      if (request.scheduledLabel != null) request.scheduledLabel!,
    ].join(' · ');

    final (statusLabel, tone) = request.hasResult
        ? switch (request.resultRate) {
            ResultRate.normal => (LocaleKeys.status_normal.tr(), AppStatusTone.positive),
            ResultRate.notNormal => (LocaleKeys.status_abnormal.tr(), AppStatusTone.critical),
            ResultRate.caution => (LocaleKeys.status_caution.tr(), AppStatusTone.warning),
            null => (LocaleKeys.status_normal.tr(), AppStatusTone.muted),
          }
        : (LocaleKeys.status_inProgress.tr(), AppStatusTone.warning);

    final row = Padding(
      padding: 9.paddingVert,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(
            svgIcon: request.type == TestRequestType.xray
                ? AppSvgIcons.xray
                : AppSvgIcons.flask,
            size: 36,
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(request.testName ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (subtitle.isNotEmpty)
                  AppText(subtitle, fontSize: 10, color: AppColors.mutedColor.themeColor),
              ],
            ),
          ),
          AppStatusChip(statusLabel, tone: tone),
        ],
      ),
    );

    return onTap == null ? row : CustomTapEffect(onTap: onTap!, child: row);
  }
}
