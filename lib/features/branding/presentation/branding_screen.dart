import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/branding_cubit.dart';
import 'widgets/theme_preview_card.dart';
import 'widgets/theme_swatch_card.dart';

/// "الهوية البصرية" — a cosmetic color-theme picker with a live-looking
/// preview card (doesn't restyle the running app; see [BrandingRepo]).
class BrandingScreen extends StatefulWidget {
  const BrandingScreen({super.key});

  @override
  State<BrandingScreen> createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  late final _cubit = getIt<BrandingCubit>()..load();
  late final _nameController = TextEditingController(text: 'مجمع الشفاء');

  @override
  void dispose() {
    _cubit.close();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<BrandingCubit, BrandingState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is BrandingLoading || state is BrandingInitial,
              error: state is BrandingError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final data = (state as BrandingSuccess).data;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.brandingScreen_title.tr(),
                      eyebrow: LocaleKeys.brandingScreen_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    AppCard(
                      color: AppColors.surfaceColor.themeColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvgIcon(AppSvgIcons.info,
                              size: 17.sp, color: AppColors.primaryColor.themeColor),
                          11.width,
                          Expanded(
                            child: AppText(LocaleKeys.brandingScreen_infoBanner.tr(),
                                fontSize: 11,
                                height: 1.7,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                        ],
                      ),
                    ),
                    18.height,
                    AppSectionTitle(LocaleKeys.brandingScreen_pickTheme.tr()),
                    12.height,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.themes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 1.6,
                      ),
                      itemBuilder: (context, i) => ThemeSwatchCard(
                        theme: data.themes[i],
                        selected: data.selectedIndex == i,
                        onTap: () => _cubit.selectTheme(i),
                      ),
                    ),
                    20.height,
                    AppSectionTitle(LocaleKeys.brandingScreen_previewTitle.tr()),
                    12.height,
                    ThemePreviewCard(theme: data.selected, clinicName: data.clinicName),
                    20.height,
                    AppSectionTitle(LocaleKeys.brandingScreen_nameTitle.tr()),
                    12.height,
                    CustomTextField(
                      controller: _nameController,
                      hint: LocaleKeys.brandingScreen_nameHint.tr(),
                      onChanged: _cubit.setClinicName,
                    ),
                    20.height,
                    CustomButton(
                      onTap: () => AppOverlay.showSuccess(LocaleKeys.brandingScreen_saveSuccess.tr()),
                      title: LocaleKeys.brandingScreen_save.tr(),
                    ),
                    9.height,
                    CustomButton(
                      onTap: () {
                        _cubit.reset();
                        _nameController.text = 'مجمع الشفاء';
                        AppOverlay.showSuccess(LocaleKeys.brandingScreen_resetSuccess.tr());
                      },
                      title: LocaleKeys.brandingScreen_reset.tr(),
                      color: AppColors.surfaceColor.themeColor,
                      textColor: AppColors.textPrimaryColor.themeColor,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
