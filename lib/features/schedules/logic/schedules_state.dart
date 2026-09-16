part of 'schedules_cubit.dart';

sealed class SchedulesState extends Equatable {
  const SchedulesState();
  @override
  List<Object?> get props => [];
}

final class SchedulesInitial extends SchedulesState {
  const SchedulesInitial();
}

final class SchedulesLoading extends SchedulesState {
  const SchedulesLoading();
}

final class SchedulesSuccess extends SchedulesState {
  const SchedulesSuccess(this.doctors);
  final List<DoctorScheduleModel> doctors;
  @override
  List<Object?> get props => [doctors];
}

final class SchedulesError extends SchedulesState {
  const SchedulesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
