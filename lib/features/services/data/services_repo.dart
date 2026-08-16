import 'models/service_model.dart';

/// TODO(api): mock data until `ApiEndpoints.services` exists.
class ServicesRepo {
  Future<List<ServiceModel>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      ServiceModel(
        id: 'svc-1',
        name: 'كشف باطنة',
        specialty: 'باطنة عامة',
        enabled: true,
        prices: [
          ServicePriceModel(modeLabel: 'عيادة', price: 150, durationMinutes: 20),
          ServicePriceModel(modeLabel: 'فيديو', price: 80, durationMinutes: 15),
          ServicePriceModel(modeLabel: 'منزلية', price: 250, durationMinutes: 45),
        ],
      ),
      ServiceModel(
        id: 'svc-2',
        name: 'كشف جديدة',
        specialty: 'جلدية',
        enabled: true,
        prices: [
          ServicePriceModel(modeLabel: 'عيادة', price: 180, durationMinutes: 20),
          ServicePriceModel(modeLabel: 'فيديو', price: 100, durationMinutes: 15),
        ],
      ),
      ServiceModel(
        id: 'svc-3',
        name: 'كشف أسنان',
        specialty: 'أسنان',
        enabled: true,
        prices: [ServicePriceModel(modeLabel: 'عيادة', price: 200, durationMinutes: 30)],
      ),
      ServiceModel(
        id: 'svc-4',
        name: 'كشف أطفال',
        specialty: 'أطفال',
        enabled: true,
        prices: [
          ServicePriceModel(modeLabel: 'عيادة', price: 160, durationMinutes: 20),
          ServicePriceModel(modeLabel: 'فيديو', price: 90, durationMinutes: 15),
          ServicePriceModel(modeLabel: 'منزلية', price: 280, durationMinutes: 45),
        ],
      ),
      ServiceModel(
        id: 'svc-5',
        name: 'باقة الفحص الشامل',
        specialty: 'باقات',
        enabled: true,
        prices: [ServicePriceModel(modeLabel: 'عيادة', price: 299, durationMinutes: 120)],
      ),
      ServiceModel(
        id: 'svc-6',
        name: 'فريق الاستجابة السريعة',
        specialty: 'طوارئ',
        enabled: false,
        prices: [ServicePriceModel(modeLabel: 'منزلية', price: 450, durationMinutes: 60)],
      ),
    ];
  }
}
