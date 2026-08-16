import 'package:equatable/equatable.dart';

/// One time slot on the selected day's list — either booked or open.
class CalendarSlotModel extends Equatable {
  const CalendarSlotModel({
    required this.time,
    this.patientName,
    this.subtitle,
  });

  final String time;

  /// `null` means the slot is open.
  final String? patientName;
  final String? subtitle;

  bool get isAvailable => patientName == null;

  @override
  List<Object?> get props => [time, patientName, subtitle];
}
