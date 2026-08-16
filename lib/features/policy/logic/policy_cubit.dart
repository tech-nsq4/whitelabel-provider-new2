import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/policy_settings_model.dart';
import '../data/policy_repo.dart';

part 'policy_state.dart';

class PolicyCubit extends Cubit<PolicyState> {
  PolicyCubit(this._repo) : super(const PolicyInitial());

  final PolicyRepo _repo;

  Future<void> loadSettings() async {
    emit(const PolicyLoading());
    try {
      final settings = await _repo.getSettings();
      emit(PolicySuccess(settings));
    } catch (e) {
      emit(PolicyError(e.toString()));
    }
  }

  void toggleCancellation() => _update((s) => s.copyWith(allowCancellation: !s.allowCancellation));
  void toggleReschedule() => _update((s) => s.copyWith(allowReschedule: !s.allowReschedule));
  void toggleAutoRefund() => _update((s) => s.copyWith(autoRefund: !s.autoRefund));
  void toggleReminderDayBefore() =>
      _update((s) => s.copyWith(reminderDayBefore: !s.reminderDayBefore));
  void toggleReminderHourBefore() =>
      _update((s) => s.copyWith(reminderHourBefore: !s.reminderHourBefore));
  void toggleCheckinRequest() => _update((s) => s.copyWith(checkinRequest: !s.checkinRequest));
  void toggleVideoPrepayment() => _update((s) => s.copyWith(videoPrepayment: !s.videoPrepayment));

  Future<void> save() async {
    final current = state;
    if (current is! PolicySuccess) return;
    await _repo.saveSettings(current.settings);
  }

  void _update(PolicySettingsModel Function(PolicySettingsModel) transform) {
    final current = state;
    if (current is! PolicySuccess) return;
    emit(PolicySuccess(transform(current.settings)));
  }
}
