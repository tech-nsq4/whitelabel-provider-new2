import 'package:flutter/material.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_card.dart';
import 'app_icon_box.dart';
import 'app_text.dart';
import 'app_text_field.dart';

/// One toggle-able service/appointment mode row inside the add/edit
/// service and doctor-pricing sheets — the reference design's `.smode`
/// card: icon + label on top, a switch to enable the mode, and a
/// price/duration pair that only shows once enabled.
class PricingModeCard extends StatelessWidget {
  const PricingModeCard({
    super.key,
    required this.svgIcon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onToggle,
    required this.priceController,
    required this.durationController,
    this.priceLabel = 'السعر',
    this.durationLabel = 'المدة (دقيقة)',
    this.extra,
  });

  final String svgIcon;
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final TextEditingController priceController;
  final TextEditingController durationController;
  final String priceLabel;
  final String durationLabel;

  /// Extra content shown under the price/duration row while enabled — e.g.
  /// the "online session mode" sub-chips in the service sheet.
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: enabled ? AppColors.surfaceColor.themeColor : AppColors.cardColor.themeColor,
      borderColor: enabled ? Colors.transparent : AppColors.dividerColor.themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: svgIcon),
              11.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(title,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText(subtitle, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              Switch(
                  value: enabled, onChanged: onToggle, activeThumbColor: AppColors.primaryColor.themeColor),
            ],
          ),
          if (enabled) ...[
            12.height,
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: priceController,
                    hint: priceLabel,
                    label: priceLabel,
                    keyboardType: TextInputType.number,
                  ),
                ),
                10.width,
                Expanded(
                  child: CustomTextField(
                    controller: durationController,
                    hint: durationLabel,
                    label: durationLabel,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            if (extra != null) ...[8.height, extra!],
          ],
        ],
      ),
    );
  }
}
