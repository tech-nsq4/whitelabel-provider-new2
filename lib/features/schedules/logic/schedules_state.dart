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
  final List<WorkScheduleModel> schedules;
  const SchedulesSuccess(this.schedules);
  @override
  List<Object?> get props => [schedules];
}

final class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
  @override
  List<Object?> get props => [message];
}
