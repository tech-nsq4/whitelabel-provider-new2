import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/specialty_model.dart';

class SpecialtiesRepo {
  SpecialtiesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<SpecialtyModel>> getSpecialties() async {
    try {
      final response = await _dio.get(ApiEndpoints.specializations);
      return [
        for (final row in response.data['data'] as List)
          SpecialtyModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
