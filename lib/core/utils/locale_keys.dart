// ignore_for_file: constant_identifier_names
//
// Usage: LocaleKeys.auth_login.tr()

abstract class LocaleKeys {
  // ─── App ─────────────────────────────────────────────────────────────────
  static const String app_name = 'app_name';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String auth_tagline = 'auth.tagline';
  static const String auth_login = 'auth.login';
  static const String auth_password = 'auth.password';
  static const String auth_loginSubtitle = 'auth.login_subtitle';
  static const String auth_phone = 'auth.phone';

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const String onboarding_skip = 'onboarding.skip';
  static const String onboarding_next = 'onboarding.next';
  static const String onboarding_getStarted = 'onboarding.get_started';
  static const String onboarding_slide1_title = 'onboarding.slide1_title';
  static const String onboarding_slide1_subtitle = 'onboarding.slide1_subtitle';
  static const String onboarding_slide2_title = 'onboarding.slide2_title';
  static const String onboarding_slide2_subtitle = 'onboarding.slide2_subtitle';
  static const String onboarding_slide3_title = 'onboarding.slide3_title';
  static const String onboarding_slide3_subtitle = 'onboarding.slide3_subtitle';
  static const String onboarding_slide4_title = 'onboarding.slide4_title';
  static const String onboarding_slide4_subtitle = 'onboarding.slide4_subtitle';

  // ─── Navigation ───────────────────────────────────────────────────────────
  static const String nav_today = 'nav.today';
  static const String nav_queue = 'nav.queue';
  static const String nav_orders = 'nav.orders';
  static const String nav_patients = 'nav.patients';

  // ─── Validation ───────────────────────────────────────────────────────────
  static const String validation_required = 'validation.required';
  static const String validation_invalidPhone = 'validation.invalid_phone';
  static const String validation_invalidEmail = 'validation.invalid_email';

  // ─── Common ───────────────────────────────────────────────────────────────
  static const String common_cancel = 'common.cancel';
  static const String common_close = 'common.close';
  static const String common_search = 'common.search';
  static const String common_retry = 'common.retry';
  static const String common_confirm = 'common.confirm';
  static const String common_currency = 'common.currency';
  static const String common_comingSoonTitle = 'common.coming_soon_title';
  static const String common_comingSoonDesc = 'common.coming_soon_desc';
  static const String common_edit = 'common.edit';
  static const String common_delete = 'common.delete';

  // ─── Setup hub ────────────────────────────────────────────────────────────
  static const String setupScreen_title = 'setup_screen.title';
  static const String setupScreen_subtitle = 'setup_screen.subtitle';
  static const String setupScreen_contentSection =
      'setup_screen.content_section';
  static const String setupScreen_servicesSub = 'setup_screen.services_sub';
  static const String setupScreen_specialtiesSub =
      'setup_screen.specialties_sub';
  static const String setupScreen_doctorsSub = 'setup_screen.doctors_sub';
  static const String setupScreen_appointmentsSection =
      'setup_screen.appointments_section';
  static const String setupScreen_schedulesSub = 'setup_screen.schedules_sub';
  static const String setupScreen_brandingTitle = 'setup_screen.branding_title';
  static const String setupScreen_brandingSub = 'setup_screen.branding_sub';
  static const String setupScreen_policySub = 'setup_screen.policy_sub';
  static const String setupScreen_branchSection = 'setup_screen.branch_section';
  static const String setupScreen_branchesSub = 'setup_screen.branches_sub';

  // ─── Services ─────────────────────────────────────────────────────────────
  static const String servicesScreen_title = 'services_screen.title';
  static const String servicesScreen_subtitle = 'services_screen.subtitle';
  static const String servicesScreen_infoBanner = 'services_screen.info_banner';
  static const String servicesScreen_deleteToast =
      'services_screen.delete_toast';
  static const String servicesScreen_minuteUnit = 'services_screen.minute_unit';

  // ─── Specialties ──────────────────────────────────────────────────────────
  static const String specialtiesScreen_title = 'specialties_screen.title';
  static const String specialtiesScreen_subtitle =
      'specialties_screen.subtitle';
  static const String specialtiesScreen_infoBanner =
      'specialties_screen.info_banner';
  static const String specialtiesScreen_availableAt =
      'specialties_screen.available_at';
  static const String specialtiesScreen_noBranch =
      'specialties_screen.no_branch';

  // ─── Branches ─────────────────────────────────────────────────────────────
  static const String branchesScreen_title = 'branches_screen.title';
  static const String branchesScreen_directions = 'branches_screen.directions';
  static const String branchesScreen_directionsToast =
      'branches_screen.directions_toast';
  static const String branchesScreen_clinicsTitle =
      'branches_screen.clinics_title';
  static const String branchesScreen_noLocations =
      'branches_screen.no_locations';
  static const String branchesScreen_noClinics = 'branches_screen.no_clinics';

