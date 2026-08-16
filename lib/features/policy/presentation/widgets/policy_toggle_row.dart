import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';

/// One on/off row inside a "سياسة الحجز" settings card.
class PolicyToggleRow extends StatelessWidget {
  const PolicyToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.paddingVert,
      decoration: showDivider
          ? BoxDecoration(
              border: BorderDirectional(bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
            )
          : null,
      child: Row(
        children: [
          AppIconBox(svgIcon: AppSvgIcons.clock),
          13.width,
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
              value: value, onChanged: onChanged, activeThumbColor: AppColors.primaryColor.themeColor),
        ],
      ),
    );
  }
}
