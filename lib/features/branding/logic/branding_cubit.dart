import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/branding_repo.dart';
import 'branding_data.dart';

part 'branding_state.dart';

class BrandingCubit extends Cubit<BrandingState> {
  BrandingCubit(this._repo) : super(const BrandingInitial());

  final BrandingRepo _repo;

  Future<void> load() async {
    emit(const BrandingLoading());
    try {
      final themes = await _repo.getThemes();
      emit(BrandingSuccess(BrandingData(themes: themes, selectedIndex: 0, clinicName: 'مجمع الشفاء')));
    } catch (e) {
      emit(BrandingError(e.toString()));
    }
  }

  void selectTheme(int index) => _update((d) => d.copyWith(selectedIndex: index));

  void setClinicName(String name) => _update((d) => d.copyWith(clinicName: name));

  void reset() => _update((d) => d.copyWith(selectedIndex: 0, clinicName: 'مجمع الشفاء'));

  void _update(BrandingData Function(BrandingData) transform) {
    final current = state;
    if (current is! BrandingSuccess) return;
    emit(BrandingSuccess(transform(current.data)));
  }
}
