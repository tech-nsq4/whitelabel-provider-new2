import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/specialty_model.dart';
import '../data/specialties_repo.dart';

part 'specialties_state.dart';

class SpecialtiesCubit extends Cubit<SpecialtiesState> {
  SpecialtiesCubit(this._repo) : super(const SpecialtiesInitial());

  final SpecialtiesRepo _repo;

  Future<void> loadSpecialties() async {
    emit(const SpecialtiesLoading());
    try {
      final specialties = await _repo.getSpecialties();
      emit(SpecialtiesSuccess(specialties));
    } catch (e) {
      emit(SpecialtiesError(e.toString()));
    }
  }

  /// Adds a new specialty, or replaces an existing one that shares its id —
  /// used by [SpecialtyEditSheet]'s add/edit flow.
  void upsert(SpecialtyModel model) {
    final current = state;
    if (current is! SpecialtiesSuccess) return;
    final exists = current.specialties.any((s) => s.id == model.id);
    emit(SpecialtiesSuccess(exists
        ? [for (final s in current.specialties) if (s.id == model.id) model else s]
        : [...current.specialties, model]));
  }
}
