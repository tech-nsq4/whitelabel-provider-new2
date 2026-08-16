part of 'billing_cubit.dart';

sealed class BillingState extends Equatable {
  const BillingState();
  @override
  List<Object?> get props => [];
}

final class BillingInitial extends BillingState {
  const BillingInitial();
}

final class BillingLoading extends BillingState {
  const BillingLoading();
}

final class BillingSuccess extends BillingState {
  final List<InvoiceModel> invoices;
  const BillingSuccess(this.invoices);
  @override
  List<Object?> get props => [invoices];
}

final class BillingError extends BillingState {
  final String message;
  const BillingError(this.message);
  @override
  List<Object?> get props => [message];
}
