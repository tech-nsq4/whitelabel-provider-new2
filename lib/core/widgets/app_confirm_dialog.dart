import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

/// A centered icon + title + message + cancel/confirm button pair —
/// destructive confirmations like "logout" across the app.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.cardColor.themeColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32.sp),
            ),
            18.height,
            AppText(
              title,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,
            AppText(
              message,
              fontSize: 13,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    title: cancelLabel,
                    isOutlined: true,
                    borderColor: AppColors.dividerColor.themeColor,
                    textColor: AppColors.textSecondaryColor.themeColor,
                    color: Colors.transparent,
                  ),
                ),
                12.width,
                Expanded(
                  child: CustomButton(
                    onTap: onConfirm,
                    title: confirmLabel,
                    color: confirmColor,
                    borderColor: confirmColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
