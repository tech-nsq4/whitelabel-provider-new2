import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../orders/data/models/test_request_model.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../data/models/patient_list_item_model.dart';
import '../logic/patient_file_cubit.dart';
import '../logic/patient_file_data.dart';
import 'widgets/patient_file_header.dart';
import 'widgets/patient_file_stats_row.dart';
import 'widgets/patient_prescription_row.dart';
import 'widgets/patient_test_history_row.dart';
import 'widgets/patient_visit_card.dart';

/// A single patient's full record — visits (once an endpoint exists),
/// results, x-rays, and medications — reached from the patients
/// directory list.
class PatientFileScreen extends StatefulWidget {
  const PatientFileScreen({super.key, required this.patient});

  final PatientListItemModel patient;

  @override
  State<PatientFileScreen> createState() => _PatientFileScreenState();
}

class _PatientFileScreenState extends State<PatientFileScreen> {
  late final _cubit = getIt<PatientFileCubit>()..load(widget.patient);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openTestDetails(TestRequestModel request) {
    Navigator.pushNamed(context, Routes.orderDetails, arguments: {'request': request});
  }

  void _startConsult() {
    Navigator.pushNamed(context, Routes.consultation, arguments: {
      'patient': QueuePatientModel(
        id: '${widget.patient.id}',
        name: widget.patient.displayName,
        initial: widget.patient.initial,
        age: widget.patient.age,
        justArrived: true,
        userId: widget.patient.id,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PatientFileCubit, PatientFileState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              onRefresh: () async => _cubit.load(widget.patient),
              isLoading: state is PatientFileLoading || state is PatientFileInitial,
              error: state is PatientFileError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.load(widget.patient),
              builder: (context) {
                final data = (state as PatientFileSuccess).data;
                final file = data.file;

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    PatientFileHeader(patient: file.patient),
                    14.height,
                    PatientFileStatsRow(patient: file.patient),
                    16.height,
                    CustomButton(
                      onTap: _startConsult,
                      title: LocaleKeys.pfile_startConsult.tr(),
                    ),
                    14.height,
                    AppCard(
                      color: AppColors.surfaceColor.themeColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvgIcon(AppSvgIcons.info,
                              size: 17.sp, color: AppColors.primaryColor.themeColor),
                          11.width,
                          Expanded(
                            child: AppText(LocaleKeys.pfile_infoBanner.tr(),
                                fontSize: 11,
                                height: 1.7,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    AppSegmentedTabs(
                      labels: [
                        LocaleKeys.pfile_tabVisits.tr(),
                        LocaleKeys.pfile_tabResults.tr(),
                        LocaleKeys.pfile_tabXrays.tr(),
                        LocaleKeys.pfile_tabMedications.tr(),
                      ],
                      selectedIndex: data.tabIndex,
                      onChanged: _cubit.setTab,
                    ),
                    16.height,
                    ..._buildTab(data),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTab(PatientFileData data) {
    switch (data.tabIndex) {
      case 0:
        return [
          for (final visit in data.file.visits)
            PatientVisitCard(
              visit: visit,
              expanded: data.expandedVisitCode == visit.code,
              onToggle: () => _cubit.toggleVisit(visit.code),
            ),
        ];
      case 1:
        return [
          for (final request in data.file.analysesHistory)
            PatientTestHistoryRow(
              request: request,
              onTap: request.hasResult ? () => _openTestDetails(request) : null,
            ),
        ];
      case 2:
        return [
          for (final request in data.file.xraysHistory)
            PatientTestHistoryRow(
              request: request,
              onTap: request.hasResult ? () => _openTestDetails(request) : null,
            ),
        ];
      default:
        return [
          for (final prescription in data.file.prescriptionHistory)
            PatientPrescriptionRow(prescription: prescription),
        ];
    }
  }
}
