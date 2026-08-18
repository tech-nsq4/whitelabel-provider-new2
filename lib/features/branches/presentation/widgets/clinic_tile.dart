import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/clinic_model.dart';

/// One row on a location's "العيادات" screen.
class ClinicTile extends StatelessWidget {
  const ClinicTile({super.key, required this.clinic});

  final ClinicModel clinic;

  Future<void> _openDirections() async {
    if (clinic.lat == null || clinic.lng == null) return;
    try {
      await HelperMethods.openGoogleMaps(lat: clinic.lat!, lng: clinic.lng!);
    } catch (_) {
      AppOverlay.showError(LocaleKeys.branchesScreen_directionsToast.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: AppSvgIcons.mapPin),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(clinic.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    if (clinic.address != null) ...[
                      2.height,
                      AppText(clinic.address!,
                          fontSize: 10.5,
                          color: AppColors.mutedColor.themeColor),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (clinic.lat != null && clinic.lng != null) ...[
            11.height,
            CustomButton(
              onTap: _openDirections,
              title: LocaleKeys.branchesScreen_directions.tr(),
              height: 36,
              radius: 10,
              fontSize: 11.5,
              isOutlined: true,
              borderColor: AppColors.dividerColor.themeColor,
              textColor: AppColors.textSecondaryColor.themeColor,
            ),
          ],
        ],
      ),
    );
  }
}
