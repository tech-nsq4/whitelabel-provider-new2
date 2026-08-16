import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/inbox_repo.dart';
import '../data/models/pending_result_model.dart';

part 'inbox_state.dart';

class InboxCubit extends Cubit<InboxState> {
  InboxCubit(this._repo) : super(const InboxInitial());

  final InboxRepo _repo;

  Future<void> loadPending() async {
    emit(const InboxLoading());
    try {
      final results = await _repo.getPending();
      emit(InboxSuccess(results));
    } catch (e) {
      emit(InboxError(e.toString()));
    }
  }

  /// Signs off a result — removes it from the queue once approved.
  void approve(String id) {
    final current = state;
    if (current is! InboxSuccess) return;
    emit(InboxSuccess(current.results.where((r) => r.id != id).toList()));
  }
}
