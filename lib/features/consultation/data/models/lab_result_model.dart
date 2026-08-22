import 'package:equatable/equatable.dart';

enum LabResultFlag { normal, low, critical, inProgress }

/// One row in the consultation history's "نتائج حديثة" list — from the
/// `recent_results` array of `GET /users/{id}/health-summary`.
class LabResultModel extends Equatable {
  const LabResultModel(
      {required this.name, required this.value, required this.flag});

  final String name;
  final String value;
  final LabResultFlag flag;

  factory LabResultModel.fromJson(Map<String, dynamic> json) {
    final test = json['test'] as Map<String, dynamic>?;
    final hasResult = json['has_result'] as bool? ?? false;
    final flag = !hasResult
        ? LabResultFlag.inProgress
        : switch (json['result_rate'] as String?) {
            'not_normal' => LabResultFlag.critical,
            'caution' => LabResultFlag.low,
            _ => LabResultFlag.normal,
          };
    return LabResultModel(
      name: test?['name'] as String? ?? '',
      value: '',
      flag: flag,
    );
  }

  @override
  List<Object?> get props => [name, value, flag];
}
