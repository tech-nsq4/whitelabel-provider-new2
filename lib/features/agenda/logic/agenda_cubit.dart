import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/agenda_repo.dart';
import '../data/models/agenda_slot_model.dart';

part 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  AgendaCubit(this._repo) : super(const AgendaInitial());

  final AgendaRepo _repo;

  Future<void> loadToday() async {
    emit(const AgendaLoading());
    try {
      final slots = await _repo.getToday();
      emit(AgendaSuccess(slots));
    } catch (e) {
      emit(AgendaError(e.toString()));
    }
  }
}
