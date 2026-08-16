import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/patient_visit_item_model.dart';

String _iconFor(PatientVisitItemKind kind) => switch (kind) {
      PatientVisitItemKind.prescription => AppSvgIcons.pill,
      PatientVisitItemKind.labTest => AppSvgIcons.flask,
      PatientVisitItemKind.imaging => AppSvgIcons.xray,
      PatientVisitItemKind.document => AppSvgIcons.document,
    };

(String label, AppStatusTone tone) _statusFor(PatientItemStatus status) => switch (status) {
      PatientItemStatus.active => (LocaleKeys.status_active.tr(), AppStatusTone.positive),
      PatientItemStatus.expired => (LocaleKeys.status_expired.tr(), AppStatusTone.muted),
      PatientItemStatus.inProgress => (LocaleKeys.status_inProgress.tr(), AppStatusTone.warning),
      PatientItemStatus.normal => (LocaleKeys.status_normal.tr(), AppStatusTone.positive),
      PatientItemStatus.low => (LocaleKeys.status_low.tr(), AppStatusTone.warning),
      PatientItemStatus.issued => (LocaleKeys.status_issued.tr(), AppStatusTone.positive),
      PatientItemStatus.certified => (LocaleKeys.status_certified.tr(), AppStatusTone.positive),
    };

/// One prescription/order/document row — used both inside an expanded
/// visit card and (with [visitCode] set) in the flattened
/// results/medications/documents tabs.
class PatientVisitItemRow extends StatelessWidget {
  const PatientVisitItemRow({super.key, required this.item, this.visitCode});

  final PatientVisitItemModel item;

  /// When set, shows a "ضمن زيارة V-xxxx" footer under the row.
  final String? visitCode;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, tone) = _statusFor(item.status);

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBox(svgIcon: _iconFor(item.kind), size: 36),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(item.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
              AppText(item.subtitle, fontSize: 10, color: AppColors.mutedColor.themeColor),
            ],
          ),
        ),
        AppStatusChip(statusLabel, tone: tone),
      ],
    );

    if (visitCode == null) return Padding(padding: 9.paddingVert, child: row);

    return Padding(
      padding: 9.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row,
          6.height,
          Padding(
            padding: EdgeInsetsDirectional.only(start: 46.w),
            child: AppText(
              '${LocaleKeys.pfile_linkedToVisit.tr()} $visitCode',
              fontSize: 10,
              color: AppColors.hintColor.themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
