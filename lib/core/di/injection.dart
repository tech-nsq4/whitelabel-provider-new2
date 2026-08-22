import 'package:get_it/get_it.dart';

import '../../features/agenda/data/agenda_repo.dart';
import '../../features/agenda/logic/agenda_cubit.dart';
import '../../features/analytics/data/analytics_repo.dart';
import '../../features/analytics/logic/analytics_cubit.dart';
import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/billing/data/billing_repo.dart';
import '../../features/billing/logic/billing_cubit.dart';
import '../../features/bookings/data/bookings_repo.dart';
import '../../features/bookings/logic/bookings_cubit.dart';
import '../../features/branches/data/branches_repo.dart';
import '../../features/branches/logic/branches_cubit.dart';
import '../../features/branches/logic/clinics_cubit.dart';
import '../../features/branding/data/branding_repo.dart';
import '../../features/branding/logic/branding_cubit.dart';
import '../../features/calendar/data/calendar_repo.dart';
import '../../features/calendar/logic/calendar_cubit.dart';
import '../../features/consultation/data/consultation_repo.dart';
import '../../features/consultation/logic/consultation_cubit.dart';
import '../../features/dashboard/data/dashboard_repo.dart';
import '../../features/dashboard/logic/dashboard_cubit.dart';
import '../../features/docs/data/docs_repo.dart';
import '../../features/docs/logic/docs_cubit.dart';
import '../../features/homecare/data/homecare_repo.dart';
import '../../features/homecare/logic/homecare_cubit.dart';
import '../../features/inbox/data/inbox_repo.dart';
import '../../features/inbox/logic/inbox_cubit.dart';
import '../../features/notifications/data/notifications_repo.dart';
import '../../features/notifications/logic/notifications_badge_cubit.dart';
import '../../features/notifications/logic/notifications_cubit.dart';
import '../../features/orders/data/orders_repo.dart';
import '../../features/orders/logic/orders_cubit.dart';
import '../../features/patients/data/patients_repo.dart';
import '../../features/patients/logic/patient_file_cubit.dart';
import '../../features/patients/logic/patients_cubit.dart';
import '../../features/policy/data/policy_repo.dart';
import '../../features/policy/logic/policy_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/queue/data/queue_repo.dart';
import '../../features/queue/logic/queue_cubit.dart';
import '../../features/schedules/data/schedules_repo.dart';
import '../../features/schedules/logic/schedules_cubit.dart';
import '../../features/services/data/services_repo.dart';
import '../../features/services/logic/services_cubit.dart';
import '../../features/specialties/data/specialties_repo.dart';
import '../../features/specialties/logic/specialties_cubit.dart';
import '../../features/staff/data/staff_repo.dart';
import '../../features/staff/logic/staff_cubit.dart';
import '../network/dio_client.dart';
import '../storage/local_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  // ─── Storage ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => LocalStorage());

  // ─── Network ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => DioClient(storage: getIt()));

  // ─── Repos ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => AuthRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => DashboardRepo(dio: getIt()));
  getIt.registerLazySingleton(() => QueueRepo(dio: getIt()));
  getIt.registerLazySingleton(() => NotificationsRepo(dio: getIt()));
  getIt.registerLazySingleton(
      () => ConsultationRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => OrdersRepo(dio: getIt()));
  getIt.registerLazySingleton(() => PatientsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => AgendaRepo());
  getIt.registerLazySingleton(() => InboxRepo());
  getIt.registerLazySingleton(() => BookingsRepo());
  getIt.registerLazySingleton(() => CalendarRepo());
  getIt.registerLazySingleton(() => StaffRepo(dio: getIt()));
  getIt.registerLazySingleton(() => SchedulesRepo());
  getIt.registerLazySingleton(() => HomecareRepo());
  getIt.registerLazySingleton(() => BillingRepo());
  getIt.registerLazySingleton(() => DocsRepo());
  getIt.registerLazySingleton(() => ServicesRepo(dio: getIt()));
  getIt.registerLazySingleton(() => SpecialtiesRepo(dio: getIt()));
  getIt.registerLazySingleton(() => BranchesRepo(dio: getIt()));
  getIt.registerLazySingleton(() => PolicyRepo());
  getIt.registerLazySingleton(() => BrandingRepo());
  getIt.registerLazySingleton(() => AnalyticsRepo());

  // ─── Cubits ───────────────────────────────────────────────────────────────
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => DashboardCubit(getIt()));
  getIt.registerFactory(() => PatientsCubit(getIt()));
  getIt.registerFactory(() => PatientFileCubit(getIt()));
  getIt.registerFactory(() => AgendaCubit(getIt()));
  getIt.registerFactory(() => InboxCubit(getIt()));
  getIt.registerFactory(() => BookingsCubit(getIt()));
  getIt.registerFactory(() => CalendarCubit(getIt()));
  getIt.registerFactory(() => StaffCubit(getIt()));
  getIt.registerFactory(() => SchedulesCubit(getIt()));
  getIt.registerFactory(() => HomecareCubit(getIt()));
  getIt.registerFactory(() => BillingCubit(getIt()));
  getIt.registerFactory(() => DocsCubit(getIt()));
  getIt.registerFactory(() => ServicesCubit(getIt()));
  getIt.registerFactory(() => SpecialtiesCubit(getIt()));
  getIt.registerFactory(() => BranchesCubit(getIt()));
  getIt.registerFactory(() => ClinicsCubit(getIt()));
  getIt.registerFactory(() => PolicyCubit(getIt()));
  getIt.registerFactory(() => BrandingCubit(getIt()));
  getIt.registerFactory(() => AnalyticsCubit(getIt()));

  // `QueueCubit`, `OrdersCubit`, `NotificationsBadgeCubit`, and
  // `NotificationsCubit` are singletons (not the usual per-screen
  // factory): the bottom nav's queue/orders badges, the dashboard's
  // notifications bell badge, their own screens, and the consultation
  // screen (finishing a visit moves the patient to "done") all need to
  // react to the exact same lists — never call `.close()` on any of them
  // from a screen's `dispose()`; they live for the app's session.
  getIt.registerLazySingleton(() => QueueCubit(getIt()));
  getIt.registerLazySingleton(() => OrdersCubit(getIt()));
  getIt.registerLazySingleton(() => NotificationsBadgeCubit(getIt()));
  getIt.registerLazySingleton(() => NotificationsCubit(getIt(), getIt()));

  // `ConsultationCubit` stays a per-screen factory — it takes the shared
  // `QueueCubit` singleton as a dependency so finishing a visit can call
  // back into the queue without the two features reaching for each other's
  // internals.
  getIt.registerFactory(() => ConsultationCubit(getIt(), getIt()));
}
