import 'package:equatable/equatable.dart';

/// The four stat tiles at the top of the "Today" dashboard — the `stats`
/// object of `GET /home`.
class DashboardStatsModel extends Equatable {
  const DashboardStatsModel({
    this.todayAppointments = 0,
    this.newBookings = 0,
    this.waiting = 0,
    this.pendingResults = 0,
  });

  final int todayAppointments;
  final int newBookings;
  final int waiting;
  final int pendingResults;

  factory DashboardStatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DashboardStatsModel();
    return DashboardStatsModel(
      todayAppointments: json['today_appointments'] as int? ?? 0,
      newBookings: json['new_bookings'] as int? ?? 0,
      waiting: json['waiting'] as int? ?? 0,
      pendingResults: json['pending_results'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [todayAppointments, newBookings, waiting, pendingResults];
}
