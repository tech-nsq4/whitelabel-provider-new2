import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/location_model.dart';

/// One row on the "الفروع" screen — taps into that location's clinics.
class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, required this.onTap});

  final LocationModel location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final area = [
      if (location.cityName != null) location.cityName!,
      if (location.areaName != null) location.areaName!,
    ].join(' · ');

    return AppCard(
      margin: 10.paddingBottom,
      onTap: onTap,
      child: Row(
        children: [
          AppIconBox(svgIcon: AppSvgIcons.home2),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(location.name,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (area.isNotEmpty) ...[
                  2.height,
                  AppText(area,
                      fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ],
            ),
          ),
          AppSvgIcon(AppSvgIcons.chevronRow,
              size: 16.sp, color: AppColors.mutedColor.themeColor),
        ],
      ),
    );
  }
}
