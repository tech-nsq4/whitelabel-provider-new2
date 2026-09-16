import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/splash_slide_model.dart';
import '../data/onboarding_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo) : super(const OnboardingInitial());

  final OnboardingRepo _repo;

  Future<void> loadSplashes() async {
    emit(const OnboardingLoading());
    try {
      final slides = await _repo.getSplashes();
      emit(OnboardingSuccess(slides));
    } catch (e) {
      emit(OnboardingError(e is NetworkException ? e.message : e.toString()));
    }
  }
}
