import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_stat_tile.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/invoice_model.dart';
import '../logic/billing_cubit.dart';
import 'widgets/invoice_tile.dart';

/// "الفواتير" — today's revenue and every invoice, paid or pending.
class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late final _cubit = getIt<BillingCubit>()..loadInvoices();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<BillingCubit, BillingState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is BillingLoading || state is BillingInitial,
              error: state is BillingError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final invoices = (state as BillingSuccess).invoices;
                final paidOnline = invoices
                    .where((i) => i.status == InvoiceStatus.paidOnline)
                    .fold(0, (sum, i) => sum + i.price);
                final pending = invoices
                    .where((i) => i.status == InvoiceStatus.pendingCollection)
                    .fold(0, (sum, i) => sum + i.price);
                final totalRevenue = invoices.fold(0, (sum, i) => sum + i.price);

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.billing_title.tr(),
                      eyebrow: LocaleKeys.billing_subtitle
                          .tr(namedArgs: {'amount': '$totalRevenue'}),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        AppStatTile(value: '$paidOnline', label: LocaleKeys.billing_statPaidOnline.tr()),
                        AppStatTile(
                          value: '$pending',
                          label: LocaleKeys.billing_statPending.tr(),
                          valueColor: AppColors.warningColor.themeColor,
                        ),
                      ],
                    ),
                    16.height,
                    for (final invoice in invoices)
                      InvoiceTile(
                        invoice: invoice,
                        onSendPaymentLink: () => AppOverlay.showSuccess(
                          LocaleKeys.bookings_paymentLinkSent.tr(namedArgs: {'name': invoice.patientName}),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
