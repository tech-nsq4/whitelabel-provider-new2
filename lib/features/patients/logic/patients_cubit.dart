import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/patient_list_item_model.dart';
import '../data/patients_repo.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  PatientsCubit(this._repo) : super(const PatientsInitial());

  final PatientsRepo _repo;
  Timer? _searchDebounce;
  String _query = '';

  Future<void> loadPatients() async {
    if (state is! PatientsSuccess) emit(const PatientsLoading());
    await _fetch();
  }

  void search(String query) {
    _query = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(AppConstants.searchDebounceDuration, _fetch);
  }

  Future<void> _fetch() async {
    final query = _query;
    try {
      final patients = await _repo.getPatients(query: query);
      if (query != _query) return;
      emit(PatientsSuccess(patients));
    } catch (e) {
      if (query != _query) return;
      final msg = e is NetworkException ? e.message : e.toString();
      if (state is PatientsSuccess) {
        AppOverlay.showError(msg);
      } else {
        emit(PatientsError(msg));
      }
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
