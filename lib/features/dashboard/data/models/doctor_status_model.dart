import 'package:equatable/equatable.dart';

enum DoctorAvailability { available, inExam, onLeave }

/// One row in the dashboard's "الأطباء الآن" live-status list.
class DoctorStatusModel extends Equatable {
  const DoctorStatusModel({
    required this.name,
    required this.initial,
    required this.specialty,
    required this.branch,
    required this.occupancyPercent,
    required this.availability,
    this.nextSlot,
  });

  final String name;
  final String initial;
  final String specialty;
  final String branch;
  final int occupancyPercent;
  final DoctorAvailability availability;

  /// `null` when the doctor has nothing left on today's schedule.
  final String? nextSlot;

  @override
  List<Object?> get props =>
      [name, initial, specialty, branch, occupancyPercent, availability, nextSlot];
}
