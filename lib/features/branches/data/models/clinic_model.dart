import 'package:equatable/equatable.dart';

/// One row on the "العيادات" screen for a given location — `GET
/// clinics?location_id=`.
class ClinicModel extends Equatable {
  const ClinicModel({
    required this.id,
    required this.name,
    this.address,
    this.lat,
    this.lng,
  });

  final int id;
  final String name;
  final String? address;
  final double? lat;
  final double? lng;

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        address: json['address'] as String?,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
      );

  @override
  List<Object?> get props => [id, name, address, lat, lng];
}
