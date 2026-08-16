import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/invoice_model.dart';

(String label, AppStatusTone tone) _statusVisual(InvoiceStatus status) => switch (status) {
      InvoiceStatus.paidOnline => (LocaleKeys.billing_paidOnline.tr(), AppStatusTone.positive),
      InvoiceStatus.pendingCollection => (
          LocaleKeys.billing_pendingCollection.tr(),
          AppStatusTone.warning,
        ),
      InvoiceStatus.insurance => (LocaleKeys.billing_insurance.tr(), AppStatusTone.muted),
    };

/// One row on the billing screen.
class InvoiceTile extends StatelessWidget {
  const InvoiceTile({super.key, required this.invoice, required this.onSendPaymentLink});

  final InvoiceModel invoice;
  final VoidCallback onSendPaymentLink;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = _statusVisual(invoice.status);
    final pending = invoice.status == InvoiceStatus.pendingCollection;

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
                    AppText(invoice.patientName,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText('${invoice.invoiceNumber} · ${invoice.serviceLabel}',
                        fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText('${invoice.price}',
                      isHeading: true,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  4.height,
                  AppStatusChip(label, tone: tone),
                ],
              ),
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
