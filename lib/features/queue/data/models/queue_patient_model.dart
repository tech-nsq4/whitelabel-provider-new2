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
    final name = appointment.patientName?.trim();
    final displayName =
        (name?.isNotEmpty ?? false) ? name! : (appointment.patientPhone ?? '');
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
      ];
}
