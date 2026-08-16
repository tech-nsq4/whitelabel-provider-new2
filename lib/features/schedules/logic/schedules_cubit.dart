import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/work_schedule_model.dart';
import '../data/schedules_repo.dart';

part 'schedules_state.dart';

class SchedulesCubit extends Cubit<SchedulesState> {
  SchedulesCubit(this._repo) : super(const SchedulesInitial());

  final SchedulesRepo _repo;

  Future<void> loadSchedules() async {
    emit(const SchedulesLoading());
    try {
      final schedules = await _repo.getSchedules();
      emit(SchedulesSuccess(schedules));
    } catch (e) {
      emit(SchedulesError(e.toString()));
    }
  }

  /// Adds a new schedule, or replaces an existing one that shares its id —
  /// used by [NewScheduleSheet]/[ScheduleEditScreen]'s save flow.
  void upsert(WorkScheduleModel model) {
    final current = state;
    if (current is! SchedulesSuccess) return;
    final exists = current.schedules.any((s) => s.id == model.id);
    emit(SchedulesSuccess(exists
        ? [for (final s in current.schedules) if (s.id == model.id) model else s]
        : [...current.schedules, model]));
  }
}
