part of 'patients_cubit.dart';

sealed class PatientsState extends Equatable {
  const PatientsState();

  @override
  List<Object?> get props => [];
}

final class PatientsInitial extends PatientsState {
  const PatientsInitial();
}

final class PatientsLoading extends PatientsState {
  const PatientsLoading();
}

final class PatientsSuccess extends PatientsState {
  final List<PatientListItemModel> patients;
  const PatientsSuccess(this.patients);

  @override
  List<Object?> get props => [patients];
}

final class PatientsError extends PatientsState {
  final String message;
  const PatientsError(this.message);

  @override
  List<Object?> get props => [message];
}