  // ─── Service sheet ────────────────────────────────────────────────────────
  static const String serviceSheet_titleAdd = 'service_sheet.title_add';
  static const String serviceSheet_titleEdit = 'service_sheet.title_edit';
  static const String serviceSheet_nameLabel = 'service_sheet.name_label';
  static const String serviceSheet_nameHint = 'service_sheet.name_hint';
  static const String serviceSheet_specialtyLabel =
      'service_sheet.specialty_label';
  static const String serviceSheet_modesLabel = 'service_sheet.modes_label';
  static const String serviceSheet_modeClinic = 'service_sheet.mode_clinic';
  static const String serviceSheet_modeClinicSub =
      'service_sheet.mode_clinic_sub';
  static const String serviceSheet_modeVideo = 'service_sheet.mode_video';
  static const String serviceSheet_modeVideoSub =
      'service_sheet.mode_video_sub';
  static const String serviceSheet_modeHome = 'service_sheet.mode_home';
  static const String serviceSheet_modeHomeSub = 'service_sheet.mode_home_sub';
  static const String serviceSheet_priceLabel = 'service_sheet.price_label';
  static const String serviceSheet_durationLabel =
      'service_sheet.duration_label';
  static const String serviceSheet_save = 'service_sheet.save';
  static const String serviceSheet_successAdd = 'service_sheet.success_add';
  static const String serviceSheet_successEdit = 'service_sheet.success_edit';
  static const String serviceSheet_errorName = 'service_sheet.error_name';
  static const String serviceSheet_errorMode = 'service_sheet.error_mode';

  // ─── Specialty sheet ──────────────────────────────────────────────────────
  static const String specialtySheet_titleAdd = 'specialty_sheet.title_add';
  static const String specialtySheet_titleEdit = 'specialty_sheet.title_edit';
  static const String specialtySheet_nameLabel = 'specialty_sheet.name_label';
  static const String specialtySheet_nameHint = 'specialty_sheet.name_hint';
  static const String specialtySheet_descLabel = 'specialty_sheet.desc_label';
  static const String specialtySheet_descHint = 'specialty_sheet.desc_hint';
  static const String specialtySheet_doctorsLabel =
      'specialty_sheet.doctors_label';
  static const String specialtySheet_save = 'specialty_sheet.save';
  static const String specialtySheet_successAdd = 'specialty_sheet.success_add';
  static const String specialtySheet_successEdit =
      'specialty_sheet.success_edit';

  // ─── Branch sheet ─────────────────────────────────────────────────────────
  static const String branchSheet_titleAdd = 'branch_sheet.title_add';
  static const String branchSheet_titleEdit = 'branch_sheet.title_edit';
  static const String branchSheet_nameLabel = 'branch_sheet.name_label';
  static const String branchSheet_nameHint = 'branch_sheet.name_hint';
  static const String branchSheet_addressLabel = 'branch_sheet.address_label';
  static const String branchSheet_addressHint = 'branch_sheet.address_hint';
  static const String branchSheet_mapHint = 'branch_sheet.map_hint';
  static const String branchSheet_mapPicked = 'branch_sheet.map_picked';
  static const String branchSheet_hoursLabel = 'branch_sheet.hours_label';
  static const String branchSheet_hoursFrom = 'branch_sheet.hours_from';
  static const String branchSheet_hoursTo = 'branch_sheet.hours_to';
  static const String branchSheet_servicesLabel = 'branch_sheet.services_label';
  static const String branchSheet_save = 'branch_sheet.save';
  static const String branchSheet_successAdd = 'branch_sheet.success_add';
  static const String branchSheet_successEdit = 'branch_sheet.success_edit';

  // ─── Policy ───────────────────────────────────────────────────────────────
  static const String policyScreen_title = 'policy_screen.title';
  static const String policyScreen_cancelSection =
      'policy_screen.cancel_section';
  static const String policyScreen_allowCancel = 'policy_screen.allow_cancel';
  static const String policyScreen_allowCancelSub =
      'policy_screen.allow_cancel_sub';
  static const String policyScreen_allowReschedule =
      'policy_screen.allow_reschedule';
  static const String policyScreen_allowRescheduleSub =
      'policy_screen.allow_reschedule_sub';
  static const String policyScreen_autoRefund = 'policy_screen.auto_refund';
  static const String policyScreen_autoRefundSub =
      'policy_screen.auto_refund_sub';
  static const String policyScreen_reminderSection =
      'policy_screen.reminder_section';
  static const String policyScreen_reminderDay = 'policy_screen.reminder_day';
  static const String policyScreen_reminderDaySub =
      'policy_screen.reminder_day_sub';
  static const String policyScreen_reminderHour = 'policy_screen.reminder_hour';
  static const String policyScreen_reminderHourSub =
      'policy_screen.reminder_hour_sub';
  static const String policyScreen_checkin = 'policy_screen.checkin';
  static const String policyScreen_checkinSub = 'policy_screen.checkin_sub';
  static const String policyScreen_paymentSection =
      'policy_screen.payment_section';
  static const String policyScreen_videoPrepayment =
      'policy_screen.video_prepayment';
  static const String policyScreen_videoPrepaymentSub =
      'policy_screen.video_prepayment_sub';
  static const String policyScreen_saveSuccess = 'policy_screen.save_success';

