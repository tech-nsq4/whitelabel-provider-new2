import 'models/lab_order_model.dart';

/// Reads and mutates the lab/imaging order queue.
///
/// TODO(api): mock data until `ApiEndpoints.orders` exists — swap
/// [getOrders] for a real `DioClient.get` call and keep the return shape so
/// [OrdersCubit] doesn't need to change.
class OrdersRepo {
  final _orders = <LabOrderModel>[
    const LabOrderModel(
      id: 'ord-1',
      patientName: 'سعد المطيري',
      patientInitial: 'س',
      mrn: '29881',
      requestedAtLabel: 'اليوم 09:20',
      testName: 'سكر تراكمي HbA1c',
      requestingDoctor: 'د. خالد العتيبي',
      status: LabOrderStatus.newOrder,
    ),
    const LabOrderModel(
      id: 'ord-2',
      patientName: 'منيرة العتيبي',
      patientInitial: 'م',
      mrn: '30412',
      requestedAtLabel: '8 يونيو 11:40',
      testName: 'وظائف الغدة TSH',
      requestingDoctor: 'د. خالد العتيبي',
      status: LabOrderStatus.inProgress,
    ),
    const LabOrderModel(
      id: 'ord-3',
      patientName: 'منيرة العتيبي',
      patientInitial: 'م',
      mrn: '30412',
      requestedAtLabel: '8 يونيو 11:42',
      testName: 'أشعة سينية — الناحية اليسرى',
      requestingDoctor: 'د. خالد العتيبي',
      status: LabOrderStatus.inProgress,
    ),
    const LabOrderModel(
      id: 'ord-4',
      patientName: 'وليد الشمري',
      patientInitial: 'و',
      mrn: '28110',
      requestedAtLabel: 'اليوم 08:55',
      testName: 'صورة دم كاملة CBC',
      requestingDoctor: 'د. رهف الدسري',
      status: LabOrderStatus.newOrder,
    ),
  ];

  Future<List<LabOrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_orders);
  }
}
