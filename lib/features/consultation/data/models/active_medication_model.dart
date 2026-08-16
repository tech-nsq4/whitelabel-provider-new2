import 'package:equatable/equatable.dart';

/// One row in the consultation history's "أدوية نشطة" list.
class ActiveMedicationModel extends Equatable {
  const ActiveMedicationModel({required this.name, required this.schedule});

  final String name;
  final String schedule;

  @override
  List<Object?> get props => [name, schedule];
}