  // ─── Branding ─────────────────────────────────────────────────────────────
  static const String brandingScreen_title = 'branding_screen.title';
  static const String brandingScreen_subtitle = 'branding_screen.subtitle';
  static const String brandingScreen_infoBanner = 'branding_screen.info_banner';
  static const String brandingScreen_pickTheme = 'branding_screen.pick_theme';
  static const String brandingScreen_previewTitle =
      'branding_screen.preview_title';
  static const String brandingScreen_nameTitle = 'branding_screen.name_title';
  static const String brandingScreen_nameHint = 'branding_screen.name_hint';
  static const String brandingScreen_save = 'branding_screen.save';
  static const String brandingScreen_saveSuccess =
      'branding_screen.save_success';
  static const String brandingScreen_reset = 'branding_screen.reset';
  static const String brandingScreen_resetSuccess =
      'branding_screen.reset_success';

  // ─── Analytics ────────────────────────────────────────────────────────────
  static const String analyticsScreen_title = 'analytics_screen.title';
  static const String analyticsScreen_exportToast =
      'analytics_screen.export_toast';
  static const String analyticsScreen_statRevenue =
      'analytics_screen.stat_revenue';
  static const String analyticsScreen_statNewPatients =
      'analytics_screen.stat_new_patients';
  static const String analyticsScreen_statNewPatientsSub =
      'analytics_screen.stat_new_patients_sub';
  static const String analyticsScreen_statNoShow =
      'analytics_screen.stat_no_show';
  static const String analyticsScreen_statNoShowSub =
      'analytics_screen.stat_no_show_sub';
  static const String analyticsScreen_statVideo = 'analytics_screen.stat_video';
  static const String analyticsScreen_statVideoSub =
      'analytics_screen.stat_video_sub';
  static const String analyticsScreen_revenueChartTitle =
      'analytics_screen.revenue_chart_title';
  static const String analyticsScreen_specialtyBreakdownTitle =
      'analytics_screen.specialty_breakdown_title';

  // ─── Dashboard (Today) ──────────────────────────────────────────────────
  static const String dashboard_eyebrowToday = 'dashboard.eyebrow_today';
  static const String dashboard_title = 'dashboard.title';
  static const String dashboard_notificationsToast =
      'dashboard.notifications_toast';
  static const String dashboard_statAppointments =
      'dashboard.stat_appointments';
  static const String dashboard_statAppointmentsSub =
      'dashboard.stat_appointments_sub';
  static const String dashboard_statNewBookings = 'dashboard.stat_new_bookings';
  static const String dashboard_statNewBookingsSub =
      'dashboard.stat_new_bookings_sub';
  static const String dashboard_statWaiting = 'dashboard.stat_waiting';
  static const String dashboard_statWaitingSub = 'dashboard.stat_waiting_sub';
  static const String dashboard_statPendingResults =
      'dashboard.stat_pending_results';
  static const String dashboard_statPendingResultsSub =
      'dashboard.stat_pending_results_sub';
  static const String dashboard_startShift = 'dashboard.start_shift';
  static const String dashboard_setupTitle = 'dashboard.setup_title';
  static const String dashboard_setupServices = 'dashboard.setup_services';
  static const String dashboard_setupSpecialties =
      'dashboard.setup_specialties';
  static const String dashboard_setupDoctors = 'dashboard.setup_doctors';
  static const String dashboard_setupSchedules = 'dashboard.setup_schedules';
  static const String dashboard_setupBranches = 'dashboard.setup_branches';
  static const String dashboard_setupPolicy = 'dashboard.setup_policy';
  static const String dashboard_doctorsNowTitle = 'dashboard.doctors_now_title';
  static const String dashboard_manage = 'dashboard.manage';
  static const String dashboard_nextLabel = 'dashboard.next_label';
  static const String dashboard_recentBookingsTitle =
      'dashboard.recent_bookings_title';
  static const String dashboard_seeAll = 'dashboard.see_all';

