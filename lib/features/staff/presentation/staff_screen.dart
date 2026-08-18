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
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/staff_cubit.dart';
import 'widgets/doctor_profile_card.dart';

/// "الأطباء" — a read-only directory of the clinic's doctors.
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

  void _openDetails(DoctorProfileModel doctor) {
    Navigator.pushNamed(context, Routes.doctorDetails,
        arguments: {'doctor': doctor});
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
              onRefresh: () async => _cubit.loadDoctors(),
              isLoading: state is StaffLoading || state is StaffInitial,
              error: state is StaffError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadDoctors(),
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
                    ),
                    16.height,
                    for (final doctor in doctors)
                      DoctorProfileCard(
                        doctor: doctor,
                        onTap: () => _openDetails(doctor),
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
