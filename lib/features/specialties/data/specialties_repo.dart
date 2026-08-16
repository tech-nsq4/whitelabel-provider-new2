import 'models/specialty_model.dart';

/// TODO(api): mock data until `ApiEndpoints.specialties` exists.
class SpecialtiesRepo {
  Future<List<SpecialtyModel>> getSpecialties() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      SpecialtyModel(
        id: 'sp-1',
        name: 'باطنة عامة',
        summary: 'طبيبان · 38٪ من الحجوزات',
        branches: ['العليا'],
      ),
      SpecialtyModel(
        id: 'sp-2',
        name: 'جلدية',
        summary: 'د. رهف الدسري · 24٪',
        branches: ['المرجس'],
      ),
      SpecialtyModel(
        id: 'sp-3',
        name: 'أسنان',
        summary: 'د. سارة المحطاني · 19٪',
        branches: ['العليا'],
      ),
      SpecialtyModel(
        id: 'sp-4',
        name: 'أطفال',
        summary: 'د. وليد الشهري · 19٪',
        branches: ['الياسمين'],
      ),
      SpecialtyModel(
        id: 'sp-5',
        name: 'نساء وولادة',
        summary: 'د. نور — لا جدول بعد',
        branches: [],
      ),
    ];
  }
}
