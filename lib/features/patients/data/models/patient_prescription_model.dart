import 'package:equatable/equatable.dart';

/// One row from `GET /users/{id}/prescriptions/history` — a medication
/// prescribed in a past visit.
class PatientPrescriptionModel extends Equatable {
  const PatientPrescriptionModel({
    required this.id,
    required this.appointmentId,
    required this.drugName,
    this.dosage,
    this.duration,
    this.date,
  });

  final int id;
  final int appointmentId;
  final String drugName;
  final String? dosage;
  final String? duration;
  final String? date;

  factory PatientPrescriptionModel.fromJson(Map<String, dynamic> json) =>
      PatientPrescriptionModel(
        id: json['id'] as int,
        appointmentId: json['appointment_id'] as int,
        drugName: json['drug_name'] as String? ?? '',
        dosage: json['dosage'] as String?,
        duration: json['duration'] as String?,
        date: json['date'] as String?,
      );

  @override
  List<Object?> get props =>
      [id, appointmentId, drugName, dosage, duration, date];
}
