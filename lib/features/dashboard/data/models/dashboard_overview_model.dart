import 'package:equatable/equatable.dart';

import 'dashboard_stats_model.dart';
import 'doctor_status_model.dart';
import 'recent_booking_model.dart';

/// Everything the "Today" dashboard renders, fetched in one call.
class DashboardOverviewModel extends Equatable {
  const DashboardOverviewModel({
    required this.stats,
    required this.doctors,
    required this.recentBookings,
  });

  final DashboardStatsModel stats;
  final List<DoctorStatusModel> doctors;
  final List<RecentBookingModel> recentBookings;

  @override
  List<Object?> get props => [stats, doctors, recentBookings];
}
