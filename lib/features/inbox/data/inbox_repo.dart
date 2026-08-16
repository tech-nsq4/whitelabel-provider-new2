import 'models/pending_result_model.dart';

/// TODO(api): mock data until `ApiEndpoints.inbox` exists.
class InboxRepo {
  final _results = <PendingResultModel>[
    const PendingResultModel(
      id: 'inb-1',
      patientName: 'سعد المطيري',
      patientInitial: 'س',
      testName: 'سكر تراكمي HbA1c',
      value: '9.1٪',
      flag: PendingResultFlag.critical,
    ),
    const PendingResultModel(
      id: 'inb-2',
      patientName: 'منيرة العتيبي',
      patientInitial: 'م',
      testName: 'فيتامين د',
      value: '22 ng/mL',
      flag: PendingResultFlag.low,
    ),
    const PendingResultModel(
      id: 'inb-3',
      patientName: 'عبدالله العتيبي',
      patientInitial: 'ع',
      testName: 'صورة دم كاملة CBC',
      value: 'ضمن المعدل',
      flag: PendingResultFlag.normal,
    ),
    const PendingResultModel(
      id: 'inb-4',
      patientName: 'نوف عبدالله',
      patientInitial: 'ن',
      testName: 'أشعة صدر',
      value: 'سليمة',
      flag: PendingResultFlag.normal,
    ),
  ];

  Future<List<PendingResultModel>> getPending() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_results);
  }
}
