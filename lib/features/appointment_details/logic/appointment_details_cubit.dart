import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../queue/data/models/appointment_model.dart';
import '../data/appointment_details_repo.dart';

part 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsCubit(this._repo)
      : super(const AppointmentDetailsInitial());

  final AppointmentDetailsRepo _repo;

  Future<void> loadAppointment(String id) async {
    emit(const AppointmentDetailsLoading());
    try {
      final appointment = await _repo.getAppointment(id);
      emit(AppointmentDetailsSuccess(appointment));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(AppointmentDetailsError(msg));
    }
  }
}
