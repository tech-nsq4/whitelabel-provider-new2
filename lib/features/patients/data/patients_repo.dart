import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../orders/data/models/test_request_model.dart';
import 'models/patient_list_item_model.dart';
import 'models/patient_prescription_model.dart';

class PatientsRepo {
  PatientsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<PatientListItemModel>> getPatients({String query = ''}) async {
    try {
      final response = await _dio.get(ApiEndpoints.users, queryParameters: {
        if (query.trim().isNotEmpty) 'search': query.trim(),
      });
      return [
        for (final row in response.data['data'] as List)
          PatientListItemModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<TestRequestModel>> getAnalysesHistory(String userId) =>
      _getTestHistory(ApiEndpoints.userAnalysesHistory(userId));

  Future<List<TestRequestModel>> getXraysHistory(String userId) =>
      _getTestHistory(ApiEndpoints.userXraysHistory(userId));

  Future<List<TestRequestModel>> _getTestHistory(String path) async {
    try {
      final response = await _dio.get(path);
      final history = [
        for (final row in response.data['data'] as List)
          TestRequestModel.fromJson(row as Map<String, dynamic>),
      ];
      history.sort((a, b) => b.id.compareTo(a.id));
      return history;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<PatientPrescriptionModel>> getPrescriptionHistory(
      String userId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.userPrescriptionsHistory(userId));
      return [
        for (final row in response.data['data'] as List)
          PatientPrescriptionModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