  // ─── Queue ────────────────────────────────────────────────────────────────
  static const String queue_eyebrow = 'queue.eyebrow';
  static const String queue_title = 'queue.title';
  static const String queue_tabWaiting = 'queue.tab_waiting';
  static const String queue_tabInRoom = 'queue.tab_in_room';
  static const String queue_tabDone = 'queue.tab_done';
  static const String queue_callIn = 'queue.call_in';
  static const String queue_startConsult = 'queue.start_consult';
  static const String queue_finishConsult = 'queue.finish_consult';
  static const String queue_emptyRoom = 'queue.empty_room';
  static const String queue_emptyWaiting = 'queue.empty_waiting';
  static const String queue_emptyDone = 'queue.empty_done';
  static const String queue_walkinTitle = 'queue.walkin_title';
  static const String queue_walkinMrnLabel = 'queue.walkin_mrn_label';
  static const String queue_walkinMrnHint = 'queue.walkin_mrn_hint';
  static const String queue_walkinNameLabel = 'queue.walkin_name_label';
  static const String queue_walkinNameHint = 'queue.walkin_name_hint';
  static const String queue_walkinSubmit = 'queue.walkin_submit';
  static const String queue_walkinSuccess = 'queue.walkin_success';
  static const String queue_calledInToast = 'queue.called_in_toast';
  static const String queue_noAppointment = 'queue.no_appointment';
  static const String queue_noMrn = 'queue.no_mrn';
  static const String queue_cancelAction = 'queue.cancel_action';
  static const String queue_cancelConfirmTitle = 'queue.cancel_confirm_title';
  static const String queue_cancelConfirmMessage =
      'queue.cancel_confirm_message';
  static const String queue_cancelSuccess = 'queue.cancel_success';

  // ─── Consultation ─────────────────────────────────────────────────────────
  static const String consultation_tabConsult = 'consultation.tab_consult';
  static const String consultation_tabHistory = 'consultation.tab_history';
  static const String consultation_allergyPrefix =
      'consultation.allergy_prefix';
  static const String consultation_complaintLabel =
      'consultation.complaint_label';
  static const String consultation_complaintHint =
      'consultation.complaint_hint';
  static const String consultation_diagnosisLabel =
      'consultation.diagnosis_label';
  static const String consultation_diagnosisHint =
      'consultation.diagnosis_hint';
  static const String consultation_prescriptionLabel =
      'consultation.prescription_label';
  static const String consultation_addMedication =
      'consultation.add_medication';
  static const String consultation_noMedications =
      'consultation.no_medications';
  static const String consultation_medicationNameHint =
      'consultation.medication_name_hint';
  static const String consultation_medicationDoseHint =
      'consultation.medication_dose_hint';
  static const String consultation_medicationDurationHint =
      'consultation.medication_duration_hint';
  static const String consultation_ordersLabel = 'consultation.orders_label';
  static const String consultation_ordersHint = 'consultation.orders_hint';
  static const String consultation_xraysLabel = 'consultation.xrays_label';
  static const String consultation_finishConsult =
      'consultation.finish_consult';
  static const String consultation_saveDraft = 'consultation.save_draft';
  static const String consultation_finishSuccess =
      'consultation.finish_success';
  static const String consultation_draftSaved = 'consultation.draft_saved';
  static const String consultation_vitalsTitle = 'consultation.vitals_title';
  static const String consultation_vitalPressure =
      'consultation.vital_pressure';
  static const String consultation_vitalPulse = 'consultation.vital_pulse';
  static const String consultation_vitalTemp = 'consultation.vital_temp';
  static const String consultation_vitalO2 = 'consultation.vital_o2';
  static const String consultation_lastVisitTitle =
      'consultation.last_visit_title';
  static const String consultation_recentResultsTitle =
      'consultation.recent_results_title';
  static const String consultation_activeMedicationsTitle =
      'consultation.active_medications_title';

  // ─── Status ───────────────────────────────────────────────────────────────
  static const String status_available = 'status.available';
  static const String status_inExam = 'status.in_exam';
  static const String status_onLeave = 'status.on_leave';
  static const String status_paid = 'status.paid';
  static const String status_confirmed = 'status.confirmed';
  static const String status_pendingPayment = 'status.pending_payment';
  static const String status_normal = 'status.normal';
  static const String status_low = 'status.low';
  static const String status_inProgress = 'status.in_progress';
  static const String status_critical = 'status.critical';
  static const String status_newOrder = 'status.new_order';
  static const String status_abnormal = 'status.abnormal';
  static const String status_caution = 'status.caution';
  static const String status_expired = 'status.expired';
  static const String status_active = 'status.active';
  static const String status_issued = 'status.issued';
  static const String status_certified = 'status.certified';
  static const String status_arrived = 'status.arrived';
  static const String status_waitingMinutes = 'status.waiting_minutes';
  static const String status_waitingOneMinute = 'status.waiting_one_minute';
  static const String status_docSickLeave = 'status.doc_sick_leave';
  static const String status_docMedicalReport = 'status.doc_medical_report';

