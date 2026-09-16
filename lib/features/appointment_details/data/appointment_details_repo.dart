import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../queue/data/models/appointment_model.dart';

class AppointmentDetailsRepo {
  AppointmentDetailsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<AppointmentModel> getAppointment(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.appointmentDetails(id));
      return AppointmentModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
