import 'package:equatable/equatable.dart';

import '../../../orders/data/models/test_request_model.dart';
import 'patient_list_item_model.dart';
import 'patient_prescription_model.dart';
import 'patient_visit_model.dart';

/// The full "ملف مريض" screen's content for one patient — the directory
/// row itself (passed straight through, not re-fetched) plus their
/// analysis/x-ray/prescription history.
class PatientFileModel extends Equatable {
  const PatientFileModel({
    required this.patient,
    this.analysesHistory = const [],
    this.xraysHistory = const [],
    this.prescriptionHistory = const [],
    this.visits = const [],
  });

  final PatientListItemModel patient;

  /// The "النتائج" tab.
  final List<TestRequestModel> analysesHistory;

  /// The "الأشعة" tab.
  final List<TestRequestModel> xraysHistory;

  /// The "الأدوية" tab.
  final List<PatientPrescriptionModel> prescriptionHistory;

  /// No endpoint for a visits timeline yet — always empty, kept only so
  /// the "الزيارات" tab keeps its existing design ready to wire up once
  /// one exists.
  final List<PatientVisitModel> visits;

  @override
  List<Object?> get props =>
      [patient, analysesHistory, xraysHistory, prescriptionHistory, visits];
}
