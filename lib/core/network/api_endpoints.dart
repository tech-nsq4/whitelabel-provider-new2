class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://white-label.nsq4.sa/api/clinic/';

  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String profile = 'profile';

  // ─── Appointments ─────────────────────────────────────────────────────────
  static const String appointments = 'appointments';
  static String appointmentAccept(String id) => 'appointments/$id/accept';
  static String appointmentStart(String id) => 'appointments/$id/start';
  static String appointmentEnd(String id) => 'appointments/$id/end';
  static String appointmentCancel(String id) => 'appointments/$id/cancel';

  // ─── Consultation catalogues ────────────────────────────────────────────
  static const String analyses = 'analyses';
  static const String xrays = 'xrays';

  // ─── Locations & clinics ──────────────────────────────────────────────────
  static const String locations = 'locations';
  static const String clinics = 'clinics';

  // ─── Test requests ──────────────────────────────────────────────────────
  static const String testRequests = 'test-requests';
  static String testRequestResult(String id) => 'test-requests/$id/result';

  // ─── Doctors ──────────────────────────────────────────────────────────────
  static const String doctors = 'doctors';
  static String doctorDetails(String id) => 'doctors/$id';

  // ─── Specializations ────────────────────────────────────────────────────
  static const String specializations = 'specializations';
  static const String subSpecializations = 'sub-specializations';

  // ─── Notifications ──────────────────────────────────────────────────────
  static const String notifications = 'notifications';

  // ─── Device ───────────────────────────────────────────────────────────────
  /// Registers/refreshes this device's push-notification token.
  static const String fcmToken = 'fcm-token';

  /// Syncs the app's active UI language with the backend.
  static const String appLang = 'app-lang';
}
