import 'package:equatable/equatable.dart';

import 'active_medication_model.dart';
import 'lab_result_model.dart';
import 'vital_signs_model.dart';

/// The consultation screen's "السجل" tab content for one patient.
class PatientHistoryModel extends Equatable {
  const PatientHistoryModel({
    required this.vitals,
    required this.lastVisitLabel,
    required this.lastVisitSummary,
    required this.recentResults,
    required this.activeMedications,
  });

  final VitalSignsModel vitals;
  final String lastVisitLabel;
  final String lastVisitSummary;
  final List<LabResultModel> recentResults;
  final List<ActiveMedicationModel> activeMedications;

  @override
  List<Object?> get props => [
        vitals,
        lastVisitLabel,
        lastVisitSummary,
        recentResults,
        activeMedications
      ];
}
