import 'package:equatable/equatable.dart';

enum PatientVisitItemKind { prescription, labTest, imaging, document }

enum PatientItemStatus { active, expired, inProgress, normal, low, issued, certified }

/// One thing that branched off a visit — a prescription, a lab/imaging
/// order, or an issued document — shown when the visit card is expanded.
class PatientVisitItemModel extends Equatable {
  const PatientVisitItemModel({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final PatientVisitItemKind kind;
  final String title;
  final String subtitle;
  final PatientItemStatus status;

  @override
  List<Object?> get props => [kind, title, subtitle, status];
}