  // ─── Agenda ───────────────────────────────────────────────────────────────
  static const String agenda_title = 'agenda.title';
  static const String agenda_subtitle = 'agenda.subtitle';
  static const String agenda_statusDone = 'agenda.status_done';
  static const String agenda_statusArrived = 'agenda.status_arrived';
  static const String agenda_statusNotArrived = 'agenda.status_not_arrived';
  static const String agenda_reminderToast = 'agenda.reminder_toast';
  static const String agenda_videoStartToast = 'agenda.video_start_toast';
  static const String agenda_editToast = 'agenda.edit_toast';

  // ─── Inbox ────────────────────────────────────────────────────────────────
  static const String inbox_title = 'inbox.title';
  static const String inbox_subtitle = 'inbox.subtitle';
  static const String inbox_noteLabel = 'inbox.note_label';
  static const String inbox_noteHint = 'inbox.note_hint';
  static const String inbox_approveSubmit = 'inbox.approve_submit';
  static const String inbox_approveSuccess = 'inbox.approve_success';

  // ─── Bookings ─────────────────────────────────────────────────────────────
  static const String bookings_title = 'bookings.title';
  static const String bookings_subtitle = 'bookings.subtitle';
  static const String bookings_tabAll = 'bookings.tab_all';
  static const String bookings_tabPending = 'bookings.tab_pending';
  static const String bookings_tabConfirmed = 'bookings.tab_confirmed';
  static const String bookings_todaySection = 'bookings.today_section';
  static const String bookings_tomorrowSection = 'bookings.tomorrow_section';
  static const String bookings_sendPaymentLink = 'bookings.send_payment_link';
  static const String bookings_paymentLinkSent = 'bookings.payment_link_sent';

  // ─── Calendar screen ──────────────────────────────────────────────────────
  static const String calendarScreen_title = 'calendar_screen.title';
  static const String calendarScreen_subtitle = 'calendar_screen.subtitle';
  static const String calendarScreen_filterAll = 'calendar_screen.filter_all';
  static const String calendarScreen_slotOpen = 'calendar_screen.slot_open';
  static const String calendarScreen_legendLight =
      'calendar_screen.legend_light';
  static const String calendarScreen_legendMedium =
      'calendar_screen.legend_medium';
  static const String calendarScreen_legendBusy = 'calendar_screen.legend_busy';
  static const String calendarScreen_dayCount = 'calendar_screen.day_count';
  static const String calendarScreen_addAppointment =
      'calendar_screen.add_appointment';
  static const String calendarScreen_month1 = 'calendar_screen.month_1';
  static const String calendarScreen_month2 = 'calendar_screen.month_2';
  static const String calendarScreen_month3 = 'calendar_screen.month_3';
  static const String calendarScreen_month4 = 'calendar_screen.month_4';
  static const String calendarScreen_month5 = 'calendar_screen.month_5';
  static const String calendarScreen_month6 = 'calendar_screen.month_6';
  static const String calendarScreen_month7 = 'calendar_screen.month_7';
  static const String calendarScreen_month8 = 'calendar_screen.month_8';
  static const String calendarScreen_month9 = 'calendar_screen.month_9';
  static const String calendarScreen_month10 = 'calendar_screen.month_10';
  static const String calendarScreen_month11 = 'calendar_screen.month_11';
  static const String calendarScreen_month12 = 'calendar_screen.month_12';
  static const String calendarScreen_wdSun = 'calendar_screen.wd_sun';
  static const String calendarScreen_wdMon = 'calendar_screen.wd_mon';
  static const String calendarScreen_wdTue = 'calendar_screen.wd_tue';
  static const String calendarScreen_wdWed = 'calendar_screen.wd_wed';
  static const String calendarScreen_wdThu = 'calendar_screen.wd_thu';
  static const String calendarScreen_wdFri = 'calendar_screen.wd_fri';
  static const String calendarScreen_wdSat = 'calendar_screen.wd_sat';

  // ─── Quick action sheet (FAB) ─────────────────────────────────────────────
  static const String quickAction_title = 'quick_action.title';
  static const String quickAction_subtitle = 'quick_action.subtitle';
  static const String quickAction_walkin = 'quick_action.walkin';
  static const String quickAction_book = 'quick_action.book';
  static const String quickAction_issueDoc = 'quick_action.issue_doc';
  static const String quickAction_inbox = 'quick_action.inbox';

  // ─── Add appointment sheet (shared: calendar + bookings) ─────────────────
  static const String appt_title = 'appt.title';
  static const String appt_patientLabel = 'appt.patient_label';
  static const String appt_patientHint = 'appt.patient_hint';
  static const String appt_typeLabel = 'appt.type_label';
  static const String appt_typeClinic = 'appt.type_clinic';
  static const String appt_typeVideo = 'appt.type_video';
  static const String appt_branchLabel = 'appt.branch_label';
  static const String appt_serviceLabel = 'appt.service_label';
  static const String appt_doctorLabel = 'appt.doctor_label';
  static const String appt_timeLabel = 'appt.time_label';
  static const String appt_totalLabel = 'appt.total_label';
  static const String appt_confirm = 'appt.confirm';
  static const String appt_success = 'appt.success';

