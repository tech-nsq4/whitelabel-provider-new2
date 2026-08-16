part of 'services_cubit.dart';

sealed class ServicesState extends Equatable {
  const ServicesState();
  @override
  List<Object?> get props => [];
}

final class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

final class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

final class ServicesSuccess extends ServicesState {
  final List<ServiceModel> services;
  const ServicesSuccess(this.services);
  @override
  List<Object?> get props => [services];
}

final class ServicesError extends ServicesState {
  final String message;
  const ServicesError(this.message);
  @override
  List<Object?> get props => [message];
}
