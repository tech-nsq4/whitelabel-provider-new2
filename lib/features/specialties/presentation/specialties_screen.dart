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
import '../data/models/specialty_model.dart';
import '../logic/specialties_cubit.dart';
import 'widgets/specialty_tile.dart';

/// "التخصصات" — a read-only directory of the clinic's specialties.
class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  late final _cubit = getIt<SpecialtiesCubit>()..loadSpecialties();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openDetails(SpecialtyModel specialty) {
    Navigator.pushNamed(context, Routes.specialtyDetails,
        arguments: {'specialty': specialty});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SpecialtiesCubit, SpecialtiesState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              onRefresh: () async => _cubit.loadSpecialties(),
              isLoading: state is SpecialtiesLoading || state is SpecialtiesInitial,
              error: state is SpecialtiesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadSpecialties(),
              builder: (context) {
                final specialties = (state as SpecialtiesSuccess).specialties;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.specialtiesScreen_title.tr(),
                      eyebrow: LocaleKeys.specialtiesScreen_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    for (final specialty in specialties)
                      SpecialtyTile(
                        specialty: specialty,
                        onTap: () => _openDetails(specialty),
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
