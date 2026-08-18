import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/doctor_profile_model.dart';
import '../data/staff_repo.dart';

part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit(this._repo) : super(const StaffInitial());

  final StaffRepo _repo;

  Future<void> loadDoctors() async {
    emit(const StaffLoading());
    try {
      final doctors = await _repo.getDoctors();
      emit(StaffSuccess(doctors));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(StaffError(msg));
    }
  }
}
