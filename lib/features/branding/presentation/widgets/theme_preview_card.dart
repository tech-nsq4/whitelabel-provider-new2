import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/branding_theme_option.dart';

/// A tiny non-interactive nav-bar mockup previewing the selected theme,
/// on the branding screen — cosmetic only.
class ThemePreviewCard extends StatelessWidget {
  const ThemePreviewCard({super.key, required this.theme, required this.clinicName});

  final BrandingThemeOption theme;
  final String clinicName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: theme.brand, borderRadius: BorderRadius.circular(14.r)),
                child: Icon(Icons.local_hospital_rounded, color: Colors.white, size: 22.sp),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(clinicName.isEmpty ? ' ' : clinicName,
                        isHeading: true,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText('نظام إدارة العيادة', fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
            ],
          ),
          14.height,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            decoration: BoxDecoration(color: theme.ink, borderRadius: BorderRadius.circular(12.r)),
            child: Row(
              children: [
                Expanded(child: _tab('اليوم', theme.brand, filled: true)),
                Expanded(child: _tab('الحجوزات', theme.ink)),
                Expanded(child: _tab('الطلبات', theme.ink)),
                Expanded(child: _tab('المرضى', theme.ink)),
              ],
            ),
          ),
          10.height,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(color: theme.brand, borderRadius: BorderRadius.circular(10.r)),
                  alignment: Alignment.center,
                  child: AppText('ابدأ الكشفيات',
                      fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              8.width,
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(color: theme.paper, borderRadius: BorderRadius.circular(10.r)),
                  alignment: Alignment.center,
                  child: AppText('الجداول', fontSize: 10.5, fontWeight: FontWeight.w600, color: theme.ink),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, Color bg, {bool filled = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: filled ? bg : Colors.transparent,
        borderRadius: BorderRadius.circular(9.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.white : Colors.white.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
