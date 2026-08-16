import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

/// One of the analytics screen's four headline stat tiles.
class AnalyticsStatTile extends StatelessWidget {
  const AnalyticsStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    this.valueColor,
    this.subColor,
  });

  final String label;
  final String value;
  final String sub;
  final Color? valueColor;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, fontSize: 10, color: AppColors.mutedColor.themeColor),
          4.height,
          AppText(value,
              isHeading: true,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimaryColor.themeColor),
          3.height,
          AppText(sub,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: subColor ?? AppColors.mutedColor.themeColor,
              maxLines: 1),
        ],
      ),
    );
  }
}
