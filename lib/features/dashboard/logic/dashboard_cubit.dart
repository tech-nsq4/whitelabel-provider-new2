import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dashboard_repo.dart';
import '../data/models/dashboard_overview_model.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repo) : super(const DashboardInitial());

  final DashboardRepo _repo;

  Future<void> loadOverview() async {
    emit(const DashboardLoading());
    try {
      final overview = await _repo.getOverview();
      emit(DashboardSuccess(overview));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
