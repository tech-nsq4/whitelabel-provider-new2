import 'models/calendar_day_load_model.dart';
import 'models/calendar_slot_model.dart';

/// TODO(api): mock data until `ApiEndpoints.calendar` exists — the month
/// load and day-slot generators below are deterministic placeholders so
/// the grid always has something plausible to show.
class CalendarRepo {
  Future<List<CalendarDayLoadModel>> getMonthLoad(DateTime month) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return [
      for (var day = 1; day <= daysInMonth; day++)
        if (day % 7 != 3 && day % 7 != 4) _dayLoad(day),
    ];
  }

  CalendarDayLoadModel _dayLoad(int day) {
    final count = 6 + (day * 5) % 18;
    final level = count >= 15
        ? CalendarLoadLevel.busy
        : count >= 9
            ? CalendarLoadLevel.medium
            : CalendarLoadLevel.light;
    return CalendarDayLoadModel(day: day, count: count, level: level);
  }

  Future<List<CalendarSlotModel>> getDaySlots(DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (day.day % 7 == 0) {
      return const [
        CalendarSlotModel(time: '09:15', patientName: 'رهف الدسري', subtitle: 'كشف باطنة · العليا'),
        CalendarSlotModel(time: '09:40', patientName: 'ماجد الغامدي', subtitle: 'متابعة · العليا'),
        CalendarSlotModel(time: '10:00'),
        CalendarSlotModel(time: '10:30', patientName: 'منيرة العتيبي', subtitle: 'كشف باطنة · العليا'),
        CalendarSlotModel(time: '10:45', patientName: 'عبدالله العتيبي', subtitle: 'متابعة · العليا'),
        CalendarSlotModel(time: '11:00', patientName: 'سعد المطيري', subtitle: 'كشف باطنة · العليا'),
        CalendarSlotModel(time: '11:30', patientName: 'وليد الحربي', subtitle: 'فيديو'),
        CalendarSlotModel(time: '12:00'),
        CalendarSlotModel(time: '14:30'),
      ];
    }
    return const [
      CalendarSlotModel(time: '09:00'),
      CalendarSlotModel(time: '09:30', patientName: 'تركي الشهري', subtitle: 'كشف باطنة · العليا'),
      CalendarSlotModel(time: '10:00'),
      CalendarSlotModel(time: '10:30', patientName: 'سارة المحطاني', subtitle: 'كشف أسنان · المرجس'),
      CalendarSlotModel(time: '11:00'),
      CalendarSlotModel(time: '11:30'),
    ];
  }
}
