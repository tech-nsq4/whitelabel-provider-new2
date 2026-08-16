import 'package:equatable/equatable.dart';

/// The four vitals shown in the consultation screen's history tab.
class VitalSignsModel extends Equatable {
  const VitalSignsModel({
    required this.pressure,
    required this.pulse,
    required this.temperature,
    required this.oxygen,
  });

  final String pressure;
  final String pulse;
  final String temperature;
  final String oxygen;

  @override
  List<Object?> get props => [pressure, pulse, temperature, oxygen];
}
