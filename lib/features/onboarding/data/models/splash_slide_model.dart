import 'package:equatable/equatable.dart';

class SplashSlideModel extends Equatable {
  const SplashSlideModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  final int id;
  final String title;
  final String description;
  final String? image;

  factory SplashSlideModel.fromJson(Map<String, dynamic> json) {
    return SplashSlideModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, title, description, image];
}
