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
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/work_schedule_model.dart';
import '../logic/schedules_cubit.dart';
import 'widgets/leave_request_sheet.dart';
import 'widgets/new_schedule_sheet.dart';
import 'widgets/work_schedule_tile.dart';

/// "جداول العمل" — every doctor × service-mode combination and its slots.
class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  late final _cubit = getIt<SchedulesCubit>()..loadSchedules();
  int _tabIndex = 0;

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openEditor({
    required String doctorName,
    required String doctorInitial,
    required WorkScheduleMode mode,
    WorkScheduleModel? existing,
  }) {
    Navigator.pushNamed(context, Routes.scheduleEditor, arguments: {
      'doctorName': doctorName,
      'doctorInitial': doctorInitial,
      'mode': mode,
      'existing': existing,
      'onSave': (WorkScheduleModel model) {
        _cubit.upsert(model);
        AppOverlay.showSuccess(LocaleKeys.scheduleEditor_success.tr(namedArgs: {'name': doctorName}));
      },
    });
  }

  void _openNewSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewScheduleSheet(
        onNext: (doctorName, doctorInitial, mode) =>
            _openEditor(doctorName: doctorName, doctorInitial: doctorInitial, mode: mode),
      ),
    );
  }

  void _openLeave(WorkScheduleModel schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaveRequestSheet(
        doctorName: schedule.doctorName,
        onSubmit: () => AppOverlay.showSuccess(
          LocaleKeys.leave_success.tr(namedArgs: {'name': schedule.doctorName}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SchedulesCubit, SchedulesState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is SchedulesLoading || state is SchedulesInitial,
              error: state is SchedulesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final all = (state as SchedulesSuccess).schedules;
                final filtered = switch (_tabIndex) {
                  1 => all.where((s) => s.mode == WorkScheduleMode.clinic).toList(),
                  2 => all.where((s) => s.mode == WorkScheduleMode.online).toList(),
                  3 => all.where((s) => s.mode == WorkScheduleMode.home).toList(),
                  _ => all,
                };

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.schedules_title.tr(),
                      eyebrow: LocaleKeys.schedules_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: _openNewSchedule,
                      ),
                    ),
                    16.height,
                    AppSegmentedTabs(
                      labels: [
                        LocaleKeys.schedules_tabAll.tr(),
                        LocaleKeys.schedules_modeClinic.tr(),
                        LocaleKeys.schedules_modeOnline.tr(),
                        LocaleKeys.schedules_modeHome.tr(),
                      ],
                      selectedIndex: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                    16.height,
                    for (final schedule in filtered)
                      WorkScheduleTile(
                        schedule: schedule,
                        onEdit: () => _openEditor(
                          doctorName: schedule.doctorName,
                          doctorInitial: schedule.doctorInitial,
                          mode: schedule.mode,
                          existing: schedule,
                        ),
                        onLeave: () => _openLeave(schedule),
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
