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

  Future<QueueSnapshotModel> getQueue({int? clinicId}) async {
    final results = await Future.wait([
      getWaiting(clinicId: clinicId),
      getInRoom(clinicId: clinicId),
      getDone(clinicId: clinicId),
    ]);
    return QueueSnapshotModel(
        waiting: results[0], inRoom: results[1], done: results[2]);
  }

  Future<List<QueuePatientModel>> getWaiting({int? clinicId}) =>
      _getByStatuses(const ['pending'], clinicId: clinicId);

  Future<List<QueuePatientModel>> getInRoom({int? clinicId}) =>
      _getByStatuses(const ['confirmed', 'in_progress'], clinicId: clinicId);

  Future<List<QueuePatientModel>> getDone({int? clinicId}) =>
      _getByStatuses(const ['completed'], clinicId: clinicId);

  Future<List<QueuePatientModel>> _getByStatuses(List<String> statuses,
      {int? clinicId}) async {
    try {
      final responses = await Future.wait([
        for (final status in statuses)
          _dio.get(ApiEndpoints.appointments, queryParameters: {
            'status': status,
            if (clinicId != null) 'clinic_id': clinicId,
          }),
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