  // ─── Staff ────────────────────────────────────────────────────────────────
  static const String staff_title = 'staff.title';
  static const String staff_subtitle = 'staff.subtitle';
  static const String staff_ratingLabel = 'staff.rating_label';
  static const String staff_occupancyLabel = 'staff.occupancy_label';
  static const String staff_editPricing = 'staff.edit_pricing';
  static const String staff_schedules = 'staff.schedules';

  // ─── Schedules ────────────────────────────────────────────────────────────
  static const String schedules_title = 'schedules.title';
  static const String schedules_subtitle = 'schedules.subtitle';
  static const String schedules_tabAll = 'schedules.tab_all';
  static const String schedules_modeClinic = 'schedules.mode_clinic';
  static const String schedules_modeOnline = 'schedules.mode_online';
  static const String schedules_modeHome = 'schedules.mode_home';
  static const String schedules_daysLabel = 'schedules.days_label';
  static const String schedules_hoursLabel = 'schedules.hours_label';
  static const String schedules_edit = 'schedules.edit';
  static const String schedules_leave = 'schedules.leave';

  // ─── Leave request sheet ──────────────────────────────────────────────────
  static const String leave_title = 'leave.title';
  static const String leave_fromLabel = 'leave.from_label';
  static const String leave_toLabel = 'leave.to_label';
  static const String leave_dateHint = 'leave.date_hint';
  static const String leave_submit = 'leave.submit';
  static const String leave_success = 'leave.success';

  // ─── Doctor sheet ─────────────────────────────────────────────────────────
  static const String doctorSheet_titleAdd = 'doctor_sheet.title_add';
  static const String doctorSheet_titleEdit = 'doctor_sheet.title_edit';
  static const String doctorSheet_nameLabel = 'doctor_sheet.name_label';
  static const String doctorSheet_nameHint = 'doctor_sheet.name_hint';
  static const String doctorSheet_rankLabel = 'doctor_sheet.rank_label';
  static const String doctorSheet_rankHint = 'doctor_sheet.rank_hint';
  static const String doctorSheet_experienceLabel =
      'doctor_sheet.experience_label';
  static const String doctorSheet_experienceHint =
      'doctor_sheet.experience_hint';
  static const String doctorSheet_specialtyLabel =
      'doctor_sheet.specialty_label';
  static const String doctorSheet_bioLabel = 'doctor_sheet.bio_label';
  static const String doctorSheet_bioHint = 'doctor_sheet.bio_hint';
  static const String doctorSheet_servicesLabel = 'doctor_sheet.services_label';
  static const String doctorSheet_servicesAddNew =
      'doctor_sheet.services_add_new';
  static const String doctorSheet_newServiceHint =
      'doctor_sheet.new_service_hint';
  static const String doctorSheet_pricingLabel = 'doctor_sheet.pricing_label';
  static const String doctorSheet_save = 'doctor_sheet.save';
  static const String doctorSheet_successAdd = 'doctor_sheet.success_add';
  static const String doctorSheet_successEdit = 'doctor_sheet.success_edit';
  static const String doctorSheet_openSchedule = 'doctor_sheet.open_schedule';
  static const String doctorSheet_errorName = 'doctor_sheet.error_name';

  // ─── New schedule sheet ───────────────────────────────────────────────────
  static const String newScheduleSheet_title = 'new_schedule_sheet.title';
  static const String newScheduleSheet_branchLabel =
      'new_schedule_sheet.branch_label';
  static const String newScheduleSheet_doctorLabel =
      'new_schedule_sheet.doctor_label';
  static const String newScheduleSheet_typeLabel =
      'new_schedule_sheet.type_label';
  static const String newScheduleSheet_typeClinic =
      'new_schedule_sheet.type_clinic';
  static const String newScheduleSheet_typeOnline =
      'new_schedule_sheet.type_online';
  static const String newScheduleSheet_typeHome =
      'new_schedule_sheet.type_home';
  static const String newScheduleSheet_next = 'new_schedule_sheet.next';

