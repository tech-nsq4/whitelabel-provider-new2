import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/booked_by_caption.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/queue_patient_model.dart';
import 'booking_discount_card.dart';
import 'queue_chat_button.dart';
import 'queue_status_chip.dart';

/// Every read-only section the backend returns for one booking — patient
/// header, appointment, doctor, discount, family member,
/// complaint/diagnosis and timeline. Shared by the queue's
/// `QueueDetailsScreen` (which adds its own call-in / consultation actions
/// below it) and the notifications feature's `AppointmentDetailsScreen`.
class BookingDetailsBody extends StatelessWidget {
  const BookingDetailsBody({super.key, required this.patient});

  final QueuePatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _patientHeader(),
        22.height,
        AppSectionTitle(LocaleKeys.queue_detailsAppointment.tr()),
        10.height,
        _sectionCard([
          _detailRow(
            icon: AppSvgIcons.calendar,
            label: LocaleKeys.queue_detailsAppointment.tr(),
            value:
                patient.scheduledLabel ?? LocaleKeys.queue_noAppointment.tr(),
          ),
          if (patient.shiftWindow != null)
            _detailRow(
              icon: AppSvgIcons.clock,
              label: LocaleKeys.queue_detailsShift.tr(),
              value: patient.shiftWindow!,
            ),
        ]),
        if (patient.doctorName != null) ...[
          18.height,
          AppSectionTitle(LocaleKeys.queue_detailsDoctor.tr()),
          10.height,
          _sectionCard([
            _detailRow(
              icon: AppSvgIcons.stethoscope,
              label: LocaleKeys.queue_detailsDoctor.tr(),
              value: patient.doctorDescription != null
                  ? '${patient.doctorName} · ${patient.doctorDescription}'
                  : patient.doctorName!,
            ),
            if (patient.doctorSpecializations != null)
              _detailRow(
                icon: AppSvgIcons.heartbeat,
                label: LocaleKeys.queue_detailsSpecialty.tr(),
                value: patient.doctorSpecializations!,
              ),
            if (patient.doctorExperience != null)
              _detailRow(
                icon: AppSvgIcons.star,
                label: LocaleKeys.queue_detailsExperience.tr(),
                value: LocaleKeys.queue_detailsExperienceValue
                    .tr(namedArgs: {'years': '${patient.doctorExperience}'}),
              ),
            if (patient.doctorPrice != null || patient.finalPrice != null)
              _detailRow(
                icon: AppSvgIcons.wallet,
                label: LocaleKeys.queue_detailsFee.tr(),
                valueChild: _feeValue(),
              ),
            if (patient.clinicName != null)
              _detailRow(
                icon: AppSvgIcons.mapPin,
                label: LocaleKeys.queue_detailsClinic.tr(),
                value: [
                  patient.clinicName,
                  patient.clinicAddress,
                  if (patient.clinicArea != null || patient.clinicCity != null)
                    [patient.clinicArea, patient.clinicCity]
                        .whereType<String>()
                        .join('، '),
                ].whereType<String>().join(' · '),
              ),
          ]),
        ],
        if (patient.hasDiscount) ...[
          18.height,
          BookingDiscountCard(patient: patient),
        ],
        if (patient.familyMemberName != null) ...[
          18.height,
          AppSectionTitle(LocaleKeys.queue_detailsFamilyMember.tr()),
          10.height,
          _sectionCard([
            if (patient.bookedByName != null)
              _detailRow(
                icon: AppSvgIcons.family,
                label: LocaleKeys.queue_detailsBookedBy.tr(),
                value: patient.bookedByName!,
              ),
            if (patient.familyMemberPhone != null)
              _detailRow(
                icon: AppSvgIcons.phoneCall,
                label: LocaleKeys.auth_phone.tr(),
                value: patient.familyMemberPhone!,
              ),
            if (patient.familyMemberDob != null)
              _detailRow(
                icon: AppSvgIcons.calendar,
                label: LocaleKeys.queue_detailsFamilyDob.tr(),
                value: ConvertHelper.formatDateTime(patient.familyMemberDob!,
                    includeDate: true),
              ),
            if (patient.familyMemberIdNumber != null)
              _detailRow(
                icon: AppSvgIcons.document,
                label: LocaleKeys.queue_detailsFamilyId.tr(),
                value: patient.familyMemberIdNumber!,
              ),
          ]),
        ],
        if ((patient.complaint?.isNotEmpty ?? false) ||
            (patient.diagnosis?.isNotEmpty ?? false)) ...[
          18.height,
          AppSectionTitle(LocaleKeys.consultation_tabConsult.tr()),
          10.height,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (patient.complaint?.isNotEmpty ?? false) ...[
                  AppText(LocaleKeys.consultation_complaintLabel.tr(),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor),
                  4.height,
                  AppText(patient.complaint!,
                      fontSize: 12,
                      color: AppColors.textSecondaryColor.themeColor),
                ],
                if ((patient.complaint?.isNotEmpty ?? false) &&
                    (patient.diagnosis?.isNotEmpty ?? false))
                  12.height,
                if (patient.diagnosis?.isNotEmpty ?? false) ...[
                  AppText(LocaleKeys.consultation_diagnosisLabel.tr(),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor),
                  4.height,
                  AppText(patient.diagnosis!,
                      fontSize: 12,
                      color: AppColors.textSecondaryColor.themeColor),
                ],
                if (patient.prescriptionImage != null) ...[
                  12.height,
                  GestureDetector(
                    onTap: () => openBottomSheet(
                        context, NetworkImage(patient.prescriptionImage!)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CustomImage(
                        image: patient.prescriptionImage!,
                        height: 120.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (patient.createdAt != null ||
            patient.startedAt != null ||
            patient.endedAt != null ||
            patient.cancelledAt != null) ...[
          18.height,
          AppSectionTitle(LocaleKeys.queue_detailsTimeline.tr()),
          10.height,
          _sectionCard([
            if (patient.createdAt != null)
              _detailRow(
                icon: AppSvgIcons.clock,
                label: LocaleKeys.queue_detailsBookedAt.tr(),
                value: ConvertHelper.formatDateTime(patient.createdAt!,
                    includeDate: true, includeTime: true),
              ),
            if (patient.startedAt != null)
              _detailRow(
                icon: AppSvgIcons.clock,
                label: LocaleKeys.queue_detailsStartedAt.tr(),
                value: ConvertHelper.formatDateTime(patient.startedAt!,
                    includeDate: true, includeTime: true),
              ),
            if (patient.endedAt != null)
              _detailRow(
                icon: AppSvgIcons.clock,
                label: LocaleKeys.queue_detailsEndedAt.tr(),
                value: ConvertHelper.formatDateTime(patient.endedAt!,
                    includeDate: true, includeTime: true),
              ),
            if (patient.cancelledAt != null)
              _detailRow(
                icon: AppSvgIcons.clock,
                label: LocaleKeys.queue_detailsCancelledAt.tr(),
                value: ConvertHelper.formatDateTime(patient.cancelledAt!,
                    includeDate: true, includeTime: true),
              ),
          ]),
        ],
      ],
    );
  }

  Widget _patientHeader() {
    return Row(
      children: [
        AppInitialsAvatar(patient.avatarLabel, filled: true, size: 52),
        14.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookedByCaption(bookedByName: patient.bookedByName),
              AppText(patient.name,
                  isHeading: true,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
              2.height,
              AppText(
                patient.mrn ?? LocaleKeys.queue_noMrn.tr(),
                fontSize: 11.5,
                color: AppColors.mutedColor.themeColor,
              ),
            ],
          ),
        ),
        QueueStatusChip(status: patient.status),
        if (patient.userId != null && (kUserModel?.isDoctor ?? false)) ...[
          8.width,
          QueueChatButton(userId: patient.userId!, userName: patient.name),
        ],
      ],
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
    String? value,
    Widget? valueChild,
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
              AppText(label,
                  fontSize: 9.5, color: AppColors.mutedColor.themeColor),
              valueChild ??
                  AppText(value!,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _feeValue() {
    final currency = LocaleKeys.common_currency.tr();
    String money(num v) =>
        v == v.roundToDouble() ? v.toInt().toString() : v.toString();

    if (patient.hasDiscount && patient.finalPrice != null) {
      final original = patient.originalPrice;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText('${money(patient.finalPrice!)} $currency',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.successColor.themeColor),
          if (original != null) ...[
            6.width,
            AppText('${money(original)} $currency',
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                color: AppColors.mutedColor.themeColor),
          ],
        ],
      );
    }

    final plain = patient.doctorPrice ?? money(patient.finalPrice!);
    return AppText('$plain $currency',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryColor.themeColor);
  }
}
