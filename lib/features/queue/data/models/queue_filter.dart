import 'package:equatable/equatable.dart';

class QueueFilter extends Equatable {
  const QueueFilter({this.clinicId, this.clinicName});

  final int? clinicId;
  final String? clinicName;

  static const empty = QueueFilter();

  bool get isActive => clinicId != null;

  int get activeCount => clinicId != null ? 1 : 0;

  @override
  List<Object?> get props => [clinicId, clinicName];
}
