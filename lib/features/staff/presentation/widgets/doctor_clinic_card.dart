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
import '../../data/models/doctor_profile_model.dart';

/// One clinic the doctor works at — its name, street address and the
/// area/city resolved from the clinic's location, with a button that
/// opens driving directions to it in the maps app.
class DoctorClinicCard extends StatelessWidget {
  const DoctorClinicCard({super.key, required this.clinic});

  final DoctorClinic clinic;

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
    final location = clinic.location;
    final locationLine = location == null
        ? ''
        : [location.name, location.areaCityLabel]
            .where((s) => s.isNotEmpty)
            .join(' · ');
    final lines = [
      if (clinic.address != null && clinic.address!.isNotEmpty) clinic.address!,
      if (locationLine.isNotEmpty) locationLine,
    ];

    return AppCard(
      margin: 8.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconBox(svgIcon: AppSvgIcons.mapPin, size: 34),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(clinic.name,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    for (final line in lines) ...[
                      3.height,
                      AppText(line,
                          fontSize: 11,
                          height: 1.5,
                          color: AppColors.textSecondaryColor.themeColor),
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
