part of 'staff_cubit.dart';

sealed class StaffState extends Equatable {
  const StaffState();
  @override
  List<Object?> get props => [];
}

final class StaffInitial extends StaffState {
  const StaffInitial();
}

final class StaffLoading extends StaffState {
  const StaffLoading();
}

final class StaffSuccess extends StaffState {
  final List<DoctorProfileModel> doctors;
  const StaffSuccess(this.doctors);
  @override
  List<Object?> get props => [doctors];
}

final class StaffError extends StaffState {
  final String message;
  const StaffError(this.message);
  @override
  List<Object?> get props => [message];
}
