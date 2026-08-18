import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
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
      final msg = e is NetworkException ? e.message : e.toString();
      emit(SpecialtiesError(msg));
    }
  }
}
