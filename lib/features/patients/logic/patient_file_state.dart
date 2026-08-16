part of 'patient_file_cubit.dart';

sealed class PatientFileState extends Equatable {
  const PatientFileState();

  @override
  List<Object?> get props => [];
}

final class PatientFileInitial extends PatientFileState {
  const PatientFileInitial();
}

final class PatientFileLoading extends PatientFileState {
  const PatientFileLoading();
}

final class PatientFileSuccess extends PatientFileState {
  final PatientFileData data;
  const PatientFileSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class PatientFileError extends PatientFileState {
  final String message;
  const PatientFileError(this.message);

  @override
  List<Object?> get props => [message];
}
