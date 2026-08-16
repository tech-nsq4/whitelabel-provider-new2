import 'package:equatable/equatable.dart';

import 'patient_visit_item_model.dart';
import 'patient_visit_model.dart';

/// One entry in a flattened results/medications/documents tab — an item
/// plus which visit it branched off.
typedef PatientLinkedItem = ({PatientVisitItemModel item, String visitCode});

/// The full "ملف مريض" screen's content for one patient.
class PatientFileModel extends Equatable {
  const PatientFileModel({
    required this.name,
    required this.initial,
    required this.mrn,
    required this.age,
    required this.bloodType,
    required this.allergy,
    required this.visits,
  });

  final String name;
  final String initial;
  final String mrn;
  final int age;
  final String bloodType;
  final String? allergy;
  final List<PatientVisitModel> visits;

  int get activeMedicationsCount => medications
      .where((linked) => linked.item.status == PatientItemStatus.active)
      .length;

  int get inProgressCount =>
      results.where((linked) => linked.item.status == PatientItemStatus.inProgress).length;

  String get lastVisitLabel => visits.isEmpty ? '—' : visits.first.dateLabel;

  List<PatientLinkedItem> get results => _flatten(
      {PatientVisitItemKind.labTest, PatientVisitItemKind.imaging});

  List<PatientLinkedItem> get medications => _flatten({PatientVisitItemKind.prescription});

  List<PatientLinkedItem> get documents => _flatten({PatientVisitItemKind.document});

  List<PatientLinkedItem> _flatten(Set<PatientVisitItemKind> kinds) => [
        for (final visit in visits)
          for (final item in visit.items)
            if (kinds.contains(item.kind)) (item: item, visitCode: visit.code),
      ];

  @override
  List<Object?> get props => [name, initial, mrn, age, bloodType, allergy, visits];
}
