import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/queue_patient_model.dart';

class BookingDiscountCard extends StatelessWidget {
  const BookingDiscountCard({super.key, required this.patient});

  final QueuePatientModel patient;

  String _price(num value) => value == value.roundToDouble()
      ? '${value.toInt()} ${LocaleKeys.common_currency.tr()}'
      : '$value ${LocaleKeys.common_currency.tr()}';

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    final gold = AppColors.accentGold.themeColor;
    final percent = patient.discountPercent;
    final original = patient.originalPrice;
    final discount = patient.discountAmount;
    final total = patient.finalPrice;

    final sourceLabel = patient.isPromoDiscount
        ? LocaleKeys.queue_detailsDiscountPromo.tr()
        : LocaleKeys.queue_detailsDiscountOffer.tr();
    final promoCode = patient.promoCode ?? '';
    final subtitle = patient.isPromoDiscount && promoCode.isNotEmpty
        ? '$sourceLabel · $promoCode'
        : sourceLabel;

    final badgeText = percent != null
        ? '−$percent%'
        : discount != null
            ? LocaleKeys.queue_detailsDiscountSavedBadge
                .tr(namedArgs: {'amount': _price(discount)})
            : null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBox(
                svgIcon: AppSvgIcons.tag,
                iconColor: success,
                background: success.withValues(alpha: 0.12),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(LocaleKeys.queue_detailsDiscountTitle.tr(),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(subtitle,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                8.width,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: AppText(badgeText,
                      isHeading: true,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: success),
                ),
              ],
            ],
          ),
          14.height,
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                if (original != null)
                  _row(
                    LocaleKeys.queue_detailsDiscountOriginal.tr(),
                    _price(original),
                    strike: true,
                  ),
                if (discount != null) ...[
                  6.height,
                  _row(
                    LocaleKeys.queue_detailsDiscountValue.tr(),
                    '− ${_price(discount)}',
                    valueColor: success,
                  ),
                ],
                if (total != null) ...[
                  10.height,
                  Divider(height: 1, color: AppColors.dividerColor.themeColor),
                  10.height,
                  _row(
                    LocaleKeys.queue_detailsDiscountTotal.tr(),
                    _price(total),
                    valueColor: gold,
                    emphasize: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool strike = false,
    Color? valueColor,
    bool emphasize = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontSize: emphasize ? 12.5 : 11.5,
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          color: emphasize
              ? AppColors.textPrimaryColor.themeColor
              : AppColors.mutedColor.themeColor,
        ),
        AppText(
          value,
          isHeading: true,
          fontSize: emphasize ? 13.5 : 11.5,
          fontWeight: FontWeight.w700,
          decoration: strike ? TextDecoration.lineThrough : null,
          color: valueColor ?? AppColors.textPrimaryColor.themeColor,
        ),
      ],
    );
  }
}
