import 'package:equatable/equatable.dart';

class OrdersFilter extends Equatable {
  const OrdersFilter({
    this.locationId,
    this.locationName,
    this.dateFrom,
    this.dateTo,
  });

  final int? locationId;
  final String? locationName;
  final String? dateFrom;
  final String? dateTo;

  static const empty = OrdersFilter();

  bool get hasDate => dateFrom != null && dateTo != null;

  bool get isSingleDay => hasDate && dateFrom == dateTo;

  bool get isActive => locationId != null || hasDate;

  int get activeCount => (locationId != null ? 1 : 0) + (hasDate ? 1 : 0);

  OrdersFilter withoutBranch() =>
      OrdersFilter(dateFrom: dateFrom, dateTo: dateTo);

  OrdersFilter withoutDate() =>
      OrdersFilter(locationId: locationId, locationName: locationName);

  @override
  List<Object?> get props => [locationId, locationName, dateFrom, dateTo];
}
