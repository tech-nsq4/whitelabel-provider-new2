import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/clinic_model.dart';
import 'models/location_model.dart';

class BranchesRepo {
  BranchesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<LocationModel>> getLocations() async {
    try {
      final response = await _dio.get(ApiEndpoints.locations);
      return [
        for (final row in response.data['data'] as List)
          LocationModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<ClinicModel>> getClinics(int locationId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.clinics,
        queryParameters: {'location_id': locationId},
      );
      return [
        for (final row in response.data['data'] as List)
          ClinicModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
