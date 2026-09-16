class ApiEndpoints {
  ApiEndpoints._();

  static const String rootUrl = 'https://white-label.nsq4.sa/api/';
  static const String baseUrl = '${rootUrl}clinic/';

  static const String apiKey =
      'd7ac249766b9dc90ab6c3db4bae39dfe98f04c8803b2eb44face6e9d187107f1';

  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String profile = 'profile';
  static const String home = 'home';
  static const String splashes = 'splashes';

  // ─── Appointments ─────────────────────────────────────────────────────────
  static const String appointments = 'appointments';
  static String appointmentDetails(String id) => 'appointments/$id';
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

  // ─── Schedules ────────────────────────────────────────────────────────────
  static const String doctorTimes = 'doctor-times';

  // ─── Specializations ────────────────────────────────────────────────────
  static const String specializations = 'specializations';
  static const String subSpecializations = 'sub-specializations';

  // ─── Patients (app users) ─────────────────────────────────────────────
  static const String users = 'users';
  static String userAnalysesHistory(String id) => 'users/$id/analyses/history';
  static String userXraysHistory(String id) => 'users/$id/xrays/history';
  static String userPrescriptionsHistory(String id) =>
      'users/$id/prescriptions/history';
  static String userHealthSummary(String id) => 'users/$id/health-summary';
  static String userVitalSigns(String id) => 'users/$id/vital-signs';

  // ─── Notifications ──────────────────────────────────────────────────────
  static const String notifications = 'notifications';
  static const String notificationsUnreadCount = 'notifications/unread-count';
  static const String notificationsReadAll = 'notifications/read-all';
  static String notificationRead(String id) => 'notifications/$id/read';

  // ─── Chat ─────────────────────────────────────────────────────────────────
  static const String chatImageUpload = 'chat/images';
  static const String chatNotifications = '${rootUrl}chat/notifications';

  // ─── Device ───────────────────────────────────────────────────────────────
  /// Registers/refreshes this device's push-notification token.
  static const String fcmToken = 'fcm-token';

  /// Syncs the app's active UI language with the backend.
  static const String appLang = 'app-lang';
}
