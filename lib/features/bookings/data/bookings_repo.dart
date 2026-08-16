import 'models/booking_model.dart';

/// TODO(api): mock data until `ApiEndpoints.bookings` exists.
class BookingsRepo {
  Future<List<BookingModel>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      BookingModel(
        id: 'bk-1',
        patientName: 'وليد الحربي',
        serviceLabel: 'استشارة فيديو',
        subLabel: 'د. خالد · 11:30 ص',
        price: 80,
        status: BookingStatus.paid,
        dayGroup: BookingDayGroup.today,
        isVideo: true,
      ),
      BookingModel(
        id: 'bk-2',
        patientName: 'منيرة العتيبي',
        serviceLabel: 'كشف باطنة',
        subLabel: 'العليا · 10:30 ص',
        price: 150,
        status: BookingStatus.confirmed,
        dayGroup: BookingDayGroup.today,
      ),
      BookingModel(
        id: 'bk-3',
        patientName: 'تركي الشهري',
        serviceLabel: 'كشف باطنة',
        subLabel: 'العليا · 10:00 ص',
        price: 150,
        status: BookingStatus.pendingPayment,
        dayGroup: BookingDayGroup.tomorrow,
      ),
      BookingModel(
        id: 'bk-4',
        patientName: 'سارة المحطاني',
        serviceLabel: 'كشف أسنان',
        subLabel: 'المرجس · 4:00 م',
        price: 200,
        status: BookingStatus.confirmed,
        dayGroup: BookingDayGroup.tomorrow,
      ),
      BookingModel(
        id: 'bk-5',
        patientName: 'عبدالعزيز الحمدان',
        serviceLabel: 'استشارة فورية',
        subLabel: 'د. رهف · 6:00 م',
        price: 100,
        status: BookingStatus.paid,
        dayGroup: BookingDayGroup.tomorrow,
        isVideo: true,
      ),
      BookingModel(
        id: 'bk-6',
        patientName: 'ماجد العتيبي',
        serviceLabel: 'فحص شامل',
        subLabel: 'العليا · 8:00 ص',
        price: 299,
        status: BookingStatus.pendingPayment,
        dayGroup: BookingDayGroup.tomorrow,
      ),
    ];
  }
}
