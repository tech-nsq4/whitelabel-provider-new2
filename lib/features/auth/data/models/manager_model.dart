import 'package:equatable/equatable.dart';

/// The signed-in clinic manager — returned by `POST auth/login` (as
/// `data.manager`) and `GET profile`.
class ManagerModel extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? appLang;

  /// e.g. `"all"` for a manager overseeing every clinic, or a scoped value
  /// tied to [locationId]/[clinicId].
  final String? managementScope;
  final int? locationId;
  final int? clinicId;
  final String? createdAt;
  final String? updatedAt;

  const ManagerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.appLang,
    this.managementScope,
    this.locationId,
    this.clinicId,
    this.createdAt,
    this.updatedAt,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) => ManagerModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        appLang: json['app_lang'] as String?,
        managementScope: json['management_scope'] as String?,
        locationId: json['location_id'] as int?,
        clinicId: json['clinic_id'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'app_lang': appLang,
        'management_scope': managementScope,
        'location_id': locationId,
        'clinic_id': clinicId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  List<Object?> get props =>
      [id, name, phone, email, appLang, managementScope, locationId, clinicId, createdAt, updatedAt];
}
