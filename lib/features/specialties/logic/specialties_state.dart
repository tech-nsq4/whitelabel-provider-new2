part of 'specialties_cubit.dart';

sealed class SpecialtiesState extends Equatable {
  const SpecialtiesState();
  @override
  List<Object?> get props => [];
}

final class SpecialtiesInitial extends SpecialtiesState {
  const SpecialtiesInitial();
}

final class SpecialtiesLoading extends SpecialtiesState {
  const SpecialtiesLoading();
}

final class SpecialtiesSuccess extends SpecialtiesState {
  final List<SpecialtyModel> specialties;
  const SpecialtiesSuccess(this.specialties);
  @override
  List<Object?> get props => [specialties];
}

final class SpecialtiesError extends SpecialtiesState {
  final String message;
  const SpecialtiesError(this.message);
  @override
  List<Object?> get props => [message];
}
