import 'package:equatable/equatable.dart';

enum AgendaSlotStatus { done, arrived, notArrived, paid, confirmed }

/// One row in "جدول اليوم" — a booked slot on today's schedule.
class AgendaSlotModel extends Equatable {
  const AgendaSlotModel({
    required this.id,
    required this.time,
    required this.patientName,
    required this.patientInitial,
    required this.mrn,
    required this.subtitle,
    required this.status,
  });

  final String id;
  final String time;
  final String patientName;
  final String patientInitial;
  final String mrn;

  /// Service type + branch/doctor line.
  final String subtitle;
  final AgendaSlotStatus status;

  @override
  List<Object?> get props => [id, time, patientName, patientInitial, mrn, subtitle, status];
}
