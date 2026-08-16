part of 'docs_cubit.dart';

sealed class DocsState extends Equatable {
  const DocsState();
  @override
  List<Object?> get props => [];
}

final class DocsInitial extends DocsState {
  const DocsInitial();
}

final class DocsLoading extends DocsState {
  const DocsLoading();
}

final class DocsSuccess extends DocsState {
  final List<DocumentRecordModel> docs;
  const DocsSuccess(this.docs);
  @override
  List<Object?> get props => [docs];
}

final class DocsError extends DocsState {
  final String message;
  const DocsError(this.message);
  @override
  List<Object?> get props => [message];
}
