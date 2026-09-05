import 'package:equatable/equatable.dart';

import 'prescription_entry_model.dart';

/// A consultation's in-progress notes, cached locally under "حفظ كمسودة" —
/// keyed by [appointmentId] so re-opening the same visit restores it.
class ConsultationDraftModel extends Equatable {
  const ConsultationDraftModel({
    required this.appointmentId,
    required this.complaint,
    required this.diagnosis,
    required this.prescriptions,
    required this.analysisIds,
    required this.xrayIds,
    this.note = '',
    this.testsDescription = '',
    this.medicationsNote = '',
  });

  final String appointmentId;
  final String complaint;
  final String diagnosis;
  final List<PrescriptionEntryModel> prescriptions;
  final List<String> analysisIds;
  final List<String> xrayIds;
  final String note;
  final String testsDescription;
  final String medicationsNote;

  factory ConsultationDraftModel.fromJson(Map<String, dynamic> json) =>
      ConsultationDraftModel(
        appointmentId: '${json['appointment_id']}',
        complaint: json['complaint'] as String? ?? '',
        diagnosis: json['diagnosis'] as String? ?? '',
        note: json['note'] as String? ?? '',
        testsDescription: json['tests_description'] as String? ?? '',
        medicationsNote: json['medications_note'] as String? ?? '',
        prescriptions: [
          for (final row in (json['prescriptions'] as List? ?? const []))
            PrescriptionEntryModel.fromJson(
                (row as Map).cast<String, dynamic>()),
        ],
        analysisIds: [
          for (final id in (json['analysis_ids'] as List? ?? const [])) '$id'
        ],
        xrayIds: [
          for (final id in (json['xray_ids'] as List? ?? const [])) '$id'
        ],
      );

  Map<String, dynamic> toJson() => {
        'appointment_id': appointmentId,
        'complaint': complaint,
        'diagnosis': diagnosis,
        'note': note,
        'tests_description': testsDescription,
        'medications_note': medicationsNote,
        'prescriptions': [for (final p in prescriptions) p.toJson()],
        'analysis_ids': analysisIds,
        'xray_ids': xrayIds,
      };

  @override
  List<Object?> get props => [
        appointmentId,
        complaint,
        diagnosis,
        note,
        testsDescription,
        medicationsNote,
        prescriptions,
        analysisIds,
        xrayIds
      ];
}
