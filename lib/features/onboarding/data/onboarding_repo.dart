import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/splash_slide_model.dart';

class OnboardingRepo {
  OnboardingRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<SplashSlideModel>> getSplashes() async {
    try {
      final response = await _dio.get(ApiEndpoints.splashes);
      return [
        for (final row in response.data['data'] as List)
          SplashSlideModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
