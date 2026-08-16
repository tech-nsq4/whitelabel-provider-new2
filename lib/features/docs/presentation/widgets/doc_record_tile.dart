import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/document_record_model.dart';

(String label, AppStatusTone tone) _statusVisual(DocumentStatus status) => switch (status) {
      DocumentStatus.certified => (LocaleKeys.status_certified.tr(), AppStatusTone.positive),
      DocumentStatus.pendingIssue => (LocaleKeys.docsScreen_pendingIssue.tr(), AppStatusTone.warning),
      DocumentStatus.issued => (LocaleKeys.status_issued.tr(), AppStatusTone.positive),
    };

/// One row on "التقارير والإجازات".
class DocRecordTile extends StatelessWidget {
  const DocRecordTile({super.key, required this.doc, required this.onAction});

  final DocumentRecordModel doc;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = _statusVisual(doc.status);
    final needsIssue = doc.status == DocumentStatus.pendingIssue;

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(doc.title,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(
                      doc.extra.isEmpty ? doc.docNumber : '${doc.docNumber} · ${doc.extra}',
                      fontSize: 10.5,
                      color: AppColors.mutedColor.themeColor,
                    ),
                  ],
                ),
              ),
              AppStatusChip(label, tone: tone),
            ],
          ),
          11.height,
          CustomButton(
            onTap: onAction,
            title: needsIssue ? LocaleKeys.docsScreen_certifyAndSend.tr() : LocaleKeys.pfile_download.tr(),
            height: 40,
            radius: 12,
            color: needsIssue ? null : AppColors.surfaceColor.themeColor,
            textColor: needsIssue ? null : AppColors.textPrimaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
