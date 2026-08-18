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
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/clinics_cubit.dart';
import 'widgets/clinic_tile.dart';

/// "العيادات" — every clinic inside one location.
class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen(
      {super.key, required this.locationId, required this.locationName});

  final int locationId;
  final String locationName;

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  late final _cubit = getIt<ClinicsCubit>()..loadClinics(widget.locationId);

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
        child: BlocBuilder<ClinicsCubit, ClinicsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is ClinicsLoading || state is ClinicsInitial,
              error: state is ClinicsError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final clinics = (state as ClinicsSuccess).clinics;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      eyebrow: widget.locationName,
                      title: LocaleKeys.branchesScreen_clinicsTitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    18.height,
                    if (clinics.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: AppText(
                              LocaleKeys.branchesScreen_noClinics.tr(),
                              fontSize: 11.5,
                              color: AppColors.mutedColor.themeColor),
                        ),
                      )
                    else
                      for (final clinic in clinics) ClinicTile(clinic: clinic),
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
