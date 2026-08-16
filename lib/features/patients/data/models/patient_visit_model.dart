import 'package:equatable/equatable.dart';

import 'patient_visit_item_model.dart';

/// One row in the patient file's "الزيارات" tab — expands to show what
/// branched off it (prescriptions, orders, documents).
class PatientVisitModel extends Equatable {
  const PatientVisitModel({
    required this.code,
    required this.title,
    required this.doctor,
    required this.dateLabel,
    required this.diagnosisSummary,
    required this.items,
  });

  /// e.g. "V-1180".
  final String code;
  final String title;
  final String doctor;
  final String dateLabel;
  final String diagnosisSummary;
  final List<PatientVisitItemModel> items;

  @override
  List<Object?> get props => [code, title, doctor, dateLabel, diagnosisSummary, items];
}
