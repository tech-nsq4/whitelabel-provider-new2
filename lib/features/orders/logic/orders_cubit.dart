import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/lab_order_model.dart';
import '../data/orders_repo.dart';

part 'orders_state.dart';

/// A singleton (not the usual per-screen factory): the bottom nav's orders
/// badge and the orders screen both react to the exact same list — never
/// call `.close()` on it from a screen's `dispose()`.
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repo) : super(const OrdersInitial());

  final OrdersRepo _repo;

  int get totalCount => state is OrdersSuccess ? (state as OrdersSuccess).orders.length : 0;

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    try {
      final orders = await _repo.getOrders();
      emit(OrdersSuccess(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void startOrder(String id) => _updateStatus(id, LabOrderStatus.inProgress);

  void markUploaded(String id) => _updateStatus(id, LabOrderStatus.done);

  void _updateStatus(String id, LabOrderStatus status) {
    final current = state;
    if (current is! OrdersSuccess) return;
    emit(OrdersSuccess([
      for (final order in current.orders)
        if (order.id == id) order.copyWith(status: status) else order,
    ]));
  }
}
