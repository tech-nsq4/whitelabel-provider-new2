import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/doctor_schedule_model.dart';
import '../logic/schedules_cubit.dart';
import 'widgets/clinic_schedule_group.dart';
import 'widgets/doctor_schedule_group.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  late final _cubit = getIt<SchedulesCubit>()..loadSchedules();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  DoctorScheduleModel? _currentDoctor(List<DoctorScheduleModel> doctors) {
    if (doctors.isEmpty) return null;
    for (final doctor in doctors) {
      if (doctor.id == kUserModel?.id) return doctor;
    }
    return doctors.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = kUserModel?.isDoctor ?? false;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SchedulesCubit, SchedulesState>(
          bloc: _cubit,
          builder: (context, state) {
            final doctors = state is SchedulesSuccess
                ? state.doctors
                : const <DoctorScheduleModel>[];
            final List<ClinicScheduleModel> clinics = isDoctor
                ? (_currentDoctor(doctors)?.clinics ??
                    const <ClinicScheduleModel>[])
                : const <ClinicScheduleModel>[];

            return CustomScreenStateLayout(
              onRefresh: () async => _cubit.loadSchedules(),
              onRetry: () => _cubit.loadSchedules(),
              isLoading: state is SchedulesLoading || state is SchedulesInitial,
              error: state is SchedulesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              isEmpty: state is SchedulesSuccess &&
                  (isDoctor ? clinics.isEmpty : doctors.isEmpty),
              noDataBuilder: (_) => CustomNoDataView(
                title: LocaleKeys.schedules_emptyTitle.tr(),
                desc: LocaleKeys.schedules_emptyDesc.tr(),
                onRefresh: () async => _cubit.loadSchedules(),
              ),
              builder: (context) {
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.schedules_title.tr(),
                      eyebrow: isDoctor
                          ? LocaleKeys.schedules_subtitleDoctor.tr()
                          : LocaleKeys.schedules_subtitleManager.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    if (isDoctor)
                      for (final clinic in clinics)
                        ClinicScheduleGroup(
                          clinic: clinic,
                          initiallyExpanded: clinics.length == 1,
                        )
                    else
                      for (final doctor in doctors)
                        DoctorScheduleGroup(doctor: doctor),
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
