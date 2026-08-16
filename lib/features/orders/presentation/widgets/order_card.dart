import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/lab_order_model.dart';

/// One lab/imaging request card on the orders screen — matches the
/// reference design's `.ord` card.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onAction});

  final LabOrderModel order;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final isNew = order.status == LabOrderStatus.newOrder;

    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(order.patientInitial, size: 34),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(order.patientName,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText('${order.mrn} · ${order.requestedAtLabel}',
                        fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              AppStatusChip(
                isNew ? LocaleKeys.status_newOrder.tr() : LocaleKeys.status_inProgress.tr(),
                tone: isNew ? AppStatusTone.critical : AppStatusTone.warning,
              ),
            ],
          ),
          11.height,
          AppText(order.testName,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          4.height,
          AppText('${LocaleKeys.orders_requestedBy.tr()} ${order.requestingDoctor}',
              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          11.height,
          CustomButton(
            onTap: onAction,
            title: isNew ? LocaleKeys.orders_start.tr() : LocaleKeys.orders_upload.tr(),
            height: 40,
            radius: 12,
          ),
        ],
      ),
    );
  }
}
