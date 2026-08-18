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
    this.specializations = const [],
    this.clinicName,
    this.clinicAddress,
    this.clinicCity,
    this.clinicArea,
  });

  final int id;
  final String name;
  final String? description;
  final int? experience;
  final String? price;
  final String? image;
  final List<String> specializations;
  final String? clinicName;
  final String? clinicAddress;
  final String? clinicCity;
  final String? clinicArea;

  /// First letter of the name with the "د. " honorific stripped.
  String get initial {
    final stripped = name.replaceFirst('د. ', '').trim();
    final source = stripped.isNotEmpty ? stripped : name;
    return source.isNotEmpty ? source[0] : '؟';
  }

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final clinic = json['clinic'] as Map<String, dynamic>?;
    final location = clinic?['location'] as Map<String, dynamic>?;
    final specializations = json['specializations'] as List?;
    return DoctorProfileModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      experience: json['experience'] as int?,
      price: json['price'] as String?,
      image: json['image'] as String?,
      specializations: specializations == null
          ? const []
          : specializations
              .map((s) => (s as Map<String, dynamic>)['title'] as String?)
              .whereType<String>()
              .toList(),
      clinicName: clinic?['name'] as String?,
      clinicAddress: clinic?['address'] as String?,
      clinicCity: (location?['city'] as Map<String, dynamic>?)?['name'] as String?,
      clinicArea: (location?['area'] as Map<String, dynamic>?)?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        experience,
        price,
        image,
        specializations,
        clinicName,
        clinicAddress,
        clinicCity,
        clinicArea,
      ];
}
