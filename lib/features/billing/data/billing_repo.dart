import 'models/invoice_model.dart';

/// TODO(api): mock data until `ApiEndpoints.billing` exists.
class BillingRepo {
  Future<List<InvoiceModel>> getInvoices() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      InvoiceModel(
        id: 'inv-1',
        patientName: 'سعد المطيري',
        invoiceNumber: 'INV-2215',
        serviceLabel: 'كشف + تحاليل',
        price: 390,
        status: InvoiceStatus.pendingCollection,
      ),
      InvoiceModel(
        id: 'inv-2',
        patientName: 'منيرة العتيبي',
        invoiceNumber: 'INV-2214',
        serviceLabel: 'كشف باطنة',
        price: 150,
        status: InvoiceStatus.paidOnline,
      ),
      InvoiceModel(
        id: 'inv-3',
        patientName: 'وليد الشمري',
        invoiceNumber: 'INV-2217',
        serviceLabel: 'فحص شامل',
        price: 299,
        status: InvoiceStatus.insurance,
      ),
    ];
  }
}
