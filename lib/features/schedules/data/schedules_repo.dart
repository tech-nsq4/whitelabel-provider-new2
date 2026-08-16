import 'models/work_schedule_model.dart';

/// TODO(api): mock data until `ApiEndpoints.schedules` exists.
class SchedulesRepo {
  Future<List<WorkScheduleModel>> getSchedules() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      WorkScheduleModel(
        id: 'sc-1',
        doctorName: 'د. خالد العتيبي',
        doctorInitial: 'خ',
        mode: WorkScheduleMode.clinic,
        note: 'فرع العليا',
        daysLabel: 'سبت — أربعاء',
        hoursLabel: '09:00 — 17:00',
        slotCount: 21,
        unitLabel: 'موعد/يوم',
      ),
      WorkScheduleModel(
        id: 'sc-2',
        doctorName: 'د. خالد العتيبي',
        doctorInitial: 'خ',
        mode: WorkScheduleMode.online,
        note: 'استشارة فيديو',
        daysLabel: 'أحد — خميس',
        hoursLabel: '19:00 — 22:00',
        slotCount: 12,
        unitLabel: 'جلسة/يوم',
      ),
      WorkScheduleModel(
        id: 'sc-3',
        doctorName: 'د. رهف الدسري',
        doctorInitial: 'ر',
        mode: WorkScheduleMode.clinic,
        note: 'فرع المرجس',
        daysLabel: 'سبت — خميس',
        hoursLabel: '10:00 — 18:00',
        slotCount: 21,
        unitLabel: 'موعد/يوم',
      ),
      WorkScheduleModel(
        id: 'sc-4',
        doctorName: 'د. رهف الدسري',
        doctorInitial: 'ر',
        mode: WorkScheduleMode.home,
        note: 'العليا والمرجس',
        daysLabel: 'سبت — أربعاء',
        hoursLabel: '16:00 — 21:00',
        slotCount: 6,
        unitLabel: 'زيارة/يوم',
      ),
      WorkScheduleModel(
        id: 'sc-5',
        doctorName: 'د. سارة المحطاني',
        doctorInitial: 'س',
        mode: WorkScheduleMode.clinic,
        note: 'فرع العليا',
        daysLabel: 'أحد — خميس',
        hoursLabel: '09:00 — 16:00',
        slotCount: 14,
        unitLabel: 'موعد/يوم',
      ),
    ];
  }
}
