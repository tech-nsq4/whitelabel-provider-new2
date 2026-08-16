import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(StaffError(e.toString()));
    }
  }

  /// Adds a new doctor, or replaces an existing one that shares its name —
  /// used by [DoctorEditSheet]'s add/edit flow.
  void upsert(DoctorProfileModel model, {String? previousName}) {
    final current = state;
    if (current is! StaffSuccess) return;
    final matchName = previousName ?? model.name;
    final exists = current.doctors.any((d) => d.name == matchName);
    emit(StaffSuccess(exists
        ? [for (final d in current.doctors) if (d.name == matchName) model else d]
        : [...current.doctors, model]));
  }
}
