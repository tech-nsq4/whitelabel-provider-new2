import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/calendar_repo.dart';
import 'calendar_data.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(this._repo) : super(const CalendarInitial());

  final CalendarRepo _repo;

  Future<void> load([DateTime? initialDay]) async {
    emit(const CalendarLoading());
    try {
      final today = initialDay ?? DateTime.now();
      final month = DateTime(today.year, today.month);
      final monthLoad = await _repo.getMonthLoad(month);
      final daySlots = await _repo.getDaySlots(today);
      emit(CalendarSuccess(CalendarData(
        month: month,
        selectedDay: today,
        monthLoad: monthLoad,
        daySlots: daySlots,
      )));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  Future<void> changeMonth(int delta) async {
    final current = state;
    if (current is! CalendarSuccess) return;
    final next = DateTime(current.data.month.year, current.data.month.month + delta);
    final monthLoad = await _repo.getMonthLoad(next);
    emit(CalendarSuccess(current.data.copyWith(month: next, monthLoad: monthLoad)));
  }

  Future<void> selectDay(DateTime day) async {
    final current = state;
    if (current is! CalendarSuccess) return;
    final slots = await _repo.getDaySlots(day);
    emit(CalendarSuccess(current.data.copyWith(selectedDay: day, daySlots: slots)));
  }

  void setDoctorFilter(String filter) {
    final current = state;
    if (current is! CalendarSuccess) return;
    emit(CalendarSuccess(current.data.copyWith(doctorFilter: filter)));
  }
}
