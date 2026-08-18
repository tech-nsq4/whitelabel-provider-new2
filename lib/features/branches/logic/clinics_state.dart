part of 'clinics_cubit.dart';

sealed class ClinicsState extends Equatable {
  const ClinicsState();
  @override
  List<Object?> get props => [];
}

final class ClinicsInitial extends ClinicsState {
  const ClinicsInitial();
}

final class ClinicsLoading extends ClinicsState {
  const ClinicsLoading();
}

final class ClinicsSuccess extends ClinicsState {
  final List<ClinicModel> clinics;
  const ClinicsSuccess(this.clinics);
  @override
  List<Object?> get props => [clinics];
}

final class ClinicsError extends ClinicsState {
  final String message;
  const ClinicsError(this.message);
  @override
  List<Object?> get props => [message];
}
