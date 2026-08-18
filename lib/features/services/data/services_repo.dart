import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/service_model.dart';

class ServicesRepo {
  ServicesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _dio.get(ApiEndpoints.subSpecializations);
      return [
        for (final row in response.data['data'] as List)
          ServiceModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
