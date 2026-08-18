import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/service_model.dart';

/// One read-only row on the "الخدمات" directory.
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(svgIcon: AppSvgIcons.stethoscope),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(service.title,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (service.description != null) ...[
                  3.height,
                  AppText(service.description!,
                      fontSize: 11.5,
                      height: 1.5,
                      color: AppColors.mutedColor.themeColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
