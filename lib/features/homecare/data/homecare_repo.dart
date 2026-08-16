import 'models/homecare_request_model.dart';

/// TODO(api): mock data until `ApiEndpoints.homecare` exists.
class HomecareRepo {
  Future<List<HomecareRequestModel>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      HomecareRequestModel(
        id: 'hc-1',
        patientName: 'منيرة العتيبي',
        serviceLabel: 'تمريض منزلي',
        price: 150,
        addressLine: 'حي المرجس — شارع الأمير محمد',
        timeWindow: 'اليوم مساءً (5–8 م)',
      ),
      HomecareRequestModel(
        id: 'hc-2',
        patientName: 'سعد المطيري',
        serviceLabel: 'زيارة طبيب',
        price: 250,
        addressLine: 'حي المونسا — طريق الأمير تركي',
        timeWindow: 'غدًا صباحًا (8–11 ص)',
      ),
      HomecareRequestModel(
        id: 'hc-3',
        patientName: 'نوف عبدالله',
        serviceLabel: 'سحب عينات',
        price: 80,
        addressLine: 'حي العليا — طريق الملك فهد',
        timeWindow: 'اليوم مساءً (5–8 م)',
      ),
      HomecareRequestModel(
        id: 'hc-4',
        patientName: 'وليد الشمري',
        serviceLabel: 'علاج طبيعي',
        price: 200,
        addressLine: 'حي مرتبة',
        timeWindow: 'اليوم (2–4 م)',
        assignedDoctor: 'د. رهف الدسري',
      ),
    ];
  }
}
