import 'package:equatable/equatable.dart';

import '../../../../core/utils/convert_helper.dart';
import 'appointment_model.dart';

/// One patient's position in the reception queue — waiting, in the room,
/// or already seen today.
class QueuePatientModel extends Equatable {
  const QueuePatientModel({
    required this.id,
    required this.name,
    required this.initial,
    this.mrn,
    this.appointmentTime,
    this.waitMinutes,
    this.justArrived = false,
    this.highlightWait = false,
    this.doneAtLabel,
    this.age,
    this.bloodType,
    this.allergy,
    this.doctorName,
    this.status,
    this.complaint,
    this.diagnosis,
    this.date,
    this.doctorDescription,
    this.doctorExperience,
    this.doctorPrice,
    this.doctorSpecializations,
    this.clinicName,
    this.clinicAddress,
    this.clinicCity,
    this.clinicArea,
    this.shiftWindow,
    this.bookedByName,
    this.familyMemberName,
    this.familyMemberPhone,
    this.familyMemberDob,
    this.familyMemberIdNumber,
    this.prescriptionImage,
    this.startedAt,
    this.endedAt,
    this.cancelledAt,
    this.createdAt,
    this.userId,
  });

  final String id;
  final String name;

  /// First letter shown inside the avatar circle.
  final String initial;

  /// `null` for a walk-in with no file yet.
  final String? mrn;

  /// `null` means the patient walked in without a booked slot.
  final String? appointmentTime;

  /// Minutes spent waiting so far — ignored when [justArrived] is true.
  final int? waitMinutes;

  /// True right after check-in, before any wait has accrued.
  final bool justArrived;

  /// True for the queue's longest-waiting patient — draws the wait label
  /// in the warning color instead of the muted one.
  final bool highlightWait;

  /// Pre-formatted "seen at" time, only set once a visit is done.
  final String? doneAtLabel;

  final int? age;
  final String? bloodType;
  final String? allergy;

  /// `null` for a walk-in not yet assigned, or when the queue only ever
  /// covers one doctor.
  final String? doctorName;

  /// The raw appointment status (`confirmed`/`in_progress`/...) — the room
  /// card reads this to tell an accepted-but-not-started visit apart from
  /// one already in progress.
  final String? status;

  /// Only set once the visit is finished — shown on the "انتهى" tile.
  final String? complaint;
  final String? diagnosis;

  /// The appointment's scheduled date (`yyyy-MM-dd`, as sent by the API).
  final String? date;

  final String? doctorDescription;
  final int? doctorExperience;
  final String? doctorPrice;
  final String? doctorSpecializations;
  final String? clinicName;
  final String? clinicAddress;
  final String? clinicCity;
  final String? clinicArea;

  /// The booked shift's start–end time (e.g. "09:00 - 13:00").
  final String? shiftWindow;

  /// Set only when [familyMemberName] is set — the account holder who
  /// made the booking, so the UI can make clear [name] (the family
  /// member) isn't who booked the visit.
  final String? bookedByName;

  /// Set when the booking was made on behalf of a family member rather
  /// than the account holder themselves. [name] is the family member's
  /// name in that case — they're who the visit is actually for.
  final String? familyMemberName;
  final String? familyMemberPhone;
  final String? familyMemberDob;
  final String? familyMemberIdNumber;

  final String? prescriptionImage;
  final String? startedAt;
  final String? endedAt;
  final String? cancelledAt;
  final String? createdAt;

  /// The booking account holder's id — `GET /users/{id}/...` calls
  /// (health summary, vital signs) use this, never [id] (the appointment's
  /// own). `null` when this patient wasn't built from a real appointment.
  final int? userId;

  /// What the avatar circle shows — the booking id when there is a real
  /// one, so two cards for the same family member (or same name) on the
  /// same day are still easy to tell apart at a glance. Falls back to
  /// [initial] for a walk-in that has no id yet.
  String get avatarLabel => RegExp(r'^\d+$').hasMatch(id) ? id : initial;

  /// A human-readable "17 أغسطس 2026 · 09:00 AM" label built from [date] +
  /// [appointmentTime] — `null`/[appointmentTime]-only when the server
  /// didn't send a date.
  String? get scheduledLabel {
    if (date == null || date!.isEmpty) return appointmentTime;
    final dateLabel = ConvertHelper.formatDateTime(date!, includeDate: true);
    if (dateLabel.isEmpty) return appointmentTime;
    return appointmentTime != null
        ? '$dateLabel · $appointmentTime'
        : dateLabel;
  }

