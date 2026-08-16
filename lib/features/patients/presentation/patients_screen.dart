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
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/patients_cubit.dart';
import 'widgets/patient_list_tile.dart';

/// Bottom nav's "Patients" destination — the searchable patient-file
/// directory.
class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late final _cubit = getIt<PatientsCubit>()..loadPatients();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openFile(String patientId) {
    Navigator.pushNamed(context, Routes.patientFile, arguments: {'patientId': patientId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PatientsCubit, PatientsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is PatientsLoading || state is PatientsInitial,
              error: state is PatientsError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadPatients(),
              isEmpty: state is PatientsSuccess && state.patients.isEmpty,
              builder: (context) {
                final patients = (state as PatientsSuccess).patients;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 108.h),
                  children: [
                    AppScreenHeader(
                      eyebrow: LocaleKeys.patientsScreen_subtitle.tr(),
                      title: LocaleKeys.patientsScreen_title.tr(),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: () => AppOverlay.showSuccess(LocaleKeys.patients_addNew.tr()),
                      ),
                    ),
                    16.height,
                    CustomTextField(
                      hint: LocaleKeys.patients_searchHint.tr(),
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.mutedColor.themeColor),
                      onChanged: (query) => _cubit.loadPatients(query: query),
                    ),
                    16.height,
                    for (final patient in patients)
                      PatientListTile(patient: patient, onTap: () => _openFile(patient.id)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
