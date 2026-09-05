import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class QueueChatButton extends StatelessWidget {
  const QueueChatButton({super.key, required this.userId, required this.userName});

  final int userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return CustomTapEffect(
      onTap: () => Navigator.pushNamed(context, Routes.chat, arguments: {
        'userId': userId,
        'userName': userName,
      }),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Center(child: AppSvgIcon(AppSvgIcons.chatBubble, size: 18.sp, color: primary)),
      ),
    );
  }
}
