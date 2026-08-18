import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/test_request_model.dart';

class OrdersRepo {
  OrdersRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<TestRequestModel>> getTestRequests() async {
    try {
      final response = await _dio.get(ApiEndpoints.testRequests);
      return [
        for (final row in response.data['data'] as List)
          TestRequestModel.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> uploadResult({
    required String testRequestId,
    required ResultRate resultRate,
    String? note,
    File? image,
  }) async {
    try {
      final data = <String, dynamic>{
        'result_rate': resultRateToJson(resultRate),
        if (note != null && note.isNotEmpty) 'note': note,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last),
      };
      await _dio.postForm(
          ApiEndpoints.testRequestResult(testRequestId), FormData.fromMap(data));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
