part of 'branches_cubit.dart';

sealed class BranchesState extends Equatable {
  const BranchesState();
  @override
  List<Object?> get props => [];
}

final class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

final class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

final class BranchesSuccess extends BranchesState {
  final List<LocationModel> locations;
  const BranchesSuccess(this.locations);
  @override
  List<Object?> get props => [locations];
}

final class BranchesError extends BranchesState {
  final String message;
  const BranchesError(this.message);
  @override
  List<Object?> get props => [message];
}
