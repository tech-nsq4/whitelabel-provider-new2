import 'package:equatable/equatable.dart';

/// One free-text medication line being composed in the current
/// consultation's prescription list.
class PrescriptionEntryModel extends Equatable {
  const PrescriptionEntryModel({
    required this.id,
    this.name = '',
    this.dose = '',
    this.duration = '',
  });

  final String id;
  final String name;
  final String dose;
  final String duration;

  factory PrescriptionEntryModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionEntryModel(
        id: json['id'] as String? ??
            'rx-${DateTime.now().microsecondsSinceEpoch}',
        name: json['name'] as String? ?? '',
        dose: json['dose'] as String? ?? '',
        duration: json['duration'] as String? ?? '',
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'dose': dose, 'duration': duration};

  PrescriptionEntryModel copyWith(
          {String? name, String? dose, String? duration}) =>
      PrescriptionEntryModel(
        id: id,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        duration: duration ?? this.duration,
      );

  @override
  List<Object?> get props => [id, name, dose, duration];
}
