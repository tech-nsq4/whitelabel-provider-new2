import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/patients_repo.dart';
import 'patient_file_data.dart';

part 'patient_file_state.dart';

class PatientFileCubit extends Cubit<PatientFileState> {
  PatientFileCubit(this._repo) : super(const PatientFileInitial());

  final PatientsRepo _repo;

  Future<void> load(String patientId) async {
    emit(const PatientFileLoading());
    try {
      final file = await _repo.getFile(patientId);
      emit(PatientFileSuccess(PatientFileData(file: file)));
    } catch (e) {
      emit(PatientFileError(e.toString()));
    }
  }

  void setTab(int index) => _update((d) => d.copyWith(tabIndex: index));

  void toggleVisit(String code) => _update((d) => d.copyWith(
        expandedVisitCode: d.expandedVisitCode == code ? null : code,
        clearExpanded: d.expandedVisitCode == code,
      ));

  void _update(PatientFileData Function(PatientFileData) transform) {
    final current = state;
    if (current is! PatientFileSuccess) return;
    emit(PatientFileSuccess(transform(current.data)));
  }
}
