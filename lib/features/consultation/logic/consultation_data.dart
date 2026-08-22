import 'package:equatable/equatable.dart';

import '../../queue/data/models/queue_patient_model.dart';
import '../data/models/consultation_option.dart';
import '../data/models/patient_history_model.dart';
import '../data/models/prescription_entry_model.dart';

/// The consultation screen's full editable state — the loaded patient
/// record plus everything the doctor is composing for this visit.
class ConsultationData extends Equatable {
  const ConsultationData({
    required this.patient,
    required this.history,
    required this.analysisOptions,
    required this.xrayOptions,
    this.tabIndex = 0,
    this.prescriptions = const [],
    this.selectedAnalysisIds = const {},
    this.selectedXrayIds = const {},
    this.complaint = '',
    this.diagnosis = '',
  });

  final QueuePatientModel patient;
  final PatientHistoryModel history;

  /// The `GET user/analyses` catalogue to pick from.
  final List<ConsultationOption> analysisOptions;

  /// The `GET user/xrays` catalogue to pick from.
  final List<ConsultationOption> xrayOptions;

  final int tabIndex;
  final List<PrescriptionEntryModel> prescriptions;
  final Set<String> selectedAnalysisIds;
  final Set<String> selectedXrayIds;

  final String complaint;
  final String diagnosis;

  ConsultationData copyWith({
    PatientHistoryModel? history,
    int? tabIndex,
    List<PrescriptionEntryModel>? prescriptions,
    Set<String>? selectedAnalysisIds,
    Set<String>? selectedXrayIds,
  }) =>
      ConsultationData(
        patient: patient,
        history: history ?? this.history,
        analysisOptions: analysisOptions,
        xrayOptions: xrayOptions,
        tabIndex: tabIndex ?? this.tabIndex,
        prescriptions: prescriptions ?? this.prescriptions,
        selectedAnalysisIds: selectedAnalysisIds ?? this.selectedAnalysisIds,
        selectedXrayIds: selectedXrayIds ?? this.selectedXrayIds,
        complaint: complaint,
        diagnosis: diagnosis,
      );

  @override
  List<Object?> get props => [
        patient,
        history,
        analysisOptions,
        xrayOptions,
        tabIndex,
        prescriptions,
        selectedAnalysisIds,
        selectedXrayIds,
        complaint,
        diagnosis,
      ];
}
