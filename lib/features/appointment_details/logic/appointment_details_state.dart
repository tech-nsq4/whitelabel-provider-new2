part of 'appointment_details_cubit.dart';

sealed class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();
  @override
  List<Object?> get props => [];
}

final class AppointmentDetailsInitial extends AppointmentDetailsState {
  const AppointmentDetailsInitial();
}

final class AppointmentDetailsLoading extends AppointmentDetailsState {
  const AppointmentDetailsLoading();
}

final class AppointmentDetailsSuccess extends AppointmentDetailsState {
  final AppointmentModel appointment;
  const AppointmentDetailsSuccess(this.appointment);
  @override
  List<Object?> get props => [appointment];
}

final class AppointmentDetailsError extends AppointmentDetailsState {
  final String message;
  const AppointmentDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
