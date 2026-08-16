import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// One dot + label pair in the month grid's load-level legend.
class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        5.width,
        AppText(label, fontSize: 10, color: AppColors.mutedColor.themeColor),
      ],
    );
  }
}
