import 'package:equatable/equatable.dart';

/// One row under a [SpecialtyModel] — a narrower specialty within it
/// (e.g. "تقويم الأسنان" under "الأسنان").
class SubSpecialtyModel extends Equatable {
  const SubSpecialtyModel({required this.id, required this.title, this.description});

  final int id;
  final String title;
  final String? description;

  factory SubSpecialtyModel.fromJson(Map<String, dynamic> json) =>
      SubSpecialtyModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
      );

  @override
  List<Object?> get props => [id, title, description];
}

/// One entry on the "التخصصات" directory — read-only, straight from
/// `GET /specializations`.
class SpecialtyModel extends Equatable {
  const SpecialtyModel({
    required this.id,
    required this.title,
    this.description,
    this.subSpecialties = const [],
  });

  final int id;
  final String title;
  final String? description;
  final List<SubSpecialtyModel> subSpecialties;

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    final subSpecializations = json['sub_specializations'] as List?;
    return SpecialtyModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      subSpecialties: subSpecializations == null
          ? const []
          : subSpecializations
              .map((s) => SubSpecialtyModel.fromJson(s as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, title, description, subSpecialties];
}