  // ─── Schedule editor ──────────────────────────────────────────────────────
  static const String scheduleEditor_title = 'schedule_editor.title';
  static const String scheduleEditor_servicesLabel =
      'schedule_editor.services_label';
  static const String scheduleEditor_onlineNowLabel =
      'schedule_editor.online_now_label';
  static const String scheduleEditor_onlineNowSub =
      'schedule_editor.online_now_sub';
  static const String scheduleEditor_coverageLabel =
      'schedule_editor.coverage_label';
  static const String scheduleEditor_daysLabel = 'schedule_editor.days_label';
  static const String scheduleEditor_daySat = 'schedule_editor.day_sat';
  static const String scheduleEditor_daySun = 'schedule_editor.day_sun';
  static const String scheduleEditor_dayMon = 'schedule_editor.day_mon';
  static const String scheduleEditor_dayTue = 'schedule_editor.day_tue';
  static const String scheduleEditor_dayWed = 'schedule_editor.day_wed';
  static const String scheduleEditor_dayThu = 'schedule_editor.day_thu';
  static const String scheduleEditor_dayFri = 'schedule_editor.day_fri';
  static const String scheduleEditor_hoursLabel = 'schedule_editor.hours_label';
  static const String scheduleEditor_hoursFrom = 'schedule_editor.hours_from';
  static const String scheduleEditor_hoursTo = 'schedule_editor.hours_to';
  static const String scheduleEditor_slotsFormula =
      'schedule_editor.slots_formula';
  static const String scheduleEditor_unitClinic = 'schedule_editor.unit_clinic';
  static const String scheduleEditor_unitOnline = 'schedule_editor.unit_online';
  static const String scheduleEditor_unitHome = 'schedule_editor.unit_home';
  static const String scheduleEditor_branchLabel =
      'schedule_editor.branch_label';
  static const String scheduleEditor_save = 'schedule_editor.save';
  static const String scheduleEditor_success = 'schedule_editor.success';

  // ─── Homecare ─────────────────────────────────────────────────────────────
  static const String homecareScreen_title = 'homecare_screen.title';
  static const String homecareScreen_subtitle = 'homecare_screen.subtitle';
  static const String homecareScreen_infoBanner = 'homecare_screen.info_banner';
  static const String homecareScreen_statPending =
      'homecare_screen.stat_pending';
  static const String homecareScreen_statAvailable =
      'homecare_screen.stat_available';
  static const String homecareScreen_statCapacity =
      'homecare_screen.stat_capacity';
  static const String homecareScreen_pendingSection =
      'homecare_screen.pending_section';
  static const String homecareScreen_assignedSection =
      'homecare_screen.assigned_section';
  static const String homecareScreen_assignSuccess =
      'homecare_screen.assign_success';
  static const String homecare_assign = 'homecare.assign';
  static const String homecare_onTheWay = 'homecare.on_the_way';

  // ─── Billing ──────────────────────────────────────────────────────────────
  static const String billing_title = 'billing.title';
  static const String billing_subtitle = 'billing.subtitle';
  static const String billing_statPaidOnline = 'billing.stat_paid_online';
  static const String billing_statPending = 'billing.stat_pending';
  static const String billing_paidOnline = 'billing.paid_online';
  static const String billing_pendingCollection = 'billing.pending_collection';
  static const String billing_insurance = 'billing.insurance';

  // ─── Docs ─────────────────────────────────────────────────────────────────
  static const String docsScreen_title = 'docs_screen.title';
  static const String docsScreen_pendingIssue = 'docs_screen.pending_issue';
  static const String docsScreen_certifyAndSend =
      'docs_screen.certify_and_send';
  static const String docsScreen_issueTitle = 'docs_screen.issue_title';
  static const String docsScreen_typeLabel = 'docs_screen.type_label';
  static const String docsScreen_detailLabel = 'docs_screen.detail_label';
  static const String docsScreen_detailHint = 'docs_screen.detail_hint';
  static const String docsScreen_issueSubmit = 'docs_screen.issue_submit';
  static const String docsScreen_issueSuccess = 'docs_screen.issue_success';
  static const String docsScreen_certifySuccess = 'docs_screen.certify_success';
  static const String docsScreen_downloadToast = 'docs_screen.download_toast';

  // ─── Orders ───────────────────────────────────────────────────────────────
  static const String ordersScreen_title = 'orders_screen.title';
  static const String ordersScreen_subtitle = 'orders_screen.subtitle';
  static const String orders_infoBanner = 'orders.info_banner';
  static const String orders_tabAll = 'orders.tab_all';
  static const String orders_tabPending = 'orders.tab_pending';
  static const String orders_tabCompleted = 'orders.tab_completed';
  static const String orders_upload = 'orders.upload';
  static const String orders_requestedBy = 'orders.requested_by';
  static const String orders_uploadTitle = 'orders.upload_title';
  static const String orders_resultRateLabel = 'orders.result_rate_label';
  static const String orders_noteLabel = 'orders.note_label';
  static const String orders_noteHint = 'orders.note_hint';
  static const String orders_uploadFileHint = 'orders.upload_file_hint';
  static const String orders_uploadNote = 'orders.upload_note';
  static const String orders_uploadSubmit = 'orders.upload_submit';
  static const String orders_uploadSuccess = 'orders.upload_success';

