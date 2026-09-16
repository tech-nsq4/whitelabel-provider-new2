part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingSuccess extends OnboardingState {
  const OnboardingSuccess(this.slides);
  final List<SplashSlideModel> slides;
  @override
  List<Object?> get props => [slides];
}

final class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
