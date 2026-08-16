part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  final DashboardOverviewModel overview;
  const DashboardSuccess(this.overview);

  @override
  List<Object?> get props => [overview];
}

final class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
