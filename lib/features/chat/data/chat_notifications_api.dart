import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/local_storage.dart';

/// `api/chat/notifications` sits outside the `api/clinic/` base, so it can't
/// run through DioClient and gets its own Dio here.
class ChatNotificationsApi {
  ChatNotificationsApi({required LocalStorage storage})
      : _storage = storage,
        _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-API-Key': '3e91ca5165b97d06d7d846e1620369970e11078ee0d232e920d95e9029ae28b7',
            },
          ),
        ) {
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        compact: true,
      ));
    }
  }

  final Dio _dio;
  final LocalStorage _storage;

  Future<void> send({
    required int recipientUserId,
    required String title,
    required String body,
  }) async {
    try {
      final token = await _storage.getToken();
      await _dio.post(
        ApiEndpoints.chatNotifications,
        data: {
          'id': recipientUserId,
          'title': title,
          'body': body,
          'type': 'user',
        },
        options: token == null || token.isEmpty
            ? null
            : Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      return;
    }
  }
}
