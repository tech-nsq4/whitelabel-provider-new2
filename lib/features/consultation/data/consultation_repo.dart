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

  /// TODO(api): no endpoint for this yet — mock data until one exists.
  Future<PatientHistoryModel> getHistory(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const PatientHistoryModel(
      vitals: VitalSignsModel(
          pressure: '118/79', pulse: '76', temperature: '37.1', oxygen: '98٪'),
      lastVisitLabel: '8 يونيو',
      lastVisitSummary: 'التهاب لوزتين حاد · وصف أموكسيسيلين 500 لمدة 7 أيام',
      recentResults: [
        LabResultModel(
            name: 'فيتامين د', value: '22 ng/mL', flag: LabResultFlag.low),
        LabResultModel(
            name: 'وظائف الغدة TSH', value: '', flag: LabResultFlag.inProgress),
      ],
      activeMedications: [
        ActiveMedicationModel(
            name: 'أموكسيسيلين 500', schedule: '3× يوميًا · باقي 4 أيام'),
        ActiveMedicationModel(
            name: 'فيتامين د 5000', schedule: 'أسبوعيًا · 10 أسابيع'),
      ],
    );
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
