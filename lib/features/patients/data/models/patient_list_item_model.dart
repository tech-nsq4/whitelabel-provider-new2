import 'package:equatable/equatable.dart';

/// The counts under one patient's `statistics` object.
class PatientStatisticsModel extends Equatable {
  const PatientStatisticsModel({
    this.bookingsCount = 0,
    this.waitingBookingsCount = 0,
    this.lastCompletedBookingDate,
    this.xraysCount = 0,
    this.analysesCount = 0,
    this.prescriptionsCount = 0,
  });

  final int bookingsCount;
  final int waitingBookingsCount;
  final String? lastCompletedBookingDate;
  final int xraysCount;
  final int analysesCount;
  final int prescriptionsCount;

  factory PatientStatisticsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PatientStatisticsModel();
    return PatientStatisticsModel(
      bookingsCount: json['bookings_count'] as int? ?? 0,
      waitingBookingsCount: json['waiting_bookings_count'] as int? ?? 0,
      lastCompletedBookingDate: json['last_completed_booking_date'] as String?,
      xraysCount: json['xrays_count'] as int? ?? 0,
      analysesCount: json['analyses_count'] as int? ?? 0,
      prescriptionsCount: json['prescriptions_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        bookingsCount,
        waitingBookingsCount,
        lastCompletedBookingDate,
        xraysCount,
        analysesCount,
        prescriptionsCount,
      ];
}

/// One row from `GET /users` — the app's registered patients, searchable
/// by name/phone/email. Doubles as the patient-file screen's header data
/// (passed straight through from the list, no separate fetch).
class PatientListItemModel extends Equatable {
  const PatientListItemModel({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.familyMembersCount = 0,
    this.appointmentsCount = 0,
    this.statistics = const PatientStatisticsModel(),
  });

  final int id;

  /// `null` for an account that hasn't set a display name yet.
  final String? name;
  final String? phone;
  final String? email;
  final String? dateOfBirth;
  final String? height;
  final String? weight;
  final int familyMembersCount;
  final int appointmentsCount;
  final PatientStatisticsModel statistics;

  String get displayName {
    final trimmed = name?.trim();
    return (trimmed?.isNotEmpty ?? false) ? trimmed! : (phone ?? '');
  }

  String get initial => displayName.isNotEmpty ? displayName[0] : '؟';

  /// Computed from [dateOfBirth] — `null` when it's missing or unparsable.
  int? get age {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) return null;
    final dob = DateTime.tryParse(dateOfBirth!);
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  factory PatientListItemModel.fromJson(Map<String, dynamic> json) =>
      PatientListItemModel(
        id: json['id'] as int,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        dateOfBirth: json['date_of_birth'] as String?,
        height: json['height'] as String?,
        weight: json['weight'] as String?,
        familyMembersCount: json['family_members_count'] as int? ?? 0,
        appointmentsCount: json['appointments_count'] as int? ?? 0,
        statistics: PatientStatisticsModel.fromJson(
            json['statistics'] as Map<String, dynamic>?),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        dateOfBirth,
        height,
        weight,
        familyMembersCount,
        appointmentsCount,
        statistics,
      ];
}
