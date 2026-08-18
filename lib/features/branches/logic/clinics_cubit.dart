import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/branches_repo.dart';
import '../data/models/clinic_model.dart';

part 'clinics_state.dart';

class ClinicsCubit extends Cubit<ClinicsState> {
  ClinicsCubit(this._repo) : super(const ClinicsInitial());

  final BranchesRepo _repo;

  Future<void> loadClinics(int locationId) async {
    emit(const ClinicsLoading());
    try {
      final clinics = await _repo.getClinics(locationId);
      emit(ClinicsSuccess(clinics));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ClinicsError(msg));
    }
  }
}
