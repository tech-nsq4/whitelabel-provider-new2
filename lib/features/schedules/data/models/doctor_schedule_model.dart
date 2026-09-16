import 'package:equatable/equatable.dart';

import '../../../staff/data/models/doctor_profile_model.dart';

class DoctorScheduleModel extends Equatable {
  const DoctorScheduleModel({
    required this.id,
    required this.name,
    this.description,
    this.experience,
    this.price,
    this.image,
    this.specializations = const [],
    this.clinics = const [],
  });

  final int id;
  final String name;
  final String? description;
  final int? experience;
  final String? price;
  final String? image;
  final List<DoctorSpecialization> specializations;
  final List<ClinicScheduleModel> clinics;

  String get initial {
    final stripped = name.replaceFirst('د. ', '').trim();
    final source = stripped.isNotEmpty ? stripped : name;
    return source.isNotEmpty ? source[0] : '؟';
  }

  String get specializationsLabel =>
      specializations.map((s) => s.title).join('، ');

  int get timetablesCount =>
      clinics.fold(0, (total, clinic) => total + clinic.timeTables.length);

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      experience: (json['experience'] as num?)?.toInt(),
      price: json['price']?.toString(),
      image: json['image'] as String?,
      specializations:
          _parseList(json['specializations'], DoctorSpecialization.fromJson),
      clinics: _parseList(json['clinics'], ClinicScheduleModel.fromJson),
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, experience, price, image, specializations, clinics];
}

class ClinicScheduleModel extends Equatable {
  const ClinicScheduleModel({
    required this.id,
    required this.name,
    this.address,
    this.location,
    this.timeTables = const [],
  });

  final int id;
  final String name;
  final String? address;
  final DoctorLocation? location;
  final List<TimeTableModel> timeTables;

  int get slotsCount => timeTables.fold(
        0,
        (total, table) =>
            total + table.days.fold(0, (sum, day) => sum + day.times.length),
      );

  factory ClinicScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClinicScheduleModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      location: json['location'] is Map<String, dynamic>
          ? DoctorLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      timeTables: _parseList(json['time_tables'], TimeTableModel.fromJson),
    );
  }

  @override
  List<Object?> get props => [id, name, address, location, timeTables];
}

class TimeTableModel extends Equatable {
  const TimeTableModel({
    required this.id,
    required this.name,
    this.notes,
    this.type,
    this.scheduleType,
    this.startDate,
    this.endDate,
    this.sessionMinutes,
    this.minutesBetweenSessions,
    this.sessionsPerSlot,
    this.shift,
    this.days = const [],
  });

  final int id;
  final String name;
  final String? notes;
  final String? type;
  final String? scheduleType;
  final String? startDate;
  final String? endDate;
  final int? sessionMinutes;
  final int? minutesBetweenSessions;
  final int? sessionsPerSlot;
  final TimeTableShiftModel? shift;
  final List<DayScheduleModel> days;

  int get slotsCount => days.fold(0, (total, day) => total + day.times.length);

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      notes: json['notes'] as String?,
      type: json['type'] as String?,
      scheduleType: json['schedule_type'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      sessionMinutes: (json['session_hours'] as num?)?.toInt(),
      minutesBetweenSessions:
          (json['duration_between_sessions'] as num?)?.toInt(),
      sessionsPerSlot: (json['sessions'] as num?)?.toInt(),
      shift: json['shift'] is Map<String, dynamic>
          ? TimeTableShiftModel.fromJson(json['shift'] as Map<String, dynamic>)
          : null,
      days: _parseList(json['schedules'], DayScheduleModel.fromJson),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        notes,
        type,
        scheduleType,
        startDate,
        endDate,
        sessionMinutes,
        minutesBetweenSessions,
        sessionsPerSlot,
        shift,
        days,
      ];
}

class TimeTableShiftModel extends Equatable {
  const TimeTableShiftModel({
    this.firstStart,
    this.firstEnd,
    this.secondStart,
    this.secondEnd,
    this.thirdStart,
    this.thirdEnd,
  });

  final String? firstStart;
  final String? firstEnd;
  final String? secondStart;
  final String? secondEnd;
  final String? thirdStart;
  final String? thirdEnd;

  factory TimeTableShiftModel.fromJson(Map<String, dynamic> json) =>
      TimeTableShiftModel(
        firstStart: json['first_shift_start'] as String?,
        firstEnd: json['first_shift_end'] as String?,
        secondStart: json['second_shift_start'] as String?,
        secondEnd: json['second_shift_end'] as String?,
        thirdStart: json['third_shift_start'] as String?,
        thirdEnd: json['third_shift_end'] as String?,
      );

  @override
  List<Object?> get props =>
      [firstStart, firstEnd, secondStart, secondEnd, thirdStart, thirdEnd];
}

class DayScheduleModel extends Equatable {
  const DayScheduleModel({
    required this.id,
    required this.day,
    this.times = const [],
  });

  final int id;
  final String day;
  final List<TimeSlotModel> times;

  int get availableCount => times.where((t) => t.available).length;

  factory DayScheduleModel.fromJson(Map<String, dynamic> json) =>
      DayScheduleModel(
        id: json['id'] as int? ?? 0,
        day: json['day'] as String? ?? '',
        times: _parseList(json['times'], TimeSlotModel.fromJson),
      );

  @override
  List<Object?> get props => [id, day, times];
}

class TimeSlotModel extends Equatable {
  const TimeSlotModel({
    required this.time,
    required this.available,
    this.shift,
  });

  final String time;
  final bool available;
  final String? shift;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
        time: json['time'] as String? ?? '',
        available: ((json['available'] as num?)?.toInt() ?? 0) > 0,
        shift: json['shift'] as String?,
      );

  @override
  List<Object?> get props => [time, available, shift];
}

List<T> _parseList<T>(
    dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map(fromJson).toList();
}
