import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/service_model.dart';

/// One row on the "الخدمات" screen — name, per-mode price strip, and an
/// on/off switch that dims the whole card when disabled.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceModel service;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: service.enabled ? 1 : 0.55,
      child: AppCard(
        margin: 10.paddingBottom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AppIconBox(svgIcon: AppSvgIcons.stethoscope),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(service.name,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      2.height,
                      AppText(service.specialty, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                Switch(
                  value: service.enabled,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: AppColors.primaryColor.themeColor,
                ),
              ],
            ),
            11.height,
            Row(
              children: [
                for (final price in service.prices) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor.themeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          AppText('${price.price}',
                              isHeading: true,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor.themeColor),
                          AppText('${price.modeLabel} · ${price.durationMinutes}${LocaleKeys.servicesScreen_minuteUnit.tr()}',
                              fontSize: 8.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                  ),
                  if (price != service.prices.last) 6.width,
                ],
              ],
            ),
            11.height,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: onEdit,
                    title: LocaleKeys.common_edit.tr(),
                    height: 36,
                    radius: 11,
                    fontSize: 12,
                    color: AppColors.surfaceColor.themeColor,
                    textColor: AppColors.textPrimaryColor.themeColor,
                  ),
                ),
                8.width,
                Expanded(
                  child: CustomButton(
                    onTap: onDelete,
                    title: LocaleKeys.common_delete.tr(),
                    height: 36,
                    radius: 11,
                    fontSize: 12,
                    isOutlined: true,
                    borderColor: AppColors.dividerColor.themeColor,
                    textColor: AppColors.textSecondaryColor.themeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
