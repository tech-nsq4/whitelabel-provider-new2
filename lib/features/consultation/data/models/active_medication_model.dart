import 'package:equatable/equatable.dart';

/// One row in the consultation history's "أدوية نشطة" list — from the
/// `active_medications` array of `GET /users/{id}/health-summary`.
class ActiveMedicationModel extends Equatable {
  const ActiveMedicationModel({
    required this.name,
    required this.schedule,
    this.remainingDays,
    this.isActive,
  });

  final String name;
  final String schedule;
  final int? remainingDays;
  final bool? isActive;

  factory ActiveMedicationModel.fromJson(Map<String, dynamic> json) {
    final schedule = [
      if ((json['dosage'] as String?)?.isNotEmpty ?? false) json['dosage'] as String,
      if ((json['duration'] as String?)?.isNotEmpty ?? false) json['duration'] as String,
    ].join(' · ');
    return ActiveMedicationModel(
      name: json['drug_name'] as String? ?? '',
      schedule: schedule,
      remainingDays: json['remaining_days'] as int?,
      isActive: json['is_active'] as bool?,
    );
  }

  @override
  List<Object?> get props => [name, schedule, remainingDays, isActive];
}
