import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/analytics_repo.dart';
import '../data/models/analytics_overview_model.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._repo) : super(const AnalyticsInitial());

  final AnalyticsRepo _repo;

  Future<void> loadOverview() async {
    emit(const AnalyticsLoading());
    try {
      final overview = await _repo.getOverview();
      emit(AnalyticsSuccess(overview));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
