import 'package:equatable/equatable.dart';

import '../data/models/patient_file_model.dart';

/// The patient-file screen's editable UI state — the loaded record plus
/// which tab and which expanded visit are currently shown.
class PatientFileData extends Equatable {
  const PatientFileData({
    required this.file,
    this.tabIndex = 0,
    this.expandedVisitCode,
  });

  final PatientFileModel file;
  final int tabIndex;
  final String? expandedVisitCode;

  PatientFileData copyWith({int? tabIndex, String? expandedVisitCode, bool clearExpanded = false}) =>
      PatientFileData(
        file: file,
        tabIndex: tabIndex ?? this.tabIndex,
        expandedVisitCode: clearExpanded ? null : (expandedVisitCode ?? this.expandedVisitCode),
      );

  @override
  List<Object?> get props => [file, tabIndex, expandedVisitCode];
}
