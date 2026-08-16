import 'package:equatable/equatable.dart';

enum BookingStatus { paid, confirmed, pendingPayment }

/// One row in the dashboard's "آخر الحجوزات" list.
class RecentBookingModel extends Equatable {
  const RecentBookingModel({
    required this.patientName,
    required this.serviceLabel,
    required this.subLabel,
    required this.status,
    this.isVideo = false,
  });

  final String patientName;
  final String serviceLabel;

  /// Branch/doctor + time line under the service label.
  final String subLabel;
  final BookingStatus status;

  /// Picks the video-camera icon instead of the calendar icon.
  final bool isVideo;

  @override
  List<Object?> get props => [patientName, serviceLabel, subLabel, status, isVideo];
}
