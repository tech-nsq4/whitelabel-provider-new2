import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/booking_model.dart';

/// One booking row — matches the reference design's `.bkc` card, with an
/// extra "أرسل رابط الدفع" action while payment is still pending.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onSendPaymentLink});

  final BookingModel booking;
  final VoidCallback onSendPaymentLink;

  @override
  Widget build(BuildContext context) {
    final pending = booking.status == BookingStatus.pendingPayment;
    final (label, tone) = switch (booking.status) {
      BookingStatus.paid => (LocaleKeys.status_paid.tr(), AppStatusTone.positive),
      BookingStatus.confirmed => (LocaleKeys.status_confirmed.tr(), AppStatusTone.positive),
      BookingStatus.pendingPayment => (
          LocaleKeys.status_pendingPayment.tr(),
          AppStatusTone.warning,
        ),
    };

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: booking.isVideo ? AppSvgIcons.videoCam : AppSvgIcons.calendar),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(booking.patientName,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText(
                      '${booking.serviceLabel} · ${booking.subLabel} · ${booking.price} ${LocaleKeys.common_currency.tr()}',
                      fontSize: 10.5,
                      color: AppColors.mutedColor.themeColor,
                    ),
                  ],
                ),
              ),
              AppStatusChip(label, tone: tone),
            ],
          ),
          if (pending) ...[
            11.height,
            CustomButton(
              onTap: onSendPaymentLink,
              title: LocaleKeys.bookings_sendPaymentLink.tr(),
              height: 40,
              radius: 12,
            ),
          ],
        ],
      ),
    );
  }
}
