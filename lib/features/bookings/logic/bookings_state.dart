part of 'bookings_cubit.dart';

sealed class BookingsState extends Equatable {
  const BookingsState();
  @override
  List<Object?> get props => [];
}

final class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

final class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

final class BookingsSuccess extends BookingsState {
  final List<BookingModel> bookings;
  const BookingsSuccess(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

final class BookingsError extends BookingsState {
  final String message;
  const BookingsError(this.message);
  @override
  List<Object?> get props => [message];
}
