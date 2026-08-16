import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/homecare_repo.dart';
import '../data/models/homecare_request_model.dart';

part 'homecare_state.dart';

const _kFallbackDoctor = 'د. رهف الدسري';

class HomecareCubit extends Cubit<HomecareState> {
  HomecareCubit(this._repo) : super(const HomecareInitial());

  final HomecareRepo _repo;

  Future<void> loadRequests() async {
    emit(const HomecareLoading());
    try {
      final requests = await _repo.getRequests();
      emit(HomecareSuccess(requests));
    } catch (e) {
      emit(HomecareError(e.toString()));
    }
  }

  void assign(String id, {String doctor = _kFallbackDoctor}) {
    final current = state;
    if (current is! HomecareSuccess) return;
    emit(HomecareSuccess([
      for (final r in current.requests)
        if (r.id == id) r.copyWith(assignedDoctor: doctor) else r,
    ]));
  }
}
