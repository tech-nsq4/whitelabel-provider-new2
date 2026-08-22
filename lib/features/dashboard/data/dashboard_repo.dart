import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/dashboard_overview_model.dart';

/// Reads the "Today" dashboard's stats, today's doctors and recent
/// bookings from `GET /home`.
class DashboardRepo {
  DashboardRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<DashboardOverviewModel> getOverview() async {
    try {
      final response = await _dio.get(ApiEndpoints.home);
      return DashboardOverviewModel.fromJson(
          response.data['data'] as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
