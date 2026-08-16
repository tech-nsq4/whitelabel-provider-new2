import 'models/analytics_overview_model.dart';

/// TODO(api): mock data until `ApiEndpoints.analytics` exists.
class AnalyticsRepo {
  Future<AnalyticsOverviewModel> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const AnalyticsOverviewModel(
      monthlyRevenue: 128400,
      revenueGrowthPercent: 18,
      newPatients: 146,
      noShowPercent: 8.4,
      videoConsultations: 312,
      videoShareOfBookingsPercent: 24,
      weeklyRevenueBars: [0.52, 0.61, 0.48, 0.70, 0.64, 0.76, 0.69, 0.83, 0.78, 0.88, 0.94, 1.0],
      specialtyShares: [
        SpecialtyShareModel(label: 'باطنة', percent: 38),
        SpecialtyShareModel(label: 'جلدية', percent: 24),
        SpecialtyShareModel(label: 'أسنان', percent: 19),
        SpecialtyShareModel(label: 'أطفال', percent: 19),
      ],
    );
  }
}
