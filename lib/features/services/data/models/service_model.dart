import 'package:equatable/equatable.dart';

/// One row on the "الخدمات" directory — read-only, straight from
/// `GET /sub-specializations`.
class ServiceModel extends Equatable {
  const ServiceModel({
    required this.id,
    required this.specializationId,
    required this.title,
    this.description,
  });

  final int id;
  final int specializationId;
  final String title;
  final String? description;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as int,
        specializationId: json['specialization_id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
      );

  @override
  List<Object?> get props => [id, specializationId, title, description];
}
