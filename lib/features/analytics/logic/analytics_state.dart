part of 'analytics_cubit.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsSuccess extends AnalyticsState {
  final AnalyticsOverviewModel overview;
  const AnalyticsSuccess(this.overview);
  @override
  List<Object?> get props => [overview];
}

final class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);
  @override
  List<Object?> get props => [message];
}
