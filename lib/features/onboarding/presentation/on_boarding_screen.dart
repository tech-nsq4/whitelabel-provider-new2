import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/splash_slide_model.dart';
import 'widgets/onboarding_dots_indicator.dart';
import 'widgets/onboarding_illustration.dart';
import 'widgets/onboarding_image.dart';
import 'widgets/onboarding_slide_data.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key, this.slides = const []});

  final List<SplashSlideModel> slides;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingSlideData> _resolveSlides() {
    if (widget.slides.isNotEmpty) {
      return [
        for (final slide in widget.slides)
          OnboardingSlideData(
            imageUrl: slide.image,
            title: slide.title,
            subtitle: slide.description,
          ),
      ];
    }
    return _bundledSlides();
  }

  List<OnboardingSlideData> _bundledSlides() {
    return [
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.welcome,
        title: LocaleKeys.onboarding_slide1_title.tr(),
        subtitle: LocaleKeys.onboarding_slide1_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.queue,
        title: LocaleKeys.onboarding_slide2_title.tr(),
        subtitle: LocaleKeys.onboarding_slide2_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.staff,
        title: LocaleKeys.onboarding_slide3_title.tr(),
        subtitle: LocaleKeys.onboarding_slide3_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.setup,
        title: LocaleKeys.onboarding_slide4_title.tr(),
        subtitle: LocaleKeys.onboarding_slide4_subtitle.tr(),
      ),
    ];
  }

  void _next(int slidesCount) {
    if (_currentPage >= slidesCount - 1) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    getIt<LocalStorage>().setOnboardingSeen();
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginScreen, (_) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _resolveSlides();
    if (_currentPage >= slides.length) _currentPage = slides.length - 1;
    final isLast = _currentPage == slides.length - 1;
    final accentGold = AppColors.accentGold.themeColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: 20.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  AppImages.logo3,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) {
                    final slide = slides[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (slide.hasImage)
                          OnboardingImage(url: slide.imageUrl!)
                        else if (slide.illustration != null)
                          OnboardingIllustration(
                              illustration: slide.illustration!),
                        32.height,
                        OnboardingDotsIndicator(
                          count: slides.length,
                          currentIndex: _currentPage,
                        ),
                        24.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                slide.title,
                                isHeading: true,
                                color: AppColors.textPrimaryColor.themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              AppText(
                                slide.subtitle,
                                color: AppColors.textSecondaryColor.themeColor,
                                height: 1.5,
                                fontSize: 15.sp,
                                maxLines: 4,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding),
                child: CustomButton(
                  title: isLast
                      ? LocaleKeys.onboarding_getStarted.tr()
                      : LocaleKeys.onboarding_next.tr(),
                  onTap: () => _next(slides.length),
                  color: isLast ? accentGold : null,
                  borderColor: isLast ? accentGold : null,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _finish,
                  child: AppText(
                    LocaleKeys.onboarding_skip.tr(),
                    color: AppColors.mutedColor.themeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
