import 'package:equatable/equatable.dart';

import '../../../queue/data/models/appointment_model.dart';
import '../../../staff/data/models/doctor_profile_model.dart';
import 'dashboard_stats_model.dart';

/// Everything the "Today" dashboard renders, fetched in one call from
/// `GET /home`. Doctors and bookings reuse the same models their own
/// features already parse `/doctors` and `/appointments` rows into.
class DashboardOverviewModel extends Equatable {
  const DashboardOverviewModel({
    this.date,
    this.stats = const DashboardStatsModel(),
    this.doctors = const [],
    this.recentAppointments = const [],
  });

  final String? date;
  final DashboardStatsModel stats;
  final List<DoctorProfileModel> doctors;
  final List<AppointmentModel> recentAppointments;

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) =>
      DashboardOverviewModel(
        date: json['date'] as String?,
        stats: DashboardStatsModel.fromJson(json['stats'] as Map<String, dynamic>?),
        doctors: [
          for (final row in (json['doctors_today'] as List? ?? []))
            DoctorProfileModel.fromJson(row as Map<String, dynamic>),
        ],
        recentAppointments: [
          for (final row in (json['recent_appointments'] as List? ?? []))
            AppointmentModel.fromJson(row as Map<String, dynamic>),
        ],
      );

  @override
  List<Object?> get props => [date, stats, doctors, recentAppointments];
}
