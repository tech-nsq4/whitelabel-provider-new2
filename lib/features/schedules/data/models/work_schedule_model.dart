import 'package:equatable/equatable.dart';

enum WorkScheduleMode { clinic, online, home }

/// One row on "جداول العمل" — a doctor × service-mode combination.
class WorkScheduleModel extends Equatable {
  const WorkScheduleModel({
    required this.id,
    required this.doctorName,
    required this.doctorInitial,
    required this.mode,
    required this.note,
    required this.daysLabel,
    required this.hoursLabel,
    required this.slotCount,
    required this.unitLabel,
  });

  final String id;
  final String doctorName;
  final String doctorInitial;
  final WorkScheduleMode mode;

  /// Branch name (clinic) or coverage note (online/home).
  final String note;
  final String daysLabel;
  final String hoursLabel;
  final int slotCount;
  final String unitLabel;

  @override
  List<Object?> get props =>
      [id, doctorName, doctorInitial, mode, note, daysLabel, hoursLabel, slotCount, unitLabel];
}
