part of 'calendar_cubit.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object?> get props => [];
}

final class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

final class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

final class CalendarSuccess extends CalendarState {
  final CalendarData data;
  const CalendarSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

final class CalendarError extends CalendarState {
  final String message;
  const CalendarError(this.message);
  @override
  List<Object?> get props => [message];
}
