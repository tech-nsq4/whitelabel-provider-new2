import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
import 'models/profile_model.dart';

class AuthRepo {
  AuthRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  /// Logs the account in with [phone] + [password] and persists the
  /// session token + the profile on success. The profile shape depends on
  /// the account type (`data.type`) — manager or doctor.
  Future<ProfileModel> login({required String phone, required String password}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'phone': phone, 'password': password},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final profile = ProfileModel.fromJson(
          (data['profile'] ?? data['manager']) as Map<String, dynamic>);
      final token = data['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _storage.setToken(token);
        await _storage.setUser(profile.toJson());
      }
      return profile;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Updates the account's [name]/[email] (phone isn't editable here) and
  /// persists the refreshed profile on success.
  Future<ProfileModel> updateProfile({required String name, String? email}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.profile,
        data: {'name': name, if (email != null) 'email': email},
      );
      final profile = ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.setUser(profile.toJson());
      return profile;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Registers/refreshes this device's push-notification token with the
  /// backend — called once on app-shell load for a logged-in account.
  Future<void> updateFcmToken(String fcmToken) async {
    try {
      await _dio.post(ApiEndpoints.fcmToken, data: {'fcm_token': fcmToken});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Syncs the app's active UI language (`ar`/`en`) with the backend.
  Future<void> updateAppLang(String lang) async {
    try {
      await _dio.post(ApiEndpoints.appLang, data: {'app_lang': lang});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } finally {
      await _storage.clearAll();
    }
  }
}
