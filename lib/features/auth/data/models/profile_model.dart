import 'package:equatable/equatable.dart';

import '../../../staff/data/models/doctor_profile_model.dart';

/// The signed-in account — from `POST auth/login` (`data.profile`) and
/// `GET profile`. The backend discriminates by [type]: a manager
/// (`clinic_manager` / `location_manager` / `admin` …) carries the
/// management-scope fields, a `doctor` carries their clinical data in
/// [doctor].
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.type,
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.appLang,
    this.managementScope,
    this.locationId,
    this.clinicId,
    this.doctor,
    this.createdAt,
    this.updatedAt,
  });

  final String type;
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? appLang;

  final String? managementScope;
  final int? locationId;
  final int? clinicId;

  final DoctorProfileModel? doctor;

  final String? createdAt;
  final String? updatedAt;

  bool get isDoctor => type == 'doctor';
  bool get isManager => !isDoctor;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';
    return ProfileModel(
      type: type,
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      appLang: json['app_lang'] as String?,
      managementScope: json['management_scope'] as String?,
      locationId: json['location_id'] as int?,
      clinicId: json['clinic_id'] as int?,
      doctor: type == 'doctor' ? DoctorProfileModel.fromJson(json) : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'app_lang': appLang,
        'management_scope': managementScope,
        'location_id': locationId,
        'clinic_id': clinicId,
        'experience': doctor?.experience,
        'price': doctor?.price,
        'avg_rate': doctor?.avgRate,
        'image': doctor?.image,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  List<Object?> get props => [
        type,
        id,
        name,
        phone,
        email,
        appLang,
        managementScope,
        locationId,
        clinicId,
        doctor,
        createdAt,
        updatedAt,
      ];
}
