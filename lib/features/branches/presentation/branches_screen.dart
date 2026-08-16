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
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/location_model.dart';
import '../logic/branches_cubit.dart';
import 'widgets/location_tile.dart';

/// "الفروع" — every location the clinic operates in; tap one to see its
/// clinics.
class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late final _cubit = getIt<BranchesCubit>()..loadLocations();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openClinics(LocationModel location) {
    Navigator.pushNamed(context, Routes.clinics, arguments: {
      'locationId': location.id,
      'locationName': location.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<BranchesCubit, BranchesState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is BranchesLoading || state is BranchesInitial,
              error: state is BranchesError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final locations = (state as BranchesSuccess).locations;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.branchesScreen_title.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    18.height,
                    if (locations.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: AppText(
                              LocaleKeys.branchesScreen_noLocations.tr(),
                              fontSize: 11.5,
                              color: AppColors.mutedColor.themeColor),
                        ),
                      )
                    else
                      for (final location in locations)
                        LocationTile(
                            location: location,
                            onTap: () => _openClinics(location)),
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
