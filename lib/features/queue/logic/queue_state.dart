part of 'queue_cubit.dart';

sealed class QueueState extends Equatable {
  const QueueState();

  @override
  List<Object?> get props => [];
}

final class QueueInitial extends QueueState {
  const QueueInitial();
}

final class QueueLoading extends QueueState {
  const QueueLoading();
}

final class QueueSuccess extends QueueState {
  final QueueSnapshotModel snapshot;
  const QueueSuccess(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

final class QueueError extends QueueState {
  final String message;
  const QueueError(this.message);

  @override
  List<Object?> get props => [message];
}
