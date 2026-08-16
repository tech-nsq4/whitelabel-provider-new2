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
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../data/models/agenda_slot_model.dart';
import '../logic/agenda_cubit.dart';
import 'widgets/agenda_slot_row.dart';

/// "جدول اليوم" — today's full appointment schedule.
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late final _cubit = getIt<AgendaCubit>()..loadToday();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onTap(AgendaSlotModel slot) {
    switch (slot.status) {
      case AgendaSlotStatus.arrived:
        Navigator.pushNamed(context, Routes.consultation, arguments: {
          'patient': QueuePatientModel(
            id: slot.id,
            name: slot.patientName,
            initial: slot.patientInitial,
            mrn: slot.mrn.isEmpty ? null : slot.mrn,
            appointmentTime: slot.time,
            justArrived: true,
          ),
        });
      case AgendaSlotStatus.notArrived:
        AppOverlay.showSuccess(LocaleKeys.agenda_reminderToast.tr(namedArgs: {'name': slot.patientName}));
      case AgendaSlotStatus.paid:
        AppOverlay.showSuccess(LocaleKeys.agenda_videoStartToast.tr(namedArgs: {'name': slot.patientName}));
      case AgendaSlotStatus.confirmed:
        AppOverlay.showSuccess(LocaleKeys.agenda_editToast.tr(namedArgs: {'name': slot.patientName}));
      case AgendaSlotStatus.done:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AgendaCubit, AgendaState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is AgendaLoading || state is AgendaInitial,
              error: state is AgendaError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final slots = (state as AgendaSuccess).slots;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.agenda_title.tr(),
                      eyebrow: LocaleKeys.agenda_subtitle.tr(namedArgs: {'count': '${slots.length}'}),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.dashboardGrid,
                        color: AppColors.primaryColor.themeColor,
                        onTap: () => Navigator.pushNamed(context, Routes.calendar),
                      ),
                    ),
                    18.height,
                    AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          for (var i = 0; i < slots.length; i++)
                            AgendaSlotRow(
                              slot: slots[i],
                              onTap: () => _onTap(slots[i]),
                              showDivider: i < slots.length - 1,
                            ),
                        ],
                      ),
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
