import 'models/document_record_model.dart';

/// TODO(api): mock data until `ApiEndpoints.docs` exists.
class DocsRepo {
  final _docs = <DocumentRecordModel>[
    const DocumentRecordModel(
      id: 'doc-1',
      title: 'إجازة مرضية — منيرة العتيبي',
      patientName: 'منيرة العتيبي',
      docNumber: 'GSL-8841',
      extra: 'يومان',
      status: DocumentStatus.certified,
    ),
    const DocumentRecordModel(
      id: 'doc-2',
      title: 'تقرير طبي — سعد المطيري',
      patientName: 'سعد المطيري',
      docNumber: 'RPT-1120',
      extra: 'لشركة التأمين',
      status: DocumentStatus.pendingIssue,
    ),
    const DocumentRecordModel(
      id: 'doc-3',
      title: 'تقرير شامل — عبدالله العتيبي',
      patientName: 'عبدالله العتيبي',
      docNumber: 'RPT-1118',
      extra: '',
      status: DocumentStatus.issued,
    ),
  ];

  Future<List<DocumentRecordModel>> getDocs() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_docs);
  }
}
