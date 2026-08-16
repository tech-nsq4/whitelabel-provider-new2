import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/branches_repo.dart';
import '../data/models/location_model.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit(this._repo) : super(const BranchesInitial());

  final BranchesRepo _repo;

  Future<void> loadLocations() async {
    emit(const BranchesLoading());
    try {
      final locations = await _repo.getLocations();
      emit(BranchesSuccess(locations));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(BranchesError(msg));
    }
  }
}
