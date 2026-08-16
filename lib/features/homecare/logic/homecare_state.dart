part of 'homecare_cubit.dart';

sealed class HomecareState extends Equatable {
  const HomecareState();
  @override
  List<Object?> get props => [];
}

final class HomecareInitial extends HomecareState {
  const HomecareInitial();
}

final class HomecareLoading extends HomecareState {
  const HomecareLoading();
}

final class HomecareSuccess extends HomecareState {
  final List<HomecareRequestModel> requests;
  const HomecareSuccess(this.requests);
  @override
  List<Object?> get props => [requests];
}

final class HomecareError extends HomecareState {
  final String message;
  const HomecareError(this.message);
  @override
  List<Object?> get props => [message];
}
