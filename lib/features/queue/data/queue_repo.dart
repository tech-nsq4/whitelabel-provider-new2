import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/appointment_model.dart';
import 'models/queue_patient_model.dart';
import 'models/queue_snapshot_model.dart';

/// Reads the queue's three tabs — one `status`-filtered request per bucket
/// (no `date` filter for now) — and accepts/cancels an appointment.
class QueueRepo {
  QueueRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<QueueSnapshotModel> getQueue() async {
    final results = await Future.wait([getWaiting(), getInRoom(), getDone()]);
    return QueueSnapshotModel(
        waiting: results[0], inRoom: results[1], done: results[2]);
  }

  Future<List<QueuePatientModel>> getWaiting() =>
      _getByStatuses(const ['pending']);

  Future<List<QueuePatientModel>> getInRoom() =>
      _getByStatuses(const ['confirmed', 'in_progress']);

  Future<List<QueuePatientModel>> getDone() =>
      _getByStatuses(const ['completed']);

  Future<List<QueuePatientModel>> _getByStatuses(List<String> statuses) async {
    try {
      final responses = await Future.wait([
        for (final status in statuses)
          _dio.get(ApiEndpoints.appointments,
              queryParameters: {'status': status}),
      ]);
      return [
        for (final response in responses)
          for (final row in response.data['data'] as List)
            QueuePatientModel.fromAppointment(
              AppointmentModel.fromJson(row as Map<String, dynamic>),
            ),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Calls a waiting patient into the room.
  Future<void> acceptAppointment(String appointmentId) async {
    try {
      await _dio.post(ApiEndpoints.appointmentAccept(appointmentId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Starts the consultation — `confirmed` → `in_progress`.
  Future<void> startAppointment(String appointmentId) async {
    try {
      await _dio.post(ApiEndpoints.appointmentStart(appointmentId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _dio.post(ApiEndpoints.appointmentCancel(appointmentId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
