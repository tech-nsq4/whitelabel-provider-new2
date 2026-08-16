import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../profile/logic/profile_cubit.dart';

/// The "more" screen's top identity card — signed-in name or a sign-in
/// prompt for a guest session.
class MoreProfileCard extends StatelessWidget {
  const MoreProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final title = LocaleKeys.profile_title.tr();
    final subtitle = LocaleKeys.more_profileCardSubtitle.tr();

    final state = context.watch<ProfileCubit>().state;
    final manager = state is ProfileSuccess ? state.manager : null;
    final displayName = manager != null && manager.name.trim().isNotEmpty
        ? manager.name
        : title;
    final initial = displayName.trim().isNotEmpty ? displayName.trim()[0] : '؟';
    final displaySubtitle =
        manager?.phone.trim().isNotEmpty ?? false ? manager!.phone : subtitle;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AppInitialsAvatar(initial, filled: true),
          14.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(displayName,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimaryColor.themeColor),
                3.height,
                AppText(displaySubtitle,
                    fontSize: 11.5, color: AppColors.mutedColor.themeColor),
              ],
            ),
          ),
          if (manager == null)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.loginScreen),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                backgroundColor: primary.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
              child: AppText(LocaleKeys.profile_loginNow.tr(),
                  fontSize: 12, fontWeight: FontWeight.w600, color: primary),
            )
          else
            CustomTapEffect(
              onTap: () => Navigator.pushNamed(context, Routes.editProfile),
              child: Container(
                width: 34.w,
                height: 34.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.edit_outlined, size: 17.sp, color: primary),
              ),
            ),
        ],
      ),
    );
  }
}
