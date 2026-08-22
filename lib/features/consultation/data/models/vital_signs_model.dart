import 'package:equatable/equatable.dart';

/// A patient's `GET /users/{id}/vital-signs` reading, shown on the
/// consultation screen's "السجل" tab. `null` `data` from that endpoint
/// means none has been recorded yet, so this model only exists once one
/// has.
class VitalSignsModel extends Equatable {
  const VitalSignsModel({
    required this.id,
    required this.bloodPressure,
    required this.pulse,
    required this.temperature,
    required this.oxygen,
    this.updatedAt,
  });

  final int id;

  /// "systolic/diastolic", e.g. "120/80".
  final String bloodPressure;

  /// Beats per minute.
  final int pulse;

  /// Celsius.
  final double temperature;

  /// SpO2 percentage.
  final int oxygen;
  final String? updatedAt;

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) =>
      VitalSignsModel(
        id: json['id'] as int,
        bloodPressure: json['blood_pressure'] as String? ?? '',
        pulse: json['pulse'] as int? ?? 0,
        temperature: double.tryParse('${json['temperature']}') ?? 0,
        oxygen: json['oxygen'] as int? ?? 0,
        updatedAt: json['updated_at'] as String?,
      );

  @override
  List<Object?> get props =>
      [id, bloodPressure, pulse, temperature, oxygen, updatedAt];
}
