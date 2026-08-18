import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/service_model.dart';
import '../data/services_repo.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this._repo) : super(const ServicesInitial());

  final ServicesRepo _repo;

  Future<void> loadServices() async {
    emit(const ServicesLoading());
    try {
      final services = await _repo.getServices();
      emit(ServicesSuccess(services));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ServicesError(msg));
    }
  }
}
