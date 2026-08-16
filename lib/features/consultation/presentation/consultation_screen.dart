import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../logic/consultation_cubit.dart';
import 'widgets/consultation_history_tab.dart';
import 'widgets/consultation_options_section.dart';
import 'widgets/consultation_patient_header.dart';
import 'widgets/consultation_prescription_section.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key, required this.patient});

  final QueuePatientModel patient;

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  late final ConsultationCubit _cubit = getIt<ConsultationCubit>()
    ..load(widget.patient);
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  final _diagnosisController = TextEditingController();
  bool _finishing = false;
  bool _savingDraft = false;
  bool _hydratedDraftFields = false;

  @override
  void dispose() {
    _complaintController.dispose();
    _diagnosisController.dispose();
    _cubit.close();
    super.dispose();
  }

  String? _validateRequired(String? v) => (v == null || v.trim().isEmpty)
      ? LocaleKeys.validation_required.tr()
      : null;

  Future<void> _finish({required bool isDraft}) async {
    final state = _cubit.state;
    if (state is! ConsultationSuccess || _finishing || _savingDraft) return;
    if (!isDraft && !(_formKey.currentState?.validate() ?? false)) {
      AppOverlay.showError(LocaleKeys.validation_required.tr());
      return;
    }

    setState(() => isDraft ? _savingDraft = true : _finishing = true);
    final ok = await _cubit.finish(
      complaint: _complaintController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      isDraft: isDraft,
    );
    if (mounted) {
      setState(() => isDraft ? _savingDraft = false : _finishing = false);
    }
    if (!ok || !mounted) return;

    if (isDraft) {
      AppOverlay.showSuccess(LocaleKeys.consultation_draftSaved.tr());
    } else {
      Navigator.pop(context);
      AppOverlay.showSuccess(
        LocaleKeys.consultation_finishSuccess
            .tr(namedArgs: {'name': state.data.patient.name}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ConsultationCubit, ConsultationState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is ConsultationSuccess && !_hydratedDraftFields) {
              _hydratedDraftFields = true;
              _complaintController.text = state.data.complaint;
              _diagnosisController.text = state.data.diagnosis;
            }
          },
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading:
                  state is ConsultationLoading || state is ConsultationInitial,
              error: state is ConsultationError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final data = (state as ConsultationSuccess).data;

                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                    children: [
                      ConsultationPatientHeader(patient: data.patient),
                      16.height,
                      AppSegmentedTabs(
                        labels: [
                          LocaleKeys.consultation_tabConsult.tr(),
                          LocaleKeys.consultation_tabHistory.tr(),
                        ],
                        selectedIndex: data.tabIndex,
                        onChanged: _cubit.setTab,
                      ),
                      16.height,
                      if (data.tabIndex == 0) ...[
                        AppText(LocaleKeys.consultation_complaintLabel.tr(),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedColor.themeColor),
                        8.height,
                        CustomTextField(
                          controller: _complaintController,
                          hint: LocaleKeys.consultation_complaintHint.tr(),
                          maxLines: 2,
                          validator: _validateRequired,
                        ),
                        14.height,
                        AppText(LocaleKeys.consultation_diagnosisLabel.tr(),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedColor.themeColor),
                        8.height,
                        CustomTextField(
                          controller: _diagnosisController,
                          hint: LocaleKeys.consultation_diagnosisHint.tr(),
                          maxLines: 5,
                          validator: _validateRequired,
                        ),
                        18.height,
                        ConsultationPrescriptionSection(
                          prescriptions: data.prescriptions,
                          onAdd: _cubit.addPrescription,
                          onChanged: (id, {name, dose, duration}) =>
                              _cubit.updatePrescription(id,
                                  name: name, dose: dose, duration: duration),
                          onRemove: _cubit.removePrescription,
                        ),
                        18.height,
                        ConsultationOptionsSection(
                          label: LocaleKeys.consultation_ordersLabel.tr(),
                          hint: LocaleKeys.consultation_ordersHint.tr(),
                          options: data.analysisOptions,
                          selectedIds: data.selectedAnalysisIds,
                          onToggle: _cubit.toggleAnalysis,
                        ),
                        18.height,
                        ConsultationOptionsSection(
                          label: LocaleKeys.consultation_xraysLabel.tr(),
                          options: data.xrayOptions,
                          selectedIds: data.selectedXrayIds,
                          onToggle: _cubit.toggleXray,
                        ),
                        20.height,
                        CustomButton(
                          onTap: () => _finish(isDraft: false),
                          title: LocaleKeys.consultation_finishConsult.tr(),
                          loading: _finishing,
                        ),
                        9.height,
                        CustomButton(
                          onTap: () => _finish(isDraft: true),
                          title: LocaleKeys.consultation_saveDraft.tr(),
                          color: AppColors.surfaceColor.themeColor,
                          textColor: AppColors.textPrimaryColor.themeColor,
                          loading: _savingDraft,
                        ),
                      ] else
                        ConsultationHistoryTab(history: data.history),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
