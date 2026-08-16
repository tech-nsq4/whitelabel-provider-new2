import 'package:equatable/equatable.dart';

/// One "الرعاية المنزلية" request — pending assignment or already assigned
/// to a doctor.
class HomecareRequestModel extends Equatable {
  const HomecareRequestModel({
    required this.id,
    required this.patientName,
    required this.serviceLabel,
    required this.price,
    required this.addressLine,
    required this.timeWindow,
    this.assignedDoctor,
  });

  final String id;
  final String patientName;
  final String serviceLabel;
  final int price;
  final String addressLine;
  final String timeWindow;

  /// `null` while the request is still waiting to be assigned.
  final String? assignedDoctor;

  bool get isAssigned => assignedDoctor != null;

  HomecareRequestModel copyWith({String? assignedDoctor}) => HomecareRequestModel(
        id: id,
        patientName: patientName,
        serviceLabel: serviceLabel,
        price: price,
        addressLine: addressLine,
        timeWindow: timeWindow,
        assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      );

  @override
  List<Object?> get props =>
      [id, patientName, serviceLabel, price, addressLine, timeWindow, assignedDoctor];
}
