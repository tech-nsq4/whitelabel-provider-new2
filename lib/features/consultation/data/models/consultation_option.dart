import 'package:equatable/equatable.dart';

/// A selectable lab test (`GET user/analyses`) or X-ray (`GET user/xrays`)
/// the doctor can order mid-visit — the chip lists under "طلب فحوصات" and
/// "الأشعة".
class ConsultationOption extends Equatable {
  const ConsultationOption({required this.id, required this.label, this.price});

  final String id;
  final String label;
  final double? price;

  factory ConsultationOption.fromJson(Map<String, dynamic> json) =>
      ConsultationOption(
        id: '${json['id']}',
        label: json['name'] as String? ?? '',
        price: double.tryParse('${json['price']}'),
      );

  @override
  List<Object?> get props => [id, label, price];
}
