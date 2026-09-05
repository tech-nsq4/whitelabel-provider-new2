import 'package:equatable/equatable.dart';

/// One doctor on the "الأطباء" directory — read-only, straight from
/// `GET /doctors` (or `GET /doctors/{id}` for the same shape).
class DoctorProfileModel extends Equatable {
  const DoctorProfileModel({
    required this.id,
    required this.name,
    this.description,
    this.experience,
    this.price,
    this.image,
    this.avgRate,
    this.specializations = const [],
    this.subSpecializations = const [],
    this.clinics = const [],
    this.location,
  });

  final int id;
  final String name;
  final String? description;
  final int? experience;
  final String? price;
  final String? image;
  final double? avgRate;
  final List<DoctorSpecialization> specializations;
  final List<DoctorSpecialization> subSpecializations;
  final List<DoctorClinic> clinics;
  final DoctorLocation? location;

  /// First letter of the name with the "د. " honorific stripped.
  String get initial {
    final stripped = name.replaceFirst('د. ', '').trim();
    final source = stripped.isNotEmpty ? stripped : name;
    return source.isNotEmpty ? source[0] : '؟';
  }

  String get specializationsLabel =>
      specializations.map((s) => s.title).join('، ');

  String? get primaryClinicName =>
      clinics.isNotEmpty ? clinics.first.name : null;

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      experience: json['experience'] as int?,
      price: json['price'] as String?,
      image: json['image'] as String?,
      avgRate: (json['avg_rate'] as num?)?.toDouble(),
      specializations: _parseList(
          json['specializations'], DoctorSpecialization.fromJson),
      subSpecializations: _parseList(
          json['sub_specializations'], DoctorSpecialization.fromJson),
      clinics: _parseList(json['clinics'], DoctorClinic.fromJson),
      location: json['location'] is Map<String, dynamic>
          ? DoctorLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<T> _parseList<T>(
      dynamic raw, T Function(Map<String, dynamic>) fromJson) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        experience,
        price,
        image,
        avgRate,
        specializations,
        subSpecializations,
        clinics,
        location,
      ];
}

class DoctorSpecialization extends Equatable {
  const DoctorSpecialization({
    required this.id,
    required this.title,
    this.description,
  });

  final int id;
  final String title;
  final String? description;

  factory DoctorSpecialization.fromJson(Map<String, dynamic> json) =>
      DoctorSpecialization(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
      );

  @override
  List<Object?> get props => [id, title, description];
}

class DoctorClinic extends Equatable {
  const DoctorClinic({
    required this.id,
    required this.name,
    this.address,
    this.lat,
    this.lng,
    this.location,
  });

  final int id;
  final String name;
  final String? address;
  final double? lat;
  final double? lng;
  final DoctorLocation? location;

  factory DoctorClinic.fromJson(Map<String, dynamic> json) => DoctorClinic(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        address: json['address'] as String?,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        location: json['location'] is Map<String, dynamic>
            ? DoctorLocation.fromJson(json['location'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [id, name, address, lat, lng, location];
}

class DoctorLocation extends Equatable {
  const DoctorLocation({
    required this.id,
    required this.name,
    this.cityName,
    this.areaName,
  });

  final int id;
  final String name;
  final String? cityName;
  final String? areaName;

  String get areaCityLabel =>
      [areaName, cityName].whereType<String>().join('، ');

  factory DoctorLocation.fromJson(Map<String, dynamic> json) => DoctorLocation(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        cityName: (json['city'] as Map<String, dynamic>?)?['name'] as String?,
        areaName: (json['area'] as Map<String, dynamic>?)?['name'] as String?,
      );

  @override
  List<Object?> get props => [id, name, cityName, areaName];
}
