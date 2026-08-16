part of 'policy_cubit.dart';

sealed class PolicyState extends Equatable {
  const PolicyState();
  @override
  List<Object?> get props => [];
}

final class PolicyInitial extends PolicyState {
  const PolicyInitial();
}

final class PolicyLoading extends PolicyState {
  const PolicyLoading();
}

final class PolicySuccess extends PolicyState {
  final PolicySettingsModel settings;
  const PolicySuccess(this.settings);
  @override
  List<Object?> get props => [settings];
}

final class PolicyError extends PolicyState {
  final String message;
  const PolicyError(this.message);
  @override
  List<Object?> get props => [message];
}
