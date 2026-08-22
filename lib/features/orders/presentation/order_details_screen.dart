import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/booked_by_caption.dart';
import '../../../core/widgets/image/custom_image.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../data/models/test_request_model.dart';
import 'widgets/order_id_badge.dart';

/// The full request-details view for one analysis/x-ray — opened from
/// the orders screen's card (with its own copy of the upload action for
/// a still-pending request) or, read-only, from a patient's file history.
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.request, this.onUpload});

  final TestRequestModel request;

  /// `null` when opened read-only (e.g. from a patient's file) — the
  /// "no result yet" card then shows without an upload button.
  final VoidCallback? onUpload;

  void _openBooking(BuildContext context) {
    final isFamilyBooking = request.bookedByName != null;
    Navigator.pushNamed(context, Routes.queueDetails, arguments: {
      'patient': QueuePatientModel(
        id: '${request.appointmentId}',
        name: request.patientName ?? '',
        initial: request.initial,
        appointmentTime: request.time,
        date: request.date,
        doctorName: request.doctorName,
        status: request.appointmentStatus,
        bookedByName: request.bookedByName,
        familyMemberName: isFamilyBooking ? request.patientName : null,
      ),
      'tabIndex': 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = request.resultUrl?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            Row(
              children: [
                AppHeaderIconButton(
                  svgIcon: AppSvgIcons.chevronBack,
                  onTap: () => Navigator.pop(context),
                ),
                12.width,
                Expanded(
                  child: AppText(LocaleKeys.orders_detailsTitle.tr(),
                      isHeading: true,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                ),
                OrderIdBadge(id: request.id),
              ],
            ),
            20.height,
            if (hasImage) ...[
              // A `Builder` here — not the screen's own `context` — so the
              // tap target sits *below* the `Scaffold` this method returns.
              // `showBottomSheet` needs `Scaffold.of(context)` to resolve to
              // an ancestor, and the outer `context` is above it, not below.
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => openBottomSheet(
                      context, NetworkImage(request.resultUrl!)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CustomImage(
                      image: request.resultUrl!,
                      height: 220.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              16.height,
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasImage)
                  AppIconBox(
                    svgIcon: request.type == TestRequestType.xray
                        ? AppSvgIcons.xray
                        : AppSvgIcons.flask,
                    size: 52,
                  ),
                if (!hasImage) 14.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookedByCaption(bookedByName: request.bookedByName),
                      AppText(request.patientName ?? '',
                          isHeading: true,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      if (request.scheduledLabel != null) ...[
                        2.height,
                        AppText(request.scheduledLabel!,
                            fontSize: 11.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ],
                  ),
                ),
                request.hasResult
                    ? _resultChip(request.resultRate)
                    : AppStatusChip(LocaleKeys.status_inProgress.tr(),
                        tone: AppStatusTone.warning),
              ],
            ),
            22.height,
            AppSectionTitle(LocaleKeys.orders_detailsTest.tr()),
            10.height,
            _sectionCard([
              _detailRow(
                icon: request.type == TestRequestType.xray
                    ? AppSvgIcons.xray
                    : AppSvgIcons.flask,
                label: LocaleKeys.orders_detailsTest.tr(),
                value: request.testName ?? '',
              ),
              _detailRow(
                icon: AppSvgIcons.document,
                label: LocaleKeys.orders_detailsType.tr(),
                value: request.type == TestRequestType.xray
                    ? LocaleKeys.orders_typeXray.tr()
                    : LocaleKeys.orders_typeAnalysis.tr(),
              ),
              if (request.testPrice != null)
                _detailRow(
                  icon: AppSvgIcons.wallet,
                  label: LocaleKeys.orders_detailsPrice.tr(),
                  value:
                      '${request.testPrice!.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                ),
              if (request.doctorName != null)
                _detailRow(
                  icon: AppSvgIcons.stethoscope,
                  label: LocaleKeys.orders_requestedBy.tr(),
                  value: request.doctorName!,
                ),
            ]),
            // if (request.appointmentId != null) ...[
            //   12.height,
            //   CustomButton(
            //     onTap: () => _openBooking(context),
            //     isOutlined: true,
            //     title: LocaleKeys.orders_detailsViewBooking.tr(),
            //   ),
            // ],
            22.height,
            AppSectionTitle(LocaleKeys.orders_detailsResult.tr()),
            10.height,
            if (request.hasResult)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _resultChip(request.resultRate),
                    if (request.resultedAt != null) ...[
                      10.height,
                      _detailRow(
                        icon: AppSvgIcons.clock,
                        label: LocaleKeys.orders_detailsResultedAt.tr(),
                        value: ConvertHelper.formatDateTime(request.resultedAt!,
                            includeDate: true, includeTime: true),
                      ),
                    ],
                    10.height,
                    AppText(
                      (request.note?.isNotEmpty ?? false)
                          ? request.note!
                          : LocaleKeys.orders_detailsNoNote.tr(),
                      fontSize: 12.5,
                      color: (request.note?.isNotEmpty ?? false)
                          ? AppColors.textSecondaryColor.themeColor
                          : AppColors.mutedColor.themeColor,
                    ),
                  ],
                ),
              )
            else ...[
              AppCard(
                color: AppColors.surfaceColor.themeColor,
                borderColor: Colors.transparent,
                child: AppText(LocaleKeys.orders_detailsNoResultYet.tr(),
                    fontSize: 12, color: AppColors.mutedColor.themeColor),
              ),
              if (onUpload != null) ...[
                16.height,
                CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                    onUpload!();
                  },
                  title: LocaleKeys.orders_upload.tr(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultChip(ResultRate? rate) {
    final (label, tone) = switch (rate) {
      ResultRate.normal => (LocaleKeys.status_normal.tr(), AppStatusTone.positive),
      ResultRate.notNormal => (LocaleKeys.status_abnormal.tr(), AppStatusTone.critical),
      ResultRate.caution => (LocaleKeys.status_caution.tr(), AppStatusTone.warning),
      null => (LocaleKeys.status_normal.tr(), AppStatusTone.muted),
    };
    return AppStatusChip(label, tone: tone);
  }

  Widget _sectionCard(List<Widget> rows) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) 14.height,
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _detailRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBox(svgIcon: icon, size: 34),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(label, fontSize: 9.5, color: AppColors.mutedColor.themeColor),
              AppText(value,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
            ],
          ),
        ),
      ],
    );
  }
}
