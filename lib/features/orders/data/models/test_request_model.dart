import 'package:equatable/equatable.dart';

import '../../../../core/utils/convert_helper.dart';

enum TestRequestType { analysis, xray }

enum ResultRate { normal, notNormal, caution }

ResultRate? resultRateFromJson(String? value) => switch (value) {
      'normal' => ResultRate.normal,
      'not_normal' => ResultRate.notNormal,
      'caution' => ResultRate.caution,
      _ => null,
    };

String resultRateToJson(ResultRate rate) => switch (rate) {
      ResultRate.normal => 'normal',
      ResultRate.notNormal => 'not_normal',
      ResultRate.caution => 'caution',
    };

class TestRequestModel extends Equatable {
  const TestRequestModel({
    required this.id,
    required this.type,
    required this.hasResult,
    this.resultRate,
    this.note,
    this.resultUrl,
    this.testName,
    this.testPrice,
    this.date,
    this.time,
    this.patientName,
    this.doctorName,
  });

  final int id;
  final TestRequestType type;
  final bool hasResult;
  final ResultRate? resultRate;
  final String? note;
  final String? resultUrl;
  final String? testName;
  final double? testPrice;
  final String? date;
  final String? time;
  final String? patientName;
  final String? doctorName;

  String get initial =>
      (patientName?.isNotEmpty ?? false) ? patientName![0] : '؟';

  String? get scheduledLabel {
    if (date == null || date!.isEmpty) return time;
    final dateLabel = ConvertHelper.formatDateTime(date!, includeDate: true);
    if (dateLabel.isEmpty) return time;
    return time != null ? '$dateLabel · $time' : dateLabel;
  }

  factory TestRequestModel.fromJson(Map<String, dynamic> json) {
    final test = json['test'] as Map<String, dynamic>?;
    final appointment = json['appointment'] as Map<String, dynamic>?;
    final user = appointment?['user'] as Map<String, dynamic>?;
    final doctor = appointment?['doctor'] as Map<String, dynamic>?;
    final name = (user?['name'] as String?)?.trim();
    return TestRequestModel(
      id: json['id'] as int,
      type: json['type'] == 'xray'
          ? TestRequestType.xray
          : TestRequestType.analysis,
      hasResult: json['has_result'] as bool? ?? false,
      resultRate: resultRateFromJson(json['result_rate'] as String?),
      note: json['note'] as String?,
      resultUrl: json['url'] as String?,
      testName: test?['name'] as String?,
      testPrice: double.tryParse('${test?['price']}'),
      date: appointment?['date'] as String?,
      time: appointment?['times'] as String?,
      patientName:
          (name?.isNotEmpty ?? false) ? name : user?['phone'] as String?,
      doctorName: doctor?['name'] as String?,
    );
  }

  TestRequestModel copyWith(
          {bool? hasResult, ResultRate? resultRate, String? note}) =>
      TestRequestModel(
        id: id,
        type: type,
        hasResult: hasResult ?? this.hasResult,
        resultRate: resultRate ?? this.resultRate,
        note: note ?? this.note,
        resultUrl: resultUrl,
        testName: testName,
        testPrice: testPrice,
        date: date,
        time: time,
        patientName: patientName,
        doctorName: doctorName,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        hasResult,
        resultRate,
        note,
        resultUrl,
        testName,
        testPrice,
        date,
        time,
        patientName,
        doctorName,
      ];
}
