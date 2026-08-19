import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/notification_model.dart';

/// One booking-lifecycle event on the "الإشعارات" screen.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final NotificationModel notification;

  (String, Color) get _iconAndColor => switch (notification.type) {
        NotificationType.booked => (AppSvgIcons.calendar, AppColors.secondaryColor.themeColor),
        NotificationType.accepted => (AppSvgIcons.checkCircle, AppColors.primaryColor.themeColor),
        NotificationType.started => (AppSvgIcons.stethoscope, AppColors.warningColor.themeColor),
        NotificationType.completed => (AppSvgIcons.checkCircle, AppColors.successColor.themeColor),
        NotificationType.unknown => (AppSvgIcons.bell, AppColors.mutedColor.themeColor),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconAndColor;

    return AppCard(
      margin: 10.paddingBottom,
      color:  Colors.white,
      // notification.isRead
      //     ? AppColors.cardColor.themeColor
      //     : AppColors.surfaceColor.themeColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(svgIcon: icon, iconColor: color, background: color.withValues(alpha: 0.12)),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(notification.titleKey.tr(),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                2.height,
                AppText(notification.bodyKey.tr(),
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.textSecondaryColor.themeColor),
                6.height,
                AppText(
                  ConvertHelper.formatDateTime(notification.createdAt,
                      includeDate: true, includeTime: true),
                  fontSize: 10,
                  color: AppColors.mutedColor.themeColor,
                ),
              ],
            ),
          ),
          if (!notification.isRead) ...[
            8.width,
            Container(
              width: 8.r,
              height: 8.r,
              margin: EdgeInsets.only(top: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.themeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
