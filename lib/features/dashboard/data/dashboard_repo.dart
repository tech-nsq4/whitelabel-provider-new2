import 'models/dashboard_overview_model.dart';
import 'models/dashboard_stats_model.dart';
import 'models/doctor_status_model.dart';
import 'models/recent_booking_model.dart';

/// Reads the "Today" dashboard's stats, live doctor status and recent
/// bookings.
///
/// TODO(api): mock data until `ApiEndpoints.dashboard` exists — swap this
/// body for a real `DioClient.get` call and keep the same return shape so
/// [DashboardCubit] doesn't need to change.
class DashboardRepo {
  Future<DashboardOverviewModel> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const DashboardOverviewModel(
      stats: DashboardStatsModel(
        appointmentsTotal: 42,
        appointmentsOnline: 14,
        appointmentsClinic: 28,
        newBookings: 9,
        waitingCount: 4,
        waitingAvgMinutes: 14,
        pendingResults: 4,
        pendingResultsCritical: 1,
      ),
      doctors: [
        DoctorStatusModel(
          name: 'د. خالد العتيبي',
          initial: 'خ',
          specialty: 'باطنة',
          branch: 'العليا',
          occupancyPercent: 92,
          availability: DoctorAvailability.inExam,
          nextSlot: '11:00 ص',
        ),
        DoctorStatusModel(
          name: 'د. رهف الدسري',
          initial: 'ر',
          specialty: 'جراحة',
          branch: 'المرجس',
          occupancyPercent: 64,
          availability: DoctorAvailability.available,
          nextSlot: '10:40 ص',
        ),
        DoctorStatusModel(
          name: 'د. سارة المحطاني',
          initial: 'س',
          specialty: 'أسنان',
          branch: 'العليا',
          occupancyPercent: 78,
          availability: DoctorAvailability.inExam,
          nextSlot: '11:30 ص',
        ),
        DoctorStatusModel(
          name: 'د. وليد الشهري',
          initial: 'و',
          specialty: 'أطفال',
          branch: 'الياسمين',
          occupancyPercent: 0,
          availability: DoctorAvailability.onLeave,
        ),
      ],
      recentBookings: [
        RecentBookingModel(
          patientName: 'وليد الحربي',
          serviceLabel: 'استشارة فيديو',
          subLabel: 'د. خالد · 11:30 ص',
          status: BookingStatus.paid,
          isVideo: true,
        ),
        RecentBookingModel(
          patientName: 'سارة المحطاني',
          serviceLabel: 'كشف أسنان',
          subLabel: 'المرجس · غدًا 4:00 م',
          status: BookingStatus.confirmed,
        ),
        RecentBookingModel(
          patientName: 'تركي الشهري',
          serviceLabel: 'كشف باطنة',
          subLabel: 'العليا · غدًا 10:00 ص',
          status: BookingStatus.pendingPayment,
        ),
      ],
    );
  }
}
