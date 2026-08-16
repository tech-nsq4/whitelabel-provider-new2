import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../../queue/logic/queue_cubit.dart';
import '../data/consultation_repo.dart';
import '../data/models/consultation_draft_model.dart';
import '../data/models/prescription_entry_model.dart';
import 'consultation_data.dart';

part 'consultation_state.dart';

class ConsultationCubit extends Cubit<ConsultationState> {
  ConsultationCubit(this._repo, this._queueCubit)
      : super(const ConsultationInitial());

  final ConsultationRepo _repo;

  /// The shared queue singleton — finishing a visit here moves the patient
  /// from "في الغرفة" to "انتهى" over there too.
  final QueueCubit _queueCubit;

  Future<void> load(QueuePatientModel patient) async {
    emit(const ConsultationLoading());
    try {
      final historyFuture = _repo.getHistory(patient.id);
      final analysesFuture = _repo.getAnalyses();
      final xraysFuture = _repo.getXrays();
      final draft = _repo.getDraft(patient.id);
      emit(ConsultationSuccess(ConsultationData(
        patient: patient,
        history: await historyFuture,
        analysisOptions: await analysesFuture,
        xrayOptions: await xraysFuture,
        prescriptions: draft?.prescriptions ?? const [],
        selectedAnalysisIds:
            draft != null ? draft.analysisIds.toSet() : const {},
        selectedXrayIds: draft != null ? draft.xrayIds.toSet() : const {},
        complaint: draft?.complaint ?? '',
        diagnosis: draft?.diagnosis ?? '',
      )));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ConsultationError(msg));
    }
  }

  void setTab(int index) => _update((d) => d.copyWith(tabIndex: index));

  void addPrescription() => _update((d) => d.copyWith(prescriptions: [
        ...d.prescriptions,
        PrescriptionEntryModel(
            id: 'rx-${DateTime.now().microsecondsSinceEpoch}'),
      ]));

  void removePrescription(String id) => _update((d) => d.copyWith(
      prescriptions: d.prescriptions.where((p) => p.id != id).toList()));

  void updatePrescription(String id,
          {String? name, String? dose, String? duration}) =>
      _update((d) => d.copyWith(
            prescriptions: [
              for (final p in d.prescriptions)
                if (p.id == id)
                  p.copyWith(name: name, dose: dose, duration: duration)
                else
                  p,
            ],
          ));

  void toggleAnalysis(String id) => _update((d) {
        final next = {...d.selectedAnalysisIds};
        next.contains(id) ? next.remove(id) : next.add(id);
        return d.copyWith(selectedAnalysisIds: next);
      });

  void toggleXray(String id) => _update((d) {
        final next = {...d.selectedXrayIds};
        next.contains(id) ? next.remove(id) : next.add(id);
        return d.copyWith(selectedXrayIds: next);
      });

  Future<bool> finish({
    required String complaint,
    required String diagnosis,
    required bool isDraft,
  }) async {
    final current = state;
    if (current is! ConsultationSuccess) return false;
    final data = current.data;

    if (isDraft) {
      await _repo.saveDraft(ConsultationDraftModel(
        appointmentId: data.patient.id,
        complaint: complaint,
        diagnosis: diagnosis,
        prescriptions: data.prescriptions,
        analysisIds: data.selectedAnalysisIds.toList(),
        xrayIds: data.selectedXrayIds.toList(),
      ));
      return true;
    }

    try {
      await _repo.finishAppointment(
        appointmentId: data.patient.id,
        complaint: complaint,
        diagnosis: diagnosis,
        prescriptions: data.prescriptions,
        analysisIds: data.selectedAnalysisIds.toList(),
        xrayIds: data.selectedXrayIds.toList(),
      );
      await _repo.clearDraft(data.patient.id);
      final now = DateTime.now();
      final label =
          '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')}';
      _queueCubit.markDone(data.patient.id, doneAtLabel: label);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  void _update(ConsultationData Function(ConsultationData) transform) {
    final current = state;
    if (current is! ConsultationSuccess) return;
    emit(ConsultationSuccess(transform(current.data)));
  }
}
