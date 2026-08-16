import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/queue_patient_model.dart';
import '../data/models/queue_snapshot_model.dart';
import '../data/queue_repo.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  QueueCubit(this._repo) : super(const QueueInitial());

  final QueueRepo _repo;

  int get waitingCount => state is QueueSuccess
      ? (state as QueueSuccess).snapshot.waiting.length
      : 0;

  Future<void> loadQueue() async {
    emit(const QueueLoading());
    try {
      final snapshot = await _repo.getQueue();
      emit(QueueSuccess(snapshot));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(QueueError(msg));
    }
  }

  Future<void> refreshTab(int tabIndex) async {
    final current = state;
    if (current is! QueueSuccess) return;
    try {
      switch (tabIndex) {
        case 0:
          final waiting = await _repo.getWaiting();
          emit(QueueSuccess(current.snapshot.copyWith(waiting: waiting)));
        case 1:
          final inRoom = await _repo.getInRoom();
          emit(QueueSuccess(current.snapshot.copyWith(inRoom: inRoom)));
        default:
          final done = await _repo.getDone();
          emit(QueueSuccess(current.snapshot.copyWith(done: done)));
      }
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
    }
  }

  Future<bool> callIn(QueuePatientModel patient) async {
    final current = state;
    if (current is! QueueSuccess) return false;
    try {
      await _repo.acceptAppointment(patient.id);
      final snapshot = current.snapshot;
      emit(QueueSuccess(snapshot.copyWith(
        waiting: snapshot.waiting.where((p) => p.id != patient.id).toList(),
        inRoom: [patient.copyWith(status: 'confirmed'), ...snapshot.inRoom],
      )));
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  Future<bool> startConsultation(QueuePatientModel patient) async {
    final current = state;
    if (current is! QueueSuccess) return false;
    try {
      await _repo.startAppointment(patient.id);
      final snapshot = current.snapshot;
      emit(QueueSuccess(snapshot.copyWith(inRoom: [
        for (final p in snapshot.inRoom)
          if (p.id == patient.id) p.copyWith(status: 'in_progress') else p,
      ])));
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Cancels a waiting patient's appointment and drops it from the queue.
  Future<bool> cancel(QueuePatientModel patient) async {
    final current = state;
    if (current is! QueueSuccess) return false;
    try {
      await _repo.cancelAppointment(patient.id);
      final snapshot = current.snapshot;
      emit(QueueSuccess(snapshot.copyWith(
        waiting: snapshot.waiting.where((p) => p.id != patient.id).toList(),
        inRoom: snapshot.inRoom.where((p) => p.id != patient.id).toList(),
      )));
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Registers a patient with no booked slot straight onto the waiting list.
  ///
  /// TODO(api): no "create appointment" endpoint exists yet — this only
  /// lives in this session's in-memory state until the next [loadQueue].
  void addWalkIn({required String name, String? mrn}) {
    final current = state;
    if (current is! QueueSuccess) return;
    final snapshot = current.snapshot;
    final walkIn = QueuePatientModel(
      id: 'walkin-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      initial: name.trim().isNotEmpty ? name.trim()[0] : '؟',
      mrn: mrn,
      justArrived: true,
    );
    emit(QueueSuccess(
        snapshot.copyWith(waiting: [...snapshot.waiting, walkIn])));
  }

  /// Marks an in-room patient as seen once their consultation is finished.
  void markDone(String patientId, {required String doneAtLabel}) {
    final current = state;
    if (current is! QueueSuccess) return;
    final snapshot = current.snapshot;
    final patient = snapshot.inRoom.firstWhere(
      (p) => p.id == patientId,
      orElse: () => QueuePatientModel(id: patientId, name: '', initial: ''),
    );
    emit(QueueSuccess(snapshot.copyWith(
      inRoom: snapshot.inRoom.where((p) => p.id != patientId).toList(),
      done: [patient.copyWith(doneAtLabel: doneAtLabel), ...snapshot.done],
    )));
  }
}
