import 'models/doctor_profile_model.dart';

/// TODO(api): mock data until `ApiEndpoints.staff` exists.
class StaffRepo {
  Future<List<DoctorProfileModel>> getDoctors() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      DoctorProfileModel(
        name: 'د. خالد العتيبي',
        initial: 'خ',
        specialty: 'استشاري باطنة',
        availability: StaffAvailability.available,
        pricing: {'عيادة': 180, 'فيديو': 100},
        rating: 4.9,
        occupancyPercent: 92,
      ),
      DoctorProfileModel(
        name: 'د. رهف الدسري',
        initial: 'ر',
        specialty: 'استشارية جراحة',
        availability: StaffAvailability.available,
        pricing: {'عيادة': 180, 'فيديو': 80, 'منزلية': 250},
        rating: 4.9,
        occupancyPercent: 78,
      ),
      DoctorProfileModel(
        name: 'د. سارة المحطاني',
        initial: 'س',
        specialty: 'أخصائية أسنان',
        availability: StaffAvailability.available,
        pricing: {'عيادة': 200},
        rating: 4.8,
        occupancyPercent: 71,
      ),
      DoctorProfileModel(
        name: 'د. وليد الشهري',
        initial: 'و',
        specialty: 'استشاري أطفال',
        availability: StaffAvailability.onLeave,
        pricing: {'عيادة': 160, 'فيديو': 90},
        rating: 4.8,
        occupancyPercent: null,
      ),
    ];
  }
}
