import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(ServicesError(e.toString()));
    }
  }

  void toggle(String id) {
    final current = state;
    if (current is! ServicesSuccess) return;
    emit(ServicesSuccess([
      for (final s in current.services)
        if (s.id == id) s.copyWith(enabled: !s.enabled) else s,
    ]));
  }

  /// Adds a new service, or replaces an existing one that shares its id —
  /// used by [ServiceEditSheet]'s add/edit flow.
  void upsert(ServiceModel model) {
    final current = state;
    if (current is! ServicesSuccess) return;
    final exists = current.services.any((s) => s.id == model.id);
    emit(ServicesSuccess(exists
        ? [for (final s in current.services) if (s.id == model.id) model else s]
        : [...current.services, model]));
  }
}
