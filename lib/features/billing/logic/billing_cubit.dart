import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/billing_repo.dart';
import '../data/models/invoice_model.dart';

part 'billing_state.dart';

class BillingCubit extends Cubit<BillingState> {
  BillingCubit(this._repo) : super(const BillingInitial());

  final BillingRepo _repo;

  Future<void> loadInvoices() async {
    emit(const BillingLoading());
    try {
      final invoices = await _repo.getInvoices();
      emit(BillingSuccess(invoices));
    } catch (e) {
      emit(BillingError(e.toString()));
    }
  }
}
