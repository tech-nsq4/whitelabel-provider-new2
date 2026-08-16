import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bookings_repo.dart';
import '../data/models/booking_model.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit(this._repo) : super(const BookingsInitial());

  final BookingsRepo _repo;

  Future<void> loadBookings() async {
    emit(const BookingsLoading());
    try {
      final bookings = await _repo.getBookings();
      emit(BookingsSuccess(bookings));
    } catch (e) {
      emit(BookingsError(e.toString()));
    }
  }
}