  /// Builds the queue/consultation display shape from a raw
  /// `GET /appointments` row.
  factory QueuePatientModel.fromAppointment(AppointmentModel appointment) {
    final bookerName = appointment.patientName?.trim();
    final familyMemberName = appointment.familyMemberName?.trim();
    final isFamilyBooking = familyMemberName?.isNotEmpty ?? false;
    final displayName = isFamilyBooking
        ? familyMemberName!
        : ((bookerName?.isNotEmpty ?? false)
            ? bookerName!
            : (appointment.patientPhone ?? ''));
    return QueuePatientModel(
      id: '${appointment.id}',
      name: displayName,
      initial: displayName.isNotEmpty ? displayName[0] : '؟',
      appointmentTime: appointment.time,
      doctorName: appointment.doctorName,
      status: appointment.status,
      complaint: appointment.complaint,
      diagnosis: appointment.diagnosis,
      date: appointment.date,
      doctorDescription: appointment.doctorDescription,
      doctorExperience: appointment.doctorExperience,
      doctorPrice: appointment.doctorPrice,
      doctorSpecializations: appointment.doctorSpecializations,
      clinicName: appointment.clinicName,
      clinicAddress: appointment.clinicAddress,
      clinicCity: appointment.clinicCity,
      clinicArea: appointment.clinicArea,
      shiftWindow: appointment.shiftWindow,
      bookedByName: isFamilyBooking ? bookerName : null,
      familyMemberName: appointment.familyMemberName,
      familyMemberPhone: appointment.familyMemberPhone,
      familyMemberDob: appointment.familyMemberDob,
      familyMemberIdNumber: appointment.familyMemberIdNumber,
      prescriptionImage: appointment.prescriptionImage,
      startedAt: appointment.startedAt,
      endedAt: appointment.endedAt,
      cancelledAt: appointment.cancelledAt,
      createdAt: appointment.createdAt,
      userId: appointment.userId,
    );
  }

  QueuePatientModel copyWith({String? doneAtLabel, String? status}) =>
      QueuePatientModel(
        id: id,
        name: name,
        initial: initial,
        mrn: mrn,
        appointmentTime: appointmentTime,
        waitMinutes: waitMinutes,
        justArrived: justArrived,
        highlightWait: highlightWait,
        doneAtLabel: doneAtLabel ?? this.doneAtLabel,
        age: age,
        bloodType: bloodType,
        allergy: allergy,
        doctorName: doctorName,
        status: status ?? this.status,
        complaint: complaint,
        diagnosis: diagnosis,
        date: date,
        doctorDescription: doctorDescription,
        doctorExperience: doctorExperience,
        doctorPrice: doctorPrice,
        doctorSpecializations: doctorSpecializations,
        clinicName: clinicName,
        clinicAddress: clinicAddress,
        clinicCity: clinicCity,
        clinicArea: clinicArea,
        shiftWindow: shiftWindow,
        bookedByName: bookedByName,
        familyMemberName: familyMemberName,
        familyMemberPhone: familyMemberPhone,
        familyMemberDob: familyMemberDob,
        familyMemberIdNumber: familyMemberIdNumber,
        prescriptionImage: prescriptionImage,
        startedAt: startedAt,
        endedAt: endedAt,
        cancelledAt: cancelledAt,
        createdAt: createdAt,
        userId: userId,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        initial,
        mrn,
        appointmentTime,
        waitMinutes,
        justArrived,
        highlightWait,
        doneAtLabel,
        age,
        bloodType,
        allergy,
        doctorName,
        status,
        complaint,
        diagnosis,
        date,
        doctorDescription,
        doctorExperience,
        doctorPrice,
        doctorSpecializations,
        clinicName,
        clinicAddress,
        clinicCity,
        clinicArea,
        shiftWindow,
        bookedByName,
        familyMemberName,
        familyMemberPhone,
        familyMemberDob,
        familyMemberIdNumber,
        prescriptionImage,
        startedAt,
        endedAt,
        cancelledAt,
        createdAt,
        userId,
      ];
}
