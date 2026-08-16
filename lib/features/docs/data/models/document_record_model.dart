import 'package:equatable/equatable.dart';

enum DocumentStatus { certified, pendingIssue, issued }

/// One row on "التقارير والإجازات".
class DocumentRecordModel extends Equatable {
  const DocumentRecordModel({
    required this.id,
    required this.title,
    required this.patientName,
    required this.docNumber,
    required this.extra,
    required this.status,
  });

  final String id;
  final String title;
  final String patientName;
  final String docNumber;

  /// Extra descriptor line (insurer name, duration...).
  final String extra;
  final DocumentStatus status;

  @override
  List<Object?> get props => [id, title, patientName, docNumber, extra, status];
}
