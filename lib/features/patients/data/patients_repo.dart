import 'models/patient_file_model.dart';
import 'models/patient_list_item_model.dart';
import 'models/patient_visit_item_model.dart';
import 'models/patient_visit_model.dart';

/// Reads the patients directory and individual patient files.
///
/// TODO(api): mock data until `ApiEndpoints.patients` exists — swap these
/// bodies for real `DioClient` calls and keep the same signatures so
/// [PatientsCubit]/[PatientFileCubit] don't need to change.
class PatientsRepo {
  final _list = <PatientListItemModel>[
    const PatientListItemModel(
      id: 'p-1',
      name: 'منيرة العتيبي',
      initial: 'م',
      mrn: '30412',
      age: 32,
      lastVisitLabel: 'آخر زيارة اليوم',
      badgeLabel: 'حساسية',
    ),
    const PatientListItemModel(
      id: 'p-2',
      name: 'عبدالله العتيبي',
      initial: 'ع',
      mrn: '30415',
      age: 36,
      lastVisitLabel: 'آخر زيارة اليوم',
    ),
    const PatientListItemModel(
      id: 'p-3',
      name: 'سعد المطيري',
      initial: 'س',
      mrn: '29881',
      age: 54,
      lastVisitLabel: '3 يونيو',
      badgeLabel: 'نتيجة حرجة',
    ),
    const PatientListItemModel(
      id: 'p-4',
      name: 'نوف عبدالله',
      initial: 'ن',
      mrn: '30480',
      age: 7,
      lastVisitLabel: 'اليوم',
      badgeLabel: 'تطعيم',
      badgeTone: PatientBadgeTone.warning,
    ),
    const PatientListItemModel(
      id: 'p-5',
      name: 'وليد الشمري',
      initial: 'و',
      mrn: '28110',
      age: 41,
      lastVisitLabel: 'يونيو',
    ),
  ];

  Future<List<PatientListItemModel>> getPatients({String query = ''}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (query.trim().isEmpty) return List.unmodifiable(_list);
    return _list.where((p) => p.name.contains(query.trim())).toList();
  }

  Future<PatientFileModel> getFile(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final listItem = _list.firstWhere((p) => p.id == patientId, orElse: () => _list.first);

    if (patientId == 'p-1') return _mounira;

    // A lighter, generic file for patients we don't have bespoke history
    // for yet — still real enough to open without crashing.
    return PatientFileModel(
      name: listItem.name,
      initial: listItem.initial,
      mrn: listItem.mrn,
      age: listItem.age,
      bloodType: 'O+',
      allergy: listItem.badgeLabel == 'حساسية' ? 'البنسلين' : null,
      visits: const [
        PatientVisitModel(
          code: 'V-2001',
          title: 'كشف عام',
          doctor: 'د. خالد العتيبي',
          dateLabel: 'الأسبوع الماضي',
          diagnosisSummary: 'فحص دوري — لا شكوى',
          items: [
            PatientVisitItemModel(
              kind: PatientVisitItemKind.prescription,
              title: 'وصفة دوائية',
              subtitle: 'باراسيتامول عند الحاجة',
              status: PatientItemStatus.active,
            ),
          ],
        ),
      ],
    );
  }

  static const _mounira = PatientFileModel(
    name: 'منيرة العتيبي',
    initial: 'م',
    mrn: '30412',
    age: 32,
    bloodType: 'O+',
    allergy: 'البنسلين',
    visits: [
      PatientVisitModel(
        code: 'V-1180',
        title: 'كشف باطنة — فرع العليا',
        doctor: 'د. خالد العتيبي',
        dateLabel: '8 يونيو',
        diagnosisSummary: 'التهاب لوزتين حاد · حرارة 38.4',
        items: [
          PatientVisitItemModel(
            kind: PatientVisitItemKind.prescription,
            title: 'وصفة دوائية',
            subtitle: 'أموكسيسيلين 500 · باراسيتامول',
            status: PatientItemStatus.active,
          ),
          PatientVisitItemModel(
            kind: PatientVisitItemKind.labTest,
            title: 'تحليل — وظائف الغدة TSH',
            subtitle: 'طُلب في هذه الزيارة',
            status: PatientItemStatus.inProgress,
          ),
          PatientVisitItemModel(
            kind: PatientVisitItemKind.imaging,
            title: 'أشعة — الناحية الأيسر',
            subtitle: 'طُلب في هذه الزيارة',
            status: PatientItemStatus.inProgress,
          ),
          PatientVisitItemModel(
            kind: PatientVisitItemKind.document,
            title: 'إجازة مرضية — يومان',
            subtitle: 'GSL-8841',
            status: PatientItemStatus.certified,
          ),
        ],
      ),
      PatientVisitModel(
        code: 'V-1156',
        title: 'متابعة — فرع العليا',
        doctor: 'د. خالد العتيبي',
        dateLabel: '11 يونيو',
        diagnosisSummary: 'نقص فيتامين د · متابعة دورية',
        items: [
          PatientVisitItemModel(
            kind: PatientVisitItemKind.labTest,
            title: 'تحليل — فيتامين د',
            subtitle: '22 ng/mL',
            status: PatientItemStatus.low,
          ),
          PatientVisitItemModel(
            kind: PatientVisitItemKind.labTest,
            title: 'تحليل — صورة دم CBC',
            subtitle: 'ضمن المعدل',
            status: PatientItemStatus.normal,
          ),
          PatientVisitItemModel(
            kind: PatientVisitItemKind.prescription,
            title: 'وصفة دوائية',
            subtitle: 'فيتامين د 5000 · 10 أسابيع',
            status: PatientItemStatus.active,
          ),
        ],
      ),
      PatientVisitModel(
        code: 'V-1102',
        title: 'كشف جلدية — فرع المرجس',
        doctor: 'د. رهف الدسري',
        dateLabel: '21 مايو',
        diagnosisSummary: 'أكزيما تماسية',
        items: [
          PatientVisitItemModel(
            kind: PatientVisitItemKind.prescription,
            title: 'وصفة موضعية',
            subtitle: 'هيدروكورتيزون 1٪',
            status: PatientItemStatus.expired,
          ),
        ],
      ),
      PatientVisitModel(
        code: 'V-1044',
        title: 'استشارة فيديو',
        doctor: 'د. خالد العتيبي',
        dateLabel: '3 أبريل',
        diagnosisSummary: 'استفسار عن نتائج التحاليل',
        items: [
          PatientVisitItemModel(
            kind: PatientVisitItemKind.document,
            title: 'تقرير استشارة',
            subtitle: 'RPT-0912',
            status: PatientItemStatus.issued,
          ),
        ],
      ),
    ],
  );
}
