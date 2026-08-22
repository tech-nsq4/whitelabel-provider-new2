import 'package:equatable/equatable.dart';

import 'active_medication_model.dart';
import 'lab_result_model.dart';
import 'vital_signs_model.dart';

/// The consultation screen's "السجل" tab content for one patient.
class PatientHistoryModel extends Equatable {
  const PatientHistoryModel({
    this.vitals,
    this.lastVisitDate,
    this.lastVisitSummary = '',
    this.recentResults = const [],
    this.activeMedications = const [],
  });

  /// `null` until the patient has a recorded vital-signs reading.
  final VitalSignsModel? vitals;

  /// Raw date string — formatted at display time. `null` when there's no
  /// last visit on record.
  final String? lastVisitDate;
  final String lastVisitSummary;
  final List<LabResultModel> recentResults;
  final List<ActiveMedicationModel> activeMedications;

  PatientHistoryModel copyWith({VitalSignsModel? vitals}) => PatientHistoryModel(
        vitals: vitals ?? this.vitals,
        lastVisitDate: lastVisitDate,
        lastVisitSummary: lastVisitSummary,
        recentResults: recentResults,
        activeMedications: activeMedications,
      );

  @override
  List<Object?> get props => [
        vitals,
        lastVisitDate,
        lastVisitSummary,
        recentResults,
        activeMedications,
      ];
}
