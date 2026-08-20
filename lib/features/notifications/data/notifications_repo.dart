import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/notification_model.dart';

class NotificationsRepo {
  NotificationsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.notifications);
      return [
        for (final row in response.data['data'] as List)
          NotificationModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiEndpoints.notificationsUnreadCount);
      return response.data['data']['unread_count'] as int? ?? 0;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.post(ApiEndpoints.notificationsReadAll);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.post(ApiEndpoints.notificationRead(notificationId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
