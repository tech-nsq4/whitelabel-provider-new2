import 'package:equatable/equatable.dart';

/// One entry in a service's per-mode price list (e.g. "عيادة" → 150 SAR /
/// 20 min).
class ServicePriceModel extends Equatable {
  const ServicePriceModel({required this.modeLabel, required this.price, required this.durationMinutes});

  final String modeLabel;
  final int price;
  final int durationMinutes;

  @override
  List<Object?> get props => [modeLabel, price, durationMinutes];
}

/// One row on the "الخدمات" setup screen.
class ServiceModel extends Equatable {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.enabled,
    required this.prices,
  });

  final String id;
  final String name;
  final String specialty;
  final bool enabled;
  final List<ServicePriceModel> prices;

  ServiceModel copyWith({bool? enabled}) => ServiceModel(
        id: id,
        name: name,
        specialty: specialty,
        enabled: enabled ?? this.enabled,
        prices: prices,
      );

  @override
  List<Object?> get props => [id, name, specialty, enabled, prices];
}
