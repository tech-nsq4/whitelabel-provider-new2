import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/test_request_model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.request, required this.onUpload});

  final TestRequestModel request;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              (request.resultUrl?.isNotEmpty ?? false)
                  ? _ResultThumbnail(url: request.resultUrl!)
                  : AppIconBox(
                      svgIcon: request.type == TestRequestType.xray
                          ? AppSvgIcons.xray
                          : AppSvgIcons.flask,
                    ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(request.patientName ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    if (request.scheduledLabel != null)
                      AppText(request.scheduledLabel!,
                          fontSize: 10.5,
                          color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              request.hasResult
                  ? _ResultChip(rate: request.resultRate)
                  : AppStatusChip(LocaleKeys.status_inProgress.tr(),
                      tone: AppStatusTone.warning),
            ],
          ),
          11.height,
          AppText(request.testName ?? '',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          if (request.doctorName != null) ...[
            4.height,
            AppText(
                '${LocaleKeys.orders_requestedBy.tr()} ${request.doctorName}',
                fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          ],
          if (request.hasResult && (request.note?.isNotEmpty ?? false)) ...[
            8.height,
            AppText(request.note!,
                fontSize: 11, color: AppColors.textSecondaryColor.themeColor),
          ],
          if (!request.hasResult) ...[
            11.height,
            CustomButton(
              onTap: onUpload,
              title: LocaleKeys.orders_upload.tr(),
              height: 40,
              radius: 12,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultThumbnail extends StatelessWidget {
  const _ResultThumbnail({required this.url});

  final String url;

  static const double _size = 42;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openBottomSheet(context, NetworkImage(url)),
      child: CustomImage(
        image: url,
        width: _size.r,
        height: _size.r,
        radius: _size * 0.31,
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  const _ResultChip({required this.rate});

  final ResultRate? rate;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (rate) {
      ResultRate.normal => (LocaleKeys.status_normal.tr(), AppStatusTone.positive),
      ResultRate.notNormal => (LocaleKeys.status_abnormal.tr(), AppStatusTone.critical),
      ResultRate.caution => (LocaleKeys.status_caution.tr(), AppStatusTone.warning),
      null => (LocaleKeys.status_normal.tr(), AppStatusTone.muted),
    };
    return AppStatusChip(label, tone: tone);
  }
}
