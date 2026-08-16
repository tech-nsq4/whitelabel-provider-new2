import 'package:equatable/equatable.dart';

/// One row on the "التخصصات" setup screen.
class SpecialtyModel extends Equatable {
  const SpecialtyModel({
    required this.id,
    required this.name,
    required this.summary,
    required this.branches,
  });

  final String id;
  final String name;

  /// e.g. "د. رهف الدسري · 24٪ من الحجوزات".
  final String summary;

  /// Branches this specialty is staffed at — empty means no doctor covers
  /// it at any branch yet.
  final List<String> branches;

  @override
  List<Object?> get props => [id, name, summary, branches];
}