  // ─── Patients (list) ──────────────────────────────────────────────────────
  static const String patientsScreen_title = 'patients_screen.title';
  static const String patientsScreen_subtitle = 'patients_screen.subtitle';
  static const String patients_searchHint = 'patients.search_hint';
  static const String patients_addNew = 'patients.add_new';
  static const String patients_lastVisitLabel = 'patients.last_visit_label';
  static const String patients_badgeAllergy = 'patients.badge_allergy';
  static const String patients_badgeCriticalResult =
      'patients.badge_critical_result';
  static const String patients_badgeVaccination = 'patients.badge_vaccination';

  // ─── Patient file ─────────────────────────────────────────────────────────
  static const String pfile_statVisits = 'pfile.stat_visits';
  static const String pfile_statInProgress = 'pfile.stat_in_progress';
  static const String pfile_statActiveMeds = 'pfile.stat_active_meds';
  static const String pfile_statLastVisit = 'pfile.stat_last_visit';
  static const String pfile_startConsult = 'pfile.start_consult';
  static const String pfile_shareRecord = 'pfile.share_record';
  static const String pfile_shareRecordToast = 'pfile.share_record_toast';
  static const String pfile_infoBanner = 'pfile.info_banner';
  static const String pfile_tabVisits = 'pfile.tab_visits';
  static const String pfile_tabResults = 'pfile.tab_results';
  static const String pfile_tabMedications = 'pfile.tab_medications';
  static const String pfile_tabDocuments = 'pfile.tab_documents';
  static const String pfile_visitSummary = 'pfile.visit_summary';
  static const String pfile_print = 'pfile.print';
  static const String pfile_linkedToVisit = 'pfile.linked_to_visit';
  static const String pfile_download = 'pfile.download';
  static const String pfile_noVisitContent = 'pfile.no_visit_content';

  // ─── More ─────────────────────────────────────────────────────────────────
  static const String more_title = 'more.title';
  static const String more_profileCardSubtitle = 'more.profile_card_subtitle';
  static const String more_roleTitle = 'more.role_title';
  static const String more_roleDoctor = 'more.role_doctor';
  static const String more_roleReception = 'more.role_reception';
  static const String more_roleAdmin = 'more.role_admin';
  static const String more_roleSwitchToast = 'more.role_switch_toast';
  static const String more_clinicSection = 'more.clinic_section';
  static const String more_agendaTitle = 'more.agenda_title';
  static const String more_agendaSub = 'more.agenda_sub';
  static const String more_docsTitle = 'more.docs_title';
  static const String more_docsSub = 'more.docs_sub';
  static const String more_homecareTitle = 'more.homecare_title';
  static const String more_homecareSub = 'more.homecare_sub';
  static const String more_billingTitle = 'more.billing_title';
  static const String more_billingSub = 'more.billing_sub';
  static const String more_setupSection = 'more.setup_section';
  static const String more_setupRowTitle = 'more.setup_row_title';
  static const String more_setupRowSub = 'more.setup_row_sub';
  static const String more_adminSection = 'more.admin_section';
  static const String more_staffTitle = 'more.staff_title';
  static const String more_staffSub = 'more.staff_sub';
  static const String more_analyticsTitle = 'more.analytics_title';
  static const String more_analyticsSub = 'more.analytics_sub';

  // ─── Profile ──────────────────────────────────────────────────────────────
  static const String profile_title = 'profile.title';
  static const String profile_loginNow = 'profile.login_now';
  static const String profile_guestName = 'profile.guest_name';
  static const String profile_guestSubtitle = 'profile.guest_subtitle';
  static const String profile_saveChanges = 'profile.save_changes';
  static const String profile_updateSuccess = 'profile.update_success';
  static const String profile_editTitle = 'profile.edit_title';
  static const String profile_editSubtitle = 'profile.edit_subtitle';
  static const String profile_nameLabel = 'profile.name_label';
  static const String profile_nameHint = 'profile.name_hint';
  static const String profile_emailLabel = 'profile.email_label';
  static const String profile_emailHint = 'profile.email_hint';
  static const String profile_phoneReadOnlyNote =
      'profile.phone_read_only_note';

  // ─── Settings ─────────────────────────────────────────────────────────────
  static const String settings_changeLanguage = 'settings.change_language';
  static const String settings_changeLanguageSubtitle =
      'settings.change_language_subtitle';
  static const String settings_languageTitle = 'settings.language_title';
  static const String settings_arabic = 'settings.arabic';
  static const String settings_english = 'settings.english';
  static const String settings_logout = 'settings.logout';
  static const String settings_logoutSubtitle = 'settings.logout_subtitle';
  static const String settings_logoutDialogTitle =
      'settings.logout_dialog_title';
  static const String settings_logoutDialogMessage =
      'settings.logout_dialog_message';

  // ─── Errors ───────────────────────────────────────────────────────────────
  static const String error_unauthorized = 'error.unauthorized';
  static const String error_notFound = 'error.not_found';
  static const String error_generic = 'error.generic';
}
