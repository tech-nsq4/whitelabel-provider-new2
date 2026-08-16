import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// The language-picker bottom sheet opened from the "more" screen.
class MoreLanguageSheet extends StatefulWidget {
  const MoreLanguageSheet({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  State<MoreLanguageSheet> createState() => _MoreLanguageSheetState();
}

class _MoreLanguageSheetState extends State<MoreLanguageSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.parentContext.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(4.r)),
            ),
          ),
          16.height,
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 18.sp, color: AppColors.textSecondaryColor.themeColor),
                ),
              ),
              const Spacer(),
              AppText(LocaleKeys.settings_languageTitle.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor),
              const Spacer(),
              SizedBox(width: 36.r),
            ],
          ),
          20.height,
          _LangOption(
            flag: '🇸🇦',
            label: LocaleKeys.settings_arabic.tr(),
            isSelected: _selected == 'ar',
            onTap: () => setState(() => _selected = 'ar'),
          ),
          12.height,
          _LangOption(
            flag: '🇬🇧',
            label: LocaleKeys.settings_english.tr(),
            isSelected: _selected == 'en',
            onTap: () => setState(() => _selected = 'en'),
          ),
          24.height,
          CustomButton(
            onTap: () async {
              Navigator.pop(context);
              await getIt<LocalStorage>().setLang(_selected);
              widget.parentContext.setLocale(Locale(_selected));
              Navigator.pushNamedAndRemoveUntil(
                widget.parentContext,
                Routes.splashScreen,
                (_) => false,
              );
            },
            title: LocaleKeys.common_confirm.tr(),
          ),
        ],
      ),
    );
  }
}

/// A single selectable language row — small enough to stay private inside
/// the one sheet that uses it rather than its own file.
class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.06) : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? primary : AppColors.dividerColor.themeColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 26.sp)),
            14.width,
            AppText(label,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? primary : AppColors.textPrimaryColor.themeColor),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primary, size: 22.sp)
            else
              Icon(Icons.radio_button_unchecked_rounded,
                  color: AppColors.hintColor.themeColor, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
