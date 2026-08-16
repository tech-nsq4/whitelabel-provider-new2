import 'package:equatable/equatable.dart';

import '../data/models/calendar_day_load_model.dart';
import '../data/models/calendar_slot_model.dart';

class CalendarData extends Equatable {
  const CalendarData({
    required this.month,
    required this.selectedDay,
    required this.monthLoad,
    required this.daySlots,
    this.doctorFilter = 'all',
  });

  final DateTime month;
  final DateTime selectedDay;
  final List<CalendarDayLoadModel> monthLoad;
  final List<CalendarSlotModel> daySlots;
  final String doctorFilter;

  CalendarData copyWith({
    DateTime? month,
    DateTime? selectedDay,
    List<CalendarDayLoadModel>? monthLoad,
    List<CalendarSlotModel>? daySlots,
    String? doctorFilter,
  }) =>
      CalendarData(
        month: month ?? this.month,
        selectedDay: selectedDay ?? this.selectedDay,
        monthLoad: monthLoad ?? this.monthLoad,
        daySlots: daySlots ?? this.daySlots,
        doctorFilter: doctorFilter ?? this.doctorFilter,
      );

  @override
  List<Object?> get props => [month, selectedDay, monthLoad, daySlots, doctorFilter];
}
