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
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/doctor_profile_model.dart';
import 'widgets/doctor_avatar.dart';
import 'widgets/doctor_clinic_card.dart';
import 'widgets/doctor_rating_stars.dart';
import 'widgets/doctor_specialization_tile.dart';

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
            _doctorHeader(),
            ..._infoSection(),
            ..._specializationsSection(
              LocaleKeys.staff_detailsSpecializations.tr(),
              doctor.specializations,
            ),
            ..._specializationsSection(
              LocaleKeys.staff_detailsSubSpecializations.tr(),
              doctor.subSpecializations,
            ),
            ..._clinicsSection(),
            ..._locationSection(),
          ],
        ),
      ),
    );
  }

  Widget _doctorHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorAvatar(doctor, filled: true, size: 52),
        14.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(doctor.name,
                        isHeading: true,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                  ),
                  if (doctor.avgRate != null) ...[
                    8.width,
                    DoctorRatingStars(rating: doctor.avgRate!, size: 12),
                  ],
                ],
              ),
              if (doctor.description != null &&
                  doctor.description!.isNotEmpty) ...[
                4.height,
                AppText(doctor.description!,
                    fontSize: 12,
                    height: 1.6,
                    color: AppColors.textSecondaryColor.themeColor),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _infoSection() {
    final rows = [
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
      if (doctor.avgRate != null)
        _detailRow(
          icon: AppSvgIcons.sparkle,
          label: LocaleKeys.staff_detailsRating.tr(),
          value: doctor.avgRate!.toStringAsFixed(1),
        ),
    ];
    if (rows.isEmpty) return const [];
    return [
      22.height,
      AppSectionTitle(LocaleKeys.staff_detailsInfo.tr()),
      10.height,
      _sectionCard(rows),
    ];
  }

  List<Widget> _specializationsSection(
      String title, List<DoctorSpecialization> items) {
    if (items.isEmpty) return const [];
    return [
      18.height,
      AppSectionTitle(title),
      10.height,
      for (final item in items) DoctorSpecializationTile(specialization: item),
    ];
  }

  List<Widget> _clinicsSection() {
    if (doctor.clinics.isEmpty) return const [];
    return [
      18.height,
      AppSectionTitle(LocaleKeys.staff_detailsClinics.tr()),
      10.height,
      for (final clinic in doctor.clinics) DoctorClinicCard(clinic: clinic),
    ];
  }

  List<Widget> _locationSection() {
    final location = doctor.location;
    if (location == null || doctor.clinics.isNotEmpty) return const [];
    return [
      18.height,
      AppSectionTitle(LocaleKeys.staff_detailsLocation.tr()),
      10.height,
      _sectionCard([
        _detailRow(
          icon: AppSvgIcons.mapPin,
          label: LocaleKeys.staff_detailsLocation.tr(),
          value: [location.name, location.areaCityLabel]
              .where((s) => s.isNotEmpty)
              .join(' · '),
        ),
      ]),
    ];
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
