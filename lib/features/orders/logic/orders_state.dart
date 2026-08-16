part of 'orders_cubit.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

final class OrdersSuccess extends OrdersState {
  final List<LabOrderModel> orders;
  const OrdersSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}

final class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
