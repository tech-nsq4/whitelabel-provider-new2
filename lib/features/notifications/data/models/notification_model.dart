import 'package:equatable/equatable.dart';

/// A booking-lifecycle event — `pending`/`accepted`/`started`/`completed`.
enum NotificationType { booked, accepted, started, completed, unknown }

NotificationType _typeFromJson(String? value) => switch (value) {
      'booked' => NotificationType.booked,
      'accepted' => NotificationType.accepted,
      'started' => NotificationType.started,
      'completed' => NotificationType.completed,
      _ => NotificationType.unknown,
    };

/// One row from `GET /notifications`. [titleKey]/[bodyKey] are
/// `easy_localization` dot-paths the backend sends directly (e.g.
/// `notifications.booking.completed.manager.title`) — the UI calls
/// `.tr()` on them like any other [LocaleKeys] constant.
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.bodyKey,
    required this.createdAt,
    this.appointmentId,
    this.date,
    this.readAt,
  });

  final String id;
  final NotificationType type;
  final String titleKey;
  final String bodyKey;
  final String createdAt;
  final int? appointmentId;
  final String? date;
  final String? readAt;

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        type: _typeFromJson(json['type'] as String?),
        titleKey: json['title'] as String? ?? '',
        bodyKey: json['body'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        appointmentId: json['appointment_id'] as int?,
        date: json['date'] as String?,
        readAt: json['read_at'] as String?,
      );

  @override
  List<Object?> get props =>
      [id, type, titleKey, bodyKey, createdAt, appointmentId, date, readAt];
}
