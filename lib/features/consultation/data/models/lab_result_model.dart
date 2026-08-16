import 'package:equatable/equatable.dart';

enum LabResultFlag { normal, low, critical, inProgress }

/// One row in the consultation history's "نتائج حديثة" list.
class LabResultModel extends Equatable {
  const LabResultModel(
      {required this.name, required this.value, required this.flag});

  final String name;
  final String value;
  final LabResultFlag flag;

  @override
  List<Object?> get props => [name, value, flag];
}
