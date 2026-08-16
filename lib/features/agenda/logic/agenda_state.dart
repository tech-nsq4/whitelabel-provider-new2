part of 'agenda_cubit.dart';

sealed class AgendaState extends Equatable {
  const AgendaState();
  @override
  List<Object?> get props => [];
}

final class AgendaInitial extends AgendaState {
  const AgendaInitial();
}

final class AgendaLoading extends AgendaState {
  const AgendaLoading();
}

final class AgendaSuccess extends AgendaState {
  final List<AgendaSlotModel> slots;
  const AgendaSuccess(this.slots);
  @override
  List<Object?> get props => [slots];
}

final class AgendaError extends AgendaState {
  final String message;
  const AgendaError(this.message);
  @override
  List<Object?> get props => [message];
}
