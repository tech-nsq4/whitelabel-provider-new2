part of 'consultation_cubit.dart';

sealed class ConsultationState extends Equatable {
  const ConsultationState();

  @override
  List<Object?> get props => [];
}

final class ConsultationInitial extends ConsultationState {
  const ConsultationInitial();
}

final class ConsultationLoading extends ConsultationState {
  const ConsultationLoading();
}

final class ConsultationSuccess extends ConsultationState {
  final ConsultationData data;
  const ConsultationSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class ConsultationError extends ConsultationState {
  final String message;
  const ConsultationError(this.message);

  @override
  List<Object?> get props => [message];
}
