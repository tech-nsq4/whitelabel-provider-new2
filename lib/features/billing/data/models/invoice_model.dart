import 'package:equatable/equatable.dart';

enum InvoiceStatus { paidOnline, pendingCollection, insurance }

/// One row on the "الفواتير" billing screen.
class InvoiceModel extends Equatable {
  const InvoiceModel({
    required this.id,
    required this.patientName,
    required this.invoiceNumber,
    required this.serviceLabel,
    required this.price,
    required this.status,
  });

  final String id;
  final String patientName;
  final String invoiceNumber;
  final String serviceLabel;
  final int price;
  final InvoiceStatus status;

  @override
  List<Object?> get props => [id, patientName, invoiceNumber, serviceLabel, price, status];
}
