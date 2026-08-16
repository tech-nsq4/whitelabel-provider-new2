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
import '../../../core/widgets/screen_state_layout.dart';
import '../../schedules/data/models/work_schedule_model.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/staff_cubit.dart';
import 'widgets/doctor_edit_sheet.dart';
import 'widgets/doctor_profile_card.dart';

/// "الأطباء" — per-doctor pricing across in-clinic/video/home-visit modes.
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  late final _cubit = getIt<StaffCubit>()..loadDoctors();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openEdit([DoctorProfileModel? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoctorEditSheet(
        existing: existing,
        onSubmit: (model, {previousName}) {
          _cubit.upsert(model, previousName: previousName);
          AppOverlay.showSuccess((existing == null
                  ? LocaleKeys.doctorSheet_successAdd
                  : LocaleKeys.doctorSheet_successEdit)
              .tr(namedArgs: {'name': model.name}));
        },
        onOpenSchedule: (doctorName) {
          final stripped = doctorName.replaceFirst('د. ', '').trim();
          Navigator.pushNamed(context, Routes.scheduleEditor, arguments: {
            'doctorName': doctorName,
            'doctorInitial': (stripped.isNotEmpty ? stripped : doctorName).substring(0, 1),
            'mode': WorkScheduleMode.clinic,
            'existing': null,
            'onSave': (WorkScheduleModel model) => AppOverlay.showSuccess(
                LocaleKeys.scheduleEditor_success.tr(namedArgs: {'name': doctorName})),
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StaffCubit, StaffState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is StaffLoading || state is StaffInitial,
              error: state is StaffError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final doctors = (state as StaffSuccess).doctors;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.staff_title.tr(),
                      eyebrow: LocaleKeys.staff_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: () => _openEdit(),
                      ),
                    ),
                    16.height,
                    for (final doctor in doctors)
                      DoctorProfileCard(
                        doctor: doctor,
                        onEditPricing: () => _openEdit(doctor),
                        onSchedules: () => Navigator.pushNamed(context, Routes.schedules),
                      ),
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
