import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

enum QuickAction { walkin, book, issueDoc, inbox }

/// The reference design's `#sh-quick` sheet — the FAB's 2×2 shortcut grid.
class QuickActionSheet extends StatelessWidget {
  const QuickActionSheet({super.key, required this.onSelect});

  final ValueChanged<QuickAction> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 26.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.hintColor.themeColor,
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
          ),
          AppText(LocaleKeys.quickAction_title.tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          AppText(LocaleKeys.quickAction_subtitle.tr(),
              fontSize: 12, color: AppColors.mutedColor.themeColor),
          18.height,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1.15,
            children: [
              _Tile(
                icon: AppSvgIcons.account,
                label: LocaleKeys.quickAction_walkin.tr(),
                filled: true,
                onTap: () => onSelect(QuickAction.walkin),
              ),
              _Tile(
                icon: AppSvgIcons.calendar,
                label: LocaleKeys.quickAction_book.tr(),
                onTap: () => onSelect(QuickAction.book),
              ),
              _Tile(
                icon: AppSvgIcons.document,
                label: LocaleKeys.quickAction_issueDoc.tr(),
                onTap: () => onSelect(QuickAction.issueDoc),
              ),
              _Tile(
                icon: AppSvgIcons.bell,
                label: LocaleKeys.quickAction_inbox.tr(),
                onTap: () => onSelect(QuickAction.inbox),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap, this.filled = false});

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: filled ? AppColors.primaryColor.themeColor : null,
      borderColor: filled ? AppColors.primaryColor.themeColor : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSvgIcon(icon, size: 26.sp, color: filled ? Colors.white : AppColors.primaryColor.themeColor),
          9.height,
          AppText(
            label,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            color: filled ? Colors.white : AppColors.textPrimaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
