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
    this.doctorDescription,
    this.doctorExperience,
    this.doctorPrice,
    this.doctorSpecializations,
    this.clinicName,
    this.clinicAddress,
    this.clinicCity,
    this.clinicArea,
    this.shiftWindow,
    this.familyMemberName,
    this.familyMemberPhone,
    this.familyMemberDob,
    this.familyMemberIdNumber,
    this.prescriptionImage,
    this.startedAt,
    this.endedAt,
    this.cancelledAt,
    this.createdAt,
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
  final String? doctorDescription;
  final int? doctorExperience;
  final String? doctorPrice;

  /// Doctor's specialization titles joined with "، ".
  final String? doctorSpecializations;
  final String? clinicName;
  final String? clinicAddress;
  final String? clinicCity;
  final String? clinicArea;

  /// The booked shift's start–end time, resolved from the schedule row
  /// using `shift_id` (e.g. "09:00 - 13:00").
  final String? shiftWindow;

  /// Set when the booking was made on behalf of a family member rather
  /// than the account holder themselves.
  final String? familyMemberName;
  final String? familyMemberPhone;
  final String? familyMemberDob;
  final String? familyMemberIdNumber;

  final String? prescriptionImage;
  final String? startedAt;
  final String? endedAt;
  final String? cancelledAt;
  final String? createdAt;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final doctor = json['doctor'] as Map<String, dynamic>?;
    final clinic = doctor?['clinic'] as Map<String, dynamic>?;
    final location = clinic?['location'] as Map<String, dynamic>?;
    final specializations = doctor?['specializations'] as List?;
    final schedule = json['schedule'] as Map<String, dynamic>?;
    final shiftId = json['shift_id'] as String?;
    final familyMember = json['family_member'] as Map<String, dynamic>?;

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
      doctorDescription: doctor?['description'] as String?,
      doctorExperience: doctor?['experience'] as int?,
      doctorPrice: doctor?['price'] as String?,
      doctorSpecializations: specializations == null || specializations.isEmpty
          ? null
          : specializations
              .map((s) => (s as Map<String, dynamic>)['title'] as String?)
              .whereType<String>()
              .join('، '),
      clinicName: clinic?['name'] as String?,
      clinicAddress: clinic?['address'] as String?,
      clinicCity: (location?['city'] as Map<String, dynamic>?)?['name'] as String?,
      clinicArea: (location?['area'] as Map<String, dynamic>?)?['name'] as String?,
      shiftWindow: _resolveShiftWindow(schedule, shiftId),
      familyMemberName: familyMember?['name'] as String?,
      familyMemberPhone: familyMember?['phone'] as String?,
      familyMemberDob: familyMember?['date_of_birth'] as String?,
      familyMemberIdNumber: familyMember?['id_number'] as String?,
      prescriptionImage: json['prescription_image'] as String?,
      startedAt: json['started_at'] as String?,
      endedAt: json['ended_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  static String? _resolveShiftWindow(
      Map<String, dynamic>? schedule, String? shiftId) {
    if (schedule == null || shiftId == null) return null;
    final start = schedule['${shiftId}_shift_start'] as String?;
    final end = schedule['${shiftId}_shift_end'] as String?;
    if (start == null || end == null) return null;
    return '$start - $end';
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
        doctorName,
        doctorDescription,
        doctorExperience,
        doctorPrice,
        doctorSpecializations,
        clinicName,
        clinicAddress,
        clinicCity,
        clinicArea,
        shiftWindow,
        familyMemberName,
        familyMemberPhone,
        familyMemberDob,
        familyMemberIdNumber,
        prescriptionImage,
        startedAt,
        endedAt,
        cancelledAt,
        createdAt,
      ];
}
