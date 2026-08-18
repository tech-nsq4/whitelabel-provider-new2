import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/test_request_model.dart';
import '../data/orders_repo.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repo) : super(const OrdersInitial());

  final OrdersRepo _repo;

  int get pendingCount => state is OrdersSuccess
      ? (state as OrdersSuccess)
          .requests
          .where((r) => !r.hasResult)
          .length
      : 0;

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    try {
      final requests = await _repo.getTestRequests();
      emit(OrdersSuccess(requests));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(OrdersError(msg));
    }
  }

  Future<bool> uploadResult({
    required String testRequestId,
    required ResultRate resultRate,
    String? note,
    File? image,
  }) async {
    final current = state;
    if (current is! OrdersSuccess) return false;
    try {
      await _repo.uploadResult(
        testRequestId: testRequestId,
        resultRate: resultRate,
        note: note,
        image: image,
      );
      emit(OrdersSuccess([
        for (final request in current.requests)
          if ('${request.id}' == testRequestId)
            request.copyWith(hasResult: true, resultRate: resultRate, note: note)
          else
            request,
      ]));
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
