import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/doctor_profile_model.dart';

class StaffRepo {
  StaffRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<DoctorProfileModel>> getDoctors() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctors);
      return [
        for (final row in response.data['data'] as List)
          DoctorProfileModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<DoctorProfileModel> getDoctorDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorDetails(id));
      return DoctorProfileModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
