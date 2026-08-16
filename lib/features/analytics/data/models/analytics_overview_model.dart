import 'package:equatable/equatable.dart';

/// One specialty's share of bookings, for the breakdown bars.
class SpecialtyShareModel extends Equatable {
  const SpecialtyShareModel({required this.label, required this.percent});

  final String label;
  final int percent;

  @override
  List<Object?> get props => [label, percent];
}

/// Everything the "التقارير الإدارية" screen renders.
class AnalyticsOverviewModel extends Equatable {
  const AnalyticsOverviewModel({
    required this.monthlyRevenue,
    required this.revenueGrowthPercent,
    required this.newPatients,
    required this.noShowPercent,
    required this.videoConsultations,
    required this.videoShareOfBookingsPercent,
    required this.weeklyRevenueBars,
    required this.specialtyShares,
  });

  final int monthlyRevenue;
  final int revenueGrowthPercent;
  final int newPatients;
  final double noShowPercent;
  final int videoConsultations;
  final int videoShareOfBookingsPercent;

  /// Relative bar heights (0–1) for the last 12 weeks.
  final List<double> weeklyRevenueBars;
  final List<SpecialtyShareModel> specialtyShares;

  @override
  List<Object?> get props => [
        monthlyRevenue,
        revenueGrowthPercent,
        newPatients,
        noShowPercent,
        videoConsultations,
        videoShareOfBookingsPercent,
        weeklyRevenueBars,
        specialtyShares,
      ];
}
