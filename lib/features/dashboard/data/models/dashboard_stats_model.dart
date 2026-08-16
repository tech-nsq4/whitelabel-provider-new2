import 'package:equatable/equatable.dart';

/// The four stat tiles at the top of the "Today" dashboard.
class DashboardStatsModel extends Equatable {
  const DashboardStatsModel({
    required this.appointmentsTotal,
    required this.appointmentsOnline,
    required this.appointmentsClinic,
    required this.newBookings,
    required this.waitingCount,
    required this.waitingAvgMinutes,
    required this.pendingResults,
    required this.pendingResultsCritical,
  });

  final int appointmentsTotal;
  final int appointmentsOnline;
  final int appointmentsClinic;
  final int newBookings;
  final int waitingCount;
  final int waitingAvgMinutes;
  final int pendingResults;
  final int pendingResultsCritical;

  @override
  List<Object?> get props => [
        appointmentsTotal,
        appointmentsOnline,
        appointmentsClinic,
        newBookings,
        waitingCount,
        waitingAvgMinutes,
        pendingResults,
        pendingResultsCritical,
      ];
}
