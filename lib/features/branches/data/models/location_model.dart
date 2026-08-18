import 'package:equatable/equatable.dart';

/// One row on the "الفروع" screen — `GET locations`.
class LocationModel extends Equatable {
  const LocationModel({
    required this.id,
    required this.name,
    this.cityName,
    this.areaName,
  });

  final int id;
  final String name;
  final String? cityName;
  final String? areaName;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        cityName: (json['city'] as Map<String, dynamic>?)?['name'] as String?,
        areaName: (json['area'] as Map<String, dynamic>?)?['name'] as String?,
      );

  @override
  List<Object?> get props => [id, name, cityName, areaName];
}
