import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/branding_theme_option.dart';

/// One selectable color-theme card in the branding screen's grid.
class ThemeSwatchCard extends StatelessWidget {
  const ThemeSwatchCard({super.key, required this.theme, required this.selected, required this.onTap});

  final BrandingThemeOption theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceColor.themeColor : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? theme.brand : AppColors.dividerColor.themeColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (final c in [theme.brand, theme.paper, theme.ink, theme.gold]) ...[
                  Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                  ),
                  if (c != theme.gold) 5.width,
                ],
                const Spacer(),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: theme.brand, size: 18.sp),
              ],
            ),
            8.height,
            AppText(theme.name,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
          ],
        ),
      ),
    );
  }
}
