part of 'inbox_cubit.dart';

sealed class InboxState extends Equatable {
  const InboxState();
  @override
  List<Object?> get props => [];
}

final class InboxInitial extends InboxState {
  const InboxInitial();
}

final class InboxLoading extends InboxState {
  const InboxLoading();
}

final class InboxSuccess extends InboxState {
  final List<PendingResultModel> results;
  const InboxSuccess(this.results);
  @override
  List<Object?> get props => [results];
}

final class InboxError extends InboxState {
  final String message;
  const InboxError(this.message);
  @override
  List<Object?> get props => [message];
}
