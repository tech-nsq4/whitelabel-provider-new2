import 'package:equatable/equatable.dart';

/// Raw `GET /appointments` row — the source of truth [QueuePatientModel]
/// (queue/consultation UI) is derived from. Only the fields the app
/// actually reads are parsed; the rest of the backend's nested
/// clinic/location/specialization tree is ignored for now.
class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.status,
    required this.date,
    this.time,
    this.complaint,
    this.diagnosis,
    this.patientName,
    this.patientPhone,
    this.doctorName,
  });

  final int id;

  /// `pending` | `confirmed` | `in_progress` | `cancelled` | `completed`.
  final String status;
  final String date;
  final String? time;
  final String? complaint;
  final String? diagnosis;
  final String? patientName;
  final String? patientPhone;
  final String? doctorName;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final doctor = json['doctor'] as Map<String, dynamic>?;
    return AppointmentModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'pending',
      date: json['date'] as String? ?? '',
      time: json['times'] as String?,
      complaint: json['complaint'] as String?,
      diagnosis: json['diagnosis'] as String?,
      patientName: user?['name'] as String?,
      patientPhone: user?['phone'] as String?,
      doctorName: doctor?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        date,
        time,
        complaint,
        diagnosis,
        patientName,
        patientPhone,
        doctorName
      ];
}
