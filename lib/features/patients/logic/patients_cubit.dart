import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/patient_list_item_model.dart';
import '../data/patients_repo.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  PatientsCubit(this._repo) : super(const PatientsInitial());

  final PatientsRepo _repo;

  Future<void> loadPatients({String query = ''}) async {
    emit(const PatientsLoading());
    try {
      final patients = await _repo.getPatients(query: query);
      emit(PatientsSuccess(patients));
    } catch (e) {
      emit(PatientsError(e.toString()));
    }
  }
}
