import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/doctor_schedule_model.dart';
import '../data/schedules_repo.dart';

part 'schedules_state.dart';

class SchedulesCubit extends Cubit<SchedulesState> {
  SchedulesCubit(this._repo) : super(const SchedulesInitial());

  final SchedulesRepo _repo;

  Future<void> loadSchedules() async {
    emit(const SchedulesLoading());
    try {
      final doctors = await _repo.getDoctorTimes();
      emit(SchedulesSuccess(doctors));
    } catch (e) {
      emit(SchedulesError(e is NetworkException ? e.message : e.toString()));
    }
  }
}
