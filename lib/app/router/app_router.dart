import 'package:flutter/material.dart';

import '../../features/agenda/presentation/agenda_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/billing/presentation/billing_screen.dart';
import '../../features/bookings/presentation/bookings_screen.dart';
import '../../features/branches/presentation/branches_screen.dart';
import '../../features/branches/presentation/clinics_screen.dart';
import '../../features/branding/presentation/branding_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/consultation/presentation/consultation_screen.dart';
import '../../features/docs/presentation/docs_screen.dart';
import '../../features/homecare/presentation/homecare_screen.dart';
import '../../features/inbox/presentation/inbox_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/onboarding/presentation/on_boarding_screen.dart';
import '../../features/patients/data/models/patient_list_item_model.dart';
import '../../features/patients/presentation/patient_file_screen.dart';
import '../../features/policy/presentation/policy_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/orders/data/models/test_request_model.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/queue/data/models/queue_patient_model.dart';
import '../../features/queue/presentation/queue_details_screen.dart';
import '../../features/schedules/data/models/work_schedule_model.dart';
import '../../features/schedules/presentation/schedule_edit_screen.dart';
import '../../features/schedules/presentation/schedules_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/setup/presentation/setup_screen.dart';
import '../../features/specialties/data/models/specialty_model.dart';
import '../../features/specialties/presentation/specialties_screen.dart';
import '../../features/specialties/presentation/specialty_details_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/staff/data/models/doctor_profile_model.dart';
import '../../features/staff/presentation/doctor_details_screen.dart';
import '../../features/staff/presentation/staff_screen.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return _pageRoute(const SplashScreen());

      case Routes.onBoardingScreen:
        return _pageRoute(const OnBoardingScreen());

      case Routes.loginScreen:
        return _pageRoute(const LoginScreen());

      case Routes.editProfile:
        return _pageRoute(const EditProfileScreen());

      case Routes.layoutScreen:
        return _pageRoute(LayoutScreen(
          currentPage: arguments?['currentPage'] ?? 0,
        ));

      case Routes.more:
        return _pageRoute(const MoreScreen());

      case Routes.consultation:
        return _pageRoute(ConsultationScreen(
          patient: arguments?['patient'] as QueuePatientModel,
        ));

      case Routes.queueDetails:
        return _pageRoute(QueueDetailsScreen(
          patient: arguments?['patient'] as QueuePatientModel,
          tabIndex: arguments?['tabIndex'] as int,
          onCallIn: arguments?['onCallIn'] as VoidCallback?,
          onCancel: arguments?['onCancel'] as VoidCallback?,
          onConsultAction: arguments?['onConsultAction'] as VoidCallback?,
        ));

      case Routes.agenda:
        return _pageRoute(const AgendaScreen());

      case Routes.inbox:
        return _pageRoute(const InboxScreen());

      case Routes.notifications:
        return _pageRoute(const NotificationsScreen());

      case Routes.bookings:
        return _pageRoute(const BookingsScreen());

      case Routes.orderDetails:
        return _pageRoute(OrderDetailsScreen(
          request: arguments?['request'] as TestRequestModel,
          onUpload: arguments?['onUpload'] as VoidCallback?,
        ));

      case Routes.calendar:
        return _pageRoute(const CalendarScreen());

      case Routes.patientFile:
        return _pageRoute(PatientFileScreen(
          patient: arguments?['patient'] as PatientListItemModel,
        ));

      case Routes.staff:
        return _pageRoute(const StaffScreen());

      case Routes.doctorDetails:
        return _pageRoute(DoctorDetailsScreen(
          doctor: arguments?['doctor'] as DoctorProfileModel,
        ));

      case Routes.schedules:
        return _pageRoute(const SchedulesScreen());

      case Routes.scheduleEditor:
        return _pageRoute(ScheduleEditScreen(
          doctorName: arguments?['doctorName'] as String,
          doctorInitial: arguments?['doctorInitial'] as String,
          mode: arguments?['mode'] as WorkScheduleMode,
          existing: arguments?['existing'] as WorkScheduleModel?,
          onSave: arguments?['onSave'] as void Function(WorkScheduleModel),
        ));

      case Routes.homecare:
        return _pageRoute(const HomecareScreen());

      case Routes.billing:
        return _pageRoute(const BillingScreen());

      case Routes.docs:
        return _pageRoute(const DocsScreen());

      case Routes.setup:
        return _pageRoute(const SetupScreen());

      case Routes.services:
        return _pageRoute(const ServicesScreen());

      case Routes.specialties:
        return _pageRoute(const SpecialtiesScreen());

      case Routes.specialtyDetails:
        return _pageRoute(SpecialtyDetailsScreen(
          specialty: arguments?['specialty'] as SpecialtyModel,
        ));

      case Routes.branches:
        return _pageRoute(const BranchesScreen());

      case Routes.clinics:
        return _pageRoute(ClinicsScreen(
          locationId: arguments?['locationId'] as int,
          locationName: arguments?['locationName'] as String,
        ));

      case Routes.policy:
        return _pageRoute(const PolicyScreen());

      case Routes.branding:
        return _pageRoute(const BrandingScreen());

      case Routes.analytics:
        return _pageRoute(const AnalyticsScreen());

      default:
        return _pageRoute(const _UndefinedScreen());
    }
  }

  static PageRoute<dynamic> _pageRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class _UndefinedScreen extends StatelessWidget {
  const _UndefinedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }
}
