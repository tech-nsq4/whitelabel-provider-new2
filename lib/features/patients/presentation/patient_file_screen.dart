import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../logic/patient_file_cubit.dart';
import '../logic/patient_file_data.dart';
import 'widgets/patient_file_header.dart';
import 'widgets/patient_file_stats_row.dart';
import 'widgets/patient_visit_card.dart';
import 'widgets/patient_visit_item_row.dart';

/// A single patient's full record — visits, results, medications and
/// documents, reached from the patients directory list.
class PatientFileScreen extends StatefulWidget {
  const PatientFileScreen({super.key, required this.patientId});

  final String patientId;

  @override
  State<PatientFileScreen> createState() => _PatientFileScreenState();
}

class _PatientFileScreenState extends State<PatientFileScreen> {
  late final _cubit = getIt<PatientFileCubit>()..load(widget.patientId);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _startConsult(PatientFileData data) {
    Navigator.pushNamed(context, Routes.consultation, arguments: {
      'patient': QueuePatientModel(
        id: widget.patientId,
        name: data.file.name,
        initial: data.file.initial,
        mrn: data.file.mrn,
        age: data.file.age,
        bloodType: data.file.bloodType,
        allergy: data.file.allergy,
        justArrived: true,
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
              isLoading: state is PatientFileLoading || state is PatientFileInitial,
              error: state is PatientFileError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final data = (state as PatientFileSuccess).data;
                final file = data.file;

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    PatientFileHeader(file: file),
                    14.height,
                    PatientFileStatsRow(file: file),
                    16.height,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () => _startConsult(data),
                            title: LocaleKeys.pfile_startConsult.tr(),
                          ),
                        ),
                        10.width,
                        InkWell(
                          onTap: () =>
                              AppOverlay.showSuccess(LocaleKeys.pfile_shareRecordToast.tr()),
                          child: Container(
                            width: 46.r,
                            height: 46.r,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cardColor.themeColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.dividerColor.themeColor),
                            ),
                            child: Icon(Icons.ios_share_rounded,
                                size: 19.sp, color: AppColors.primaryColor.themeColor),
                          ),
                        ),
                      ],
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
                        LocaleKeys.pfile_tabMedications.tr(),
                        LocaleKeys.pfile_tabDocuments.tr(),
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
          for (final linked in data.file.results)
            PatientVisitItemRow(item: linked.item, visitCode: linked.visitCode),
        ];
      case 2:
        return [
          for (final linked in data.file.medications)
            PatientVisitItemRow(item: linked.item, visitCode: linked.visitCode),
        ];
      default:
        return [
          for (final linked in data.file.documents)
            PatientVisitItemRow(item: linked.item, visitCode: linked.visitCode),
        ];
    }
  }
}
