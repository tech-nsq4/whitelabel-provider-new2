import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/homecare_request_model.dart';

/// Picks the assigned doctor's first-name initial for the little avatar
/// ("د. رهف الدسري" → "ر"), tolerant of the "د." honorific prefix.
String _doctorInitial(String doctorName) {
  final words = doctorName.replaceAll('د.', '').trim().split(' ');
  final firstName = words.isNotEmpty ? words.first : '';
  return firstName.isNotEmpty ? firstName[0] : '؟';
}

/// One pending or assigned home-care request card.
class HomecareRequestCard extends StatelessWidget {
  const HomecareRequestCard({super.key, required this.request, required this.onAssign});

  final HomecareRequestModel request;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 10.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBox(svgIcon: AppSvgIcons.home2),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(request.patientName,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    2.height,
                    AppText('${request.serviceLabel} · ${request.price} ${LocaleKeys.common_currency.tr()}',
                        fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
              if (!request.isAssigned)
                AppStatusChip(LocaleKeys.status_newOrder.tr(), tone: AppStatusTone.critical),
            ],
          ),
          10.height,
          Row(
            children: [
              AppSvgIcon(AppSvgIcons.mapPin, size: 15.sp, color: AppColors.mutedColor.themeColor),
              7.width,
              Expanded(
                child: AppText(request.addressLine,
                    fontSize: 11, color: AppColors.mutedColor.themeColor)),
            ],
          ),
          5.height,
          Row(
            children: [
              AppSvgIcon(AppSvgIcons.clock, size: 15.sp, color: AppColors.mutedColor.themeColor),
              7.width,
              AppText(request.timeWindow, fontSize: 11, color: AppColors.mutedColor.themeColor),
            ],
          ),
          if (!request.isAssigned) ...[
            11.height,
            CustomButton(
              onTap: onAssign,
              title: LocaleKeys.homecare_assign.tr(),
              height: 40,
              radius: 12,
            ),
          ] else ...[
            11.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Row(
                children: [
                  AppInitialsAvatar(_doctorInitial(request.assignedDoctor!), size: 28),
                  8.width,
                  Expanded(
                    child: AppText(
                      LocaleKeys.homecare_onTheWay.tr(namedArgs: {'name': request.assignedDoctor!}),
                      fontSize: 11,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
