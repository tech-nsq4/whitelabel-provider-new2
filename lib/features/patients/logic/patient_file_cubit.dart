import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/patient_file_model.dart';
import '../data/models/patient_list_item_model.dart';
import '../data/patients_repo.dart';
import 'patient_file_data.dart';

part 'patient_file_state.dart';

class PatientFileCubit extends Cubit<PatientFileState> {
  PatientFileCubit(this._repo) : super(const PatientFileInitial());

  final PatientsRepo _repo;

  /// [patient] is the directory row the screen was opened from — reused
  /// as-is for the header/stats, no separate "get one user" endpoint.
  Future<void> load(PatientListItemModel patient) async {
    emit(const PatientFileLoading());
    try {
      final analysesFuture = _repo.getAnalysesHistory('${patient.id}');
      final xraysFuture = _repo.getXraysHistory('${patient.id}');
      final prescriptionHistoryFuture =
          _repo.getPrescriptionHistory('${patient.id}');
      emit(PatientFileSuccess(PatientFileData(
        file: PatientFileModel(
          patient: patient,
          analysesHistory: await analysesFuture,
          xraysHistory: await xraysFuture,
          prescriptionHistory: await prescriptionHistoryFuture,
        ),
      )));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(PatientFileError(msg));
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
