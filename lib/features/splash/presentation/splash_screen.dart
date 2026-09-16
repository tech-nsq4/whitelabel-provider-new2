import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../onboarding/data/models/splash_slide_model.dart';
import '../../onboarding/logic/onboarding_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import 'widgets/splash_logo_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _minTimer;
  bool _navigated = false;
  final _onboardingCubit = getIt<OnboardingCubit>();
  Future<void>? _splashesFuture;

  @override
  void initState() {
    super.initState();
    if (!getIt<LocalStorage>().isLoggedIn) {
      _splashesFuture = _onboardingCubit.loadSplashes();
    }
    _minTimer = Timer(const Duration(milliseconds: 3100), _navigate);
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _onboardingCubit.close();
    super.dispose();
  }

  Future<void> _navigate() async {
    if (_navigated || !mounted) return;
    _navigated = true;

    final storage = getIt<LocalStorage>();
    if (!storage.isLoggedIn) {
      await _splashesFuture;
      if (!mounted) return;
      final state = _onboardingCubit.state;
      final slides = state is OnboardingSuccess
          ? state.slides
          : const <SplashSlideModel>[];
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.onBoardingScreen,
        (_) => false,
        arguments: {'slides': slides},
      );
      return;
    }

    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.getProfile();
    if (!mounted) return;

    if (profileCubit.state is ProfileSuccess) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.layoutScreen, (_) => false);
    } else {
      await storage.removeToken();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: const SplashLogoAnimation(),
        ),
      ),
    );
  }
}
