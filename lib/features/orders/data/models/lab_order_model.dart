import 'package:equatable/equatable.dart';

enum LabOrderStatus { newOrder, inProgress, done }

/// One lab/imaging test request raised from a consultation.
class LabOrderModel extends Equatable {
  const LabOrderModel({
    required this.id,
    required this.patientName,
    required this.patientInitial,
    required this.mrn,
    required this.requestedAtLabel,
    required this.testName,
    required this.requestingDoctor,
    required this.status,
  });

  final String id;
  final String patientName;
  final String patientInitial;
  final String mrn;

  /// Pre-formatted "requested at" line, e.g. "اليوم 09:20".
  final String requestedAtLabel;
  final String testName;
  final String requestingDoctor;
  final LabOrderStatus status;

  LabOrderModel copyWith({LabOrderStatus? status}) => LabOrderModel(
        id: id,
        patientName: patientName,
        patientInitial: patientInitial,
        mrn: mrn,
        requestedAtLabel: requestedAtLabel,
        testName: testName,
        requestingDoctor: requestingDoctor,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props =>
      [id, patientName, patientInitial, mrn, requestedAtLabel, testName, requestingDoctor, status];
}
