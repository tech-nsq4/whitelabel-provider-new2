import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_initials_avatar.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/doctor_profile_model.dart';

/// The doctors directory's read-only details screen — everything
/// `GET /doctors/{id}` returns for one doctor.
class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            Row(
              children: [
                AppHeaderIconButton(
                  svgIcon: AppSvgIcons.chevronBack,
                  onTap: () => Navigator.pop(context),
                ),
                12.width,
                AppText(LocaleKeys.staff_detailsTitle.tr(),
                    isHeading: true,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
              ],
            ),
            20.height,
            Row(
              children: [
                AppInitialsAvatar(doctor.initial, filled: true, size: 52),
                14.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(doctor.name,
                          isHeading: true,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      if (doctor.description != null) ...[
                        2.height,
                        AppText(doctor.description!,
                            fontSize: 11.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (doctor.specializations.isNotEmpty) ...[
              18.height,
              AppSectionTitle(LocaleKeys.staff_detailsSpecializations.tr()),
              10.height,
              Wrap(
                spacing: 7.w,
                runSpacing: 7.h,
                children: [
                  for (final title in doctor.specializations)
                    AppStatusChip(title, tone: AppStatusTone.positive),
                ],
              ),
            ],
            22.height,
            AppSectionTitle(LocaleKeys.staff_detailsInfo.tr()),
            10.height,
            _sectionCard([
              if (doctor.experience != null)
                _detailRow(
                  icon: AppSvgIcons.star,
                  label: LocaleKeys.queue_detailsExperience.tr(),
                  value: LocaleKeys.queue_detailsExperienceValue
                      .tr(namedArgs: {'years': '${doctor.experience}'}),
                ),
              if (doctor.price != null)
                _detailRow(
                  icon: AppSvgIcons.wallet,
                  label: LocaleKeys.queue_detailsFee.tr(),
                  value: '${doctor.price} ${LocaleKeys.common_currency.tr()}',
                ),
            ]),
            if (doctor.clinicName != null) ...[
              18.height,
              AppSectionTitle(LocaleKeys.queue_detailsClinic.tr()),
              10.height,
              _sectionCard([
                _detailRow(
                  icon: AppSvgIcons.mapPin,
                  label: LocaleKeys.queue_detailsClinic.tr(),
                  value: [
                    doctor.clinicName,
                    doctor.clinicAddress,
                    if (doctor.clinicArea != null || doctor.clinicCity != null)
                      [doctor.clinicArea, doctor.clinicCity]
                          .whereType<String>()
                          .join('، '),
                  ].whereType<String>().join(' · '),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(List<Widget> rows) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) 14.height,
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _detailRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBox(svgIcon: icon, size: 34),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(label, fontSize: 9.5, color: AppColors.mutedColor.themeColor),
              AppText(value,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
            ],
          ),
        ),
      ],
    );
  }
}
