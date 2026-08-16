import 'package:equatable/equatable.dart';

enum StaffAvailability { available, onLeave }

/// One row on the "الأطباء" staff-pricing screen.
class DoctorProfileModel extends Equatable {
  const DoctorProfileModel({
    required this.name,
    required this.initial,
    required this.specialty,
    required this.availability,
    required this.pricing,
    required this.rating,
    this.occupancyPercent,
  });

  final String name;
  final String initial;
  final String specialty;
  final StaffAvailability availability;

  /// Mode label (e.g. "عيادة"/"فيديو"/"منزلية") → price.
  final Map<String, int> pricing;
  final double rating;

  /// `null` when the doctor is on leave.
  final int? occupancyPercent;

  @override
  List<Object?> get props =>
      [name, initial, specialty, availability, pricing, rating, occupancyPercent];
}
