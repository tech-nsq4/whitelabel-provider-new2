import 'package:equatable/equatable.dart';

enum PatientBadgeTone { warning, critical }

/// One row in the patients directory list.
class PatientListItemModel extends Equatable {
  const PatientListItemModel({
    required this.id,
    required this.name,
    required this.initial,
    required this.mrn,
    required this.age,
    required this.lastVisitLabel,
    this.badgeLabel,
    this.badgeTone = PatientBadgeTone.critical,
  });

  final String id;
  final String name;
  final String initial;
  final String mrn;
  final int age;
  final String lastVisitLabel;

  /// e.g. "حساسية" / "نتيجة حرجة" / "تطعيم" — `null` for a plain row.
  final String? badgeLabel;
  final PatientBadgeTone badgeTone;

  @override
  List<Object?> get props => [id, name, initial, mrn, age, lastVisitLabel, badgeLabel, badgeTone];
}
