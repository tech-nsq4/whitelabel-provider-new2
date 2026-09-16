import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/patient_list_item_model.dart';
import '../logic/patients_cubit.dart';
import 'widgets/patient_list_tile.dart';

/// Bottom nav's "Patients" destination — the searchable patient directory.
class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late final _cubit = getIt<PatientsCubit>()..loadPatients();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _openFile(PatientListItemModel patient) {
    Navigator.pushNamed(context, Routes.patientFile, arguments: {'patient': patient});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppScreenHeader(
                eyebrow: LocaleKeys.patientsScreen_subtitle.tr(),
                title: LocaleKeys.patientsScreen_title.tr(),
              ),
              16.height,
              CustomTextField(
                controller: _searchController,
                hint: LocaleKeys.patients_searchHint.tr(),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.mutedColor.themeColor),
                onChanged: _cubit.search,
              ),
              16.height,
              Expanded(
                child: BlocBuilder<PatientsCubit, PatientsState>(
                  bloc: _cubit,
                  builder: (context, state) {
                    return CustomScreenStateLayout(
                      onRefresh: () async => _cubit.loadPatients(),
                      isLoading: state is PatientsLoading || state is PatientsInitial,
                      error: state is PatientsError
                          ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                          : null,
                      onRetry: () => _cubit.loadPatients(),
                      isEmpty: state is PatientsSuccess && state.patients.isEmpty,
                      builder: (context) {
                        final patients = (state as PatientsSuccess).patients;
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: 108.h),
                          itemCount: patients.length,
                          itemBuilder: (context, index) => PatientListTile(
                            patient: patients[index],
                            onTap: () => _openFile(patients[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
