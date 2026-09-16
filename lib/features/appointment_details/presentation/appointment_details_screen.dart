import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../queue/data/models/queue_patient_model.dart';
import '../../queue/presentation/widgets/booking_details_body.dart';
import '../logic/appointment_details_cubit.dart';

/// Opened from a notification tap — fetches one appointment by id and
/// shows every read-only section the backend returns for it.
class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late final _cubit = getIt<AppointmentDetailsCubit>()
    ..loadAppointment(widget.appointmentId);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is AppointmentDetailsLoading ||
                  state is AppointmentDetailsInitial,
              error: state is AppointmentDetailsError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadAppointment(widget.appointmentId),
              builder: (context) {
                final appointment =
                    (state as AppointmentDetailsSuccess).appointment;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    Row(
                      children: [
                        AppHeaderIconButton(
                          svgIcon: AppSvgIcons.chevronBack,
                          onTap: () => Navigator.pop(context),
                        ),
                        12.width,
                        AppText(LocaleKeys.queue_detailsTitle.tr(),
                            isHeading: true,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                      ],
                    ),
                    20.height,
                    BookingDetailsBody(
                      patient: QueuePatientModel.fromAppointment(appointment),
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
