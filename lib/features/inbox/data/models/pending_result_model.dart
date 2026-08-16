import 'package:equatable/equatable.dart';

enum PendingResultFlag { critical, low, normal }

/// One test result waiting for the doctor's sign-off before the patient
/// sees it.
class PendingResultModel extends Equatable {
  const PendingResultModel({
    required this.id,
    required this.patientName,
    required this.patientInitial,
    required this.testName,
    required this.value,
    required this.flag,
  });

  final String id;
  final String patientName;
  final String patientInitial;
  final String testName;
  final String value;
  final PendingResultFlag flag;

  @override
  List<Object?> get props => [id, patientName, patientInitial, testName, value, flag];
}
