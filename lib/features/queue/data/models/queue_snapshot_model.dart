import 'package:equatable/equatable.dart';

import 'queue_patient_model.dart';

/// The three buckets shown on the queue screen's tabs.
class QueueSnapshotModel extends Equatable {
  const QueueSnapshotModel({
    required this.waiting,
    required this.inRoom,
    required this.done,
  });

  final List<QueuePatientModel> waiting;
  final List<QueuePatientModel> inRoom;
  final List<QueuePatientModel> done;

  QueueSnapshotModel copyWith({
    List<QueuePatientModel>? waiting,
    List<QueuePatientModel>? inRoom,
    List<QueuePatientModel>? done,
  }) =>
      QueueSnapshotModel(
        waiting: waiting ?? this.waiting,
        inRoom: inRoom ?? this.inRoom,
        done: done ?? this.done,
      );

  @override
  List<Object?> get props => [waiting, inRoom, done];
}
