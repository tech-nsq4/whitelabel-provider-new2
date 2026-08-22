import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
import 'models/active_medication_model.dart';
import 'models/consultation_draft_model.dart';
import 'models/consultation_option.dart';
import 'models/lab_result_model.dart';
import 'models/patient_history_model.dart';
import 'models/prescription_entry_model.dart';
import 'models/vital_signs_model.dart';

class ConsultationRepo {
  ConsultationRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  /// The "السجل" tab — last visit, recent results and active medications
  /// from `GET /users/{id}/health-summary`, plus a `GET .../vital-signs`
  /// (`null` `data` there just means none has been recorded yet).
  Future<PatientHistoryModel> getHistory(String userId) async {
    try {
      final summaryFuture = _dio.get(ApiEndpoints.userHealthSummary(userId));
      final vitalsFuture = _dio.get(ApiEndpoints.userVitalSigns(userId));
      final summary =
          (await summaryFuture).data['data'] as Map<String, dynamic>? ?? const {};
      final vitalsData = (await vitalsFuture).data['data'];
      final lastVisit = summary['last_visit'] as Map<String, dynamic>?;

      return PatientHistoryModel(
        vitals: vitalsData == null
            ? null
            : VitalSignsModel.fromJson(vitalsData as Map<String, dynamic>),
        lastVisitDate: lastVisit?['date'] as String?,
        lastVisitSummary: lastVisit?['summary'] as String? ?? '',
        recentResults: [
          for (final row in (summary['recent_results'] as List? ?? []))
            LabResultModel.fromJson(row as Map<String, dynamic>),
        ],
        activeMedications: [
          for (final row in (summary['active_medications'] as List? ?? []))
            ActiveMedicationModel.fromJson(row as Map<String, dynamic>),
        ],
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<VitalSignsModel> saveVitalSigns(
    String userId, {
    required String bloodPressure,
    required int pulse,
    required double temperature,
    required int oxygen,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.userVitalSigns(userId), data: {
        'blood_pressure': bloodPressure,
        'pulse': pulse,
        'temperature': temperature,
        'oxygen': oxygen,
      });
      return VitalSignsModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<ConsultationOption>> getAnalyses() =>
      _getOptions(ApiEndpoints.analyses);

  Future<List<ConsultationOption>> getXrays() =>
      _getOptions(ApiEndpoints.xrays);

  Future<List<ConsultationOption>> _getOptions(String path) async {
    try {
      final response = await _dio.get(path);
      return [
        for (final row in response.data['data'] as List)
          ConsultationOption.fromJson(row as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Ends the appointment — `POST /appointments/{id}/end`. The endpoint
  /// also accepts a per-prescription image, not collected here yet.
  Future<void> finishAppointment({
    required String appointmentId,
    required String complaint,
    required String diagnosis,
    required List<PrescriptionEntryModel> prescriptions,
    required List<String> analysisIds,
    required List<String> xrayIds,
  }) async {
    try {
      final data = <String, dynamic>{
        'complaint': complaint,
        'diagnosis': diagnosis,
      };
      for (var i = 0; i < analysisIds.length; i++) {
        data['analysis_ids[$i]'] = int.parse(analysisIds[i]);
      }
      for (var i = 0; i < xrayIds.length; i++) {
        data['xray_ids[$i]'] = int.parse(xrayIds[i]);
      }
      for (var i = 0; i < prescriptions.length; i++) {
        data['prescriptions[$i][drug_name]'] = prescriptions[i].name;
        data['prescriptions[$i][dosage]'] = prescriptions[i].dose;
        data['prescriptions[$i][duration]'] = prescriptions[i].duration;
      }
      await _dio.postForm(
          ApiEndpoints.appointmentEnd(appointmentId), FormData.fromMap(data));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  ConsultationDraftModel? getDraft(String appointmentId) {
    final json = _storage.getConsultationDraft(appointmentId);
    return json == null ? null : ConsultationDraftModel.fromJson(json);
  }

  Future<void> saveDraft(ConsultationDraftModel draft) =>
      _storage.saveConsultationDraft(draft.appointmentId, draft.toJson());

  Future<void> clearDraft(String appointmentId) =>
      _storage.removeConsultationDraft(appointmentId);
}
