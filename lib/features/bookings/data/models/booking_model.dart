import 'package:equatable/equatable.dart';

enum BookingStatus { paid, confirmed, pendingPayment }

enum BookingDayGroup { today, tomorrow }

/// One row on the bookings screen — a patient-made appointment request.
class BookingModel extends Equatable {
  const BookingModel({
    required this.id,
    required this.patientName,
    required this.serviceLabel,
    required this.subLabel,
    required this.price,
    required this.status,
    required this.dayGroup,
    this.isVideo = false,
  });

  final String id;
  final String patientName;
  final String serviceLabel;

  /// Branch/doctor + time line.
  final String subLabel;
  final int price;
  final BookingStatus status;
  final BookingDayGroup dayGroup;
  final bool isVideo;

  @override
  List<Object?> get props =>
      [id, patientName, serviceLabel, subLabel, price, status, dayGroup, isVideo];
}
