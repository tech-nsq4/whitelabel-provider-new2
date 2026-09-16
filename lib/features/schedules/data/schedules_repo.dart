import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/doctor_schedule_model.dart';

class SchedulesRepo {
  SchedulesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<DoctorScheduleModel>> getDoctorTimes() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorTimes);
      return [
        for (final row in response.data['data'] as List)
          DoctorScheduleModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
